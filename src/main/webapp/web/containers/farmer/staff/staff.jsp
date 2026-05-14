<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoultryPro - Staff Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Early global variable so all included scripts can use it -->
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
</head>
<body class="bg-gray-50 dark:bg-gray-900">

<%@ include file="../../../components/layout/layout2.0.jsp" %>
<%@ include file="../../../components/forms/staff-form-panel.jsp" %>

<div id="mainContent" class="transition-all duration-300" style="margin-left: 280px; padding-top: 64px;">
    <div class="container mx-auto px-6 py-8">

        <!-- Page Header -->
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Staff Management</h1>
                <p class="text-gray-600 dark:text-gray-400 mt-1">Manage farm staff and their assignments</p>
            </div>
            <div class="flex items-center space-x-3 mt-4 sm:mt-0">
                <button onclick="refreshStaffList()" class="p-3 bg-white dark:bg-gray-800 rounded-xl shadow hover:shadow-lg text-gray-600 dark:text-gray-300">
                    <i class="fas fa-sync-alt"></i>
                </button>
                <c:if test="${sessionScope.userRole eq 'farm_owner'}">
                    <button id="addStaffBtn" class="bg-gradient-to-r from-blue-500 to-blue-600 text-white px-5 py-3 rounded-xl font-semibold shadow-md hover:shadow-xl flex items-center gap-2">
                        <i class="fas fa-plus"></i> Add Staff
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Sub Navigation -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-2 mb-6 border">
            <nav class="flex space-x-2">
                <a href="staff.jsp" class="px-4 py-2.5 rounded-lg bg-blue-500 text-white font-semibold shadow">
                    <i class="fas fa-users mr-2"></i> Staff
                </a>
            </nav>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border">
                <div class="flex items-center justify-between">
                    <span class="text-sm font-medium">Total Staff</span>
                    <i class="fas fa-users text-blue-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold mt-2 stats-total">0</p>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border">
                <div class="flex items-center justify-between">
                    <span class="text-sm font-medium">Active</span>
                    <i class="fas fa-user-check text-green-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold mt-2 stats-active">0</p>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border">
                <div class="flex items-center justify-between">
                    <span class="text-sm font-medium">Blocked</span>
                    <i class="fas fa-user-lock text-red-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold mt-2 stats-blocked">0</p>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border">
                <div class="flex items-center justify-between">
                    <span class="text-sm font-medium">Assigned to Farms</span>
                    <i class="fas fa-tractor text-amber-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold mt-2 stats-withFarms">0</p>
            </div>
        </div>

        <!-- Search & Table Card -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow border overflow-hidden">
            <div class="p-4 border-b bg-gray-50 dark:bg-gray-900/50">
                <div class="relative max-w-md">
                    <i class="fas fa-search absolute left-3 top-3.5 text-gray-400"></i>
                    <input type="text" id="searchInput" placeholder="Search staff..."
                           class="w-full pl-10 pr-4 py-3 border rounded-xl bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500">
                </div>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 dark:bg-gray-900/50 border-b">
                        <tr>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Photo</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Name</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Email</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Phone</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Farms</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Status</th>
                            <th class="px-4 py-4 text-center text-xs font-semibold uppercase">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <!-- filled by JS -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    console.log("staff.jsp main script started");

    window.refreshStaffList = async function() {
        console.log("refreshStaffList called");
        try {
            const url = window.contextPath + '/staff/records?format=json&_=' + Date.now();
            console.log("Fetching", url);
            const resp = await fetch(url, { headers: { 'Accept': 'application/json' } });
            console.log("Response status", resp.status);
            if (!resp.ok) {
                const text = await resp.text();
                console.error("Server error", text);
                throw new Error("Server error");
            }
            const data = await resp.json();
            console.log("Data received", data);
            
            window.staffData = data.staff || [];
            window.farmList = data.farms || [];

            // Stats
            document.querySelector('.stats-total').textContent = data.staff.length;
            document.querySelector('.stats-active').textContent = data.staff.filter(s => s.status === 'active').length;
            document.querySelector('.stats-blocked').textContent = data.staff.filter(s => s.status === 'blocked').length;
            document.querySelector('.stats-withFarms').textContent = data.staff.filter(s => s.farms && s.farms.length > 0).length;

            updateTable(data.staff);
        } catch (e) {
            console.error("Error in refreshStaffList", e);
            alert("Failed to load staff data. Check console.");
        }
    };

    function updateTable(staffList) {
        const tbody = document.getElementById('tableBody');
        if (!staffList.length) {
            tbody.innerHTML = '<tr><td colspan="7" class="px-4 py-16 text-center text-gray-500">No staff found.</td></tr>';
            return;
        }

        // Using escaped \${...} so JSP does not parse them
        tbody.innerHTML = staffList.map(s => {
            const farms = s.farms && s.farms.length ? s.farms.map(f => f.farmName).join(', ') : 'None';
            const photoSrc = s.photo
                ? (s.photo.startsWith('http') ? s.photo : window.contextPath + '/' + s.photo)
                : null;
            const initial = (s.staffName || 'S').charAt(0).toUpperCase();
            const statusClass = s.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800';
            const statusText = s.status || 'active';
            const lockIcon = s.status === 'blocked' ? 'fa-lock-open' : 'fa-lock';

            return '\
                <tr class="border-b hover:bg-gray-50 dark:hover:bg-gray-700/30">\
                    <td class="px-4 py-4">' + (photoSrc
                        ? '<img src="' + photoSrc + '" class="w-10 h-10 rounded-full object-cover border">'
                        : '<div class="w-10 h-10 rounded-full bg-gradient-to-r from-blue-400 to-blue-600 flex items-center justify-center text-white font-bold">' + initial + '</div>'
                    ) + '</td>\
                    <td class="px-4 py-4 font-medium">' + (s.staffName || '') + '</td>\
                    <td class="px-4 py-4">' + (s.email || '') + '</td>\
                    <td class="px-4 py-4">' + (s.phone || '') + '</td>\
                    <td class="px-4 py-4">' + farms + '</td>\
                    <td class="px-4 py-4"><span class="px-2 py-1 text-xs rounded-full capitalize ' + statusClass + '">' + statusText + '</span></td>\
                    <td class="px-4 py-4 text-center">\
                        <div class="flex justify-center space-x-2">\
                            <button class="edit-staff-btn p-2 bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100" data-id="' + s.id + '"><i class="fas fa-edit"></i></button>\
                            <button class="toggle-staff-btn p-2 bg-orange-50 text-orange-600 rounded-lg hover:bg-orange-100" data-id="' + s.id + '" data-status="' + s.status + '"><i class="fas ' + lockIcon + '"></i></button>\
                            <button onclick="deleteStaff(\'' + s.id + '\')" class="p-2 bg-red-50 text-red-600 rounded-lg hover:bg-red-100"><i class="fas fa-trash"></i></button>\
                        </div>\
                    </td>\
                </tr>';
        }).join('');

        // Bind edit buttons
        document.querySelectorAll('.edit-staff-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const id = this.dataset.id;
                const staff = window.staffData.find(s => s.id === id);
                if (staff) openStaffForm('edit', { ...staff, assignedFarmIds: staff.farms?.map(f => f.id) || [] });
            });
        });

        // Toggle status
        document.querySelectorAll('.toggle-staff-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const id = this.dataset.id;
                const currentStatus = this.dataset.status;
                Swal.fire({
                    title: 'Change status?',
                    text: currentStatus === 'active' ? 'Block this staff?' : 'Activate this staff?',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: 'Yes'
                }).then(result => {
                    if (result.isConfirmed) {
                        fetch(window.contextPath + '/staff/toggleStatus', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'id=' + id
                        }).then(r => r.json()).then(d => {
                            if (d.success) {
                                Swal.fire('Updated!', '', 'success');
                                refreshStaffList();
                            }
                        });
                    }
                });
            });
        });
    }

    window.deleteStaff = function(id) {
        Swal.fire({
            title: 'Delete staff?',
            text: "This action cannot be undone.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33'
        }).then(result => {
            if (result.isConfirmed) {
                fetch(window.contextPath + '/staff/deleteStaff?id=' + id)
                    .then(r => r.json())
                    .then(d => {
                        if (d.success) {
                            Swal.fire('Deleted!', '', 'success');
                            refreshStaffList();
                        } else {
                            Swal.fire('Error', d.message, 'error');
                        }
                    });
            }
        });
    };

    document.getElementById('searchInput').addEventListener('input', e => {
        const term = e.target.value.toLowerCase();
        document.querySelectorAll('#tableBody tr').forEach(row => {
            row.style.display = row.textContent.toLowerCase().includes(term) ? '' : 'none';
        });
    });

    const addBtn = document.getElementById('addStaffBtn');
    if (addBtn) {
        addBtn.addEventListener('click', function() {
            console.log("Add button clicked");
            openStaffForm('add');
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        console.log("DOMContentLoaded – calling refreshStaffList");
        refreshStaffList();
    });
</script>
</body>
</html>
