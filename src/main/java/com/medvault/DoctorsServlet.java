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

public class DoctorsServlet extends HttpServlet {
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
            List<Doctor> doctors = new ArrayList<>();

            if ("doctor".equals(role)) {
                // Doctors can see all doctors
                String doctorsQuery = "SELECT * FROM doctors ORDER BY name";
                PreparedStatement doctorsStmt = conn.prepareStatement(doctorsQuery);
                ResultSet doctorsRs = doctorsStmt.executeQuery();

                while (doctorsRs.next()) {
                    Doctor doc = new Doctor();
                    doc.setId(doctorsRs.getInt("id"));
                    doc.setName(doctorsRs.getString("name"));
                    doc.setSpecialization(doctorsRs.getString("specialization"));
                    doc.setPhone(doctorsRs.getString("phone"));
                    doc.setInstitute(doctorsRs.getString("institute"));
                    doctors.add(doc);
                }
            } else if ("receptionist".equals(role)) {
                // Receptionists can only see their associated doctor
                String receptionistQuery = "SELECT doctor_id FROM receptionists WHERE user_id = ?";
                PreparedStatement receptionistStmt = conn.prepareStatement(receptionistQuery);
                receptionistStmt.setInt(1, userId);
                ResultSet receptionistRs = receptionistStmt.executeQuery();

                if (receptionistRs.next()) {
                    int doctorId = receptionistRs.getInt("doctor_id");

                    String doctorsQuery = "SELECT * FROM doctors WHERE id = ?";
                    PreparedStatement doctorsStmt = conn.prepareStatement(doctorsQuery);
                    doctorsStmt.setInt(1, doctorId);
                    ResultSet doctorsRs = doctorsStmt.executeQuery();

                    if (doctorsRs.next()) {
                        Doctor doc = new Doctor();
                        doc.setId(doctorsRs.getInt("id"));
                        doc.setName(doctorsRs.getString("name"));
                        doc.setSpecialization(doctorsRs.getString("specialization"));
                        doc.setPhone(doctorsRs.getString("phone"));
                        doc.setInstitute(doctorsRs.getString("institute"));
                        doctors.add(doc);
                    }
                }
            }

            request.setAttribute("doctors", doctors);
            request.getRequestDispatcher("doctors.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load doctors: " + e.getMessage());
            request.getRequestDispatcher("doctors.jsp").forward(request, response);
        }
    }
}
