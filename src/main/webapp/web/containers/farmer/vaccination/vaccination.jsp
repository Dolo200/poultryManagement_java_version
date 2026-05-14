<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoultryPro - Vaccination Tracker</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Early global variable -->
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
</head>
<body class="bg-gray-50 dark:bg-gray-900">

<%@ include file="../../../components/layout/layout2.0.jsp" %>
<%@ include file="../../../components/forms/vaccination-form-panel.jsp" %>

<div id="mainContent" class="transition-all duration-300" style="margin-left: 280px; padding-top: 64px;">
    <div class="container mx-auto px-6 py-8">

        <!-- Header -->
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Vaccination Tracker</h1>
                <p class="text-gray-600 dark:text-gray-400 mt-1">Monitor and manage flock vaccinations</p>
            </div>
            <div class="flex items-center space-x-3 mt-4 sm:mt-0">
                <button onclick="refreshVaccineList()" class="p-3 bg-white dark:bg-gray-800 rounded-xl shadow hover:shadow-lg text-gray-600 dark:text-gray-300">
                    <i class="fas fa-sync-alt"></i>
                </button>
                <c:if test="${sessionScope.userRole eq 'farm_owner'}">
                    <button id="addVaccineBtn" class="bg-gradient-to-r from-blue-500 to-blue-600 text-white px-5 py-3 rounded-xl font-semibold shadow-md hover:shadow-xl flex items-center gap-2">
                        <i class="fas fa-plus"></i> Add Vaccination
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Sub Navigation -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-2 mb-6 border">
            <nav class="flex space-x-2">
                <a href="../chicken-group/chicken-group.jsp" class="px-4 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">Flock Management</a>
                <a href="vaccination.jsp" class="px-4 py-2.5 rounded-lg bg-blue-500 text-white font-semibold shadow">Vaccination Tracker</a>
            </nav>
        </div>

        <!-- Flock Selector & Stats -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-4 mb-6 border">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div class="flex items-center gap-3">
                    <label class="text-sm font-medium text-gray-700 dark:text-gray-300">Select Flock:</label>
                    <select id="flockFilter" class="px-4 py-2 border rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                        <option value="all">All Flocks</option>
                    </select>
                </div>
                <div class="grid grid-cols-2 sm:grid-cols-4 gap-2">
                    <div class="text-center p-2 rounded-lg bg-gray-100 dark:bg-gray-700">
                        <div class="text-lg font-bold stats-total">0</div>
                        <div class="text-xs text-gray-600 dark:text-gray-400">Total</div>
                    </div>
                    <div class="text-center p-2 rounded-lg bg-amber-100 dark:bg-amber-900/20">
                        <div class="text-lg font-bold text-amber-600 stats-pending">0</div>
                        <div class="text-xs text-gray-600 dark:text-gray-400">Pending</div>
                    </div>
                    <div class="text-center p-2 rounded-lg bg-green-100 dark:bg-green-900/20">
                        <div class="text-lg font-bold text-green-600 stats-done">0</div>
                        <div class="text-xs text-gray-600 dark:text-gray-400">Completed</div>
                    </div>
                    <div class="text-center p-2 rounded-lg bg-red-100 dark:bg-red-900/20">
                        <div class="text-lg font-bold text-red-600 stats-overdue">0</div>
                        <div class="text-xs text-gray-600 dark:text-gray-400">Overdue</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Calendar View -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-6 mb-6 border">
            <h2 class="text-xl font-bold mb-4">Vaccination Calendar</h2>
            <div id="calendarContainer" class="overflow-x-auto"></div>
        </div>

        <!-- Vaccination Matrix (Table) -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow border overflow-hidden">
            <div class="p-4 border-b bg-gray-50 dark:bg-gray-900/50">
                <h2 class="text-lg font-bold text-gray-900 dark:text-white">Vaccination Schedule</h2>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 dark:bg-gray-900/50 border-b">
                        <tr>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Vaccine</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Disease</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Flock</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Due Date</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Age (days)</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Status</th>
                            <th class="px-4 py-4 text-center text-xs font-semibold uppercase">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody"></tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    // All \${...} are escaped so JSP does not parse them
    let rawRecords = [];

    window.refreshVaccineList = async function() {
        try {
            const flockId = document.getElementById('flockFilter').value;
            let url = window.contextPath + '/vaccination/records?format=json&_=' + Date.now();
            if (flockId !== 'all') url += '&flockId=' + flockId;
            const resp = await fetch(url, { headers: { 'Accept': 'application/json' } });
            if (!resp.ok) throw new Error('Server error');
            const data = await resp.json();
            rawRecords = data.records || [];
            window.flockList = data.flocks || [];

            // Populate flock dropdown
            const flockFilter = document.getElementById('flockFilter');
            const currentVal = flockFilter.value;
            flockFilter.innerHTML = '<option value="all">All Flocks</option>';
            (data.flocks || []).forEach(f => {
                const opt = document.createElement('option');
                opt.value = f.id;
                opt.textContent = f.flockName;
                if (f.id === currentVal) opt.selected = true;
                flockFilter.appendChild(opt);
            });

            // Stats
            document.querySelector('.stats-total').textContent = rawRecords.length;
            document.querySelector('.stats-pending').textContent = rawRecords.filter(r => r.status === 'pending').length;
            document.querySelector('.stats-done').textContent = rawRecords.filter(r => r.status === 'done').length;
            document.querySelector('.stats-overdue').textContent = rawRecords.filter(r => r.isOverdue).length;

            updateTable(rawRecords);
            renderCalendar();
        } catch(e) { console.error(e); }
    };

    function updateTable(records) {
        const tbody = document.getElementById('tableBody');
        if (!records.length) {
            tbody.innerHTML = '<tr><td colspan="7" class="px-4 py-16 text-center text-gray-500">No vaccinations found.</td></tr>';
            return;
        }
        tbody.innerHTML = records.map(r => {
            const statusBadge = r.status === 'done' ? 'bg-green-100 text-green-800' : (r.isOverdue ? 'bg-red-100 text-red-800' : 'bg-amber-100 text-amber-800');
            const statusText = r.status === 'done' ? 'Completed' : (r.isOverdue ? 'Overdue' : 'Pending');
            // Note: all \${...} are now escaped
            return '<tr class="border-b hover:bg-gray-50 dark:hover:bg-gray-700/30">' +
                '<td class="px-4 py-4 font-medium">' + (r.vaccineName || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.disease || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.flockName || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.dueDate || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.ageDays || '') + '</td>' +
                '<td class="px-4 py-4"><span class="px-2 py-1 text-xs rounded-full ' + statusBadge + '">' + statusText + '</span></td>' +
                '<td class="px-4 py-4 text-center">' +
                    '<button class="mark-done-btn p-2 bg-green-50 text-green-600 rounded-lg mr-1" data-id="' + r.id + '" data-status="' + r.status + '"><i class="fas fa-check"></i></button>' +
                    '<button class="toggle-alert-btn p-2 bg-yellow-50 text-yellow-600 rounded-lg mr-1" data-id="' + r.id + '" data-alert="' + r.alertActive + '"><i class="fas fa-bell"></i></button>' +
                    (window.isOwner ? '<button class="edit-vaccine-btn p-2 bg-blue-50 text-blue-600 rounded-lg mr-1" data-id="' + r.id + '"><i class="fas fa-edit"></i></button>' : '') +
                    (window.isOwner ? '<button onclick="deleteVaccine(\'' + r.id + '\')" class="p-2 bg-red-50 text-red-600 rounded-lg"><i class="fas fa-trash"></i></button>' : '') +
                '</td>' +
            '</tr>';
        }).join('');

        // Bind action buttons
        document.querySelectorAll('.mark-done-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const id = btn.dataset.id;
                fetch(window.contextPath + '/vaccination/toggleStatus', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'id=' + id
                }).then(r => r.json()).then(d => { if (d.success) refreshVaccineList(); });
            });
        });
        document.querySelectorAll('.toggle-alert-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const id = btn.dataset.id;
                fetch(window.contextPath + '/vaccination/toggleAlert', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'id=' + id
                }).then(r => r.json()).then(d => { if (d.success) refreshVaccineList(); });
            });
        });
        document.querySelectorAll('.edit-vaccine-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const id = btn.dataset.id;
                const record = rawRecords.find(r => r.id === id);
                if (record) openVaccineForm('edit', record);
            });
        });
    }

    window.deleteVaccine = function(id) {
        Swal.fire({
            title: 'Delete vaccination?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33'
        }).then(result => {
            if (result.isConfirmed) {
                fetch(window.contextPath + '/vaccination/delete?id=' + id)
                    .then(r => r.json())
                    .then(d => { if (d.success) { Swal.fire('Deleted!', '', 'success'); refreshVaccineList(); } });
            }
        });
    };

    function renderCalendar() {
        const container = document.getElementById('calendarContainer');
        const now = new Date();
        const year = now.getFullYear();
        const month = now.getMonth(); // 0-indexed
        const firstDay = new Date(year, month, 1).getDay();
        const daysInMonth = new Date(year, month + 1, 0).getDate();

        let html = '<table class="w-full border-collapse"><thead><tr>';
        ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].forEach(d => html += '<th class="p-2 border">' + d + '</th>');
        html += '</tr></thead><tbody><tr>';

        for (let i = 0; i < firstDay; i++) html += '<td class="border p-2"></td>';

        for (let day = 1; day <= daysInMonth; day++) {
            const dateStr = year + '-' + String(month+1).padStart(2,'0') + '-' + String(day).padStart(2,'0');
            const dayVacs = rawRecords.filter(v => v.dueDate === dateStr && v.status !== 'done');
            let bgColor = '';
            if (dayVacs.length) {
                const minDays = Math.min(...dayVacs.map(v => {
                    const due = new Date(v.dueDate);
                    return Math.floor((due - now) / (1000*60*60*24));
                }));
                if (minDays < 0) bgColor = 'bg-red-500';
                else if (minDays === 0) bgColor = 'bg-orange-500';
                else if (minDays <= 3) bgColor = 'bg-amber-500';
                else if (minDays <= 7) bgColor = 'bg-yellow-400';
                else bgColor = 'bg-green-500';
            }
            html += '<td class="border p-2 relative">' +
                '<div class="font-bold">' + day + '</div>' +
                (dayVacs.length ? '<div class="w-6 h-6 rounded-full text-white text-xs font-bold flex items-center justify-center ' + bgColor + ' mx-auto">' + dayVacs.length + '</div>' : '') +
                '</td>';
            if ((firstDay + day) % 7 === 0) html += '</tr><tr>';
        }
        html += '</tr></tbody></table>';
        container.innerHTML = html;
    }

    document.getElementById('flockFilter').addEventListener('change', refreshVaccineList);
    document.addEventListener('DOMContentLoaded', refreshVaccineList);
    document.getElementById('addVaccineBtn')?.addEventListener('click', () => openVaccineForm('add'));
</script>
</body>
</html>