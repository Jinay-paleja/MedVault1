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

            if (receptionistRs.next()) {
                Receptionist receptionist = new Receptionist();
                receptionist.setId(receptionistRs.getInt("id"));
                receptionist.setName(receptionistRs.getString("name"));
                request.setAttribute("receptionist", receptionist);
            }

            // All Appointments
            String appointmentsQuery = "SELECT a.*, p.name as patient_name, d.name as doctor_name " +
                                     "FROM appointments a " +
                                     "JOIN patients p ON a.patient_id = p.id " +
                                     "JOIN doctors d ON a.doctor_id = d.id " +
                                     "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
            PreparedStatement appointmentsStmt = conn.prepareStatement(appointmentsQuery);
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

            // All Patients
            String patientsQuery = "SELECT * FROM patients";
            PreparedStatement patientsStmt = conn.prepareStatement(patientsQuery);
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

            // All Doctors
            String doctorsQuery = "SELECT * FROM doctors";
            PreparedStatement doctorsStmt = conn.prepareStatement(doctorsQuery);
            ResultSet doctorsRs = doctorsStmt.executeQuery();

            List<Doctor> doctors = new ArrayList<>();
            while (doctorsRs.next()) {
                Doctor doc = new Doctor();
                doc.setId(doctorsRs.getInt("id"));
                doc.setName(doctorsRs.getString("name"));
                doc.setSpecialization(doctorsRs.getString("specialization"));
                doctors.add(doc);
            }
            request.setAttribute("doctors", doctors);

            // Dashboard Summary
            String summaryQuery = "SELECT " +
                                "(SELECT COUNT(*) FROM patients) as total_patients, " +
                                "(SELECT COUNT(*) FROM appointments WHERE appointment_date = CURDATE()) as today_appointments, " +
                                "(SELECT COUNT(*) FROM appointments WHERE status = 'pending') as pending_appointments, " +
                                "(SELECT COUNT(*) FROM doctors) as available_doctors";
            PreparedStatement summaryStmt = conn.prepareStatement(summaryQuery);
            ResultSet summaryRs = summaryStmt.executeQuery();

            if (summaryRs.next()) {
                request.setAttribute("totalPatients", summaryRs.getInt("total_patients"));
                request.setAttribute("todayAppointments", summaryRs.getInt("today_appointments"));
                request.setAttribute("pendingAppointments", summaryRs.getInt("pending_appointments"));
                request.setAttribute("availableDoctors", summaryRs.getInt("available_doctors"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load dashboard: " + e.getMessage());
        }

        request.getRequestDispatcher("receptionistDashboard.jsp").forward(request, response);
    }
}
