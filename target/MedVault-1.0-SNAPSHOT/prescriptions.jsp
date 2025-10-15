<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.medvault.Patient" %>
<%@ page import="com.medvault.Prescription" %>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - My Prescriptions</title>
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
        .prescription-item {
            border-bottom: 1px solid #e2e8f0;
            padding: 20px 0;
            transition: background-color 0.2s ease;
        }
        .prescription-item:hover {
            background-color: #f8fafc;
        }
        .prescription-item:last-child {
            border-bottom: none;
        }
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
        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
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
        .prescription-details {
            margin-bottom: 15px;
        }
        .prescription-details strong {
            color: #2563eb;
            font-size: 16px;
        }
        .prescription-text {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 20px;
            border-radius: 12px;
            margin-top: 15px;
            white-space: pre-line;
            border: 1px solid #e2e8f0;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            line-height: 1.6;
            color: #374151;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>MedVault</h1>
        <div class="nav">
            <a href="dashboard">Dashboard</a>
            <a href="appointments">Appointments</a>
            <a href="prescriptions">Prescriptions</a>
            <a href="profile">Profile</a>
            <a href="logout">Logout</a>
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
                           <div style="margin-top: 10px;">
                               <a href="#" class="btn">View Details</a>
                               <a href="downloadPrescription?id=<%= pres.getId() %>" class="btn btn-success">⬇ Download PDF</a>
                           </div>
                       </div>
                   <% }
               } else { %>
                   <p>No prescriptions found.</p>
               <% } %>
        </div>
    </div>
</body>
</html>
