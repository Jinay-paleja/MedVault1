package com.medvault;

public class Patient {
    private int id;
    private int userId;
    private String name;
    private String phone;
    private int age;
    private String gender;
    private String address;

    // Constructors
    public Patient() {}

    public Patient(int userId, String name, String phone, int age, String gender, String address) {
        this.userId = userId;
        this.name = name;
        this.phone = phone;
        this.age = age;
        this.gender = gender;
        this.address = address;
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

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}
