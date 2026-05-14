<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoultryPro - Feed Consumption</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Early global variable -->
    <script>window.contextPath = '${pageContext.request.contextPath}';</script>
</head>
<body class="bg-gray-50 dark:bg-gray-900">

<%@ include file="../../../components/layout/layout2.0.jsp" %>
<%@ include file="../../../components/forms/feed-form-panel.jsp" %>

<div id="mainContent" class="transition-all duration-300" style="margin-left: 280px; padding-top: 64px;">
    <div class="container mx-auto px-6 py-8">

        <!-- Header -->
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Feed Consumption</h1>
                <p class="text-gray-600 dark:text-gray-400 mt-1">Track and manage poultry feed usage</p>
            </div>
            <div class="flex items-center space-x-3 mt-4 sm:mt-0">
                <button onclick="refreshFeedList()" class="p-3 bg-white dark:bg-gray-800 rounded-xl shadow hover:shadow-lg text-gray-600 dark:text-gray-300">
                    <i class="fas fa-sync-alt"></i>
                </button>
                <c:if test="${sessionScope.userRole eq 'farm_owner'}">
                    <button id="addFeedBtn" class="bg-gradient-to-r from-amber-500 to-amber-600 text-white px-5 py-3 rounded-xl font-semibold shadow-md hover:shadow-xl flex items-center gap-2">
                        <i class="fas fa-plus"></i> Add Feed Record
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Sub Navigation -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-2 mb-6 border">
            <nav class="flex space-x-2">
                <a href="../production/production.jsp" class="px-4 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">Production</a>
                <a href="feed.jsp" class="px-4 py-2.5 rounded-lg bg-amber-500 text-white font-semibold shadow">Feed</a>
                <a href="#" class="px-4 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">Equipment</a>
            </nav>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border">
                <div class="flex items-center justify-between">
                    <span class="text-sm text-gray-600 dark:text-gray-400">Total Consumption (kg)</span>
                    <i class="fas fa-weight-hanging text-green-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold text-gray-900 dark:text-white mt-2 stats-totalConsumption">0</p>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border">
                <div class="flex items-center justify-between">
                    <span class="text-sm text-gray-600 dark:text-gray-400">Total Quantity (kg)</span>
                    <i class="fas fa-boxes text-blue-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold text-gray-900 dark:text-white mt-2 stats-totalQuantity">0</p>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border">
                <div class="flex items-center justify-between">
                    <span class="text-sm text-gray-600 dark:text-gray-400">Avg Protein (%)</span>
                    <i class="fas fa-flask text-purple-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold text-gray-900 dark:text-white mt-2 stats-avgProtein">0</p>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border">
                <div class="flex items-center justify-between">
                    <span class="text-sm text-gray-600 dark:text-gray-400">Active Flocks</span>
                    <i class="fas fa-chicken text-yellow-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold text-gray-900 dark:text-white mt-2 stats-activeFlocks">0</p>
            </div>
        </div>

        <!-- Chart Card with Controls -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow mb-6 border border-gray-200 dark:border-gray-700">
            <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                <h2 class="text-xl font-bold text-gray-900 dark:text-white">Feed Consumption Trends</h2>
            </div>
            <div class="p-4 border-b bg-gray-50 dark:bg-gray-900/50 flex flex-wrap gap-3">
                <select id="chartMetricSelect" class="px-4 py-2 border rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option value="consumptionPerDay">Daily Consumption</option>
                    <option value="quantityPerDelivery">Delivery Quantity</option>
                    <option value="cumulativeFeedKg">Cumulative Feed</option>
                </select>
                <select id="chartTimeUnitSelect" class="px-4 py-2 border rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option value="day">Daily</option>
                    <option value="week">Weekly</option>
                    <option value="month">Monthly</option>
                </select>
                <select id="chartFlockFilterSelect" class="px-4 py-2 border rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option value="all">All Flocks</option>
                </select>
                <select id="chartTypeSelect" class="px-4 py-2 border rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option value="bar">Bar Chart</option>
                    <option value="line">Line Chart</option>
                    <option value="area">Area Chart</option>
                </select>
            </div>
            <div class="p-6"><canvas id="feedChart" height="80"></canvas></div>
        </div>

        <!-- Table Card -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow border overflow-hidden">
            <div class="p-4 border-b bg-gray-50 dark:bg-gray-900/50">
                <div class="relative max-w-md">
                    <i class="fas fa-search absolute left-3 top-3.5 text-gray-400"></i>
                    <input type="text" id="searchInput" placeholder="Search by batch, name, flock..."
                           class="w-full pl-10 pr-4 py-3 border rounded-xl bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500">
                </div>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 dark:bg-gray-900/50 border-b">
                        <tr>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Flock</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Batch ID</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Feed Name</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Delivery Date</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Qty/Delivery</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Protein (%)</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Cost/Bag</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Cumulative (kg)</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Daily (kg)</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Notes</th>
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
    let chartInstance = null;
    let rawRecords = [];

    window.refreshFeedList = async function() {
        try {
            const url = window.contextPath + '/feed/records?format=json&_=' + Date.now();
            console.log('Fetching feed records:', url);
            const resp = await fetch(url, { headers: { 'Accept': 'application/json' } });
            console.log('Response status:', resp.status);
            if (!resp.ok) {
                // --- THIS IS THE KEY ADDITION ---
                const errorText = await resp.text();
                console.error('Server error response:', errorText);
                throw new Error('Server error (status ' + resp.status + ') - see console for details');
            }
            const data = await resp.json();
            console.log('Received feed data:', data);

            rawRecords = data.records || [];
            window.flocks = data.flocks || [];

            // Stats
            document.querySelector('.stats-totalConsumption').textContent = (data.stats?.totalConsumption || 0).toFixed(2);
            document.querySelector('.stats-totalQuantity').textContent = (data.stats?.totalQuantity || 0).toFixed(2);
            document.querySelector('.stats-avgProtein').textContent = (data.stats?.avgProtein || 0).toFixed(1);
            document.querySelector('.stats-activeFlocks').textContent = data.stats?.activeFlocks || 0;

            // Populate chart flock filter
            const flockFilter = document.getElementById('chartFlockFilterSelect');
            flockFilter.innerHTML = '<option value="all">All Flocks</option>';
            (data.flocks || []).forEach(f => {
                const opt = document.createElement('option');
                opt.value = f.id;
                opt.textContent = f.flockName;
                flockFilter.appendChild(opt);
            });

            updateTable(rawRecords);
            renderChart();
        } catch(e) {
            console.error('Error in refreshFeedList:', e);
        }
    };

    function updateTable(records) {
        const tbody = document.getElementById('tableBody');
        if (!records.length) {
            tbody.innerHTML = '<tr><td colspan="11" class="px-4 py-16 text-center text-gray-500">No feed records found.</td></tr>';
            return;
        }
        tbody.innerHTML = records.map(r => {
            return '<tr class="border-b hover:bg-gray-50 dark:hover:bg-gray-700/30">' +
                '<td class="px-4 py-4 font-medium">' + (r.flockName || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.feedBatchId || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.feedName || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.deliveryDate || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.quantityPerDelivery != null ? r.quantityPerDelivery.toFixed(2) : '') + '</td>' +
                '<td class="px-4 py-4">' + (r.crudeProtein != null ? r.crudeProtein.toFixed(2) : '') + '</td>' +
                '<td class="px-4 py-4">' + (r.costPerBag != null ? r.costPerBag.toFixed(2) : '') + '</td>' +
                '<td class="px-4 py-4 font-semibold">' + (r.cumulativeFeedKg != null ? r.cumulativeFeedKg.toFixed(2) : '') + '</td>' +
                '<td class="px-4 py-4">' + (r.consumptionPerDay != null ? r.consumptionPerDay.toFixed(2) : '') + '</td>' +
                '<td class="px-4 py-4">' + (r.notes || '') + '</td>' +
                '<td class="px-4 py-4 text-center">' +
                    '<button class="edit-feed-btn p-2 bg-blue-50 text-blue-600 rounded-lg mr-1" data-id="' + r.id + '"><i class="fas fa-edit"></i></button>' +
                    '<button onclick="deleteFeed(\'' + r.id + '\')" class="p-2 bg-red-50 text-red-600 rounded-lg"><i class="fas fa-trash"></i></button>' +
                '</td>' +
            '</tr>';
        }).join('');

        document.querySelectorAll('.edit-feed-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const id = this.dataset.id;
                const record = rawRecords.find(r => r.id === id);
                if (record) openFeedForm('edit', record);
            });
        });
    }

    window.deleteFeed = function(id) {
        Swal.fire({
            title: 'Delete record?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33'
        }).then(result => {
            if (result.isConfirmed) {
                fetch(window.contextPath + '/feed/deleteFeed?id=' + id)
                    .then(r => r.json())
                    .then(d => {
                        if (d.success) { Swal.fire('Deleted!', '', 'success'); refreshFeedList(); }
                        else Swal.fire('Error', d.message, 'error');
                    });
            }
        });
    };

    // ---------- CHART ----------
    function getWeekNumber(date) {
        const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
        const dayNum = d.getUTCDay() || 7;
        d.setUTCDate(d.getUTCDate() + 4 - dayNum);
        const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
        const weekNo = Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
        return d.getUTCFullYear() + '-W' + weekNo.toString().padStart(2, '0');
    }

    function aggregateChartData() {
        const metric = document.getElementById('chartMetricSelect').value;
        const timeUnit = document.getElementById('chartTimeUnitSelect').value;
        const flockFilter = document.getElementById('chartFlockFilterSelect').value;

        let filtered = rawRecords;
        if (flockFilter !== 'all') filtered = rawRecords.filter(r => r.flockId === flockFilter);
        if (!filtered.length) return [];

        const sorted = [...filtered].sort((a, b) => new Date(a.deliveryDate) - new Date(b.deliveryDate));
        const getKey = (dateStr) => {
            const d = new Date(dateStr);
            if (isNaN(d)) return dateStr;
            if (timeUnit === 'day') return dateStr;
            if (timeUnit === 'week') return getWeekNumber(d);
            if (timeUnit === 'month') return d.getFullYear() + '-' + (d.getMonth()+1).toString().padStart(2,'0');
            return dateStr;
        };

        const groups = {};
        sorted.forEach(r => {
            const key = getKey(r.deliveryDate);
            if (!groups[key]) groups[key] = { date: key, sum: 0, count: 0 };
            groups[key].sum += (r[metric] || 0);
            groups[key].count++;
        });

        const keys = Object.keys(groups).sort();
        return keys.map(key => {
            const g = groups[key];
            return {
                date: key,
                value: metric === 'cumulativeFeedKg' ? g.sum : (g.sum / g.count)
            };
        });
    }

    function renderChart() {
        const data = aggregateChartData();
        if (!data.length) { if (chartInstance) { chartInstance.destroy(); chartInstance = null; } return; }

        const metric = document.getElementById('chartMetricSelect').value;
        const chartType = document.getElementById('chartTypeSelect').value;
        const ctx = document.getElementById('feedChart').getContext('2d');
        if (chartInstance) chartInstance.destroy();

        const labels = data.map(d => d.date);
        const values = data.map(d => d.value);
        const color = metric === 'consumptionPerDay' ? '#10b981' : metric === 'quantityPerDelivery' ? '#f59e0b' : '#7c3aed';

        chartInstance = new Chart(ctx, {
            type: chartType === 'area' ? 'line' : chartType,
            data: {
                labels: labels,
                datasets: [{
                    label: document.getElementById('chartMetricSelect').selectedOptions[0].text,
                    data: values,
                    borderColor: color,
                    backgroundColor: chartType === 'area' ? color + '33' : undefined,
                    fill: chartType === 'area',
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: true } },
                scales: {
                    y: { beginAtZero: true,
                        ticks: { callback: v => metric === 'cumulativeFeedKg' ? v.toFixed(2) + ' kg' : v.toFixed(2) }
                    }
                }
            }
        });
    }

    ['chartMetricSelect','chartTimeUnitSelect','chartFlockFilterSelect','chartTypeSelect'].forEach(id => {
        document.getElementById(id).addEventListener('change', renderChart);
    });

    document.getElementById('searchInput').addEventListener('input', e => {
        const term = e.target.value.toLowerCase();
        document.querySelectorAll('#tableBody tr').forEach(row => {
            row.style.display = row.textContent.toLowerCase().includes(term) ? '' : 'none';
        });
    });

    document.addEventListener('DOMContentLoaded', refreshFeedList);
    document.getElementById('addFeedBtn')?.addEventListener('click', () => openFeedForm('add'));
</script>
</body>
</html>