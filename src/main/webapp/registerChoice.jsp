<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - Register</title>
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
            max-width: 900px;
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
            margin-bottom: 40px;
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
        .role-option {
            margin: 25px 0;
            padding: 30px;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #ffffff;
            position: relative;
            overflow: hidden;
        }
        .role-option::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #2563eb, #3b82f6, #06b6d4);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        .role-option:hover::before {
            transform: scaleX(1);
        }
        .role-option:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.12);
            border-color: #cbd5e1;
        }
        .role-option h3 {
            margin: 0 0 15px 0;
            color: #1e293b;
            font-size: 22px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }
        .role-option h3::before {
            content: '👤';
            margin-right: 12px;
            font-size: 24px;
        }
        .role-option:nth-child(2) h3::before {
            content: '👨‍⚕️';
        }
        .role-option:nth-child(3) h3::before {
            content: '🏥';
        }
        .role-option p {
            margin: 0;
            color: #64748b;
            line-height: 1.6;
            font-size: 15px;
        }
        .btn {
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            color: white;
            padding: 15px 40px;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 20px;
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
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(37,99,235,0.4);
        }
        .login-link {
            text-align: center;
            margin-top: 40px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>MedVault</h1>
    </div>

    <div class="container">
        <h2>Register as</h2>

        <div class="role-option" onclick="window.location.href='registerPatient.jsp'">
            <h3>Patient</h3>
            <p>Register as a patient to manage your medical records, appointments, and prescriptions.</p>
        </div>

        <div class="role-option" onclick="window.location.href='registerDoctor.jsp'">
            <h3>Doctor</h3>
            <p>Register as a doctor to manage patient appointments and prescriptions.</p>
        </div>

        <div class="role-option" onclick="window.location.href='registerReceptionist.jsp'">
            <h3>Receptionist</h3>
            <p>Register as a receptionist to manage appointments and patient records.</p>
        </div>

        <div class="login-link">
            <a href="login.jsp" class="btn">Already have an account? Login</a>
        </div>
    </div>
</body>
</html>
