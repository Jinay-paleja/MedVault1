 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - Register Doctor</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 50%, #cbd5e1 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            color: #1e293b;
        }
        .header {
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            color: white;
            padding: 30px 20px;
            text-align: center;
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
            font-size: 36px;
            font-weight: 600;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            position: relative;
            z-index: 1;
        }
        .container {
            max-width: 500px;
            margin: 50px auto;
            padding: 40px;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
            flex-grow: 1;
        }
        .container h2 {
            color: #1e293b;
            margin-bottom: 30px;
            text-align: center;
            font-size: 28px;
            font-weight: 600;
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 15px;
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
        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
            background-color: #f8fafc;
        }
        input[type="text"]:focus, input[type="email"]:focus, input[type="password"]:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
            background-color: #ffffff;
        }
        .btn {
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(37,99,235,0.3);
            position: relative;
            overflow: hidden;
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
            box-shadow: 0 12px 35px rgba(37,99,235,0.4);
        }
        .error {
            color: #dc2626;
            margin-bottom: 20px;
            padding: 12px 16px;
            background-color: #fef2f2;
            border-radius: 8px;
            border-left: 4px solid #dc2626;
            font-weight: 500;
            font-size: 14px;
        }
        .link {
            text-align: center;
            margin-top: 25px;
        }
        .link a {
            color: #2563eb;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 14px;
        }
        .link a:hover {
            color: #1d4ed8;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>MedVault</h1>
    </div>

    <div class="container">
        <h2>Doctor Registration</h2>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="register" method="post">
            <input type="hidden" name="role" value="doctor">

            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required>
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>

            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>

            <div class="form-group">
                <label for="phone">Phone Number:</label>
                <input type="text" id="phone" name="phone" required>
            </div>

            <div class="form-group">
                <label for="specialization">Specialization:</label>
                <input type="text" id="specialization" name="specialization" required>
            </div>

            <div class="form-group">
                <label for="institute">Institute/College Name:</label>
                <input type="text" id="institute" name="institute" required>
            </div>

            <button type="submit" class="btn">Register</button>
        </form>

        <div class="link">
            <a href="registerChoice.jsp">Back to Role Selection</a>
        </div>
    </div>
</body>
</html>
