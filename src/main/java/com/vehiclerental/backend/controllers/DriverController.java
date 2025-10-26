package com.vehiclerental.backend.controllers;

import com.vehiclerental.backend.models.Driver;
import com.vehiclerental.backend.models.Rental;
import com.vehiclerental.backend.models.User;
import com.vehiclerental.backend.repositories.RentalRepository;
import com.vehiclerental.backend.services.DriverService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/driver")
public class DriverController {

    @Autowired
    private DriverService driverService;

    @Autowired
    private RentalRepository rentalRepository;

    // Driver Dashboard - for logged-in drivers
    @GetMapping("/dashboard")
    public String driverDashboard(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // Get driver information
        Driver driver = driverService.getDriverById(user.getUserId()).orElse(null);
        if (driver == null) {
            model.addAttribute("error", "Driver profile not found");
            return "redirect:/login";
        }

        // Get driver's assigned rentals
        List<Rental> assignedRentals = rentalRepository.findAll().stream()
                .filter(r -> r.getDriver() != null && r.getDriver().getUserId().equals(user.getUserId()))
                .toList();

        model.addAttribute("driver", driver);
        model.addAttribute("assignedRentals", assignedRentals);
        return "driver_dashboard";
    }

    // Admin endpoint - List all drivers
    @GetMapping("/list")
    public String getAllDrivers(Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        List<Driver> drivers = driverService.getAllDrivers();
        model.addAttribute("drivers", drivers);
        return "driver_list";
    }

    @GetMapping("/add")
    public String showAddDriverForm(Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        String suggestedUserId = driverService.generateDriverId();
        model.addAttribute("suggestedUserId", suggestedUserId);
        model.addAttribute("driver", new Driver());
        return "driver_add";
    }

    @PostMapping("/add")
    public String createDriver(@ModelAttribute Driver driver, RedirectAttributes redirectAttributes) {
        try {
            driverService.saveDriver(driver);
            redirectAttributes.addFlashAttribute("success", "Driver registered successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error registering driver: " + e.getMessage());
        }
        return "redirect:/driver/list";
    }

    @GetMapping("/edit/{driverId}")
    public String showEditDriverForm(@PathVariable String driverId, Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        Driver driver = driverService.getDriverById(driverId)
                .orElseThrow(() -> new RuntimeException("Driver not found with id: " + driverId));
        model.addAttribute("driver", driver);
        return "driver_edit";
    }

    @PostMapping("/update/{driverId}")
    public String updateDriver(@PathVariable String driverId, @ModelAttribute Driver driverDetails,
                              RedirectAttributes redirectAttributes) {
        try {
            driverService.updateDriver(driverId, driverDetails);
            redirectAttributes.addFlashAttribute("success", "Driver updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error updating driver: " + e.getMessage());
        }
        return "redirect:/driver/list";
    }

    @GetMapping("/delete/{driverId}")
    public String deleteDriver(@PathVariable String driverId, RedirectAttributes redirectAttributes) {
        try {
            driverService.deleteDriver(driverId);
            redirectAttributes.addFlashAttribute("success", "Driver deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting driver: " + e.getMessage());
        }
        return "redirect:/driver/list";
    }

    @GetMapping("/view/{driverId}")
    public String viewDriver(@PathVariable String driverId, Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        Driver driver = driverService.getDriverById(driverId)
                .orElseThrow(() -> new RuntimeException("Driver not found with id: " + driverId));
        model.addAttribute("driver", driver);
        return "driver_view";
    }
}
