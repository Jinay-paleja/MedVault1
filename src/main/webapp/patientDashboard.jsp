<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.medvault.Patient" %>
<%@ page import="com.medvault.Appointment" %>
<%@ page import="com.medvault.Prescription" %>
<%@ page import="com.medvault.Doctor" %>
<%!
    private String extractSection(String text, String startMarker, String endMarker) {
        int startIndex = text.indexOf(startMarker);
        if (startIndex == -1) return "";

        startIndex += startMarker.length();
        int endIndex = text.indexOf(endMarker, startIndex);
        if (endIndex == -1) return text.substring(startIndex).trim();

        return text.substring(startIndex, endIndex).trim();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - Patient Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 50%, #cbd5e1 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            color: #1e293b;
            line-height: 1.6;
        }

        .header {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            color: white;
            padding: 1.5rem 2rem;
            box-shadow: 0 4px 25px rgba(0,0,0,0.15);
            position: relative;
            backdrop-filter: blur(10px);
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

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .header h1 {
            margin: 0;
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(135deg, #ffffff 0%, #e2e8f0 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav {
            display: flex;
            gap: 1.5rem;
        }

        .nav a {
            color: white;
            text-decoration: none;
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: 500;
            font-size: 0.95rem;
            position: relative;
            overflow: hidden;
        }

        .nav a::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .nav a:hover::before {
            left: 100%;
        }

        .nav a:hover {
            background-color: rgba(255,255,255,0.15);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

        .welcome {
            text-align: center;
            margin-bottom: 3rem;
            animation: fadeInUp 0.8s ease-out;
        }

        .welcome h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0 2px 4px rgba(37,99,235,0.1);
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
            overflow: hidden;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, #2563eb, #3b82f6, #06b6d4, #10b981);
            border-radius: 20px 20px 0 0;
        }

        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 32px 64px rgba(0,0,0,0.15);
        }

        .card h3 {
            color: #1e293b;
            margin: 0 0 1.5rem 0;
            font-size: 1.5rem;
            font-weight: 600;
            position: relative;
        }

        .card h3::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 60px;
            height: 3px;
            background: linear-gradient(90deg, #2563eb, #3b82f6);
            border-radius: 2px;
        }

        .appointment-item, .prescription-item {
            border-bottom: 1px solid #e2e8f0;
            padding: 1.25rem 0;
            transition: all 0.3s ease;
            border-radius: 8px;
            margin-bottom: 0.5rem;
        }

        .appointment-item:hover, .prescription-item:hover {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            transform: translateX(4px);
            padding-left: 1rem;
        }

        .appointment-item:last-child, .prescription-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .status {
            padding: 0.375rem 0.875rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
        }

        .status.confirmed {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            box-shadow: 0 2px 8px rgba(16,185,129,0.3);
        }

        .status.pending {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
            box-shadow: 0 2px 8px rgba(245,158,11,0.3);
        }

        .status.cancelled {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 2px 8px rgba(239,68,68,0.3);
        }

        .btn {
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-weight: 500;
            font-size: 0.9rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 15px rgba(37,99,235,0.3);
            position: relative;
            overflow: hidden;
            min-height: 40px;
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
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(37,99,235,0.4);
        }

        .btn:active {
            transform: translateY(-1px);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            box-shadow: 0 4px 15px rgba(239,68,68,0.3);
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            box-shadow: 0 8px 25px rgba(239,68,68,0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            box-shadow: 0 4px 15px rgba(16,185,129,0.3);
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            box-shadow: 0 8px 25px rgba(16,185,129,0.4);
        }

        .health-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .summary-item {
            text-align: center;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            border: 1px solid rgba(255,255,255,0.2);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .summary-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #2563eb, #3b82f6, #06b6d4);
            border-radius: 16px 16px 0 0;
        }

        .summary-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.12);
        }

        .summary-item h4 {
            margin: 0 0 1rem 0;
            color: #64748b;
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .summary-item p {
            margin: 0;
            font-size: 2.5rem;
            font-weight: 700;
            color: #2563eb;
            text-shadow: 0 2px 4px rgba(37,99,235,0.1);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            color: #374151;
            font-weight: 500;
            font-size: 0.95rem;
        }

        select, input[type="date"], input[type="time"] {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 1rem;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #f8fafc;
            color: #1e293b;
        }

        select:focus, input[type="date"]:focus, input[type="time"]:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37,99,235,0.1);
            background: #ffffff;
            transform: translateY(-1px);
        }

        .error {
            color: #dc2626;
            margin-bottom: 1.5rem;
            padding: 1rem 1.25rem;
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            border-radius: 12px;
            border-left: 4px solid #dc2626;
            font-weight: 500;
        }

        .success {
            color: #059669;
            margin-bottom: 1.5rem;
            padding: 1rem 1.25rem;
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
            border-radius: 12px;
            border-left: 4px solid #059669;
            font-weight: 500;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .header-content {
                flex-direction: column;
                gap: 1rem;
            }

            .nav {
                flex-wrap: wrap;
                justify-content: center;
            }

            .welcome h2 {
                font-size: 2rem;
            }

            .card {
                padding: 1.5rem;
            }

            .health-summary {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 1rem;
            }

            .header h1 {
                font-size: 1.5rem;
            }

            .nav a {
                padding: 0.5rem 1rem;
                font-size: 0.85rem;
            }

            .welcome h2 {
                font-size: 1.75rem;
            }

            .card h3 {
                font-size: 1.25rem;
            }

            .summary-item p {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1>MedVault</h1>
            <nav class="nav">
                <a href="dashboard">Dashboard</a>
                <a href="profile">Profile</a>
                <a href="logout">Logout</a>
            </nav>
        </div>
    </div>

    <div class="container">
        <%
            String successMessage = (String) session.getAttribute("success");
            String errorMessage = (String) session.getAttribute("error");
            if (successMessage != null) {
                session.removeAttribute("success");
        %>
        <div class="success"><%= successMessage %></div>
        <%
            }
            if (errorMessage != null) {
                session.removeAttribute("error");
        %>
        <div class="error"><%= errorMessage %></div>
        <%
            }
        %>

        <div class="welcome">
            <h2>Welcome, <%= ((Patient) request.getAttribute("patient")).getName() %>!</h2>
        </div>

        <div class="dashboard-grid">
            <!-- Upcoming Appointments -->
            <div class="card">
                <h3>Upcoming Appointments</h3>
                <% List<Appointment> upcomingAppointments = (List<Appointment>) request.getAttribute("upcomingAppointments");
                   if (upcomingAppointments != null && !upcomingAppointments.isEmpty()) {
                       for (Appointment apt : upcomingAppointments) { %>
                           <div class="appointment-item">
                               <strong><%= request.getAttribute("doctorName_" + apt.getId()) %> (<%= request.getAttribute("doctorSpec_" + apt.getId()) %>)</strong><br>
                               <%= apt.getAppointmentDate() %> at <%= apt.getAppointmentTime() %><br>
                               <span class="status <%= apt.getStatus() %>"><%= apt.getStatus() %></span>
                               <a href="#" class="btn">View</a>
                               <% if ("pending".equals(apt.getStatus())) { %>
                                   <a href="#" class="btn btn-danger">Cancel</a>
                               <% } %>
                           </div>
                       <% }
                   } else { %>
                       <p>No upcoming appointments.</p>
                   <% } %>
                <a href="#bookAppointment" class="btn btn-success" style="margin-top: 10px;">Book New Appointment</a>
            </div>

            <!-- Prescription History -->
            <div class="card">
                <h3>Prescription History</h3>
                <% List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
                   if (prescriptions != null && !prescriptions.isEmpty()) {
                       for (Prescription pres : prescriptions) {
                           String prescriptionText = pres.getPrescriptionText();
                           %>
                           <div class="prescription-item">
                               <div style="margin-bottom: 10px;">
                                   <strong><%= request.getAttribute("presDate_" + pres.getId()) %> - Dr. <%= request.getAttribute("presDoctor_" + pres.getId()) %></strong>
                                   <a href="downloadPrescription?id=<%= pres.getId() %>" class="btn" style="float: right; font-size: 12px; padding: 6px 12px;">⬇ PDF</a>
                               </div>
                               <div style="clear: both;"></div>

                               <% if (prescriptionText.contains("Symptoms:")) { %>
                                   <div style="margin-bottom: 8px;">
                                       <strong style="color: #2563eb;">Symptoms:</strong>
                                       <%= extractSection(prescriptionText, "Symptoms:", "Diagnosis:") %>
                                   </div>
                               <% } %>

                               <% if (prescriptionText.contains("Diagnosis:")) { %>
                                   <div style="margin-bottom: 8px;">
                                       <strong style="color: #2563eb;">Diagnosis:</strong>
                                       <%= extractSection(prescriptionText, "Diagnosis:", "Medicines:") %>
                                   </div>
                               <% } %>

                               <% if (prescriptionText.contains("Medicines:")) { %>
                                   <div style="margin-bottom: 8px;">
                                       <strong style="color: #2563eb;">Medications:</strong><br>
                                       <div style="margin-left: 15px; font-family: 'Courier New', monospace; background: #f8fafc; padding: 8px; border-radius: 4px; margin-top: 5px;">
                                           <%= extractSection(prescriptionText, "Medicines:", "Advice:").replace("\n", "<br>") %>
                                       </div>
                                   </div>
                               <% } %>

                               <% if (prescriptionText.contains("Advice:")) { %>
                                   <div style="margin-bottom: 8px;">
                                       <strong style="color: #2563eb;">Doctor's Advice:</strong>
                                       <%= prescriptionText.substring(prescriptionText.indexOf("Advice:") + 7).trim() %>
                                   </div>
                               <% } %>
                           </div>
                       <% }
                   } else { %>
                       <p>No prescriptions found.</p>
                   <% } %>
            </div>
        </div>

        <!-- Book New Appointment -->
        <div class="card" id="bookAppointment">
            <h3>Book New Appointment</h3>
            <form action="<%= request.getContextPath() %>/bookAppointment" method="post">
                <div class="form-group">
                    <label for="doctorId">Choose Doctor:</label>
                    <select id="doctorId" name="doctorId" required>
                        <option value="">Select Doctor</option>
                        <% List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
                           if (doctors != null) {
                               for (Doctor doc : doctors) { %>
                                   <option value="<%= doc.getId() %>"><%= doc.getName() %> (<%= doc.getSpecialization() %>)</option>
                               <% }
                           } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="appointmentDate">Date:</label>
                    <input type="date" id="appointmentDate" name="appointmentDate" required>
                </div>

                <div class="form-group">
                    <label for="appointmentTime">Time:</label>
                    <input type="time" id="appointmentTime" name="appointmentTime" required>
                </div>

                <button type="submit" class="btn">Book Appointment</button>
            </form>
        </div>

        <!-- Health Summary -->
        <div class="card">
            <h3>Health Summary</h3>
            <div class="health-summary">
                <div class="summary-item">
                    <h4>Total Appointments</h4>
                    <p><%= request.getAttribute("totalAppointments") %></p>
                </div>
                <div class="summary-item">
                    <h4>Prescriptions Received</h4>
                    <p><%= request.getAttribute("prescriptionsReceived") %></p>
                </div>
                <div class="summary-item">
                    <h4>Upcoming Appointments</h4>
                    <p><%= request.getAttribute("upcomingAppointmentsCount") %></p>
                </div>
                <div class="summary-item">
                    <h4>Last Visit</h4>
                    <p><%= request.getAttribute("lastVisit") != null ? request.getAttribute("lastVisit") : "N/A" %></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
