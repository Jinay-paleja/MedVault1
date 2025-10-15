 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.medvault.Patient" %>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - My Patients</title>
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
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #2563eb, #3b82f6, #06b6d4);
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.12);
        }
        .stat-card h3 {
            color: #64748b;
            margin: 0 0 15px 0;
            font-size: 16px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .stat-card p {
            font-size: 36px;
            font-weight: bold;
            margin: 0;
            color: #2563eb;
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
        .patient-item {
            border-bottom: 1px solid #e2e8f0;
            padding: 20px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background-color 0.2s ease;
        }
        .patient-item:hover {
            background-color: #f8fafc;
        }
        .patient-item:last-child {
            border-bottom: none;
        }
        .patient-info {
            flex-grow: 1;
        }
        .patient-info strong {
            display: block;
            font-size: 18px;
            color: #1e293b;
            margin-bottom: 8px;
        }
        .patient-details {
            color: #64748b;
            margin-top: 8px;
            font-size: 14px;
            line-height: 1.5;
        }
        .patient-actions {
            display: flex;
            gap: 10px;
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
        .search-bar {
            margin-bottom: 25px;
        }
        .search-bar input {
            width: 100%;
            max-width: 400px;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 25px;
            font-size: 14px;
            transition: all 0.3s ease;
            background-color: #f8fafc;
        }
        .search-bar input:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
            background-color: #ffffff;
        }
    </style>
<body>
    <div class="header">
        <h1>MedVault</h1>
        <div class="nav">
            <a href="doctorDashboard">Dashboard</a>
            <a href="patients">Patients</a>
            <a href="appointments">Appointments</a>
            <a href="prescriptions">Prescriptions</a>
            <a href="profile">Profile</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="welcome">
            <h2>My Patients</h2>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success"><%= request.getAttribute("success") %></div>
        <% } %>

        <!-- Statistics -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Patients</h3>
                <p><%= request.getAttribute("totalPatients") != null ? request.getAttribute("totalPatients") : "0" %></p>
            </div>
            <div class="stat-card">
                <h3>Active Patients</h3>
                <p><%= request.getAttribute("totalPatients") != null ? request.getAttribute("totalPatients") : "0" %></p>
            </div>
        </div>

        <!-- Patient List -->
        <div class="card">
            <h3>Patient Records</h3>
            <div class="search-bar">
                <input type="text" id="patientSearch" placeholder="Search patient by name or ID">
                <button class="btn" onclick="searchPatients()">Search</button>
            </div>
            <div id="patientResults">
                <% List<Patient> patients = (List<Patient>) request.getAttribute("patients");
                   if (patients != null && !patients.isEmpty()) {
                       for (Patient patient : patients) { %>
                           <div class="patient-item">
                               <div class="patient-info">
                                   <strong><%= patient.getName() %> (ID: <%= patient.getId() %>)</strong>
                                   <div class="patient-details">
                                       Age: <%= patient.getAge() %>, Gender: <%= patient.getGender() %>, Phone: <%= patient.getPhone() %><br>
                                       Address: <%= patient.getAddress() %><br>
                                       Appointments: <%= request.getAttribute("appointmentCount_" + patient.getId()) %> |
                                       Last Visit: <%= request.getAttribute("lastVisit_" + patient.getId()) != null ? request.getAttribute("lastVisit_" + patient.getId()) : "Never" %>
                                   </div>
                               </div>
                               <div class="patient-actions">
                                   <a href="#" class="btn btn-info">View History</a>
                                   <a href="#" class="btn btn-success">Start Consultation</a>
                               </div>
                           </div>
                       <% }
                   } else { %>
                       <p>No patients found.</p>
                   <% } %>
            </div>
        </div>
    </div>

    <script>
        function searchPatients() {
            const query = document.getElementById('patientSearch').value.toLowerCase();
            const items = document.querySelectorAll('.patient-item');
            items.forEach(item => {
                const text = item.textContent.toLowerCase();
                item.style.display = text.includes(query) ? 'block' : 'none';
            });
        }
    </script>
</body>
</html>
