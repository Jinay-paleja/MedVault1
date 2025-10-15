package com.medvault;

public class Prescription {
    private int id;
    private int appointmentId;
    private String prescriptionText;

    // Constructors
    public Prescription() {}

    public Prescription(int appointmentId, String prescriptionText) {
        this.appointmentId = appointmentId;
        this.prescriptionText = prescriptionText;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public String getPrescriptionText() { return prescriptionText; }
    public void setPrescriptionText(String prescriptionText) { this.prescriptionText = prescriptionText; }
}
