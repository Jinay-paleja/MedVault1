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

public class DoctorDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userId == null || !"doctor".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Get doctor info
            String doctorQuery = "SELECT * FROM doctors WHERE user_id = ?";
            PreparedStatement doctorStmt = conn.prepareStatement(doctorQuery);
            doctorStmt.setInt(1, userId);
            ResultSet doctorRs = doctorStmt.executeQuery();

            Doctor doctor = null;
            if (doctorRs.next()) {
                doctor = new Doctor();
                doctor.setId(doctorRs.getInt("id"));
                doctor.setName(doctorRs.getString("name"));
                doctor.setSpecialization(doctorRs.getString("specialization"));
                doctor.setInstitute(doctorRs.getString("institute"));
                // Optional fields if present in schema
                try { doctor.setPhone(doctorRs.getString("phone")); } catch (SQLException ignored) {}
                request.setAttribute("doctor", doctor);
            } else {
                request.setAttribute("error", "Doctor profile not found");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            int doctorId = doctor.getId();

            // Today's Appointments
            String todayAppointmentsQuery = "SELECT a.*, p.name as patient_name, p.age, p.gender " +
                                          "FROM appointments a " +
                                          "JOIN patients p ON a.patient_id = p.id " +
                                          "WHERE a.doctor_id = ? AND a.appointment_date = CURDATE() " +
                                          "ORDER BY a.appointment_time";
            PreparedStatement todayStmt = conn.prepareStatement(todayAppointmentsQuery);
            todayStmt.setInt(1, doctorId);
            ResultSet todayRs = todayStmt.executeQuery();

            List<Appointment> todayAppointments = new ArrayList<>();
            while (todayRs.next()) {
                Appointment apt = new Appointment();
                apt.setId(todayRs.getInt("id"));
                apt.setAppointmentDate(todayRs.getDate("appointment_date"));
                apt.setAppointmentTime(todayRs.getTime("appointment_time"));
                apt.setStatus(todayRs.getString("status"));
                apt.setPatientId(todayRs.getInt("patient_id"));
                request.setAttribute("patientName_" + apt.getId(), todayRs.getString("patient_name"));
                request.setAttribute("patientAge_" + apt.getId(), todayRs.getInt("age"));
                request.setAttribute("patientGender_" + apt.getId(), todayRs.getString("gender"));
                todayAppointments.add(apt);
            }
            request.setAttribute("todayAppointments", todayAppointments);

            // Prescription History
            String prescriptionsQuery = "SELECT p.*, a.appointment_date, pt.name as patient_name " +
                                      "FROM prescriptions p " +
                                      "JOIN appointments a ON p.appointment_id = a.id " +
                                      "JOIN patients pt ON a.patient_id = pt.id " +
                                      "WHERE a.doctor_id = ? " +
                                      "ORDER BY a.appointment_date DESC";
            PreparedStatement prescriptionsStmt = conn.prepareStatement(prescriptionsQuery);
            prescriptionsStmt.setInt(1, doctorId);
            ResultSet prescriptionsRs = prescriptionsStmt.executeQuery();

            List<Prescription> prescriptions = new ArrayList<>();
            while (prescriptionsRs.next()) {
                Prescription pres = new Prescription();
                pres.setId(prescriptionsRs.getInt("id"));
                pres.setPrescriptionText(prescriptionsRs.getString("prescription_text"));
                prescriptions.add(pres);
                request.setAttribute("presDate_" + pres.getId(), prescriptionsRs.getDate("appointment_date"));
                request.setAttribute("presPatient_" + pres.getId(), prescriptionsRs.getString("patient_name"));
            }
            request.setAttribute("prescriptions", prescriptions);

            // Dashboard Statistics
            String statsQuery = "SELECT " +
                              "(SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND appointment_date = CURDATE()) as today_appointments, " +
                              "(SELECT COUNT(DISTINCT patient_id) FROM appointments WHERE doctor_id = ?) as total_patients, " +
                              "(SELECT COUNT(*) FROM prescriptions p JOIN appointments a ON p.appointment_id = a.id WHERE a.doctor_id = ?) as prescriptions_issued, " +
                              "(SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND status = 'pending') as pending_appointments";
            PreparedStatement statsStmt = conn.prepareStatement(statsQuery);
            statsStmt.setInt(1, doctorId);
            statsStmt.setInt(2, doctorId);
            statsStmt.setInt(3, doctorId);
            statsStmt.setInt(4, doctorId);
            ResultSet statsRs = statsStmt.executeQuery();

            if (statsRs.next()) {
                request.setAttribute("todayAppointmentsCount", statsRs.getInt("today_appointments"));
                request.setAttribute("totalPatients", statsRs.getInt("total_patients"));
                request.setAttribute("prescriptionsIssued", statsRs.getInt("prescriptions_issued"));
                request.setAttribute("pendingAppointments", statsRs.getInt("pending_appointments"));
            }

            // All Patients for search
            String patientsQuery = "SELECT DISTINCT p.id, p.name, p.age, p.gender, p.phone " +
                                 "FROM patients p " +
                                 "JOIN appointments a ON p.id = a.patient_id " +
                                 "WHERE a.doctor_id = ?";
            PreparedStatement patientsStmt = conn.prepareStatement(patientsQuery);
            patientsStmt.setInt(1, doctorId);
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

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load dashboard: " + e.getMessage());
        }

        request.getRequestDispatcher("doctorDashboard.jsp").forward(request, response);
    }
}
