<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <title>View Driver - DriveLK</title>
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

        .view-container { background: #fff; padding: 32px; border-radius: 16px; box-shadow: 0 6px 20px rgba(0,0,0,0.08); max-width: 700px; margin: auto; border: 1px solid #e5e7eb; }
        .view-container h3 { margin-bottom: 20px; font-size: 1.25rem; color: #111827; border-bottom: 2px solid #0891b2; padding-bottom: 8px; }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-grid div { display: flex; flex-direction: column; }
        .col-span-2 { grid-column: span 2; }

        .info-label { margin-bottom: 6px; font-weight: 600; color: #374151; font-size: 0.95rem; }
        .info-value { padding: 12px 14px; border: 1px solid #e5e7eb; border-radius: 10px; background-color: #f9fafb; font-size: 0.95rem; min-height: 44px; }

        .badge { padding: 0.3rem 0.8rem; border-radius: 1rem; font-size: 0.8rem; font-weight: 600; display: inline-block; margin-right: 0.5rem; margin-bottom: 0.5rem; }
        .status-available { background: #d1fae5; color: #065f46; }
        .status-busy { background: #fee2e2; color: #991b1b; }
        .status-onleave { background: #fef3c7; color: #92400e; }
        .vehicle-badge { background: #e0ecff; color: #0891b2; }
        .language-badge { background: #f0f9ff; color: #0c4a6e; }

        .button-group { display: flex; justify-content: center; gap: 14px; margin-top: 24px; flex-wrap: wrap; }
        .btn { padding: 10px 18px; border-radius: 10px; font-weight: 600; border: none; cursor: pointer; text-decoration: none; text-align: center; min-width: 140px; transition: transform 0.2s ease, background 0.3s ease; }
        .btn:hover { transform: translateY(-2px); }
        .btn-edit { background: #0891b2; color: #fff; }
        .btn-edit:hover { background: #0e7490; }
        .btn-back { background: #f97316; color: #fff; }
        .btn-back:hover { background: #ea580c; }
        .btn-list { background: #e5e7eb; color: #374151; }
        .btn-list:hover { background: #d1d5db; }

        .fade-in { opacity:0; transform: translateY(20px); animation: fadeInUp 0.6s ease-out forwards; }
        @keyframes fadeInUp { to { opacity:1; transform: translateY(0); } }

        @media(max-width: 768px) {
            .sidebar { position: relative; width: 100%; height: auto; left:0; }
            .main-content { margin-left: 0; }
            header { left: 0; width: 100%; }
            .info-grid { grid-template-columns: 1fr; }
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
        <div><h2>Driver Details</h2></div>
        <div>
            <span>Welcome, <c:out value="${sessionScope.user.username != null ? sessionScope.user.username : 'Admin'}"/></span>
            <a href="<spring:url value='/logout'/>" class="logout-btn">Logout</a>
        </div>
    </header>

    <main>
        <div class="fade-in" style="text-align: center; margin-bottom: 20px;">
            <p>View detailed information about the driver.</p>
        </div>
        <div class="view-container fade-in">
            <h3>Driver Information</h3>
            <div class="info-grid">
                <div>
                    <span class="info-label">Driver ID</span>
                    <div class="info-value">${driver.userId}</div>
                </div>
                <div>
                    <span class="info-label">Full Name</span>
                    <div class="info-value">${driver.firstName} ${driver.lastName}</div>
                </div>
                <div>
                    <span class="info-label">Username</span>
                    <div class="info-value">${driver.username}</div>
                </div>
                <div>
                    <span class="info-label">Contact Info</span>
                    <div class="info-value">${driver.contactInfo}</div>
                </div>
                <div>
                    <span class="info-label">Date of Birth</span>
                    <div class="info-value"><fmt:formatDate value="${driver.dateOfBirth}" pattern="yyyy-MM-dd"/></div>
                </div>
                <div>
                    <span class="info-label">Join Date</span>
                    <div class="info-value"><fmt:formatDate value="${driver.joinDate}" pattern="yyyy-MM-dd"/></div>
                </div>
                <div class="col-span-2">
                    <span class="info-label">Address</span>
                    <div class="info-value">${driver.address}</div>
                </div>
                <div>
                    <span class="info-label">License Number</span>
                    <div class="info-value">${driver.licenseNumber}</div>
                </div>
                <div>
                    <span class="info-label">License Expiry</span>
                    <div class="info-value"><fmt:formatDate value="${driver.licenseExpiry}" pattern="yyyy-MM-dd"/></div>
                </div>
                <div>
                    <span class="info-label">Driver Status</span>
                    <div class="info-value">
                        <span class="badge status-${fn:toLowerCase(driver.driverStatus)}">${driver.driverStatus}</span>
                    </div>
                </div>
                <div>
                    <span class="info-label">Hourly Rate</span>
                    <div class="info-value">Rs. ${driver.hourlyRate != null ? driver.hourlyRate : '0.00'}</div>
                </div>
                <div class="col-span-2">
                    <span class="info-label">Vehicle Types</span>
                    <div class="info-value">
                        <c:forEach items="${fn:split(driver.vehicleTypes, ',')}" var="vehicleType">
                            <span class="badge vehicle-badge">${vehicleType}</span>
                        </c:forEach>
                    </div>
                </div>
                <div class="col-span-2">
                    <span class="info-label">Languages</span>
                    <div class="info-value">
                        <c:forEach items="${fn:split(driver.languages, ',')}" var="language">
                            <span class="badge language-badge">${language}</span>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Buttons -->
            <div class="button-group">
                <spring:url value="/driver/edit/${driver.userId}" var="editUrl"/>
                <a href="${editUrl}" class="btn btn-edit">Edit Driver</a>
                <a href="${listUrl}" class="btn btn-list">Back to List</a>
                <a href="${dashboardUrl}" class="btn btn-back">Back to Dashboard</a>
            </div>
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
</script>
</body>
</html>