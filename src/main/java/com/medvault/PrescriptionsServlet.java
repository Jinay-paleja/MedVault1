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

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            if ("patient".equals(role)) {
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
                request.setAttribute("userRole", "patient");
            } else if ("doctor".equals(role)) {
                // Get doctor info
                String doctorQuery = "SELECT id, name FROM doctors WHERE user_id = ?";
                PreparedStatement doctorStmt = conn.prepareStatement(doctorQuery);
                doctorStmt.setInt(1, userId);
                ResultSet doctorRs = doctorStmt.executeQuery();
                if (!doctorRs.next()) {
                    request.setAttribute("error", "Doctor profile not found");
                    request.getRequestDispatcher("doctorDashboard").forward(request, response);
                    return;
                }
                int doctorId = doctorRs.getInt("id");

                // Load recent appointments with patient names for quick prescription creation
                String doctorAppointmentsQuery = "SELECT a.id, a.appointment_date, a.appointment_time, a.status, p.name as patient_name " +
                                               "FROM appointments a JOIN patients p ON a.patient_id = p.id " +
                                               "WHERE a.doctor_id = ? ORDER BY a.appointment_date DESC, a.appointment_time DESC";
                PreparedStatement daStmt = conn.prepareStatement(doctorAppointmentsQuery);
                daStmt.setInt(1, doctorId);
                ResultSet daRs = daStmt.executeQuery();

                List<Appointment> doctorAppointments = new ArrayList<>();
                while (daRs.next()) {
                    Appointment apt = new Appointment();
                    apt.setId(daRs.getInt("id"));
                    apt.setAppointmentDate(daRs.getDate("appointment_date"));
                    apt.setAppointmentTime(daRs.getTime("appointment_time"));
                    apt.setStatus(daRs.getString("status"));
                    request.setAttribute("patientName_" + apt.getId(), daRs.getString("patient_name"));
                    doctorAppointments.add(apt);
                }
                request.setAttribute("doctorAppointments", doctorAppointments);
                request.setAttribute("userRole", "doctor");
            } else {
                response.sendRedirect("login.jsp");
                return;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load prescriptions: " + e.getMessage());
        }

        request.getRequestDispatcher("prescriptions.jsp").forward(request, response);
    }
}
