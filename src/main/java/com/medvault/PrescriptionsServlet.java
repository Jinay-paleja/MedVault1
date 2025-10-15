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

public class PrescriptionsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userId == null || !"patient".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Get patient info
            String patientQuery = "SELECT id FROM patients WHERE user_id = ?";
            PreparedStatement patientStmt = conn.prepareStatement(patientQuery);
            patientStmt.setInt(1, userId);
            ResultSet patientRs = patientStmt.executeQuery();

            if (!patientRs.next()) {
                request.setAttribute("error", "Patient profile not found");
                request.getRequestDispatcher("dashboard").forward(request, response);
                return;
            }

            int patientId = patientRs.getInt("id");

            // Get prescription history
            String prescriptionQuery = "SELECT p.*, a.appointment_date, d.name as doctor_name " +
                                     "FROM prescriptions p " +
                                     "JOIN appointments a ON p.appointment_id = a.id " +
                                     "JOIN doctors d ON a.doctor_id = d.id " +
                                     "WHERE a.patient_id = ? " +
                                     "ORDER BY a.appointment_date DESC";
            PreparedStatement prescriptionStmt = conn.prepareStatement(prescriptionQuery);
            prescriptionStmt.setInt(1, patientId);
            ResultSet prescriptionRs = prescriptionStmt.executeQuery();

            List<Prescription> prescriptions = new ArrayList<>();
            while (prescriptionRs.next()) {
                Prescription pres = new Prescription();
                pres.setId(prescriptionRs.getInt("id"));
                pres.setPrescriptionText(prescriptionRs.getString("prescription_text"));
                prescriptions.add(pres);
                request.setAttribute("presDate_" + pres.getId(), prescriptionRs.getDate("appointment_date"));
                request.setAttribute("presDoctor_" + pres.getId(), prescriptionRs.getString("doctor_name"));
            }
            request.setAttribute("prescriptions", prescriptions);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load prescriptions: " + e.getMessage());
        }

        request.getRequestDispatcher("prescriptions.jsp").forward(request, response);
    }
}
