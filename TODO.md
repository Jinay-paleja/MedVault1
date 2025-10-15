# MedVault Project TODO

## 1. Project Structure Setup
- [x] Create src/main/java directory structure
- [x] Create src/main/webapp directory structure (WEB-INF, jsp pages)
- [x] Create lib directory for dependencies
- [x] Create web.xml for servlet configuration

## 2. Database Schema
- [x] Create schema.sql with all table definitions
- [x] Create data.sql for initial admin user and sample data

## 3. JSP Pages
- [x] Create index.jsp (home page)
- [x] Create login.jsp (common login page)
- [x] Create registerChoice.jsp (role selection popup)
- [x] Create patientRegister.jsp
- [x] Create doctorRegister.jsp
- [x] Create receptionistRegister.jsp
- [x] Create patientDashboard.jsp with all sections
- [x] Create bookAppointment.jsp
- [x] Create profile.jsp
- [x] Create success.jsp for registration success

## 4. Java Components
- [x] Create DBConnection utility class
- [x] Create User, Patient, Doctor, Receptionist bean classes
- [x] Create Appointment, Prescription bean classes
- [x] Create RegisterServlet
- [x] Create LoginServlet
- [x] Create DashboardServlet
- [x] Create BookAppointmentServlet
- [x] Create ProfileServlet

## 5. Features Implementation
- [x] Implement role-based registration logic
- [x] Implement login with auto-role detection
- [x] Implement patient dashboard data retrieval
- [x] Add appointment booking with availability check
- [x] Add prescription download functionality
- [x] Add profile editing
- [x] Add health summary calculations
- [x] Implement proper error handling and success messages

## 6. Testing and Deployment
- [x] Test database connection
- [x] Test registration flow
- [x] Test login and redirection
- [x] Test dashboard functionality
- [x] Deploy to Tomcat 10.1
