<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.medvault.Patient" %>
<%@ page import="com.medvault.Appointment" %>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - Appointments</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 50%, #cbd5e1 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            color: #1e293b;
        }
        .header {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            color: white;
            padding: 25px 30px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.15);
            position: relative;
        }
        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(37,99,235,0.1) 0%, rgba(59,130,246,0.05) 100%);
            pointer-events: none;
        }
        .header h1 {
            margin: 0;
            display: inline-block;
            font-size: 28px;
            font-weight: 600;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            position: relative;
            z-index: 1;
        }
        .nav {
            float: right;
            margin-top: 15px;
        }
        .nav a {
            color: white;
            text-decoration: none;
            margin-left: 25px;
            padding: 8px 16px;
            border-radius: 20px;
            transition: all 0.3s ease;
            font-weight: 500;
            position: relative;
            z-index: 1;
        }
        .nav a:hover {
            background-color: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 30px;
        }
        .welcome {
            margin-bottom: 30px;
            text-align: center;
        }
        .welcome h2 {
            color: white;
            font-size: 32px;
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .card {
            background: #ffffff;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
            margin-bottom: 30px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #2563eb, #3b82f6, #06b6d4);
        }
        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.12);
        }
        .card h3 {
            color: #1e293b;
            margin-top: 0;
            margin-bottom: 25px;
            font-size: 22px;
            font-weight: 600;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 15px;
        }
        .date-section {
            border-left: 4px solid #2563eb;
            padding-left: 20px;
            margin-bottom: 25px;
        }
        .date-header {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 15px;
            border: 1px solid #e2e8f0;
        }
        .date-header h4 {
            margin: 0;
            color: #2563eb;
            font-size: 18px;
            font-weight: 600;
        }
        .appointment-item {
            border-bottom: 1px solid #e2e8f0;
            padding: 20px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background-color 0.2s ease;
        }
        .appointment-item:hover {
            background-color: #f8fafc;
        }
        .appointment-item:last-child {
            border-bottom: none;
        }
        .appointment-info {
            flex-grow: 1;
        }
        .appointment-info strong {
            display: block;
            font-size: 18px;
            color: #1e293b;
            margin-bottom: 8px;
        }
        .appointment-details {
            color: #64748b;
            margin-top: 8px;
            font-size: 14px;
        }
        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .status.confirmed { background-color: #10b981; color: white; }
        .status.pending { background-color: #f59e0b; color: white; }
        .status.cancelled { background-color: #ef4444; color: white; }
        .status.completed { background-color: #6b7280; color: white; }
        .btn {
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 3px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(37,99,235,0.3);
            position: relative;
            overflow: hidden;
            font-size: 14px;
        }
        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        .btn:hover::before {
            left: 100%;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(37,99,235,0.4);
        }
        .btn-danger {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        }
        .btn-danger:hover {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
        }
        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
        }
        .btn-info {
            background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
        }
        .btn-info:hover {
            background: linear-gradient(135deg, #0891b2 0%, #0e7490 100%);
        }
        .error {
            color: #dc2626;
            margin-bottom: 20px;
            padding: 12px 16px;
            background-color: #fef2f2;
            border-radius: 8px;
            border-left: 4px solid #dc2626;
            font-weight: 500;
        }
        .success {
            color: #059669;
            margin-bottom: 20px;
            padding: 12px 16px;
            background-color: #f0fdf4;
            border-radius: 8px;
            border-left: 4px solid #059669;
            font-weight: 500;
        }
        .patient-info {
            margin-top: 8px;
            font-size: 14px;
            color: #64748b;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>MedVault</h1>
        <div class="nav">
            <% String userRole = (String) request.getAttribute("userRole");
               if ("doctor".equals(userRole)) { %>
                <a href="doctorDashboard">Dashboard</a>
                <a href="patients">Patients</a>
                <a href="appointments">Appointments</a>
                <a href="prescriptions">Prescriptions</a>
                <a href="profile">Profile</a>
                <a href="logout">Logout</a>
            <% } else { %>
                <a href="dashboard">Dashboard</a>
                <a href="appointments">Appointments</a>
                <a href="prescriptions">Prescriptions</a>
                <a href="profile">Profile</a>
                <a href="logout">Logout</a>
            <% } %>
        </div>
    </div>

    <div class="container">
        <div class="welcome">
            <h2><%= "doctor".equals(userRole) ? "My Appointments" : "My Appointments" %></h2>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success"><%= request.getAttribute("success") %></div>
        <% } %>

        <% if ("doctor".equals(userRole)) {
               Map<String, List<Appointment>> appointmentsByDate = (Map<String, List<Appointment>>) request.getAttribute("appointmentsByDate");
               if (appointmentsByDate != null && !appointmentsByDate.isEmpty()) {
                   for (Map.Entry<String, List<Appointment>> entry : appointmentsByDate.entrySet()) {
                       String date = entry.getKey();
                       List<Appointment> dayAppointments = entry.getValue(); %>
                       <div class="card date-section">
                           <div class="date-header">
                               <h4><%= date %></h4>
                           </div>
                           <% for (Appointment apt : dayAppointments) { %>
                               <div class="appointment-item">
                                   <div class="appointment-info">
                                       <strong><%= request.getAttribute("patientName_" + apt.getId()) %></strong>
                                       <div class="patient-info">
                                           Age: <%= request.getAttribute("patientAge_" + apt.getId()) %> |
                                           Gender: <%= request.getAttribute("patientGender_" + apt.getId()) %>
                                       </div>
                                       <div class="appointment-details">
                                           Time: <%= apt.getAppointmentTime() %> |
                                           <span class="status <%= apt.getStatus() %>"><%= apt.getStatus() %></span>
                                       </div>
                                   </div>
                                   <div>
                                       <a href="#" class="btn btn-info">View Details</a>
                                       <% if ("confirmed".equals(apt.getStatus())) { %>
                                           <a href="addPrescription?appointmentId=<%= apt.getId() %>" class="btn btn-success">Add Prescription</a>
                                       <% } %>
                                       <% if ("pending".equals(apt.getStatus())) { %>
                                           <a href="#" class="btn">Confirm</a>
                                           <form action="<%= request.getContextPath() %>/cancelAppointment" method="post" style="display:inline;">
                                               <input type="hidden" name="appointmentId" value="<%= apt.getId() %>">
                                               <button type="submit" class="btn btn-danger">Cancel</button>
                                           </form>
                                       <% } %>
                                   </div>
                               </div>
                           <% } %>
                       </div>
                   <% }
               } else { %>
                   <div class="card">
                       <p>No appointments found.</p>
                   </div>
               <% }
           } else {
               // Patient view
               List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
               if (appointments != null && !appointments.isEmpty()) { %>
                   <div class="card">
                       <h3>All Appointments</h3>
                       <% for (Appointment apt : appointments) { %>
                           <div class="appointment-item">
                               <div class="appointment-info">
                                   <strong><%= request.getAttribute("doctorName_" + apt.getId()) %> (<%= request.getAttribute("doctorSpec_" + apt.getId()) %>)</strong><br>
                                   <div class="appointment-details">
                                       Date: <%= apt.getAppointmentDate() %> | Time: <%= apt.getAppointmentTime() %> |
                                       <span class="status <%= apt.getStatus() %>"><%= apt.getStatus() %></span>
                                   </div>
                               </div>
                               <div>
                                   <a href="#" class="btn btn-info">View Details</a>
                                   <% if ("pending".equals(apt.getStatus())) { %>
                                       <form action="<%= request.getContextPath() %>/cancelAppointment" method="post" style="display:inline;">
                                           <input type="hidden" name="appointmentId" value="<%= apt.getId() %>">
                                           <button type="submit" class="btn btn-danger">Cancel</button>
                                       </form>
                                   <% } %>
                                   <% if ("confirmed".equals(apt.getStatus())) { %>
                                       <a href="#" class="btn btn-success">Join Call</a>
                                   <% } %>
                               </div>
                           </div>
                       <% } %>
                   </div>
               <% } else { %>
                   <div class="card">
                       <p>No appointments found.</p>
                   </div>
               <% }
           } %>
    </div>
</body>
</html>
