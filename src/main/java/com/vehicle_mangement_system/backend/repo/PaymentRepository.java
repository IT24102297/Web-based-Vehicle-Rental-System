package com.vehiclerental.backend.repositories;

import com.vehiclerental.backend.models.Payment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByUserId(String userId);

    Payment findByBookingId(String bookingId);

}