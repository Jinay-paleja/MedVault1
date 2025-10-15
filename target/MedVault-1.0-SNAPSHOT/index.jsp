<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - Home</title>
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
            padding: 40px 20px;
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
            margin: 0 0 10px 0;
            font-size: 48px;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            position: relative;
            z-index: 1;
        }
        .header p {
            margin: 0;
            font-size: 18px;
            opacity: 0.95;
            font-weight: 400;
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
            text-align: center;
            position: relative;
        }
        .container h2 {
            color: #1e293b;
            margin-bottom: 20px;
            font-size: 32px;
            font-weight: 600;
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .container p {
            color: #64748b;
            font-size: 18px;
            line-height: 1.6;
            margin-bottom: 40px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
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
            margin: 15px;
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
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }
        .feature-card {
            background: #ffffff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #2563eb, #3b82f6, #06b6d4);
        }
        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.12);
            border-color: #cbd5e1;
        }
        .feature-card h3 {
            color: #1e293b;
            margin: 0 0 15px 0;
            font-size: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }
        .feature-card h3::before {
            content: '✓';
            color: #10b981;
            font-weight: bold;
            margin-right: 10px;
            font-size: 18px;
        }
        .feature-card p {
            color: #64748b;
            margin: 0;
            line-height: 1.6;
            font-size: 15px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>MedVault</h1>
        <p>Your trusted medical records management system</p>
    </div>

    <div class="container">
        <h2>Welcome to MedVault</h2>
        <p>Manage your medical records, appointments, and prescriptions all in one place. Experience seamless healthcare management with our modern platform.</p>

        <div style="text-align: center; margin-top: 40px;">
            <a href="login.jsp" class="btn">Login</a>
            <a href="registerChoice.jsp" class="btn">Register</a>
        </div>

        <div class="features">
            <div class="feature-card">
                <h3>📅 Appointment Management</h3>
                <p>Schedule and manage appointments with ease. View your medical history and upcoming consultations in one place.</p>
            </div>
            <div class="feature-card">
                <h3>💊 Prescription Tracking</h3>
                <p>Keep track of all your prescriptions, dosages, and medical advice from healthcare providers.</p>
            </div>
            <div class="feature-card">
                <h3>👨‍⚕️ Doctor Dashboard</h3>
                <p>For healthcare professionals: manage patients, view appointments, and create prescriptions efficiently.</p>
            </div>
        </div>
    </div>
</body>
</html>
