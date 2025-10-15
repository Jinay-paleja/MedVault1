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

public class AddPrescriptionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userId == null || !"doctor".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String appointmentIdParam = request.getParameter("appointmentId");
        if (appointmentIdParam == null) {
            request.setAttribute("error", "Missing appointment id");
            request.getRequestDispatcher("appointments").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT a.id, a.appointment_date, a.appointment_time, p.name as patient_name, d.id as doctor_id " +
                           "FROM appointments a " +
                           "JOIN patients p ON a.patient_id = p.id " +
                           "JOIN doctors d ON a.doctor_id = d.id " +
                           "WHERE a.id = ? AND d.user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, Integer.parseInt(appointmentIdParam));
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            if (!rs.next()) {
                request.setAttribute("error", "Appointment not found or not authorized");
                request.getRequestDispatcher("appointments").forward(request, response);
                return;
            }

            request.setAttribute("appointmentId", rs.getInt("id"));
            request.setAttribute("patientName", rs.getString("patient_name"));
            request.setAttribute("appointmentDate", rs.getDate("appointment_date"));
            request.setAttribute("appointmentTime", rs.getTime("appointment_time"));

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load appointment: " + e.getMessage());
        }

        request.getRequestDispatcher("addPrescription.jsp").forward(request, response);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userId == null || !"doctor".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        String symptoms = request.getParameter("symptoms");
        String diagnosis = request.getParameter("diagnosis");
        String medicines = request.getParameter("medicines");
        String advice = request.getParameter("advice");

        // Combine all prescription details into one text
        String prescriptionText = "Symptoms: " + symptoms + "\n\n" +
                                 "Diagnosis: " + diagnosis + "\n\n" +
                                 "Medicines: " + medicines + "\n\n" +
                                 "Advice: " + advice;

        try (Connection conn = DBConnection.getConnection()) {
            String query = "INSERT INTO prescriptions (appointment_id, prescription_text) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, appointmentId);
            stmt.setString(2, prescriptionText);
            stmt.executeUpdate();

            int prescriptionId = 0;
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    prescriptionId = generatedKeys.getInt(1);
                }
            }

            // Update appointment status to completed
            String updateQuery = "UPDATE appointments SET status = 'completed' WHERE id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
            updateStmt.setInt(1, appointmentId);
            updateStmt.executeUpdate();

            request.setAttribute("success", "Prescription added successfully! PDF generated.");
            response.sendRedirect("doctorDashboard");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to add prescription: " + e.getMessage());
            response.sendRedirect("doctorDashboard");
        }
    }
}
