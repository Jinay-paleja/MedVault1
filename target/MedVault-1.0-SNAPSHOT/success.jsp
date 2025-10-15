<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>MedVault - Registration Successful</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f5f5f5; margin: 0; padding: 0; }
        .header { background-color: #007bff; color: white; padding: 20px; text-align: center; }
        .container { max-width: 500px; margin: 50px auto; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); text-align: center; }
        .success-icon { font-size: 48px; color: #28a745; margin-bottom: 20px; }
        .btn { background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; margin: 10px; }
        .btn:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <div class="header">
        <h1>MedVault</h1>
    </div>

    <div class="container">
        <div class="success-icon">✓</div>
        <h2>Registration Successful!</h2>
        <p>Your account has been created successfully. You can now log in to access your dashboard.</p>

        <a href="login.jsp" class="btn">Go to Login</a>
    </div>
</body>
</html>
