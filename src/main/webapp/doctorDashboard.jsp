<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.medvault.Doctor" %>
<%@ page import="com.medvault.Appointment" %>
<%@ page import="com.medvault.Prescription" %>
<%@ page import="com.medvault.Patient" %>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - Doctor Dashboard</title>
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
        .profile-section {
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            color: white;
            padding: 40px;
            border-radius: 16px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0,0,0,0.08);
            position: relative;
            overflow: hidden;
        }
        .profile-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%);
            pointer-events: none;
        }
        .profile-section h3 {
            margin: 0 0 15px 0;
            font-size: 28px;
            font-weight: 700;
            position: relative;
            z-index: 1;
        }
        .profile-section p {
            margin: 8px 0;
            opacity: 0.95;
            font-size: 16px;
            position: relative;
            z-index: 1;
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
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
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
            transform: translateY(-5px);
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
        .appointment-item, .prescription-item, .patient-item {
            border-bottom: 1px solid #e2e8f0;
            padding: 15px 0;
            transition: background-color 0.2s ease;
        }
        .appointment-item:hover, .prescription-item:hover, .patient-item:hover {
            background-color: #f8fafc;
        }
        .appointment-item:last-child, .prescription-item:last-child, .patient-item:last-child {
            border-bottom: none;
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
        .btn-warning {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        }
        .btn-warning:hover {
            background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #374151;
            font-weight: 500;
            font-size: 14px;
        }
        select, input[type="text"], input[type="date"], textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background-color: #f8fafc;
            font-family: inherit;
        }
        select:focus, input[type="text"]:focus, input[type="date"]:focus, textarea:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
            background-color: #ffffff;
        }
        textarea {
            resize: vertical;
            min-height: 80px;
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
        .hidden {
            display: none;
        }
    </style>
</head>
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
        <!-- Profile Section -->
        <%
            Doctor doctor = (Doctor) request.getAttribute("doctor");
            String doctorName = (doctor != null && doctor.getName() != null && !doctor.getName().isEmpty()) ? doctor.getName() : "Doctor";
            String specialization = (doctor != null && doctor.getSpecialization() != null && !doctor.getSpecialization().isEmpty()) ? doctor.getSpecialization() : "N/A";
            String institute = (doctor != null && doctor.getInstitute() != null && !doctor.getInstitute().isEmpty()) ? doctor.getInstitute() : "N/A";
            int experience = (doctor != null) ? doctor.getExperience() : 0;
        %>
        <div class="profile-section">
            <h3>Welcome, Dr. <%= doctorName %>!</h3>
            <p><strong>Specialization:</strong> <%= specialization %></p>
            <p><strong>Institute:</strong> <%= institute %></p>
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
                <h3>Today's Appointments</h3>
                <p><%= request.getAttribute("todayAppointmentsCount") != null ? request.getAttribute("todayAppointmentsCount") : "0" %></p>
            </div>
            <div class="stat-card">
                <h3>Total Patients</h3>
                <p><%= request.getAttribute("totalPatients") != null ? request.getAttribute("totalPatients") : "0" %></p>
            </div>
            <div class="stat-card">
                <h3>Prescriptions Issued</h3>
                <p><%= request.getAttribute("prescriptionsIssued") != null ? request.getAttribute("prescriptionsIssued") : "0" %></p>
            </div>
            <div class="stat-card">
                <h3>Pending Appointments</h3>
                <p><%= request.getAttribute("pendingAppointments") != null ? request.getAttribute("pendingAppointments") : "0" %></p>
            </div>
        </div>

        <div class="dashboard-grid">
            <!-- Today's Appointments -->
            <div class="card">
                <h3>Today's Appointments</h3>
                <% List<Appointment> todayAppointments = (List<Appointment>) request.getAttribute("todayAppointments");
                   if (todayAppointments != null && !todayAppointments.isEmpty()) {
                       for (Appointment apt : todayAppointments) { %>
                           <div class="appointment-item">
                               <strong><%= request.getAttribute("patientName_" + apt.getId()) %> (<%= request.getAttribute("patientAge_" + apt.getId()) %>, <%= request.getAttribute("patientGender_" + apt.getId()) %>)</strong><br>
                               <%= apt.getAppointmentTime() %><br>
                               <span class="status <%= apt.getStatus() %>"><%= apt.getStatus() %></span>
                               <a href="#" class="btn">View Details</a>
                               <a href="#" class="btn btn-success">Add Prescription</a>
                               <% if ("confirmed".equals(apt.getStatus())) { %>
                                   <a href="#" class="btn btn-warning">Mark Completed</a>
                               <% } %>
                           </div>
                       <% }
                   } else { %>
                       <p>No appointments today.</p>
                   <% } %>
            </div>

            <!-- Prescription Management -->
            <div class="card">
                <h3>Prescription Management</h3>
                <% List<Prescription> prescriptions = (List<Prescription>) request.getAttribute("prescriptions");
                   if (prescriptions != null && !prescriptions.isEmpty()) {
                       for (Prescription pres : prescriptions) { %>
                           <div class="prescription-item">
                               <strong><%= request.getAttribute("presDate_" + pres.getId()) %> - <%= request.getAttribute("presPatient_" + pres.getId()) %></strong><br>
                               <%= pres.getPrescriptionText() %>
                               <a href="#" class="btn" style="float: right;">View / Edit</a>
                               <a href="downloadPrescription?id=<%= pres.getId() %>" class="btn" style="float: right;">⬇ PDF</a>
                           </div>
                       <% }
                   } else { %>
                       <p>No prescriptions issued yet.</p>
                   <% } %>
            </div>
        </div>

        <!-- Patient Records -->
        <div class="card">
            <h3>Patient Records</h3>
            <div class="search-bar">
                <input type="text" id="patientSearch" placeholder="Search patient by name or ID">
                <button class="btn" onclick="searchPatients()">Search</button>
            </div>
            <div id="patientResults">
                <% List<Patient> patients = (List<Patient>) request.getAttribute("patients");
                   if (patients != null && !patients.isEmpty()) {
                       for (Patient pat : patients) { %>
                           <div class="patient-item">
                               <strong><%= pat.getName() %> (ID: <%= pat.getId() %>)</strong><br>
                               Age: <%= pat.getAge() %>, Gender: <%= pat.getGender() %>, Phone: <%= pat.getPhone() %><br>
                               <a href="#" class="btn">View History</a>
                               <a href="#" class="btn btn-success">Start Consultation</a>
                           </div>
                       <% }
                   } else { %>
                       <p>No patients found.</p>
                   <% } %>
            </div>
        </div>

        <!-- Add Prescription Form (Hidden by default) -->
        <div class="card hidden" id="addPrescriptionForm">
            <h3>Add Prescription</h3>
            <div style="border: 2px solid #2563eb; border-radius: 10px; padding: 20px; background: #f8fafc;">
                <div style="text-align: center; margin-bottom: 20px;">
                    <h4 style="color: #2563eb; margin: 0;">Medical Prescription</h4>
                    <p style="margin: 5px 0; color: #64748b;">MedVault Healthcare System</p>
                </div>

                <form action="addPrescription" method="post">
                    <div class="form-group">
                        <label for="appointmentId" style="font-weight: bold;">Patient Appointment:</label>
                        <select id="appointmentId" name="appointmentId" required style="font-weight: bold;">
                            <option value="">Select Patient Appointment</option>
                            <% if (todayAppointments != null) {
                                   for (Appointment apt : todayAppointments) { %>
                                       <option value="<%= apt.getId() %>"><%= request.getAttribute("patientName_" + apt.getId()) %> - <%= apt.getAppointmentTime() %> (<%= apt.getStatus() %>)</option>
                                   <% }
                               } %>
                        </select>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                        <div class="form-group">
                            <label for="symptoms" style="font-weight: bold;">Symptoms:</label>
                            <textarea id="symptoms" name="symptoms" rows="3" placeholder="Describe patient's symptoms..." required style="width: 100%; font-family: 'Courier New', monospace;"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="diagnosis" style="font-weight: bold;">Diagnosis:</label>
                            <textarea id="diagnosis" name="diagnosis" rows="3" placeholder="Medical diagnosis..." required style="width: 100%; font-family: 'Courier New', monospace;"></textarea>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="medicines" style="font-weight: bold;">Medicines Prescribed:</label>
                        <textarea id="medicines" name="medicines" rows="6" placeholder="Medicine Name, Dosage, Duration, Instructions&#10;e.g., Paracetamol 500mg - 1 tablet every 6 hours for 5 days&#10;Aspirin 75mg - 1 tablet daily" required style="width: 100%; font-family: 'Courier New', monospace; line-height: 1.5;"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="advice" style="font-weight: bold;">Doctor's Advice / Notes:</label>
                        <textarea id="advice" name="advice" rows="3" placeholder="Additional instructions, follow-up advice..." style="width: 100%; font-family: 'Courier New', monospace;"></textarea>
                    </div>

                    <div style="text-align: center; margin-top: 20px; padding-top: 15px; border-top: 1px solid #e2e8f0;">
                        <button type="submit" class="btn btn-success" style="margin-right: 10px;">Save Prescription & Generate PDF</button>
                        <button type="button" class="btn btn-danger" onclick="hideForm()">Cancel</button>
                    </div>
                </form>
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

        function showAddPrescriptionForm() {
            document.getElementById('addPrescriptionForm').classList.remove('hidden');
        }

        function hideForm() {
            document.getElementById('addPrescriptionForm').classList.add('hidden');
        }

        // Attach event listeners to "Add Prescription" buttons
        document.querySelectorAll('.btn-success').forEach(btn => {
            if (btn.textContent.includes('Add Prescription')) {
                btn.addEventListener('click', showAddPrescriptionForm);
            }
        });
    </script>
</body>
</html>
