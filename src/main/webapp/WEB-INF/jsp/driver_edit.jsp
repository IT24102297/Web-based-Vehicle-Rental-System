<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:url value="/driver/update/${driver.userId}" var="updateUrl"/>
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
    <title>Edit Driver - DriveLK</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e1e6e6;
            min-height: 100vh;
            color: #374151;
            display: flex;
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

        .button-group { display: flex; justify-content: flex-end; gap: 14px; margin-top: 24px; flex-wrap: wrap; }
        .btn { padding: 10px 18px; border-radius: 10px; font-weight: 600; border: none; cursor: pointer; text-decoration: none; text-align: center; min-width: 140px; transition: transform 0.2s ease, background 0.3s ease; }
        .btn:hover { transform: translateY(-2px); }
        .btn-submit { background: #0891b2; color: #fff; }
        .btn-submit:hover { background: #0e7490; }
        .btn-cancel { background: #e5e7eb; color: #374151; }
        .btn-cancel:hover { background: #d1d5db; }
        .btn-back { background: #f97316; color: #fff; }
        .btn-back:hover { background: #ea580c; }

        .error-message { color: #dc2626; font-size: 0.85rem; margin-top:4px; }
        .fade-in { opacity:0; transform: translateY(20px); animation: fadeInUp 0.6s ease-out forwards; }
        @keyframes fadeInUp { to { opacity:1; transform: translateY(0); } }

        @media(max-width: 768px) {
            .sidebar { position: relative; width: 100%; height: auto; left:0; }
            .main-content { margin-left: 0; }
            header { left: 0; width: 100%; }
            .form-grid { grid-template-columns: 1fr; }
            .button-group { justify-content: center; }
            .btn { flex: 1; min-width: auto; }
        }
    </style>
</head>
<body>
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

<div class="main-content">
    <header>
        <div><h2>Edit Driver</h2></div>
        <div>
            <span>Welcome, <c:out value="${sessionScope.user.username != null ? sessionScope.user.username : 'Admin'}"/></span>
            <a href="<spring:url value='/logout'/>" class="logout-btn">Logout</a>
        </div>
    </header>

    <main>
        <div class="fade-in" style="text-align: center; margin-bottom: 20px;">
            <p>Update the details for the selected driver account.</p>
        </div>
        <div class="form-container fade-in">
            <form action="${updateUrl}" method="post">
                <h3>Driver Information</h3>
                <div class="form-grid">
                    <c:if test="${not empty error}">
                        <div class="col-span-2 error-message">${error}</div>
                    </c:if>

                    <div>
                        <label for="userId">Driver ID</label>
                        <input type="text" id="userId" name="userId" value="${driver.userId}" readonly>
                    </div>
                    <div>
                        <label for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" value="${driver.firstName}" required>
                    </div>
                    <div>
                        <label for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" value="${driver.lastName}" required>
                    </div>
                    <div>
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" value="${driver.username}" required>
                    </div>
                    <div>
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" value="${driver.password}" required>
                    </div>
                    <div>
                        <label for="contactInfo">Contact Info</label>
                        <input type="text" id="contactInfo" name="contactInfo" value="${driver.contactInfo}">
                    </div>
                    <div>
                        <label for="dateOfBirth">Date of Birth (Must be 18+)</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth"
                               value="<fmt:formatDate value='${driver.dateOfBirth}' pattern='yyyy-MM-dd' />" required>
                    </div>
                    <div>
                        <label for="address">Address</label>
                        <textarea id="address" name="address" rows="3">${driver.address}</textarea>
                    </div>
                    <div>
                        <label for="licenseNumber">License Number</label>
                        <input type="text" id="licenseNumber" name="licenseNumber" value="${driver.licenseNumber}" required>
                    </div>
                    <div>
                        <label for="licenseExpiry">License Expiry Date</label>
                        <input type="date" id="licenseExpiry" name="licenseExpiry"
                               value="<fmt:formatDate value='${driver.licenseExpiry}' pattern='yyyy-MM-dd' />" required>
                    </div>
                    <div>
                        <label for="joinDate">Join Date</label>
                        <input type="date" id="joinDate" name="joinDate"
                               value="<fmt:formatDate value='${driver.joinDate}' pattern='yyyy-MM-dd' />" readonly required>
                    </div>
                    <div>
                        <label for="driverStatus">Driver Status</label>
                        <select id="driverStatus" name="driverStatus" required>
                            <option value="Available" ${driver.driverStatus == 'Available' ? 'selected' : ''}>Available</option>
                            <option value="Busy" ${driver.driverStatus == 'Busy' ? 'selected' : ''}>Busy</option>
                            <option value="OnLeave" ${driver.driverStatus == 'OnLeave' ? 'selected' : ''}>On Leave</option>
                        </select>
                    </div>
                    <div>
                        <label for="hourlyRate">Hourly Rate (Rs.)</label>
                        <input type="number" id="hourlyRate" name="hourlyRate" step="0.01" min="0"
                               value="${driver.hourlyRate != null ? driver.hourlyRate : '0.00'}" required>
                    </div>

                    <div class="col-span-2">
                        <label>Vehicle Types</label>
                        <div class="checkbox-group">
                            <label><input type="checkbox" name="vehicleTypes" value="Car" <c:if test="${fn:contains(driver.vehicleTypes, 'Car')}">checked</c:if>> Car</label>
                            <label><input type="checkbox" name="vehicleTypes" value="Van" <c:if test="${fn:contains(driver.vehicleTypes, 'Van')}">checked</c:if>> Van</label>
                            <label><input type="checkbox" name="vehicleTypes" value="Bus" <c:if test="${fn:contains(driver.vehicleTypes, 'Bus')}">checked</c:if>> Bus</label>
                        </div>
                    </div>

                    <div class="col-span-2">
                        <label>Languages</label>
                        <div class="checkbox-group">
                            <label><input type="checkbox" name="languages" value="Sinhala" <c:if test="${fn:contains(driver.languages, 'Sinhala')}">checked</c:if>> Sinhala</label>
                            <label><input type="checkbox" name="languages" value="Tamil" <c:if test="${fn:contains(driver.languages, 'Tamil')}">checked</c:if>> Tamil</label>
                            <label><input type="checkbox" name="languages" value="English" <c:if test="${fn:contains(driver.languages, 'English')}">checked</c:if>> English</label>
                        </div>
                    </div>
                </div>

                <!-- Buttons -->
                <div class="button-group">
                    <button type="submit" class="btn btn-submit">Update Driver</button>
                    <a href="${listUrl}" class="btn btn-cancel">Cancel</a>
                    <a href="${dashboardUrl}" class="btn btn-back">Back to Dashboard</a>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    // Fade-in animation
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.fade-in').forEach((el, index) => {
            el.style.animationDelay = `${index * 0.1}s`;
        });
    });

    // Client-side validation
    document.querySelector('form').addEventListener('submit', (e) => {
        let valid = true;
        const licenseNumber = document.getElementById('licenseNumber');
        const licenseExpiry = document.getElementById('licenseExpiry');
        const hourlyRate = document.getElementById('hourlyRate');
        const dateOfBirth = document.getElementById('dateOfBirth');
        const vehicleTypes = document.querySelectorAll('input[name="vehicleTypes"]:checked');
        const languages = document.querySelectorAll('input[name="languages"]:checked');

        [licenseNumber, licenseExpiry, hourlyRate, dateOfBirth].forEach(i => {
            i.style.borderColor = '#d1d5db';
            const next = i.nextElementSibling;
            if(next && next.classList.contains('error-message')) next.remove();
        });

        if(!/^[A-Z0-9]{5,20}$/.test(licenseNumber.value)){
            valid = false;
            licenseNumber.style.borderColor = '#dc2626';
            licenseNumber.insertAdjacentHTML('afterend','<p class="error-message">License number must be 5-20 alphanumeric characters</p>');
        }

        const expiryDate = new Date(licenseExpiry.value);
        const currentDate = new Date();
        if(expiryDate <= currentDate){
            valid = false;
            licenseExpiry.style.borderColor = '#dc2626';
            licenseExpiry.insertAdjacentHTML('afterend','<p class="error-message">License expiry must be a future date</p>');
        }

        if(parseFloat(hourlyRate.value) <= 0){
            valid = false;
            hourlyRate.style.borderColor = '#dc2626';
            hourlyRate.insertAdjacentHTML('afterend','<p class="error-message">Hourly rate must be greater than 0</p>');
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
            dateOfBirth.style.borderColor = '#dc2626';
            dateOfBirth.insertAdjacentHTML('afterend','<p class="error-message">Driver must be at least 18 years old</p>');
        }

        if(vehicleTypes.length === 0){
            valid = false;
            alert('Please select at least one vehicle type');
        }

        if(languages.length === 0){
            valid = false;
            alert('Please select at least one language');
        }

        if(!valid) e.preventDefault();
    });
</script>
</body>
</html>