package com.medvault;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;

public class BookAppointmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        Date appointmentDate = Date.valueOf(request.getParameter("appointmentDate"));
        Time appointmentTime = Time.valueOf(request.getParameter("appointmentTime") + ":00");

        try (Connection conn = DBConnection.getConnection()) {
            // Get patient ID
            String patientQuery = "SELECT id FROM patients WHERE user_id = ?";
            PreparedStatement patientStmt = conn.prepareStatement(patientQuery);
            patientStmt.setInt(1, userId);
            ResultSet patientRs = patientStmt.executeQuery();

            if (!patientRs.next()) {
                session.setAttribute("error", "Patient profile not found");
                response.sendRedirect("dashboard");
                return;
            }

            int patientId = patientRs.getInt("id");

            // Check if slot is available
            String checkQuery = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND appointment_date = ? AND appointment_time = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setInt(1, doctorId);
            checkStmt.setDate(2, appointmentDate);
            checkStmt.setTime(3, appointmentTime);
            ResultSet checkRs = checkStmt.executeQuery();

            if (checkRs.next() && checkRs.getInt(1) > 0) {
                session.setAttribute("error", "This time slot is already booked");
                response.sendRedirect("dashboard");
                return;
            }

            // Book appointment
            String insertQuery = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status) VALUES (?, ?, ?, ?, 'pending')";
            PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
            insertStmt.setInt(1, patientId);
            insertStmt.setInt(2, doctorId);
            insertStmt.setDate(3, appointmentDate);
            insertStmt.setTime(4, appointmentTime);
            insertStmt.executeUpdate();

            session.setAttribute("success", "Appointment booked successfully!");
            response.sendRedirect("dashboard");

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Failed to book appointment: " + e.getMessage());
            response.sendRedirect("dashboard");
        }
    }
}
