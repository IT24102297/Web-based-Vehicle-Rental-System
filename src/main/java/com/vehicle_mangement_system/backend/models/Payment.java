package com.vehiclerental.backend.models;

import jakarta.persistence.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity@Table(name = "Payments")
@Data
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long paymentId;

    @Column(name = "BookingID", nullable = false)
    private String bookingId;

    @Column(name = "UserID", length = 10, nullable = false)
    private String userId;

    @Column(name = "Amount", nullable = false)
    private BigDecimal amount;

    @Column(name = "PaymentSlipPath")
    private String paymentSlipPath;

    @Column(name = "PaymentStatus", nullable = false)
    private String paymentStatus;

    @Column(name = "UploadedAt", nullable = false)
    private LocalDateTime uploadedAt;

    @Column(name = "VerifiedAt")
    private LocalDateTime verifiedAt;

    @ManyToOne
    @JoinColumn(name = "UserID", referencedColumnName = "UserID", insertable = false, updatable = false)
    private User user;
}