<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:url value="/driver/add" var="addUrl"/>
<spring:url value="/driver/list" var="listUrl"/>
<spring:url value="/admin/dashboard" var="dashboardUrl"/>
<spring:url value="/admin/list" var="adminListUrl"/>
<spring:url value="/driver/list" var="driverListUrl"/>
<spring:url value="/vehicle/list" var="vehicleListUrl"/>
<spring:url value="/rental/list" var="rentalListUrl"/>
<spring:url value="/payment/admin/payments" var="financeListUrl"/>
<spring:url value="/support/admin/tickets" var="customerListUrl"/>

<html>
<head>
    <title>Add Driver - DriveLK</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        /* Use the same styling as your admin_add.jsp */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #dee3e3;
            margin: 0;
            display: flex;
            min-height: 100vh;
        }

        .sidebar { width: 256px; background-color: #ffffff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); position: fixed; height: 100%; overflow-y: auto; z-index: 10; }
        .sidebar .logo { display: flex; align-items: center; padding: 24px; font-weight: bold; }
        .sidebar nav ul { list-style: none; padding: 0; margin: 0; }
        .sidebar nav ul li { margin: 0; }
        .sidebar-link { display: flex; align-items: center; padding: 12px 24px; color: #4b5563; font-weight: 600; border-radius: 8px; transition: all 0.3s ease; text-decoration: none; }
        .sidebar-link:hover, .sidebar-link.active { background-color: #e0ecff; color: #0891b2; }

        .main-content { flex: 1; margin-left: 256px; display: flex; flex-direction: column; }
        header { background: #fff; padding: 16px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 4px rgba(0,0,0,0.1); position: fixed; top:0; left: 256px; right: 0; z-index: 20; }
        header h2 { color: #0891b2; font-size: 1.5rem; margin:0; }
        .logout-btn { background: #f97316; color: #fff; padding: 8px 16px; border-radius: 8px; text-decoration: none; font-weight: 600; transition: 0.3s; }
        .logout-btn:hover { background: #ea580c; }

        main { padding: 100px 24px 24px 24px; }

        .form-container { background: #fff; padding: 32px; border-radius: 16px; box-shadow: 0 6px 20px rgba(0,0,0,0.08); max-width: 650px; margin: auto; border: 1px solid #e5e7eb; }
        .form-container h3 { margin-bottom: 20px; font-size: 1.25rem; color: #111827; border-bottom: 2px solid #0891b2; padding-bottom: 8px; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-grid div { display: flex; flex-direction: column; }
        .col-span-2 { grid-column: span 2; }

        label { margin-bottom: 6px; font-weight: 600; color: #374151; font-size: 0.95rem; }
        input[type="text"], input[type="password"], input[type="number"], input[type="date"], select, textarea {
            padding: 12px 14px; border: 1px solid #d1d5db; border-radius: 10px; background-color: #f9fafb; font-size: 0.95rem; transition: all 0.25s ease;
        }
        input:focus, select:focus, textarea:focus { border-color: #0891b2; background-color: #fff; box-shadow: 0 0 0 4px rgba(8,145,178,0.15); }
        input[readonly] { background: #f3f4f6; color: #6b7280; cursor: not-allowed; }

        .checkbox-group { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 5px; }
        .checkbox-group label { display: flex; align-items: center; font-weight: normal; margin-bottom: 0; }
        .checkbox-group input[type="checkbox"] { margin-right: 5px; }

        .button-group { display:flex; justify-content:center; align-items:center; gap:14px; flex-wrap:nowrap; margin-top:24px; }
        .btn { padding: 10px 18px; border-radius: 10px; font-weight: 600; border: none; cursor: pointer; text-decoration: none; text-align: center; min-width: 70px; transition: transform 0.2s ease, background 0.3s ease; }
        .btn:hover { transform: translateY(-2px); }
        .btn-submit { background: #0891b2; color: #fff; }
        .btn-submit:hover { background: #0e7490; }
        .btn-cancel { background: #e5e7eb; color: #374151; }
        .btn-cancel:hover { background: #d1d5db; }
        .btn-back { background: #f97316; color: #fff; }
        .btn-back:hover { background: #ea580c; }

        .error-message { grid-column: 1 / -1; padding: 10px; background: #fee2e2; color: #b91c1c; border-radius: 6px; }
        .fade-in { opacity: 0; transform: translateY(20px); animation: fadeInUp 0.6s ease-out forwards; }
        @keyframes fadeInUp { to { opacity: 1; transform: translateY(0); } }

        @media(max-width: 768px) {
            .sidebar { position: relative; width: 100%; height: auto; left:0; }
            .main-content { margin-left: 0; }
            header { left: 0; width: 100%; }
            .form-grid { grid-template-columns: 1fr; }
            .button-group { flex-wrap: wrap; }
            .btn { flex: 1; min-width: auto; }
        }
    </style>
</head>
<body>
<!-- Sidebar -->
<aside class="sidebar">
    <div class="logo"><h1 style="color: #0891b2;">DriveLK</h1></div>
    <nav>
        <ul>
            <li><a href="<spring:url value='/admin/dashboard'/>" class="sidebar-link">Dashboard</a></li>
            <li><a href="${adminListUrl}" class="sidebar-link">Manage Admins</a></li>
            <li><a href="<spring:url value='/driver/list'/>" class="sidebar-link active">Manage Drivers</a></li>
            <li><a href="${vehicleListUrl}" class="sidebar-link">Manage Vehicles</a></li>
            <li><a href="${rentalListUrl}" class="sidebar-link">Manage Rentals</a></li>
            <li><a href="${financeListUrl}" class="sidebar-link">Manage Finances</a></li>
            <li><a href="${customerListUrl}" class="sidebar-link">Manage Customer Tickets</a></li>
        </ul>
    </nav>
</aside>

<!-- Main Content -->
<div class="main-content">
    <header>
        <div style="display:flex; align-items:center; gap:16px;">
            <h2 style="font-weight: bold;">Add New Driver</h2>
        </div>
        <div style="display:flex; align-items:center; gap:16px;">
            <span style="color:#555;">
                Welcome, <c:out value="${sessionScope.user.username != null ? sessionScope.user.username : 'Admin'}"/>
            </span>
            <a href="<spring:url value='/logout'/>" class="logout-btn">Logout</a>
        </div>
    </header>

    <main>
        <div class="mb-6 fade-in" style="text-align:center; margin-bottom:20px;">
            <p>Fill in the details to create a new driver account.</p>
        </div>
        <div class="form-container fade-in">
            <form action="${addUrl}" method="post" class="form-grid">
                <c:if test="${not empty error}"><div class="error-message">${error}</div></c:if>

                <div>
                    <label for="userId">Driver ID (Suggested: ${suggestedUserId})</label>
                    <input type="text" id="userId" name="userId" value="${suggestedUserId}" required>
                </div>
                <div>
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" required>
                </div>
                <div>
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" required>
                </div>
                <div>
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div>
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div>
                    <label for="contactInfo">Contact Info</label>
                    <input type="text" id="contactInfo" name="contactInfo">
                </div>
                <div>
                    <label for="dateOfBirth">Date of Birth (Must be 18+)</label>
                    <input type="date" id="dateOfBirth" name="dateOfBirth" required>
                </div>
                <div>
                    <label for="address">Address</label>
                    <textarea id="address" name="address" rows="3"></textarea>
                </div>
                <div>
                    <label for="licenseNumber">License Number</label>
                    <input type="text" id="licenseNumber" name="licenseNumber" required>
                </div>
                <div>
                    <label for="licenseExpiry">License Expiry Date</label>
                    <input type="date" id="licenseExpiry" name="licenseExpiry" required>
                </div>
                <div>
                    <label for="joinDate">Join Date</label>
                    <input type="date" id="joinDate" name="joinDate" readonly required>
                </div>
                <div>
                    <label for="driverStatus">Driver Status</label>
                    <select id="driverStatus" name="driverStatus" required>
                        <option value="Available">Available</option>
                        <option value="Busy">Busy</option>
                        <option value="OnLeave">On Leave</option>
                    </select>
                </div>
                <div>
                    <label for="hourlyRate">Hourly Rate (Rs.)</label>
                    <input type="number" id="hourlyRate" name="hourlyRate" step="0.01" min="0" required>
                </div>

                <div class="col-span-2">
                    <label>Vehicle Types</label>
                    <div class="checkbox-group">
                        <label><input type="checkbox" name="vehicleTypes" value="Car"> Car</label>
                        <label><input type="checkbox" name="vehicleTypes" value="Van"> Van</label>
                        <label><input type="checkbox" name="vehicleTypes" value="Bus"> Bus</label>
                    </div>
                </div>

                <div class="col-span-2">
                    <label>Languages</label>
                    <div class="checkbox-group">
                        <label><input type="checkbox" name="languages" value="Sinhala"> Sinhala</label>
                        <label><input type="checkbox" name="languages" value="Tamil"> Tamil</label>
                        <label><input type="checkbox" name="languages" value="English"> English</label>
                    </div>
                </div>

                <div class="col-span-2 button-group">
                    <button type="submit" class="btn btn-submit">
                        <span id="submit-text">Add Driver</span>
                    </button>
                    <a href="${listUrl}" class="btn btn-cancel">Cancel</a>
                    <a href="${dashboardUrl}" class="btn btn-back">Back to Dashboard</a>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    // Highlight active sidebar link
    const currentPath = window.location.pathname.replace(/\/$/, '');
    document.querySelectorAll('.sidebar-link').forEach(link => {
        const linkPath = link.getAttribute('href').replace(/\/$/, '');
        if (linkPath === currentPath) link.classList.add('active');
    });

    // Set join date to today and make it readonly
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('joinDate').value = today;

    // Calculate maximum date for date of birth (18 years ago from today)
    const maxBirthDate = new Date();
    maxBirthDate.setFullYear(maxBirthDate.getFullYear() - 18);
    const maxBirthDateStr = maxBirthDate.toISOString().split('T')[0];
    document.getElementById('dateOfBirth').max = maxBirthDateStr;

    // Set minimum date to today for license expiry
    document.getElementById('licenseExpiry').min = today;

    // Client-side validation
    document.querySelector('form').addEventListener('submit', (e) => {
        let valid = true;
        const userId = document.getElementById('userId');
        const licenseNumber = document.getElementById('licenseNumber');
        const hourlyRate = document.getElementById('hourlyRate');
        const dateOfBirth = document.getElementById('dateOfBirth');
        const licenseExpiry = document.getElementById('licenseExpiry');
        const vehicleTypes = document.querySelectorAll('input[name="vehicleTypes"]:checked');
        const languages = document.querySelectorAll('input[name="languages"]:checked');

        [userId, licenseNumber, hourlyRate, dateOfBirth, licenseExpiry].forEach(input => {
            input.style.borderColor = "#ccc";
        });

        if (!/^[D][0-9]{3}$/.test(userId.value)) {
            valid = false;
            userId.style.borderColor = "red";
            alert('Driver ID must be in format D001, D002, etc.');
        }
        if (!/^[A-Z0-9]{5,20}$/.test(licenseNumber.value)) {
            valid = false;
            licenseNumber.style.borderColor = "red";
            alert('License number must be 5-20 alphanumeric characters');
        }
        if (parseFloat(hourlyRate.value) <= 0) {
            valid = false;
            hourlyRate.style.borderColor = "red";
            alert('Hourly rate must be greater than 0');
        }

        // Check license expiry is in future
        const expiryDate = new Date(licenseExpiry.value);
        const currentDate = new Date();
        if (expiryDate <= currentDate) {
            valid = false;
            licenseExpiry.style.borderColor = "red";
            alert('License expiry must be a future date');
        }

        // Check if driver is at least 18 years old
        const birthDate = new Date(dateOfBirth.value);
        const todayDate = new Date();
        let age = todayDate.getFullYear() - birthDate.getFullYear();
        const monthDiff = todayDate.getMonth() - birthDate.getMonth();
        if (monthDiff < 0 || (monthDiff === 0 && todayDate.getDate() < birthDate.getDate())) {
            age--;
        }
        if (age < 18) {
            valid = false;
            dateOfBirth.style.borderColor = "red";
            alert('Driver must be at least 18 years old');
        }

        if (vehicleTypes.length === 0) {
            valid = false;
            alert('Please select at least one vehicle type');
        }
        if (languages.length === 0) {
            valid = false;
            alert('Please select at least one language');
        }

        if (!valid) e.preventDefault();
    });
</script>
</body>
</html>