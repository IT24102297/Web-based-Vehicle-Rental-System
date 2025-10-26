package com.vehiclerental.backend.models;

import jakarta.persistence.*;

@Entity
@Table(name = "drivers")
public class Driver {

    @Id
    @Column(name = "UserID", length = 10)
    private String userId;

    @Column(name = "FirstName", length = 50)
    private String firstName;

    @Column(name = "LastName", length = 50)
    private String lastName;

    @Column(name = "Username", length = 50, nullable = false, unique = true)
    private String username;

    @Column(name = "Password", length = 255, nullable = false)
    private String password;

    @Column(name = "ContactInfo", length = 100)
    private String contactInfo;

    @Column(name = "Role", length = 20)
    private String role = "Driver";

    // Driver-specific fields
    @Column(name = "LicenseNumber")
    private String licenseNumber;

    @Column(name = "LicenseExpiry")
    private java.sql.Date licenseExpiry;

    @Column(name = "DriverStatus")
    private String driverStatus = "Available";

    @Column(name = "HourlyRate", precision = 10, scale = 2)
    private java.math.BigDecimal hourlyRate;

    // Additional driver-specific attributes
    @Column(name = "DateOfBirth")
    private java.sql.Date dateOfBirth;

    @Column(name = "Address", length = 255)
    private String address;

    @Column(name = "VehicleTypes", length = 100)
    private String vehicleTypes;

    @Column(name = "Languages", length = 100)
    private String languages;

    @Column(name = "JoinDate")
    private java.sql.Date joinDate;

    // ManyToOne relationship with User
    @ManyToOne
    @JoinColumn(name = "UserID", referencedColumnName = "UserID", insertable = false, updatable = false)
    private User user;

    // Constructors
    public Driver() {}

    public Driver(String userId, String firstName, String lastName, String username,
                  String password, String licenseNumber) {
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.username = username;
        this.password = password;
        this.licenseNumber = licenseNumber;
        this.role = "Driver";
        this.driverStatus = "Available";
    }

    // Getters and Setters
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }

    public java.sql.Date getLicenseExpiry() { return licenseExpiry; }
    public void setLicenseExpiry(java.sql.Date licenseExpiry) { this.licenseExpiry = licenseExpiry; }

    public String getDriverStatus() { return driverStatus; }
    public void setDriverStatus(String driverStatus) { this.driverStatus = driverStatus; }

    public java.math.BigDecimal getHourlyRate() { return hourlyRate; }
    public void setHourlyRate(java.math.BigDecimal hourlyRate) { this.hourlyRate = hourlyRate; }

    public java.sql.Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(java.sql.Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getVehicleTypes() { return vehicleTypes; }
    public void setVehicleTypes(String vehicleTypes) { this.vehicleTypes = vehicleTypes; }

    public String getLanguages() { return languages; }
    public void setLanguages(String languages) { this.languages = languages; }

    public java.sql.Date getJoinDate() { return joinDate; }
    public void setJoinDate(java.sql.Date joinDate) { this.joinDate = joinDate; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}
