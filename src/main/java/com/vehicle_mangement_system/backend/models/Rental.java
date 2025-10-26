// Rental.java
package com.vehiclerental.backend.models;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "Rental")
public class Rental {
    @Id
    @Column(name = "RentalID", length = 10)
    private String rentalId;

    @ManyToOne
    @JoinColumn(name = "CustomerID")
    private User customer;

    @ManyToOne
    @JoinColumn(name = "VehicleID")
    private Vehicle vehicle;

    @ManyToOne
    @JoinColumn(name = "DriverID")
    private Driver driver;

    @Column(name = "RentalStartDate")
    private LocalDate rentalStartDate;

    @Column(name = "RentalEndDate")
    private LocalDate rentalEndDate;

    @Column(name = "BookingStatus", length = 20)
    private String bookingStatus;

    // Fix: Use BigDecimal instead of Double for precise decimal handling
    @Column(name = "TotalCost", precision = 10, scale = 2)
    private java.math.BigDecimal totalCost;

    @Column(name = "NumberOfDays")
    private Integer numberOfDays;

    // Getters and Setters
    public String getRentalId() { return rentalId; }
    public void setRentalId(String rentalId) { this.rentalId = rentalId; }
    public User getCustomer() { return customer; }
    public void setCustomer(User customer) { this.customer = customer; }
    public Vehicle getVehicle() { return vehicle; }
    public void setVehicle(Vehicle vehicle) { this.vehicle = vehicle; }
    public Driver getDriver() { return driver; }
    public void setDriver(Driver driver) { this.driver = driver; }
    public LocalDate getRentalStartDate() { return rentalStartDate; }
    public void setRentalStartDate(LocalDate rentalStartDate) { this.rentalStartDate = rentalStartDate; }
    public LocalDate getRentalEndDate() { return rentalEndDate; }
    public void setRentalEndDate(LocalDate rentalEndDate) { this.rentalEndDate = rentalEndDate; }
    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
    public java.math.BigDecimal getTotalCost() { return totalCost; }
    public void setTotalCost(java.math.BigDecimal totalCost) { this.totalCost = totalCost; }
    public Integer getNumberOfDays() { return numberOfDays; }
    public void setNumberOfDays(Integer numberOfDays) { this.numberOfDays = numberOfDays; }

    // Transient formatted date getters for JSP
    @Transient
    public String getFormattedStartDate() {
        if (rentalStartDate != null) {
            return rentalStartDate.format(DateTimeFormatter.ofPattern("MMM dd, yyyy"));
        }
        return "";
    }

    @Transient
    public String getFormattedEndDate() {
        if (rentalEndDate != null) {
            return rentalEndDate.format(DateTimeFormatter.ofPattern("MMM dd, yyyy"));
        }
        return "";
    }
}