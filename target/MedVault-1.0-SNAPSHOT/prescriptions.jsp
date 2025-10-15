<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.medvault.Patient" %>
<%@ page import="com.medvault.Prescription" %>
<%@ page import="com.medvault.Appointment" %>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - My Prescriptions</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: radial-gradient(1200px 600px at 20% 0%, #eff6ff, transparent),
                        radial-gradient(1000px 500px at 100% 0%, #f0f9ff, transparent),
                        linear-gradient(180deg, #f8fafc 0%, #eef2f7 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            color: #0f172a;
        }
        .header {
            background: linear-gradient(120deg, #0f172a 0%, #1e293b 35%, #0b3fa8 100%);
            color: white;
            padding: 20px 28px;
            box-shadow: 0 12px 30px rgba(2, 6, 23, 0.35);
            position: sticky;
            top: 0;
            z-index: 50;
        }
        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(59,130,246,0.15) 0%, rgba(99,102,241,0.08) 100%);
            pointer-events: none;
        }
        .header h1 {
            margin: 0;
            display: inline-block;
            font-size: 24px;
            font-weight: 700;
            letter-spacing: 0.2px;
            position: relative;
            z-index: 1;
        }
        .nav { float: right; margin-top: 4px; display: flex; gap: 12px; align-items: center; }
        .nav a {
            color: white;
            text-decoration: none;
            padding: 10px 14px;
            border-radius: 12px;
            transition: background-color 0.25s ease, transform 0.2s ease, box-shadow 0.25s ease;
            font-weight: 500;
            position: relative;
            z-index: 1;
            border: 1px solid rgba(255,255,255,0.12);
            background: linear-gradient(180deg, rgba(255,255,255,0.06), rgba(255,255,255,0.02));
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.08);
        }
        .nav a:hover {
            background-color: rgba(255,255,255,0.16);
            transform: translateY(-1px);
            box-shadow: 0 10px 20px rgba(15, 23, 42, 0.25);
        }
        .container {
            max-width: 1200px;
            margin: 32px auto;
            padding: 0 24px;
        }
        .welcome {
            margin-bottom: 28px;
            text-align: center;
        }
        .welcome h2 {
            font-size: 28px;
            margin: 0;
            background: linear-gradient(135deg, #0b3fa8 0%, #2563eb 45%, #06b6d4 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .card {
            background: rgba(255,255,255,0.92);
            backdrop-filter: blur(8px);
            border-radius: 18px;
            padding: 24px;
            box-shadow: 0 18px 40px rgba(2, 6, 23, 0.08);
            border: 1px solid rgba(226,232,240,0.8);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            position: relative;
            overflow: hidden;
            margin-bottom: 24px;
        }
        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #2563eb, #4f46e5, #06b6d4, #22c55e);
        }
        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 28px 60px rgba(2, 6, 23, 0.12);
        }
        .card h3 {
            color: #0f172a;
            margin-top: 0;
            margin-bottom: 18px;
            font-size: 20px;
            font-weight: 700;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 14px;
        }
        .prescription-item {
            border-bottom: 1px solid #e2e8f0;
            padding: 18px 0;
            transition: background-color 0.2s ease, transform 0.2s ease;
        }
        .prescription-item:hover {
            background-color: #f8fafc;
            transform: translateX(2px);
        }
        .prescription-item:last-child {
            border-bottom: none;
        }
        .actions { margin-top: 10px; display: flex; gap: 8px; flex-wrap: wrap; }
        .btn {
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            color: white;
            padding: 10px 16px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 3px;
            font-weight: 600;
            letter-spacing: 0.2px;
            transition: transform 0.2s ease, box-shadow 0.25s ease, opacity 0.25s ease;
            box-shadow: 0 10px 20px rgba(37,99,235,0.25);
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
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.28), transparent);
            transition: left 0.6s;
        }
        .btn:hover::before {
            left: 100%;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 32px rgba(37,99,235,0.35);
        }
        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
        }
        .status {
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-left: 10px;
        }
        .status.pending { background: #f59e0b; color: white; }
        .status.confirmed { background: #10b981; color: white; }
        .status.cancelled { background: #ef4444; color: white; }
        .error {
            color: #b91c1c;
            margin-bottom: 16px;
            padding: 12px 14px;
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            border-radius: 12px;
            border-left: 4px solid #ef4444;
            font-weight: 600;
        }
        .success {
            color: #065f46;
            margin-bottom: 16px;
            padding: 12px 14px;
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
            border-radius: 12px;
            border-left: 4px solid #10b981;
            font-weight: 600;
        }
        .prescription-details {
            margin-bottom: 12px;
        }
        .prescription-details strong {
            color: #1e293b;
            font-size: 16px;
        }
        .prescription-text {
            background: linear-gradient(135deg, #f8fafc 0%, #eef2f7 100%);
            padding: 16px;
            border-radius: 12px;
            margin-top: 12px;
            white-space: pre-line;
            border: 1px solid #e2e8f0;
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace;
            font-size: 13px;
            line-height: 1.65;
            color: #334155;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .nav { gap: 8px; }
            .nav a { padding: 8px 10px; font-size: 13px; }
            .welcome h2 { font-size: 24px; }
            .card { padding: 18px; }
        }
        @media (max-width: 600px) {
            .header { padding: 16px 18px; }
            .header h1 { font-size: 20px; }
            .nav { flex-wrap: wrap; justify-content: flex-end; }
            .container { padding: 0 16px; }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>MedVault</h1>
        <div class="nav">
            <% String userRole = (String) request.getAttribute("userRole"); %>
            <% if ("doctor".equals(userRole)) { %>
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
            <h2>My Prescriptions</h2>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success"><%= request.getAttribute("success") %></div>
        <% } %>

        <% if ("doctor".equals(userRole)) { %>
            <div class="card">
                <h3>Write Prescription</h3>
                <% List<Appointment> doctorAppointments = (List<Appointment>) request.getAttribute("doctorAppointments");
                   if (doctorAppointments != null && !doctorAppointments.isEmpty()) { %>
                    <div>
                        <% for (Appointment apt : doctorAppointments) { %>
                            <div class="prescription-item">
                                <div class="prescription-details">
                                    <strong><a href="addPrescription?appointmentId=<%= apt.getId() %>"><%= request.getAttribute("patientName_" + apt.getId()) %></a></strong>
                                    - <%= apt.getAppointmentDate() %> <%= apt.getAppointmentTime() %>
                                    <span class="status <%= apt.getStatus() %>"><%= apt.getStatus() %></span>
                                </div>
                                <div class="actions">
                                    <a href="addPrescription?appointmentId=<%= apt.getId() %>" class="btn btn-success">Write Prescription</a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <p>No appointments found.</p>
                <% } %>
            </div>
        <% } %>

        <% if (!"doctor".equals(userRole)) { %>
            <div class="card">
                <h3>Prescription History</h3>
                <% List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
                   if (prescriptions != null && !prescriptions.isEmpty()) {
                       for (Prescription pres : prescriptions) { %>
                           <div class="prescription-item">
                               <div class="prescription-details">
                                   <strong><%= request.getAttribute("presDoctor_" + pres.getId()) %></strong> - <%= request.getAttribute("presDate_" + pres.getId()) %>
                               </div>
                               <div class="prescription-text">
                                   <%= pres.getPrescriptionText() %>
                               </div>
                               <div class="actions">
                                   <a href="#" class="btn">View Details</a>
                                   <a href="downloadPrescription?id=<%= pres.getId() %>" class="btn btn-success">⬇ Download PDF</a>
                               </div>
                           </div>
                       <% }
                   } else { %>
                       <p>No prescriptions found.</p>
                   <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
