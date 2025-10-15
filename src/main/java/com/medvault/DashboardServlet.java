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

public class DashboardServlet extends HttpServlet {
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
            String patientQuery = "SELECT * FROM patients WHERE user_id = ?";
            PreparedStatement patientStmt = conn.prepareStatement(patientQuery);
            patientStmt.setInt(1, userId);
            ResultSet patientRs = patientStmt.executeQuery();

            if (patientRs.next()) {
                Patient patient = new Patient();
                patient.setId(patientRs.getInt("id"));
                patient.setName(patientRs.getString("name"));
                request.setAttribute("patient", patient);
            }

            // Get upcoming appointments
            String upcomingQuery = "SELECT a.*, d.name as doctor_name, d.specialization " +
                                 "FROM appointments a " +
                                 "JOIN doctors d ON a.doctor_id = d.id " +
                                 "WHERE a.patient_id = ? AND a.appointment_date >= CURDATE() " +
                                 "ORDER BY a.appointment_date, a.appointment_time";
            PreparedStatement upcomingStmt = conn.prepareStatement(upcomingQuery);
            upcomingStmt.setInt(1, patientRs.getInt("id"));
            ResultSet upcomingRs = upcomingStmt.executeQuery();

            List<Appointment> upcomingAppointments = new ArrayList<>();
            while (upcomingRs.next()) {
                Appointment apt = new Appointment();
                apt.setId(upcomingRs.getInt("id"));
                apt.setAppointmentDate(upcomingRs.getDate("appointment_date"));
                apt.setAppointmentTime(upcomingRs.getTime("appointment_time"));
                apt.setStatus(upcomingRs.getString("status"));
                apt.setDoctorId(upcomingRs.getInt("doctor_id"));
                // Add doctor name and specialization as attributes
                request.setAttribute("doctorName_" + apt.getId(), upcomingRs.getString("doctor_name"));
                request.setAttribute("doctorSpec_" + apt.getId(), upcomingRs.getString("specialization"));
                upcomingAppointments.add(apt);
            }
            request.setAttribute("upcomingAppointments", upcomingAppointments);

            // Get prescription history
            String prescriptionQuery = "SELECT p.*, a.appointment_date, d.name as doctor_name " +
                                     "FROM prescriptions p " +
                                     "JOIN appointments a ON p.appointment_id = a.id " +
                                     "JOIN doctors d ON a.doctor_id = d.id " +
                                     "WHERE a.patient_id = ? " +
                                     "ORDER BY a.appointment_date DESC";
            PreparedStatement prescriptionStmt = conn.prepareStatement(prescriptionQuery);
            prescriptionStmt.setInt(1, patientRs.getInt("id"));
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

            // Get health summary
            String summaryQuery = "SELECT " +
                                "(SELECT COUNT(*) FROM appointments WHERE patient_id = ?) as total_appointments, " +
                                "(SELECT COUNT(*) FROM prescriptions p JOIN appointments a ON p.appointment_id = a.id WHERE a.patient_id = ?) as prescriptions_received, " +
                                "(SELECT COUNT(*) FROM appointments WHERE patient_id = ? AND appointment_date >= CURDATE()) as upcoming_appointments, " +
                                "(SELECT MAX(appointment_date) FROM appointments WHERE patient_id = ?) as last_visit";
            PreparedStatement summaryStmt = conn.prepareStatement(summaryQuery);
            summaryStmt.setInt(1, patientRs.getInt("id"));
            summaryStmt.setInt(2, patientRs.getInt("id"));
            summaryStmt.setInt(3, patientRs.getInt("id"));
            summaryStmt.setInt(4, patientRs.getInt("id"));
            ResultSet summaryRs = summaryStmt.executeQuery();

            if (summaryRs.next()) {
                request.setAttribute("totalAppointments", summaryRs.getInt("total_appointments"));
                request.setAttribute("prescriptionsReceived", summaryRs.getInt("prescriptions_received"));
                request.setAttribute("upcomingAppointmentsCount", summaryRs.getInt("upcoming_appointments"));
                request.setAttribute("lastVisit", summaryRs.getDate("last_visit"));
            }

            // Get all doctors for booking
            String doctorsQuery = "SELECT id, name, specialization FROM doctors";
            PreparedStatement doctorsStmt = conn.prepareStatement(doctorsQuery);
            ResultSet doctorsRs = doctorsStmt.executeQuery();

            List<Doctor> doctors = new ArrayList<>();
            while (doctorsRs.next()) {
                Doctor doc = new Doctor();
                doc.setId(doctorsRs.getInt("id"));
                doc.setName(doctorsRs.getString("name"));
                doc.setSpecialization(doctorsRs.getString("specialization"));
                doctors.add(doc);
            }
            request.setAttribute("doctors", doctors);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load dashboard: " + e.getMessage());
        }

        request.getRequestDispatcher("patientDashboard.jsp").forward(request, response);
    }
}
