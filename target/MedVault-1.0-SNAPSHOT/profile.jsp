<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medvault.Patient" %>
<%@ page import="com.medvault.Doctor" %>
<%@ page import="com.medvault.Receptionist" %>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - Profile</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }
        .header {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            padding: 25px 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        .header h1 {
            margin: 0;
            display: inline-block;
            font-size: 28px;
            font-weight: 600;
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
        }
        .nav a:hover {
            background-color: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }
        .container {
            max-width: 700px;
            margin: 30px auto;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            border: 1px solid rgba(255,255,255,0.2);
        }
        .container h2 {
            color: #2c3e50;
            margin-bottom: 30px;
            text-align: center;
            font-size: 28px;
            font-weight: 600;
            border-bottom: 2px solid #3498db;
            padding-bottom: 15px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 500;
            font-size: 14px;
        }
        input[type="text"], input[type="email"], input[type="number"], select, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        input[type="text"]:focus, input[type="email"]:focus, input[type="number"]:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.2);
        }
        .error {
            color: #e74c3c;
            margin-bottom: 20px;
            padding: 12px;
            background-color: #fdf2f2;
            border-radius: 8px;
            border-left: 4px solid #e74c3c;
            font-weight: 500;
        }
        .success {
            color: #27ae60;
            margin-bottom: 20px;
            padding: 12px;
            background-color: #f0f9f0;
            border-radius: 8px;
            border-left: 4px solid #27ae60;
            font-weight: 500;
        }
        .change-password {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #e9ecef;
        }
        .change-password h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 20px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>MedVault</h1>
        <div class="nav">
            <%
                String role = (String) session.getAttribute("role");
                if ("patient".equals(role)) {
            %>
                <a href="dashboard">Dashboard</a>
                <a href="appointments">Appointments</a>
                <a href="prescriptions">Prescriptions</a>
                <a href="profile">Profile</a>
                <a href="logout">Logout</a>
            <% } else if ("doctor".equals(role)) { %>
                <a href="doctorDashboard">Dashboard</a>
                <a href="patients">Patients</a>
                <a href="appointments">Appointments</a>
                <a href="prescriptions">Prescriptions</a>
                <a href="profile">Profile</a>
                <a href="logout">Logout</a>
            <% } else if ("receptionist".equals(role)) { %>
                <a href="receptionistDashboard">Dashboard</a>
                <a href="patients">Patients</a>
                <a href="appointments">Appointments</a>
                <a href="profile">Profile</a>
                <a href="logout">Logout</a>
            <% } %>
        </div>
    </div>

    <div class="container">
        <h2>My Profile</h2>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success"><%= request.getAttribute("success") %></div>
        <% } %>

        <%
            String email = (String) request.getAttribute("email");
            String userRole = (String) session.getAttribute("role");
            if ("patient".equals(userRole)) {
                Patient patient = (Patient) request.getAttribute("profile");
                if (patient != null) {
        %>

            <form action="profile" method="post">
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" value="<%= patient.getName() %>" required>
                </div>

                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" value="<%= email %>" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone:</label>
                    <input type="text" id="phone" name="phone" value="<%= patient.getPhone() %>" required>
                </div>

                <div class="form-group">
                    <label for="age">Age:</label>
                    <input type="number" id="age" name="age" value="<%= patient.getAge() %>" required>
                </div>

                <div class="form-group">
                    <label for="gender">Gender:</label>
                    <select id="gender" name="gender" required>
                        <option value="male" <%= "male".equals(patient.getGender()) ? "selected" : "" %>>Male</option>
                        <option value="female" <%= "female".equals(patient.getGender()) ? "selected" : "" %>>Female</option>
                        <option value="other" <%= "other".equals(patient.getGender()) ? "selected" : "" %>>Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="address">Address:</label>
                    <textarea id="address" name="address" required><%= patient.getAddress() %></textarea>
                </div>

                <button type="submit" class="btn">Update Profile</button>
            </form>

        <% } else { %>
            <p>No profile found. Please contact administrator.</p>
        <% }
        } else if ("doctor".equals(userRole)) {
            Doctor doctor = (Doctor) request.getAttribute("profile");
            if (doctor != null) {
        %>

            <form action="profile" method="post">
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" value="<%= doctor.getName() %>" required>
                </div>

                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" value="<%= email %>" required>
                </div>

                <div class="form-group">
                    <label for="specialization">Specialization:</label>
                    <input type="text" id="specialization" name="specialization" value="<%= doctor.getSpecialization() %>" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone:</label>
                    <input type="text" id="phone" name="phone" value="<%= doctor.getPhone() %>" required>
                </div>





                <div class="form-group">
                    <label for="institute">Institute:</label>
                    <input type="text" id="institute" name="institute" value="<%= doctor.getInstitute() %>" required>
                </div>

                <button type="submit" class="btn">Update Profile</button>
            </form>

        <% } else { %>
            <p>No profile found. Please contact administrator.</p>
        <% }
        } else if ("receptionist".equals(userRole)) {
            Receptionist receptionist = (Receptionist) request.getAttribute("profile");
            if (receptionist != null) {
        %>

            <form action="profile" method="post">
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" value="<%= receptionist.getName() %>" required>
                </div>

                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" value="<%= email %>" required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone:</label>
                    <input type="text" id="phone" name="phone" value="<%= receptionist.getPhone() %>" required>
                </div>

                <button type="submit" class="btn">Update Profile</button>
            </form>

        <% } else { %>
            <p>No profile found. Please contact administrator.</p>
        <% } } %>

        <div class="change-password">
            <h3>Change Password</h3>
        <form action="changePassword" method="post">
            <div class="form-group">
                <label for="currentPassword">Current Password:</label>
                <input type="password" id="currentPassword" name="currentPassword" required>
            </div>

            <div class="form-group">
                <label for="newPassword">New Password:</label>
                <input type="password" id="newPassword" name="newPassword" required>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm New Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>

            <button type="submit" class="btn">Change Password</button>
        </form>
        </div>
    </div>
</body>
</html>
