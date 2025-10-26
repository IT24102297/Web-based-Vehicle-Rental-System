package com.vehiclerental.backend.controllers;

import com.vehiclerental.backend.models.Driver;
import com.vehiclerental.backend.models.Rental;
import com.vehiclerental.backend.models.User;
import com.vehiclerental.backend.models.Vehicle;
import com.vehiclerental.backend.repositories.DriverRepository;
import com.vehiclerental.backend.repositories.RentalRepository;
import com.vehiclerental.backend.repositories.VehicleRepository;
import com.vehiclerental.backend.services.RentalService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Controller
@RequestMapping("/rental")
public class RentalController {

    private final VehicleRepository vehicleRepository;
    private final DriverRepository driverRepository;
    private final RentalService rentalService;
    private final RentalRepository rentalRepository;

    public RentalController(VehicleRepository vehicleRepository, DriverRepository driverRepository, RentalService rentalService, RentalRepository rentalRepository) {
        this.vehicleRepository = vehicleRepository;
        this.driverRepository = driverRepository;
        this.rentalService = rentalService;
        this.rentalRepository = rentalRepository;
    }

    @GetMapping("/vehicles")
    public String showVehicles(Model model) {
        List<Vehicle> availableVehicles = vehicleRepository.findAvailableVehicles();
        model.addAttribute("vehicles", availableVehicles);
        return "rental/vehicles";
    }

    @GetMapping("/book/{vehicleId}")
    public String showBookingForm(@PathVariable String vehicleId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Vehicle vehicle = vehicleRepository.findById(vehicleId).orElse(null);
        if (vehicle == null) {
            return "redirect:/rental/vehicles";
        }

        // Add list of available drivers
        List<Driver> drivers = driverRepository.findAll();
        model.addAttribute("drivers", drivers);

        model.addAttribute("vehicle", vehicle);
        model.addAttribute("rental", new Rental());
        return "rental/booking";
    }

    @PostMapping("/book")
    public String processBooking(@RequestParam String vehicleId,
                                 @RequestParam String startDate,
                                 @RequestParam String endDate,
                                 @RequestParam boolean withDriver,
                                 @RequestParam(required = false) String driverId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            // Validate that dates are not empty or null
            if (startDate == null || startDate.trim().isEmpty() || startDate.equals("--")) {
                throw new IllegalArgumentException("Start date is required. Please select rental dates.");
            }
            if (endDate == null || endDate.trim().isEmpty() || endDate.equals("--")) {
                throw new IllegalArgumentException("End date is required. Please select rental dates.");
            }

            LocalDate start = LocalDate.parse(startDate);
            LocalDate end = LocalDate.parse(endDate);
            LocalDate today = LocalDate.now();
            if (start.isBefore(today)) {
                throw new IllegalArgumentException("Start date must be today or later");
            }
            if (end.isBefore(start)) {
                throw new IllegalArgumentException("End date must be after start date");
            }
            long daysBetween = ChronoUnit.DAYS.between(start, end);
            if (daysBetween < 0) {
                throw new IllegalArgumentException("Invalid date range");
            }
            int numberOfDays = (int) (daysBetween + 1);
            if (numberOfDays > 30) {
                throw new IllegalArgumentException("Rental period cannot exceed 30 days");
            }

            if (withDriver && (driverId == null || driverId.isEmpty())) {
                throw new IllegalArgumentException("Driver must be selected when booking with driver");
            }

            Rental rental = rentalService.createBooking(user, vehicleId, start, end, driverId);
            // Status remains "Pending" as set in service
            redirectAttributes.addFlashAttribute("success", "Booking created successfully! It is now pending confirmation.");
            return "redirect:/rental/my-bookings";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to create booking: " + e.getMessage());
        }

        return "redirect:/rental/my-bookings";
    }

    @GetMapping("/my-bookings")
    public String showMyBookings(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Rental> bookings = rentalService.getCustomerBookings(user.getUserId());
        model.addAttribute("bookings", bookings);
        return "rental/my-bookings";
    }

    @PostMapping("/update/{rentalId}")
    public String updateBooking(@PathVariable String rentalId,
                                @RequestParam Integer numberOfDays,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            rentalService.updateBooking(rentalId, user.getUserId(), numberOfDays);
            redirectAttributes.addFlashAttribute("success", "Booking updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/rental/my-bookings";
    }

    @PostMapping("/cancel/{rentalId}")
    public String cancelBooking(@PathVariable String rentalId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            rentalService.cancelBooking(rentalId, user.getUserId());
            redirectAttributes.addFlashAttribute("success", "Booking cancelled successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/rental/my-bookings";
    }

    @PostMapping("/delete/{rentalId}")
    public String deleteBooking(@PathVariable String rentalId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            rentalService.deleteBooking(rentalId, user.getUserId());
            redirectAttributes.addFlashAttribute("success", "Booking deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/rental/my-bookings";
    }

    // ============ ADMIN ENDPOINTS ============

    @GetMapping("/list")
    public String listAllRentals(Model model, HttpSession session) {
        // Check if user is logged in and is admin
        Object user = session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Rental> rentals = rentalRepository.findAll();
        model.addAttribute("rentals", rentals);
        return "rental_list";
    }

    @GetMapping("/view/{id}")
    public String viewRental(@PathVariable String id, Model model, HttpSession session) {
        Object user = session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Rental rental = rentalRepository.findById(id).orElse(null);
        if (rental == null) {
            return "redirect:/rental/list";
        }

        model.addAttribute("rental", rental);
        return "rental_view";
    }

    @PostMapping("/admin/update-status/{id}")
    public String updateRentalStatus(@PathVariable String id,
                                     @RequestParam String status,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        Object user = session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            Rental rental = rentalRepository.findById(id).orElse(null);
            if (rental != null) {
                rental.setBookingStatus(status);
                rentalRepository.save(rental);
                redirectAttributes.addFlashAttribute("success", "Rental status updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Rental not found");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating status: " + e.getMessage());
        }

        return "redirect:/rental/list";
    }

    @GetMapping("/admin/delete/{id}")
    public String adminDeleteRental(@PathVariable String id, HttpSession session, RedirectAttributes redirectAttributes) {
        Object user = session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            rentalRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("success", "Rental deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting rental: " + e.getMessage());
        }

        return "redirect:/rental/list";
    }
}