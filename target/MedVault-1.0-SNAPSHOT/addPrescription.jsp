<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Prescription</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background: #f8fafc; }
        .header { background: linear-gradient(135deg, #1e293b 0%, #334155 100%); color: white; padding: 20px 30px; }
        .container { max-width: 900px; margin: 30px auto; background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: 600; margin-bottom: 6px; }
        textarea, input[type="text"] { width: 100%; padding: 10px; border: 1px solid #e2e8f0; border-radius: 8px; }
        .btn { background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%); color: #fff; border: none; border-radius: 25px; padding: 10px 20px; cursor: pointer; }
        .meta { color: #475569; margin-bottom: 15px; }
    </style>
    </head>
<body>
    <div class="header">
        <h2>Write Prescription</h2>
    </div>
    <div class="container">
        <div class="meta">
            Patient: <strong><%= request.getAttribute("patientName") %></strong><br>
            Appointment: <%= request.getAttribute("appointmentDate") %> at <%= request.getAttribute("appointmentTime") %>
        </div>
        <form action="<%= request.getContextPath() %>/addPrescription" method="post">
            <input type="hidden" name="appointmentId" value="<%= request.getAttribute("appointmentId") %>">
            <div class="form-group">
                <label for="symptoms">Symptoms</label>
                <textarea id="symptoms" name="symptoms" rows="4" required></textarea>
            </div>
            <div class="form-group">
                <label for="diagnosis">Diagnosis</label>
                <textarea id="diagnosis" name="diagnosis" rows="4" required></textarea>
            </div>
            <div class="form-group">
                <label for="medicines">Medicines</label>
                <textarea id="medicines" name="medicines" rows="6" required></textarea>
            </div>
            <div class="form-group">
                <label for="advice">Doctor's Advice</label>
                <textarea id="advice" name="advice" rows="4"></textarea>
            </div>
            <button type="submit" class="btn">Save Prescription</button>
        </form>
    </div>
</body>
</html>


