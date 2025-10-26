package com.vehiclerental.backend.controllers;

import com.vehiclerental.backend.models.SupportTicket;
import com.vehiclerental.backend.models.User;
import com.vehiclerental.backend.services.SupportTicketService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/support")
public class SupportTicketController {

    @Autowired
    private SupportTicketService ticketService;

    @GetMapping("/tickets")
    public String customerTickets(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<SupportTicket> tickets = ticketService.getTicketsByCustomer(user.getUserId());
        model.addAttribute("tickets", tickets);
        model.addAttribute("user", user);
        return "support/customer-tickets";
    }

    @GetMapping("/ticket/new")
    public String newTicketForm(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "support/new-ticket";
    }

    @PostMapping("/ticket/new")
    public String createTicket(@RequestParam("description") String description,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            ticketService.createTicket(user, description);
            redirectAttributes.addFlashAttribute("success", "Support ticket created successfully!");
            return "redirect:/support/tickets";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to create ticket: " + e.getMessage());
            return "redirect:/support/ticket/new";
        }
    }

    @GetMapping("/ticket/view/{id}")
    public String viewTicket(@PathVariable("id") String id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        SupportTicket ticket = ticketService.findById(id)
                .orElseThrow(() -> new RuntimeException("Ticket not found"));
        model.addAttribute("ticket", ticket);
        model.addAttribute("user", user);
        return "support/ticket-view";
    }

    // Admin endpoints for support agents
    @GetMapping("/admin/tickets")
    public String adminTickets(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Admin".equals(user.getRole())) {
            return "redirect:/login";
        }

        List<SupportTicket> tickets = ticketService.getAllTickets();
        model.addAttribute("tickets", tickets);
        return "support/admin-tickets";
    }

    @GetMapping("/admin/ticket/update/{id}")
    public String updateTicketForm(@PathVariable("id") String id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"Admin".equals(user.getRole())) {
            return "redirect:/login";
        }

        SupportTicket ticket = ticketService.findById(id)
                .orElseThrow(() -> new RuntimeException("Ticket not found"));
        model.addAttribute("ticket", ticket);
        return "support/update-ticket";
    }

    @PostMapping("/admin/ticket/update/{id}")
    public String updateTicket(@PathVariable("id") String id,
                              @RequestParam("status") String status,
                              @RequestParam("response") String response,
                              RedirectAttributes redirectAttributes) {
        try {
            ticketService.updateTicket(id, status, response);
            redirectAttributes.addFlashAttribute("success", "Ticket updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update ticket: " + e.getMessage());
        }
        return "redirect:/support/admin/tickets";
    }

    @PostMapping("/admin/ticket/delete/{id}")
    public String deleteTicket(@PathVariable("id") String id, RedirectAttributes redirectAttributes) {
        try {
            ticketService.deleteTicket(id);
            redirectAttributes.addFlashAttribute("success", "Ticket deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to delete ticket: " + e.getMessage());
        }
        return "redirect:/support/admin/tickets";
    }
}
