<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<html>
<head>
    <title>Driver Dashboard - DriveLK</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        /* Reset & Body */
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #374151;
        }

        /* Header */
        header {
            background: rgba(255, 255, 255, 0.95);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        header h1 {
            color: #667eea;
            font-size: 1.75rem;
            margin: 0;
        }
        header .logout-btn {
            background: #f97316;
            color: #fff;
            padding: 0.5rem 1.5rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
        }
        header .logout-btn:hover {
            background: #ea580c;
        }

        /* Main Container */
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* Welcome Card */
        .welcome-card {
            background: #fff;
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .welcome-card h2 {
            color: #667eea;
            font-size: 2rem;
            margin: 0 0 1rem 0;
        }

        .driver-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }

        .info-box {
            background: #f9fafb;
            padding: 1.5rem;
            border-radius: 0.5rem;
            border-left: 4px solid #667eea;
        }

        .info-label {
            font-weight: 700;
            color: #6b7280;
            font-size: 0.875rem;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
        }

        .info-value {
            font-size: 1.25rem;
            color: #1f2937;
            font-weight: 600;
        }

        /* Section Title */
        .section-title {
            color: #fff;
            font-size: 1.5rem;
            font-weight: 700;
            margin: 2rem 0 1rem 0;
            display: flex;
            align-items: center;
        }

        .section-title::before {
            content: "";
            display: inline-block;
            width: 4px;
            height: 1.5rem;
            background: #fbbf24;
            margin-right: 0.75rem;
        }

        /* Rentals Card */
        .rentals-card {
            background: #fff;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        thead {
            background: #667eea;
            color: #fff;
        }

        th, td {
            padding: 1rem;
            text-align: left;
        }

        tr {
            border-bottom: 1px solid #e5e7eb;
        }

        tbody tr:hover {
            background-color: #f3f4f6;
        }

        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 1rem;
            font-size: 0.875rem;
            font-weight: 600;
            display: inline-block;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-confirmed {
            background: #d1fae5;
            color: #065f46;
        }

        .status-active {
            background: #dbeafe;
            color: #1e40af;
        }

        .status-completed {
            background: #e0e7ff;
            color: #3730a3;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #9ca3af;
        }

        .empty-state svg {
            width: 80px;
            height: 80px;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 1.5rem;
            border-radius: 0.75rem;
            box-shadow: 0 4px 10px rgba(0,0,0,0.15);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            font-size: 0.95rem;
            opacity: 0.9;
        }

        /* Responsive */
        @media(max-width: 768px) {
            .container {
                padding: 0 1rem;
            }
            header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
            .driver-info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<header>
    <h1>DriveLK Driver Portal</h1>
    <div>
        <span style="margin-right:1rem; color:#374151;">
            Welcome, <c:out value="${driver.firstName} ${driver.lastName}"/>
        </span>
        <a href="<spring:url value='/logout'/>" class="logout-btn">Logout</a>
    </div>
</header>

<!-- Main Container -->
<div class="container">
    <!-- Welcome Card -->
    <div class="welcome-card">
        <h2>Welcome, ${driver.firstName}!</h2>
        <p style="color: #6b7280; font-size: 1.1rem;">Driver ID: ${driver.userId}</p>

        <div class="driver-info-grid">
            <div class="info-box">
                <div class="info-label">Full Name</div>
                <div class="info-value">${driver.firstName} ${driver.lastName}</div>
            </div>

            <div class="info-box">
                <div class="info-label">License Number</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty driver.licenseNumber}">
                            ${driver.licenseNumber}
                        </c:when>
                        <c:otherwise>
                            <span style="color: #9ca3af;">Not Set</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="info-box">
                <div class="info-label">Contact Info</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty driver.contactInfo}">
                            ${driver.contactInfo}
                        </c:when>
                        <c:otherwise>
                            <span style="color: #9ca3af;">Not Set</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="info-box">
                <div class="info-label">Status</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${driver.driverStatus == 'Available'}">
                            <span style="color: #10b981;">Available</span>
                        </c:when>
                        <c:otherwise>
                            ${driver.driverStatus}
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="info-box">
                <div class="info-label">Username</div>
                <div class="info-value">${driver.username}</div>
            </div>

            <div class="info-box">
                <div class="info-label">Address</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty driver.address}">
                            ${driver.address}
                        </c:when>
                        <c:otherwise>
                            <span style="color: #9ca3af;">Not Set</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Statistics -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-number">${assignedRentals.size()}</div>
            <div class="stat-label">Total Assignments</div>
        </div>

        <div class="stat-card">
            <div class="stat-number">
                <c:set var="activeCount" value="0"/>
                <c:forEach var="rental" items="${assignedRentals}">
                    <c:if test="${rental.bookingStatus == 'Active'}">
                        <c:set var="activeCount" value="${activeCount + 1}"/>
                    </c:if>
                </c:forEach>
                ${activeCount}
            </div>
            <div class="stat-label">Active Assignments</div>
        </div>

        <div class="stat-card">
            <div class="stat-number">
                <c:set var="completedCount" value="0"/>
                <c:forEach var="rental" items="${assignedRentals}">
                    <c:if test="${rental.bookingStatus == 'Completed'}">
                        <c:set var="completedCount" value="${completedCount + 1}"/>
                    </c:if>
                </c:forEach>
                ${completedCount}
            </div>
            <div class="stat-label">Completed Trips</div>
        </div>
    </div>

    <!-- Assigned Rentals Section -->
    <h2 class="section-title">My Assignments</h2>
    <div class="rentals-card">
        <c:choose>
            <c:when test="${empty assignedRentals}">
                <div class="empty-state">
                    <div style="font-size: 3rem;">🚗</div>
                    <h3 style="color: #6b7280;">No Assignments Yet</h3>
                    <p>You don't have any rental assignments at the moment.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th>Rental ID</th>
                        <th>Customer</th>
                        <th>Vehicle</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Days</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="rental" items="${assignedRentals}">
                        <tr>
                            <td>${rental.rentalId}</td>
                            <td>
                                <c:out value="${rental.customer.firstName} ${rental.customer.lastName}"/>
                            </td>
                            <td>
                                <c:out value="${rental.vehicle.brand} ${rental.vehicle.model}"/>
                            </td>
                            <td>${rental.formattedStartDate}</td>
                            <td>${rental.formattedEndDate}</td>
                            <td>${rental.numberOfDays} days</td>
                            <td>
                                <c:choose>
                                    <c:when test="${rental.bookingStatus == 'Pending'}">
                                        <span class="status-badge status-pending">Pending</span>
                                    </c:when>
                                    <c:when test="${rental.bookingStatus == 'Confirmed'}">
                                        <span class="status-badge status-confirmed">Confirmed</span>
                                    </c:when>
                                    <c:when test="${rental.bookingStatus == 'Active'}">
                                        <span class="status-badge status-active">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-completed">Completed</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
