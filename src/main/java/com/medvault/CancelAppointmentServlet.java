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

public class CancelAppointmentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userId == null || role == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // If receptionist, get associated doctor
        int associatedDoctorId = 0;
        if ("receptionist".equals(role)) {
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
        }

        String idParam = request.getParameter("appointmentId");
        if (idParam == null) {
            session.setAttribute("error", "Missing appointment id");
            response.sendRedirect("appointments");
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid appointment id");
            response.sendRedirect("appointments");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Fetch appointment with ownership info
            String fetchSql = "SELECT id, patient_id, doctor_id, status FROM appointments WHERE id = ?";
            PreparedStatement fetchStmt = conn.prepareStatement(fetchSql);
            fetchStmt.setInt(1, appointmentId);
            ResultSet rs = fetchStmt.executeQuery();
            if (!rs.next()) {
                session.setAttribute("error", "Appointment not found");
                response.sendRedirect("appointments");
                return;
            }

            int appointmentPatientId = rs.getInt("patient_id");
            int appointmentDoctorId = rs.getInt("doctor_id");
            String status = rs.getString("status");

            // Only allow cancelling non-completed/non-cancelled appointments
            if ("cancelled".equalsIgnoreCase(status) || "completed".equalsIgnoreCase(status)) {
                session.setAttribute("error", "This appointment cannot be cancelled");
                response.sendRedirect("appointments");
                return;
            }

            boolean authorized = false;
            if ("patient".equals(role)) {
                // Map user -> patient id
                String patientSql = "SELECT id FROM patients WHERE user_id = ?";
                PreparedStatement pStmt = conn.prepareStatement(patientSql);
                pStmt.setInt(1, userId);
                ResultSet pRs = pStmt.executeQuery();
                if (pRs.next() && pRs.getInt("id") == appointmentPatientId) {
                    authorized = true;
                }
            } else if ("doctor".equals(role)) {
                // Map user -> doctor id
                String doctorSql = "SELECT id FROM doctors WHERE user_id = ?";
                PreparedStatement dStmt = conn.prepareStatement(doctorSql);
                dStmt.setInt(1, userId);
                ResultSet dRs = dStmt.executeQuery();
                if (dRs.next() && dRs.getInt("id") == appointmentDoctorId) {
                    authorized = true;
                }
            } else if ("receptionist".equals(role)) {
                // Receptionist can cancel any non-completed appointment
                authorized = true;
            }

            if (!authorized) {
                session.setAttribute("error", "You are not authorized to cancel this appointment");
                response.sendRedirect("appointments");
                return;
            }

            // Update status to cancelled
            String updateSql = "UPDATE appointments SET status = 'cancelled' WHERE id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setInt(1, appointmentId);
            int updated = updateStmt.executeUpdate();

            if (updated > 0) {
                session.setAttribute("success", "Appointment cancelled successfully");
            } else {
                session.setAttribute("error", "Failed to cancel appointment");
            }

            // Redirect by role
            if ("receptionist".equals(role)) {
                response.sendRedirect("receptionistDashboard");
            } else if ("doctor".equals(role) || "patient".equals(role)) {
                response.sendRedirect("appointments");
            } else {
                response.sendRedirect("login.jsp");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Failed to cancel appointment: " + e.getMessage());
            if ("receptionist".equals(role)) {
                response.sendRedirect("receptionistDashboard");
            } else {
                response.sendRedirect("appointments");
            }
        }
    }
}


