create database medvault1;

USE medvault1;

-- Insert sample doctors
INSERT INTO users (email, password, role) VALUES ('dr.smith@medvault.com', 'password123', 'doctor');
INSERT INTO doctors (user_id, name, phone, specialization, institute) VALUES (LAST_INSERT_ID(), 'Dr. John Smith', '1234567890', 'Cardiologist', 'Harvard Medical School');

INSERT INTO users (email, password, role) VALUES ('dr.jones@medvault.com', 'password123', 'doctor');
INSERT INTO doctors (user_id, name, phone, specialization, institute) VALUES (LAST_INSERT_ID(), 'Dr. Sarah Jones', '1234567891', 'Dermatologist', 'Johns Hopkins');

INSERT INTO users (email, password, role) VALUES ('dr.brown@medvault.com', 'password123', 'doctor');
INSERT INTO doctors (user_id, name, phone, specialization, institute) VALUES (LAST_INSERT_ID(), 'Dr. Michael Brown', '1234567892', 'Neurologist', 'Mayo Clinic');

-- Insert sample receptionist
INSERT INTO users (email, password, role) VALUES ('receptionist@medvault.com', 'password123', 'receptionist');
INSERT INTO receptionists (user_id, name, phone, address) VALUES (LAST_INSERT_ID(), 'Jane Wilson', '1234567893', '123 Hospital St, City, State');

-- Insert sample patients
INSERT INTO users (email, password, role) VALUES ('patient1@medvault.com', 'password123', 'patient');
INSERT INTO patients (user_id, name, phone, age, gender, address) VALUES (LAST_INSERT_ID(), 'Alice Johnson', '1234567894', 30, 'female', '456 Elm St, City, State');

INSERT INTO users (email, password, role) VALUES ('patient2@medvault.com', 'password123', 'patient');
INSERT INTO patients (user_id, name, phone, age, gender, address) VALUES (LAST_INSERT_ID(), 'Bob Davis', '1234567895', 45, 'male', '789 Oak St, City, State');

-- Insert sample appointments
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status) VALUES (1, 1, '2024-12-20', '10:00:00', 'confirmed');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status) VALUES (1, 2, '2024-12-25', '14:30:00', 'pending');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status) VALUES (2, 3, '2024-12-18', '09:00:00', 'completed');

-- Insert sample prescriptions
INSERT INTO prescriptions (appointment_id, prescription_text) VALUES (3, 'Paracetamol 500mg - Take 2 tablets every 6 hours for fever\nAmoxicillin 250mg - Take 1 capsule 3 times daily for 7 days');
INSERT INTO prescriptions (appointment_id, prescription_text) VALUES (1, 'Aspirin 75mg - Take 1 tablet daily\nLisinopril 10mg - Take 1 tablet daily');
