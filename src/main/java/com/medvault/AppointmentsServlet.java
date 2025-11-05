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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppointmentsServlet extends HttpServlet {
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
            if ("doctor".equals(role)) {
                // Doctor appointments view
                handleDoctorAppointments(request, response, conn, userId);
            } else if ("patient".equals(role)) {
                // Patient appointments view
                handlePatientAppointments(request, response, conn, userId);
            } else if ("receptionist".equals(role)) {
                // Receptionist appointments view (same as doctor for associated doctor)
                handleReceptionistAppointments(request, response, conn, userId);
            } else {
                response.sendRedirect("login.jsp");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load appointments: " + e.getMessage());
            request.getRequestDispatcher("appointments.jsp").forward(request, response);
        }
    }

    private void handleDoctorAppointments(HttpServletRequest request, HttpServletResponse response,
                                        Connection conn, int userId) throws SQLException, ServletException, IOException {
        // Get doctor info
        String doctorQuery = "SELECT id FROM doctors WHERE user_id = ?";
        PreparedStatement doctorStmt = conn.prepareStatement(doctorQuery);
        doctorStmt.setInt(1, userId);
        ResultSet doctorRs = doctorStmt.executeQuery();

        if (!doctorRs.next()) {
            request.setAttribute("error", "Doctor profile not found");
            request.getRequestDispatcher("doctorDashboard").forward(request, response);
            return;
        }

        int doctorId = doctorRs.getInt("id");

        // Get all appointments for the doctor, grouped by date
        String appointmentsQuery = "SELECT a.*, p.name as patient_name, p.age, p.gender " +
                                 "FROM appointments a " +
                                 "JOIN patients p ON a.patient_id = p.id " +
                                 "WHERE a.doctor_id = ? " +
                                 "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        PreparedStatement appointmentsStmt = conn.prepareStatement(appointmentsQuery);
        appointmentsStmt.setInt(1, doctorId);
        ResultSet appointmentsRs = appointmentsStmt.executeQuery();

        Map<String, List<Appointment>> appointmentsByDate = new HashMap<>();
        while (appointmentsRs.next()) {
            Appointment apt = new Appointment();
            apt.setId(appointmentsRs.getInt("id"));
            apt.setAppointmentDate(appointmentsRs.getDate("appointment_date"));
            apt.setAppointmentTime(appointmentsRs.getTime("appointment_time"));
            apt.setStatus(appointmentsRs.getString("status"));
            apt.setPatientId(appointmentsRs.getInt("patient_id"));

            String dateKey = apt.getAppointmentDate().toString();
            request.setAttribute("patientName_" + apt.getId(), appointmentsRs.getString("patient_name"));
            request.setAttribute("patientAge_" + apt.getId(), appointmentsRs.getInt("age"));
            request.setAttribute("patientGender_" + apt.getId(), appointmentsRs.getString("gender"));

            appointmentsByDate.computeIfAbsent(dateKey, k -> new ArrayList<>()).add(apt);
        }

        request.setAttribute("appointmentsByDate", appointmentsByDate);
        request.setAttribute("userRole", "doctor");
        request.getRequestDispatcher("appointments.jsp").forward(request, response);
    }

    private void handlePatientAppointments(HttpServletRequest request, HttpServletResponse response,
                                         Connection conn, int userId) throws SQLException, ServletException, IOException {
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

        // Get all appointments for the patient
        String appointmentsQuery = "SELECT a.*, d.name as doctor_name, d.specialization " +
                                 "FROM appointments a " +
                                 "JOIN doctors d ON a.doctor_id = d.id " +
                                 "WHERE a.patient_id = ? " +
                                 "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        PreparedStatement appointmentsStmt = conn.prepareStatement(appointmentsQuery);
        appointmentsStmt.setInt(1, patientId);
        ResultSet appointmentsRs = appointmentsStmt.executeQuery();

        List<Appointment> appointments = new ArrayList<>();
        while (appointmentsRs.next()) {
            Appointment apt = new Appointment();
            apt.setId(appointmentsRs.getInt("id"));
            apt.setAppointmentDate(appointmentsRs.getDate("appointment_date"));
            apt.setAppointmentTime(appointmentsRs.getTime("appointment_time"));
            apt.setStatus(appointmentsRs.getString("status"));
            apt.setDoctorId(appointmentsRs.getInt("doctor_id"));
            request.setAttribute("doctorName_" + apt.getId(), appointmentsRs.getString("doctor_name"));
            request.setAttribute("doctorSpec_" + apt.getId(), appointmentsRs.getString("specialization"));
            appointments.add(apt);
        }
        request.setAttribute("appointments", appointments);
        request.setAttribute("userRole", "patient");
        request.getRequestDispatcher("appointments.jsp").forward(request, response);
    }

    private void handleReceptionistAppointments(HttpServletRequest request, HttpServletResponse response,
                                              Connection conn, int userId) throws SQLException, ServletException, IOException {
        // Get receptionist info and associated doctor
        String receptionistQuery = "SELECT doctor_id FROM receptionists WHERE user_id = ?";
        PreparedStatement receptionistStmt = conn.prepareStatement(receptionistQuery);
        receptionistStmt.setInt(1, userId);
        ResultSet receptionistRs = receptionistStmt.executeQuery();

        if (!receptionistRs.next()) {
            request.setAttribute("error", "Receptionist profile not found");
            request.getRequestDispatcher("receptionistDashboard").forward(request, response);
            return;
        }

        int doctorId = receptionistRs.getInt("doctor_id");

        // Get all appointments for the associated doctor, grouped by date
        String appointmentsQuery = "SELECT a.*, p.name as patient_name, p.age, p.gender " +
                                 "FROM appointments a " +
                                 "JOIN patients p ON a.patient_id = p.id " +
                                 "WHERE a.doctor_id = ? " +
                                 "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        PreparedStatement appointmentsStmt = conn.prepareStatement(appointmentsQuery);
        appointmentsStmt.setInt(1, doctorId);
        ResultSet appointmentsRs = appointmentsStmt.executeQuery();

        Map<String, List<Appointment>> appointmentsByDate = new HashMap<>();
        while (appointmentsRs.next()) {
            Appointment apt = new Appointment();
            apt.setId(appointmentsRs.getInt("id"));
            apt.setAppointmentDate(appointmentsRs.getDate("appointment_date"));
            apt.setAppointmentTime(appointmentsRs.getTime("appointment_time"));
            apt.setStatus(appointmentsRs.getString("status"));
            apt.setPatientId(appointmentsRs.getInt("patient_id"));

            String dateKey = apt.getAppointmentDate().toString();
            request.setAttribute("patientName_" + apt.getId(), appointmentsRs.getString("patient_name"));
            request.setAttribute("patientAge_" + apt.getId(), appointmentsRs.getInt("age"));
            request.setAttribute("patientGender_" + apt.getId(), appointmentsRs.getString("gender"));

            appointmentsByDate.computeIfAbsent(dateKey, k -> new ArrayList<>()).add(apt);
        }

        request.setAttribute("appointmentsByDate", appointmentsByDate);
        request.setAttribute("userRole", "receptionist");
        request.getRequestDispatcher("appointments.jsp").forward(request, response);
    }
}
