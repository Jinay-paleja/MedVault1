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

public class PatientsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userId == null || (!"doctor".equals(role) && !"receptionist".equals(role))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            int doctorId = 0;
            if ("doctor".equals(role)) {
                // Get doctor ID
                String doctorQuery = "SELECT id FROM doctors WHERE user_id = ?";
                PreparedStatement doctorStmt = conn.prepareStatement(doctorQuery);
                doctorStmt.setInt(1, userId);
                ResultSet doctorRs = doctorStmt.executeQuery();
                if (doctorRs.next()) {
                    doctorId = doctorRs.getInt("id");
                }
            } else if ("receptionist".equals(role)) {
                // Get associated doctor ID for receptionist
                String receptionistQuery = "SELECT doctor_id FROM receptionists WHERE user_id = ?";
                PreparedStatement receptionistStmt = conn.prepareStatement(receptionistQuery);
                receptionistStmt.setInt(1, userId);
                ResultSet receptionistRs = receptionistStmt.executeQuery();
                if (receptionistRs.next()) {
                    doctorId = receptionistRs.getInt("doctor_id");
                }
            }

            if (doctorId > 0) {

                // Get patients who have appointments with this doctor
                String patientsQuery = "SELECT DISTINCT p.*, " +
                                     "(SELECT COUNT(*) FROM appointments WHERE patient_id = p.id AND doctor_id = ?) as appointment_count, " +
                                     "(SELECT MAX(appointment_date) FROM appointments WHERE patient_id = p.id AND doctor_id = ?) as last_visit " +
                                     "FROM patients p " +
                                     "JOIN appointments a ON p.id = a.patient_id " +
                                     "WHERE a.doctor_id = ? " +
                                     "ORDER BY p.name";
                PreparedStatement patientsStmt = conn.prepareStatement(patientsQuery);
                patientsStmt.setInt(1, doctorId);
                patientsStmt.setInt(2, doctorId);
                patientsStmt.setInt(3, doctorId);
                ResultSet patientsRs = patientsStmt.executeQuery();

                List<Patient> patients = new ArrayList<>();
                while (patientsRs.next()) {
                    Patient patient = new Patient();
                    patient.setId(patientsRs.getInt("id"));
                    patient.setName(patientsRs.getString("name"));
                    patient.setPhone(patientsRs.getString("phone"));
                    patient.setAge(patientsRs.getInt("age"));
                    patient.setGender(patientsRs.getString("gender"));
                    patient.setAddress(patientsRs.getString("address"));
                    patients.add(patient);

                    // Add additional attributes
                    request.setAttribute("appointmentCount_" + patient.getId(), patientsRs.getInt("appointment_count"));
                    request.setAttribute("lastVisit_" + patient.getId(), patientsRs.getDate("last_visit"));
                }
                request.setAttribute("patients", patients);
                request.setAttribute("totalPatients", patients.size());
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load patients: " + e.getMessage());
        }

        request.getRequestDispatcher("patients.jsp").forward(request, response);
    }
}
