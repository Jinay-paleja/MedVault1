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

public class ProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            if ("patient".equals(role)) {
                String query = "SELECT p.*, u.email FROM patients p JOIN users u ON p.user_id = u.id WHERE p.user_id = ?";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setName(rs.getString("name"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setAge(rs.getInt("age"));
                    patient.setGender(rs.getString("gender"));
                    patient.setAddress(rs.getString("address"));
                    request.setAttribute("profile", patient);
                    request.setAttribute("email", rs.getString("email"));
                }
            } else if ("doctor".equals(role)) {
                String query = "SELECT d.*, u.email FROM doctors d JOIN users u ON d.user_id = u.id WHERE d.user_id = ?";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setName(rs.getString("name"));
                    doctor.setSpecialization(rs.getString("specialization"));
                    doctor.setPhone(rs.getString("phone"));
                    doctor.setInstitute(rs.getString("institute"));
                    request.setAttribute("profile", doctor);
                    request.setAttribute("email", rs.getString("email"));
                } else {
                    // If doctor profile doesn't exist, redirect to login or show error
                    request.setAttribute("error", "Doctor profile not found. Please contact administrator.");
                }
            } else if ("receptionist".equals(role)) {
                String query = "SELECT r.*, u.email FROM receptionists r JOIN users u ON r.user_id = u.id WHERE r.user_id = ?";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    Receptionist receptionist = new Receptionist();
                    receptionist.setName(rs.getString("name"));
                    receptionist.setPhone(rs.getString("phone"));
                    request.setAttribute("profile", receptionist);
                    request.setAttribute("email", rs.getString("email"));
                }
            }
            // Add similar logic for other roles if needed

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load profile: " + e.getMessage());
        }

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        try (Connection conn = DBConnection.getConnection()) {
            // Update email in users table
            String userQuery = "UPDATE users SET email = ? WHERE id = ?";
            PreparedStatement userStmt = conn.prepareStatement(userQuery);
            userStmt.setString(1, email);
            userStmt.setInt(2, userId);
            userStmt.executeUpdate();

            if ("patient".equals(role)) {
                String patientQuery = "UPDATE patients SET name = ?, phone = ?, age = ?, gender = ?, address = ? WHERE user_id = ?";
                PreparedStatement patientStmt = conn.prepareStatement(patientQuery);
                patientStmt.setString(1, name);
                patientStmt.setString(2, phone);
                patientStmt.setInt(3, Integer.parseInt(request.getParameter("age")));
                patientStmt.setString(4, request.getParameter("gender"));
                patientStmt.setString(5, request.getParameter("address"));
                patientStmt.setInt(6, userId);
                patientStmt.executeUpdate();
            } else if ("doctor".equals(role)) {
                String doctorQuery = "UPDATE doctors SET name = ?, specialization = ?, phone = ?, institute = ? WHERE user_id = ?";
                PreparedStatement doctorStmt = conn.prepareStatement(doctorQuery);
                doctorStmt.setString(1, name);
                doctorStmt.setString(2, request.getParameter("specialization"));
                doctorStmt.setString(3, phone);
                doctorStmt.setString(4, request.getParameter("institute"));
                doctorStmt.setInt(5, userId);
                doctorStmt.executeUpdate();
            } else if ("receptionist".equals(role)) {
                String receptionistQuery = "UPDATE receptionists SET name = ?, phone = ? WHERE user_id = ?";
                PreparedStatement receptionistStmt = conn.prepareStatement(receptionistQuery);
                receptionistStmt.setString(1, name);
                receptionistStmt.setString(2, phone);
                receptionistStmt.setInt(3, userId);
                receptionistStmt.executeUpdate();
            }
            // Add similar logic for other roles if needed

            request.setAttribute("success", "Profile updated successfully!");
            doGet(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to update profile: " + e.getMessage());
            doGet(request, response);
        }
    }
}
