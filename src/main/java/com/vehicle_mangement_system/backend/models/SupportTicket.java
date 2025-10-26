package com.vehiclerental.backend.models;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "support_tickets")
public class SupportTicket {
    @Id
    @Column(name = "ticket_id")
    private String ticketId;

    @Column(name = "customer_id")
    private String customerId;

    @Column(name = "description", length = 2000)
    private String description;

    @Column(name = "status", length = 50)
    private String status;

    @Column(name = "response", length = 2000)
    private String response;
}
