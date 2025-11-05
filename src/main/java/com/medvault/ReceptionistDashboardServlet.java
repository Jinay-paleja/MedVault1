package com.medvault;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReceptionistDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userId == null || !"receptionist".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Get receptionist info
            String receptionistQuery = "SELECT * FROM receptionists WHERE user_id = ?";
            PreparedStatement receptionistStmt = conn.prepareStatement(receptionistQuery);
            receptionistStmt.setInt(1, userId);
            ResultSet receptionistRs = receptionistStmt.executeQuery();

            int associatedDoctorId = 0;
            if (receptionistRs.next()) {
                Receptionist receptionist = new Receptionist();
                receptionist.setId(receptionistRs.getInt("id"));
                receptionist.setName(receptionistRs.getString("name"));
                receptionist.setDoctorId(receptionistRs.getInt("doctor_id"));
                associatedDoctorId = receptionist.getDoctorId();
                request.setAttribute("receptionist", receptionist);
            }

            // Appointments for associated doctor
            String appointmentsQuery = "SELECT a.*, p.name as patient_name, d.name as doctor_name " +
                                     "FROM appointments a " +
                                     "JOIN patients p ON a.patient_id = p.id " +
                                     "JOIN doctors d ON a.doctor_id = d.id " +
                                     "WHERE a.doctor_id = ? AND a.status <> 'cancelled' " +
                                     "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
            PreparedStatement appointmentsStmt = conn.prepareStatement(appointmentsQuery);
            appointmentsStmt.setInt(1, associatedDoctorId);
            ResultSet appointmentsRs = appointmentsStmt.executeQuery();

            List<Appointment> appointments = new ArrayList<>();
            while (appointmentsRs.next()) {
                Appointment apt = new Appointment();
                apt.setId(appointmentsRs.getInt("id"));
                apt.setAppointmentDate(appointmentsRs.getDate("appointment_date"));
                apt.setAppointmentTime(appointmentsRs.getTime("appointment_time"));
                apt.setStatus(appointmentsRs.getString("status"));
                apt.setPatientId(appointmentsRs.getInt("patient_id"));
                apt.setDoctorId(appointmentsRs.getInt("doctor_id"));
                request.setAttribute("patientName_" + apt.getId(), appointmentsRs.getString("patient_name"));
                request.setAttribute("doctorName_" + apt.getId(), appointmentsRs.getString("doctor_name"));
                appointments.add(apt);
            }
            request.setAttribute("appointments", appointments);

            // Patients associated with the doctor's appointments
            String patientsQuery = "SELECT DISTINCT p.* FROM patients p " +
                                 "JOIN appointments a ON p.id = a.patient_id " +
                                 "WHERE a.doctor_id = ?";
            PreparedStatement patientsStmt = conn.prepareStatement(patientsQuery);
            patientsStmt.setInt(1, associatedDoctorId);
            ResultSet patientsRs = patientsStmt.executeQuery();

            List<Patient> patients = new ArrayList<>();
            while (patientsRs.next()) {
                Patient pat = new Patient();
                pat.setId(patientsRs.getInt("id"));
                pat.setName(patientsRs.getString("name"));
                pat.setAge(patientsRs.getInt("age"));
                pat.setGender(patientsRs.getString("gender"));
                pat.setPhone(patientsRs.getString("phone"));
                patients.add(pat);
            }
            request.setAttribute("patients", patients);

            // Only the associated doctor
            String doctorsQuery = "SELECT * FROM doctors WHERE id = ?";
            PreparedStatement doctorsStmt = conn.prepareStatement(doctorsQuery);
            doctorsStmt.setInt(1, associatedDoctorId);
            ResultSet doctorsRs = doctorsStmt.executeQuery();

            List<Doctor> doctors = new ArrayList<>();
            if (doctorsRs.next()) {
                Doctor doc = new Doctor();
                doc.setId(doctorsRs.getInt("id"));
                doc.setName(doctorsRs.getString("name"));
                doc.setSpecialization(doctorsRs.getString("specialization"));
                doctors.add(doc);
            }
            request.setAttribute("doctors", doctors);

            // Dashboard Summary for associated doctor
            String summaryQuery = "SELECT " +
                                "(SELECT COUNT(DISTINCT p.id) FROM patients p JOIN appointments a ON p.id = a.patient_id WHERE a.doctor_id = ?) as total_patients, " +
                                "(SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND appointment_date = CURDATE()) as today_appointments, " +
                                "(SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND status = 'pending') as pending_appointments, " +
                                "1 as available_doctors";
            PreparedStatement summaryStmt = conn.prepareStatement(summaryQuery);
            summaryStmt.setInt(1, associatedDoctorId);
            summaryStmt.setInt(2, associatedDoctorId);
            summaryStmt.setInt(3, associatedDoctorId);
            ResultSet summaryRs = summaryStmt.executeQuery();

            if (summaryRs.next()) {
                request.setAttribute("totalPatients", summaryRs.getInt("total_patients"));
                request.setAttribute("todayAppointments", summaryRs.getInt("today_appointments"));
                request.setAttribute("pendingAppointments", summaryRs.getInt("pending_appointments"));
                request.setAttribute("availableDoctors", summaryRs.getInt("available_doctors"));
            }

            // Clinic status (singleton row id=1)
            try {
                conn.createStatement().executeUpdate(
                    "CREATE TABLE IF NOT EXISTS clinic_status (id INT PRIMARY KEY, status VARCHAR(16) NOT NULL)"
                );
                ResultSet cs = conn.createStatement().executeQuery("SELECT status FROM clinic_status WHERE id = 1");
                String clinicStatus = cs.next() ? cs.getString("status") : "open";
                request.setAttribute("clinicStatus", clinicStatus);
            } catch (SQLException ignored) {}

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load dashboard: " + e.getMessage());
        }

        request.getRequestDispatcher("receptionistDashboard.jsp").forward(request, response);
    }
}
