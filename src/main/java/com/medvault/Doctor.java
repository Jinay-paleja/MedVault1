package com.medvault;

public class Doctor {
    private int id;
    private int userId;
    private String name;
    private String phone;
    private String specialization;
    private String institute;
    private int experience;
    private String qualification;

    // Constructors
    public Doctor() {}

    public Doctor(int userId, String name, String phone, String specialization, String institute) {
        this.userId = userId;
        this.name = name;
        this.phone = phone;
        this.specialization = specialization;
        this.institute = institute;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getInstitute() { return institute; }
    public void setInstitute(String institute) { this.institute = institute; }

    public int getExperience() { return experience; }
    public void setExperience(int experience) { this.experience = experience; }

    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }
}
