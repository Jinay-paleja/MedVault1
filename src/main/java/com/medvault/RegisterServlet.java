package com.medvault;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RegisterServlet extends HttpServlet {

    private String capitalize(String str) {
        if (str == null || str.isEmpty()) {
            return str;
        }
        return str.substring(0, 1).toUpperCase() + str.substring(1);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        try (Connection conn = DBConnection.getConnection()) {
            // Check if email already exists
            String checkQuery = "SELECT id FROM users WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("error", "Email already exists!");
                request.getRequestDispatcher("register" + capitalize(role) + ".jsp").forward(request, response);
                return;
            }

            // Insert into users table
            String userQuery = "INSERT INTO users (email, password, role) VALUES (?, ?, ?)";
            PreparedStatement userStmt = conn.prepareStatement(userQuery, PreparedStatement.RETURN_GENERATED_KEYS);
            userStmt.setString(1, email);
            userStmt.setString(2, password); // In production, hash the password
            userStmt.setString(3, role);
            userStmt.executeUpdate();

            ResultSet generatedKeys = userStmt.getGeneratedKeys();
            int userId = 0;
            if (generatedKeys.next()) {
                userId = generatedKeys.getInt(1);
            }

            // Insert into role-specific table
            String roleQuery = "";
            PreparedStatement roleStmt = null;

            switch (role) {
                case "patient":
                    roleQuery = "INSERT INTO patients (user_id, name, phone, age, gender, address) VALUES (?, ?, ?, ?, ?, ?)";
                    roleStmt = conn.prepareStatement(roleQuery);
                    roleStmt.setInt(1, userId);
                    roleStmt.setString(2, name);
                    roleStmt.setString(3, phone);
                    roleStmt.setInt(4, Integer.parseInt(request.getParameter("age")));
                    roleStmt.setString(5, request.getParameter("gender"));
                    roleStmt.setString(6, request.getParameter("address"));
                    break;
                case "doctor":
                    roleQuery = "INSERT INTO doctors (user_id, name, phone, specialization, institute) VALUES (?, ?, ?, ?, ?)";
                    roleStmt = conn.prepareStatement(roleQuery);
                    roleStmt.setInt(1, userId);
                    roleStmt.setString(2, name);
                    roleStmt.setString(3, phone);
                    roleStmt.setString(4, request.getParameter("specialization"));
                    roleStmt.setString(5, request.getParameter("institute"));
                    break;
                case "receptionist":
                    roleQuery = "INSERT INTO receptionists (user_id, name, phone, address, doctor_id) VALUES (?, ?, ?, ?, ?)";
                    roleStmt = conn.prepareStatement(roleQuery);
                    roleStmt.setInt(1, userId);
                    roleStmt.setString(2, name);
                    roleStmt.setString(3, phone);
                    roleStmt.setString(4, request.getParameter("address"));
                    roleStmt.setInt(5, Integer.parseInt(request.getParameter("doctorId")));
                    break;
            }

            if (roleStmt != null) {
                roleStmt.executeUpdate();
            }

            // Redirect to success page
            response.sendRedirect("success.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("register" + capitalize(role) + ".jsp").forward(request, response);
        }
    }
}
