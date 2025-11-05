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

public class ConfirmAppointmentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userId == null || role == null || !"receptionist".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get receptionist's associated doctor
        int associatedDoctorId = 0;
        try (Connection conn = DBConnection.getConnection()) {
            String receptionistQuery = "SELECT doctor_id FROM receptionists WHERE user_id = ?";
            PreparedStatement receptionistStmt = conn.prepareStatement(receptionistQuery);
            receptionistStmt.setInt(1, userId);
            ResultSet rs = receptionistStmt.executeQuery();
            if (rs.next()) {
                associatedDoctorId = rs.getInt("doctor_id");
            } else {
                session.setAttribute("error", "Receptionist not found or not associated with a doctor");
                response.sendRedirect("receptionistDashboard");
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Failed to verify receptionist: " + e.getMessage());
            response.sendRedirect("receptionistDashboard");
            return;
        }

        String idParam = request.getParameter("appointmentId");
        if (idParam == null) {
            session.setAttribute("error", "Missing appointment id");
            response.sendRedirect("receptionistDashboard");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE appointments SET status = 'confirmed' WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(idParam));
            int updated = stmt.executeUpdate();
            if (updated > 0) {
                session.setAttribute("success", "Appointment confirmed.");
            } else {
                session.setAttribute("error", "Failed to confirm appointment.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Error confirming appointment: " + e.getMessage());
        }

        response.sendRedirect("receptionistDashboard");
    }
}


