<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.medvault.Receptionist" %>
<%@ page import="com.medvault.Appointment" %>
<%@ page import="com.medvault.Patient" %>
<%@ page import="com.medvault.Doctor" %>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - Receptionist Dashboard</title>
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
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 30px;
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
        select, input[type="text"], input[type="date"], input[type="time"], input[type="number"], textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background-color: #f8fafc;
            font-family: inherit;
        }
        select:focus, input[type="text"]:focus, input[type="date"]:focus, input[type="time"]:focus, input[type="number"]:focus, textarea:focus {
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
        .hidden {
            display: none;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        th, td {
            padding: 15px 12px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        th {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            color: #374151;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        tbody tr {
            transition: background-color 0.2s ease;
        }
        tbody tr:hover {
            background-color: #f8fafc;
        }
        tbody tr:last-child td {
            border-bottom: none;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>MedVault</h1>
        <div class="nav">
            <a href="receptionistDashboard">Dashboard</a>
            <a href="patients">Patients</a>
            <a href="appointments">Appointments</a>
            <a href="doctors">Doctors</a>
            <a href="profile">Profile</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="welcome">
            <h2>Welcome, <%= ((Receptionist) request.getAttribute("receptionist")).getName() %>!</h2>
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
                <p><%= request.getAttribute("totalPatients") %></p>
            </div>
            <div class="stat-card">
                <h3>Today's Appointments</h3>
                <p><%= request.getAttribute("todayAppointments") %></p>
            </div>
            <div class="stat-card">
                <h3>Pending Appointments</h3>
                <p><%= request.getAttribute("pendingAppointments") %></p>
            </div>
            <div class="stat-card">
                <h3>Available Doctors</h3>
                <p><%= request.getAttribute("availableDoctors") %></p>
            </div>
        </div>

        <div class="dashboard-grid">
            <!-- Appointment Management -->
            <div class="card">
                <h3>Appointment Management</h3>
                <a href="#bookAppointment" class="btn btn-success" style="margin-bottom: 10px;">+ Add Appointment</a>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                           if (appointments != null && !appointments.isEmpty()) {
                               for (Appointment apt : appointments) { %>
                                   <tr>
                                       <td><%= apt.getId() %></td>
                                       <td><%= apt.getAppointmentDate() %></td>
                                       <td><%= apt.getAppointmentTime() %></td>
                                       <td><%= request.getAttribute("patientName_" + apt.getId()) %></td>
                                       <td><%= request.getAttribute("doctorName_" + apt.getId()) %></td>
                                       <td><span class="status <%= apt.getStatus() %>"><%= apt.getStatus() %></span></td>
                                       <td>
                                           <% if ("pending".equals(apt.getStatus())) { %>
                                               <a href="#" class="btn btn-success">Approve</a>
                                           <% } %>
                                           <a href="#" class="btn btn-warning">Edit</a>
                                           <a href="#" class="btn btn-danger">Cancel</a>
                                       </td>
                                   </tr>
                               <% }
                           } else { %>
                               <tr><td colspan="7">No appointments found.</td></tr>
                           <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Patient Management -->
            <div class="card">
                <h3>Patient Management</h3>
                <a href="#addPatient" class="btn btn-success" style="margin-bottom: 10px;">+ Add Patient</a>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Contact</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% List<Patient> patients = (List<Patient>) request.getAttribute("patients");
                           if (patients != null && !patients.isEmpty()) {
                               for (Patient pat : patients) { %>
                                   <tr>
                                       <td><%= pat.getId() %></td>
                                       <td><%= pat.getName() %></td>
                                       <td><%= pat.getAge() %></td>
                                       <td><%= pat.getGender() %></td>
                                       <td><%= pat.getPhone() %></td>
                                       <td>
                                           <a href="#" class="btn">View</a>
                                           <a href="#" class="btn btn-warning">Edit</a>
                                           <a href="#" class="btn btn-danger">Delete</a>
                                       </td>
                                   </tr>
                               <% }
                           } else { %>
                               <tr><td colspan="6">No patients found.</td></tr>
                           <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Doctor Schedule Overview -->
        <div class="card">
            <h3>Doctor Schedule Overview</h3>
            <table>
                <thead>
                    <tr>
                        <th>Doctor</th>
                        <th>Specialization</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
                       if (doctors != null && !doctors.isEmpty()) {
                           for (Doctor doc : doctors) { %>
                               <tr>
                                   <td><%= doc.getName() %></td>
                                   <td><%= doc.getSpecialization() %></td>
                                   <td>
                                       <a href="#" class="btn">View Schedule</a>
                                       <a href="#" class="btn btn-warning">Update Availability</a>
                                   </td>
                               </tr>
                           <% }
                       } else { %>
                           <tr><td colspan="3">No doctors found.</td></tr>
                       <% } %>
                </tbody>
            </table>
        </div>

        <!-- Book New Appointment -->
        <div class="card hidden" id="bookAppointment">
            <h3>Book New Appointment</h3>
            <form action="bookAppointment" method="post">
                <div class="form-group">
                    <label for="patientId">Patient:</label>
                    <select id="patientId" name="patientId" required>
                        <option value="">Select Patient</option>
                        <% if (patients != null) {
                               for (Patient pat : patients) { %>
                                   <option value="<%= pat.getId() %>"><%= pat.getName() %> (ID: <%= pat.getId() %>)</option>
                               <% }
                           } %>
                    </select>
                </div>
                <div class="form-group">
                    <label for="doctorId">Doctor:</label>
                    <select id="doctorId" name="doctorId" required>
                        <option value="">Select Doctor</option>
                        <% if (doctors != null) {
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
                <div class="form-group">
                    <label for="status">Status:</label>
                    <select id="status" name="status">
                        <option value="pending">Pending</option>
                        <option value="confirmed">Confirmed</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="notes">Notes:</label>
                    <input type="text" id="notes" name="notes">
                </div>
                <button type="submit" class="btn btn-success">Book Appointment</button>
                <button type="button" class="btn btn-danger" onclick="hideForm('bookAppointment')">Cancel</button>
            </form>
        </div>

        <!-- Add New Patient -->
        <div class="card hidden" id="addPatient">
            <h3>Add New Patient</h3>
            <form action="addPatient" method="post">
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="age">Age:</label>
                    <input type="number" id="age" name="age" required>
                </div>
                <div class="form-group">
                    <label for="gender">Gender:</label>
                    <select id="gender" name="gender" required>
                        <option value="">Select Gender</option>
                        <option value="male">Male</option>
                        <option value="female">Female</option>
                        <option value="other">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="phone">Phone:</label>
                    <input type="text" id="phone" name="phone" required>
                </div>
                <div class="form-group">
                    <label for="address">Address:</label>
                    <textarea id="address" name="address" rows="3"></textarea>
                </div>
                <button type="submit" class="btn btn-success">Add Patient</button>
                <button type="button" class="btn btn-danger" onclick="hideForm('addPatient')">Cancel</button>
            </form>
        </div>
    </div>

    <script>
        function showForm(formId) {
            document.getElementById(formId).classList.remove('hidden');
        }

        function hideForm(formId) {
            document.getElementById(formId).classList.add('hidden');
        }

        // Attach event listeners
        document.querySelectorAll('a[href="#bookAppointment"]').forEach(link => {
            link.addEventListener('click', () => showForm('bookAppointment'));
        });

        document.querySelectorAll('a[href="#addPatient"]').forEach(link => {
            link.addEventListener('click', () => showForm('addPatient'));
        });
    </script>
</body>
</html>
