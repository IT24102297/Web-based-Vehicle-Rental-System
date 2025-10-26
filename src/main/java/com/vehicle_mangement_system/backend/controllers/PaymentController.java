package com.vehiclerental.backend.controllers;

import com.vehiclerental.backend.models.Payment;
import com.vehiclerental.backend.models.User;
import com.vehiclerental.backend.repositories.PaymentRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private PaymentRepository paymentRepository;

    private User getSessionUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    @GetMapping("/upload")
    public String showPaymentForm(@RequestParam(required = false) String bookingId,
                                  HttpSession session, Model model) {
        User user = getSessionUser(session);
        if (user == null) return "redirect:/login";

        model.addAttribute("user", user);
        if (bookingId != null && !bookingId.isEmpty()) {
            model.addAttribute("prefilledBookingId", bookingId);
        }
        return "payment_upload";
    }


    @PostMapping("/upload")
    public String uploadPayment(
            @RequestParam("bookingId") String bookingId,
            @RequestParam("amount") Double amount,
            @RequestParam("paymentSlip") MultipartFile paymentSlip,
            HttpSession session,
            RedirectAttributes redirectAttributes) throws IOException {

        User user = getSessionUser(session);
        if (user == null) return "redirect:/login";

        if (paymentSlip.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Please select a payment slip to upload.");
            return "redirect:/payment/upload";
        }

        String originalFilename = paymentSlip.getOriginalFilename();
        String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String uniqueName = UUID.randomUUID() + extension;
        Path uploadDir = Paths.get("./Uploads");
        if (!Files.exists(uploadDir)) Files.createDirectories(uploadDir);
        Files.write(uploadDir.resolve(uniqueName), paymentSlip.getBytes());

        Payment payment = new Payment();
        payment.setBookingId(bookingId);
        payment.setUserId(user.getUserId());
        payment.setAmount(BigDecimal.valueOf(amount));
        payment.setPaymentSlipPath(uniqueName);
        payment.setPaymentStatus("Pending");
        payment.setUploadedAt(LocalDateTime.now());
        paymentRepository.save(payment);

        redirectAttributes.addFlashAttribute("success", "Payment slip uploaded successfully!");
        redirectAttributes.addFlashAttribute("bookingId", bookingId);
        redirectAttributes.addFlashAttribute("amount", amount);

        return "redirect:/payment/upload";
    }
    // ----------------- User Payment Status -----------------
    @GetMapping("/status/{bookingId}")
    public String checkPaymentStatus(@PathVariable String bookingId, HttpSession session, Model model) {
        User user = getSessionUser(session);
        if (user == null) return "redirect:/login";

        List<Payment> payments = paymentRepository.findByUserId(user.getUserId());
        Payment payment = payments.stream()
                .filter(p -> p.getBookingId().equals(bookingId))
                .findFirst()
                .orElse(null);

        if (payment == null) {
            model.addAttribute("error", "Payment not found.");
            return "payment_pending";
        }

        model.addAttribute("bookingId", payment.getBookingId());
        model.addAttribute("amount", payment.getAmount());
        model.addAttribute("uploadTime", payment.getUploadedAt());
        model.addAttribute("paymentStatus", payment.getPaymentStatus());

        return "payment_pending";
    }

    // ----------------- Generate Invoice -----------------
    @GetMapping("/invoice/{bookingId}")
    public String generateInvoice(@PathVariable String bookingId, HttpSession session, Model model) {
        User user = getSessionUser(session);
        if (user == null) return "redirect:/login";

        Payment payment = paymentRepository.findByBookingId(bookingId);
        if (payment == null || !"Verified".equals(payment.getPaymentStatus())) {
            model.addAttribute("error", "Invoice not available for this payment.");
            return "invoice_error"; // you can create a simple error page
        }

        model.addAttribute("payment", payment);
        model.addAttribute("user", user);
        return "invoice"; // JSP page for invoice
    }

    // ----------------- Admin Manage Payments -----------------
    @GetMapping("/admin/payments")
    public String showPayments(
            HttpSession session,
            Model model,
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "sortBy", defaultValue = "paymentId") String sortBy,
            @RequestParam(value = "sortDir", defaultValue = "asc") String sortDir,
            @RequestParam(value = "message", required = false) String message) {

        User user = getSessionUser(session);
        if (user == null || !user.getRole().equals("Admin")) return "redirect:/login";

        Sort sort = Sort.by(sortDir.equalsIgnoreCase("asc") ? Sort.Direction.ASC : Sort.Direction.DESC, sortBy);
        List<Payment> payments = paymentRepository.findAll(sort);

        if (search != null && !search.trim().isEmpty()) {
            String searchLower = search.toLowerCase();
            payments = payments.stream()
                    .filter(p -> p.getBookingId().toLowerCase().contains(searchLower) ||
                            p.getUserId().toLowerCase().contains(searchLower))
                    .collect(Collectors.toList());
        }

        model.addAttribute("payments", payments);
        model.addAttribute("verifiedCount", payments.stream().filter(p -> "Verified".equals(p.getPaymentStatus())).count());
        model.addAttribute("rejectedCount", payments.stream().filter(p -> "Rejected".equals(p.getPaymentStatus())).count());
        model.addAttribute("deletedCount", payments.stream().filter(p -> "Deleted".equals(p.getPaymentStatus())).count());
        model.addAttribute("totalCount", payments.size());
        model.addAttribute("totalOutstanding", payments.stream()
                .filter(p -> "Pending".equals(p.getPaymentStatus()))
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add));

        model.addAttribute("totalPayments", payments.stream()
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add));


        model.addAttribute("currentSearch", search != null ? search : "");
        model.addAttribute("currentSortBy", sortBy);
        model.addAttribute("currentSortDir", sortDir);
        if (message != null) model.addAttribute("message", message);

        return "admin_payments";
    }

    @PostMapping("/admin/verify")
    public String verifyPayment(@RequestParam("paymentId") Long paymentId) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid payment ID"));
        payment.setPaymentStatus("Verified");
        payment.setVerifiedAt(LocalDateTime.now());
        paymentRepository.save(payment);
        return "redirect:/payment/admin/payments";
    }

    @PostMapping("/admin/reject")
    public String rejectPayment(@RequestParam("paymentId") Long paymentId) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid payment ID"));
        payment.setPaymentStatus("Rejected");
        paymentRepository.save(payment);
        return "redirect:/payment/admin/payments";
    }





    // ----------------- User Payment History -----------------
    @GetMapping("/history")
    public String viewPaymentHistory(HttpSession session, Model model) {
        User user = getSessionUser(session);
        if (user == null) return "redirect:/login";

        List<Payment> payments = paymentRepository.findByUserId(user.getUserId());
        model.addAttribute("payments", payments);

        return "payment_history"; // this is your new JSP file
    }







    @PostMapping("/admin/delete")
    public String deletePayment(@RequestParam("paymentId") Long paymentId, RedirectAttributes redirectAttributes) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid payment ID"));

        if (payment.getPaymentSlipPath() != null) {
            try {
                Path filePath = Paths.get("./Uploads", payment.getPaymentSlipPath());
                Files.deleteIfExists(filePath);
            } catch (IOException e) {
                System.err.println("Failed to delete file: " + payment.getPaymentSlipPath() + " - " + e.getMessage());
            }
        }

        paymentRepository.delete(payment);
        redirectAttributes.addAttribute("message", "Payment ID " + paymentId + " was deleted");
        return "redirect:/payment/admin/payments";









    }
}
