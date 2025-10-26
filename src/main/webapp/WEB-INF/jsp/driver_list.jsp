<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:url value="/driver/add" var="addUrl"/>
<spring:url value="/admin/list" var="adminListUrl"/>
<spring:url value="/driver/list" var="driverListUrl"/>
<spring:url value="/vehicle/list" var="vehicleListUrl"/>
<spring:url value="/rental/list" var="rentalListUrl"/>
<spring:url value="/payment/admin/payments" var="financeListUrl"/>
<spring:url value="/support/admin/tickets" var="customerListUrl"/>

<html>
<head>
    <title>Driver List - DriveLK</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9fafb;
            display: flex;
            min-height: 100vh;
            color: #374151;
        }

        .sidebar { width: 256px; background-color: #ffffff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); position: fixed; height: 100%; overflow-y: auto; z-index: 10; }
        .sidebar .logo { display: flex; align-items: center; padding: 24px; font-weight: bold; }
        .sidebar nav ul { list-style: none; padding: 0; margin: 0; }
        .sidebar nav ul li { margin: 0; }
        .sidebar-link { display: flex; align-items: center; padding: 12px 24px; color: #4b5563; font-weight: 600; border-radius: 8px; transition: all 0.3s ease; text-decoration: none; }
        .sidebar-link:hover, .sidebar-link.active { background-color: #e0ecff; color: #0891b2; }

        .main-content { margin-left: 16rem; flex: 1; display: flex; flex-direction: column; }
        header { background: #fff; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 4px rgba(0,0,0,0.1); }
        header h2 { color: #0891b2; font-size: 1.5rem; margin: 0; }
        header .logout-btn { background: #f97316; color: #fff; padding: 0.5rem 1rem; border-radius: 0.5rem; text-decoration: none; font-weight: 600; transition: 0.3s; }
        header .logout-btn:hover { background: #ea580c; }

        main { padding: 2rem; flex: 1; }
        h1 { color: #0891b2; font-size: 1.75rem; font-weight: 700; margin-bottom: 1rem; }

        .add-btn { background: #0b7e9a; color: #fff; padding: 0.6rem 1.2rem; border-radius: 0.5rem; text-decoration: none; font-weight: 600; transition: 0.3s; float: right; margin-bottom: 1.5rem; }
        .add-btn:hover { background: #0e7490; }

        .table-container { background: #fff; border-radius: 0.5rem; box-shadow: 0 4px 6px rgba(0,0,0,0.1); overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; font-size: 0.95rem; }
        thead { background: #0891b2; color: #fff; }
        th, td { padding: 0.75rem 1rem; text-align: left; }
        tr { border-bottom: 1px solid #e5e7eb; transition: background 0.2s; }

        .btn { padding: 0.4rem 0.8rem; border-radius: 0.5rem; font-weight: 600; text-decoration: none; font-size: 0.85rem; transition: 0.3s; display: inline-block; margin-right: 0.3rem; }
        .btn-view { background: #0891b2; color: #fff; }
        .btn-view:hover { background: #0e7490; }
        .btn-edit { background: #135c70; color: #fff; }
        .btn-edit:hover { background: #2092b1; }
        .btn-delete { background: #dc2626; color: #fff; }
        .btn-delete:hover { background: #b91c1c; }

        .status-badge { padding: 0.3rem 0.8rem; border-radius: 1rem; font-size: 0.8rem; font-weight: 600; }
        .status-available { background: #d1fae5; color: #065f46; }
        .status-busy { background: #fee2e2; color: #991b1b; }
        .status-onleave { background: #fef3c7; color: #92400e; }

        .back-link { display: inline-block; margin-top: 2rem; color: #f97316; font-weight: 600; text-decoration: none; }
        .back-link:hover { text-decoration: underline; }

        @media(max-width: 768px) {
            .sidebar { position: relative; width: 100%; height: auto; box-shadow: none; }
            .main-content { margin-left: 0; }
            .add-btn { float: none; display: block; width: 100%; text-align: center; }
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
        <h2>Driver List</h2>
        <div>
            <span style="margin-right:1rem; color:#374151;">
                Welcome, <c:out value="${sessionScope.user.username != null ? sessionScope.user.username : 'Admin'}"/>
            </span>
            <a href="<spring:url value='/logout'/>" class="logout-btn">Logout</a>
        </div>
    </header>

    <main>
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
            <h1 style="color: #f97316; margin: 0;">Manage Drivers</h1>
            <a href="<spring:url value='/driver/add'/>" class="add-btn">Add New Driver</a>
        </div>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Driver ID</th>
                    <th>Name</th>
                    <th>License Number</th>
                    <th>License Expiry</th>
                    <th>Status</th>
                    <th>Hourly Rate</th>
                    <th>Vehicle Types</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="driver" items="${drivers}">
                    <spring:url value="/driver/view/${driver.userId}" var="viewUrl"/>
                    <spring:url value="/driver/edit/${driver.userId}" var="editUrl"/>
                    <spring:url value="/driver/delete/${driver.userId}" var="deleteUrl"/>
                    <tr>
                        <td>${driver.userId}</td>
                        <td>${driver.firstName} ${driver.lastName}</td>
                        <td>${driver.licenseNumber}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty driver.licenseExpiry}">
                                    <fmt:formatDate value="${driver.licenseExpiry}" pattern="yyyy-MM-dd"/>
                                </c:when>
                                <c:otherwise>
                                    Not set
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span class="status-badge status-${fn:toLowerCase(driver.driverStatus)}">
                                    ${driver.driverStatus}
                            </span>
                        </td>
                        <td>Rs. ${driver.hourlyRate != null ? driver.hourlyRate : '0.00'}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty driver.vehicleTypes}">
                                    ${driver.vehicleTypes}
                                </c:when>
                                <c:otherwise>
                                    Not set
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${viewUrl}" class="btn btn-view">View</a>
                            <a href="${editUrl}" class="btn btn-edit">Edit</a>
                            <a href="${deleteUrl}" onclick="return confirm('Are you sure you want to delete this driver?');" class="btn btn-delete">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <a href="<spring:url value='/admin/dashboard'/>" class="back-link">Back to Dashboard</a>
    </main>
</div>
</body>
</html>