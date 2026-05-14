<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoultryPro - Production</title>
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
<%@ include file="../../../components/forms/production-form-panel.jsp" %>

<div id="mainContent" class="transition-all duration-300" style="margin-left: 280px; padding-top: 64px;">
    <div class="container mx-auto px-6 py-8">

        <!-- Header -->
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Production Products</h1>
                <p class="text-gray-600 dark:text-gray-400 mt-1">Manage and analyze your poultry production</p>
            </div>
            <div class="flex items-center space-x-3 mt-4 sm:mt-0">
                <button onclick="refreshProductList()" class="p-3 bg-white dark:bg-gray-800 rounded-xl shadow hover:shadow-lg text-gray-600 dark:text-gray-300">
                    <i class="fas fa-sync-alt"></i>
                </button>
                <c:if test="${sessionScope.userRole eq 'farm_owner'}">
                    <button id="addProductBtn" class="bg-gradient-to-r from-green-500 to-green-600 text-white px-5 py-3 rounded-xl font-semibold shadow-md hover:shadow-xl flex items-center gap-2">
                        <i class="fas fa-plus"></i> Add Product
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Sub Navigation -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-2 mb-6 border">
            <nav class="flex space-x-2">
                <a href="production.jsp" class="px-4 py-2.5 rounded-lg bg-green-500 text-white font-semibold shadow">Production</a>
                <a href="../feed/feed.jsp" class="px-4 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">Feed</a>
                <a href="#" class="px-4 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">Equipment</a>
            </nav>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border">
                <p class="text-sm text-gray-600 dark:text-gray-400">Total Products</p>
                <p class="text-3xl font-bold text-gray-900 dark:text-white mt-2 stats-totalProducts">0</p>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border">
                <p class="text-sm text-gray-600 dark:text-gray-400">Total Initial Quantity</p>
                <p class="text-3xl font-bold text-gray-900 dark:text-white mt-2 stats-totalInitial">0</p>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border">
                <p class="text-sm text-gray-600 dark:text-gray-400">Total Available</p>
                <p class="text-3xl font-bold text-green-600 mt-2 stats-totalAvailable">0</p>
            </div>
        </div>

        <!-- Chart Card with Controls -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow mb-6 border border-gray-200 dark:border-gray-700">
            <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                <h2 class="text-xl font-bold text-gray-900 dark:text-white">Production Trends</h2>
            </div>
            <div class="p-4 border-b bg-gray-50 dark:bg-gray-900/50 flex flex-wrap gap-3">
                <select id="chartMetricSelect" class="px-4 py-2 border rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option value="availablequantity">Available Quantity</option>
                    <option value="initialquantity">Initial Quantity</option>
                    <option value="cost">Average Cost</option>
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
                    <option value="line">Line Chart</option>
                    <option value="bar">Bar Chart</option>
                    <option value="area">Area Chart</option>
                </select>
            </div>
            <div class="p-6"><canvas id="productionChart" height="80"></canvas></div>
        </div>

        <!-- Table Card -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow border overflow-hidden">
            <div class="p-4 border-b bg-gray-50 dark:bg-gray-900/50">
                <div class="relative max-w-md">
                    <i class="fas fa-search absolute left-3 top-3.5 text-gray-400"></i>
                    <input type="text" id="searchInput" placeholder="Search products..."
                           class="w-full pl-10 pr-4 py-3 border rounded-xl bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-green-500">
                </div>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 dark:bg-gray-900/50 border-b">
                        <tr>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Product Name</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Flock</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Type</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Cost</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Initial Qty</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Available Qty</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Flock Cumulative</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Description</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Storage Location</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold uppercase">Register Date</th>
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

    window.refreshProductList = async function() {
        try {
            const url = window.contextPath + '/production/records?format=json&_=' + Date.now();
            const resp = await fetch(url, { headers: { 'Accept': 'application/json' } });
            if (!resp.ok) throw new Error('Server error');
            const data = await resp.json();
            rawRecords = data.records || [];
            window.flocks = data.flocks || [];

            // Stats
            document.querySelector('.stats-totalProducts').textContent = data.stats?.totalProducts ?? 0;
            document.querySelector('.stats-totalInitial').textContent = data.stats?.totalInitial ?? 0;
            document.querySelector('.stats-totalAvailable').textContent = data.stats?.totalAvailable ?? 0;

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
        } catch(e) { console.error(e); }
    };

    function updateTable(records) {
        const tbody = document.getElementById('tableBody');
        if (!records.length) {
            tbody.innerHTML = '<tr><td colspan="11" class="px-4 py-16 text-center text-gray-500">No products found.</td></tr>';
            return;
        }
        tbody.innerHTML = records.map(r => {
            return '<tr class="border-b hover:bg-gray-50 dark:hover:bg-gray-700/30">' +
                '<td class="px-4 py-4 font-medium">' + (r.productname || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.flockname || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.type || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.cost != null ? r.cost.toFixed(2) : '') + '</td>' +
                '<td class="px-4 py-4">' + (r.initialquantity || 0) + '</td>' +
                '<td class="px-4 py-4 font-semibold">' + (r.availablequantity || 0) + '</td>' +
                '<td class="px-4 py-4">' + (r.flockCumulative || 0) + '</td>' +
                '<td class="px-4 py-4">' + (r.description || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.storagelocation || '') + '</td>' +
                '<td class="px-4 py-4">' + (r.registerdate || '') + '</td>' +
                '<td class="px-4 py-4 text-center">' +
                    '<button class="edit-product-btn p-2 bg-blue-50 text-blue-600 rounded-lg mr-1" data-id="' + r.id + '"><i class="fas fa-edit"></i></button>' +
                    '<button class="decrease-product-btn p-2 bg-orange-50 text-orange-600 rounded-lg mr-1" data-id="' + r.id + '"><i class="fas fa-minus"></i></button>' +
                    '<button onclick="deleteProduct(\'' + r.id + '\')" class="p-2 bg-red-50 text-red-600 rounded-lg"><i class="fas fa-trash"></i></button>' +
                '</td>' +
            '</tr>';
        }).join('');

        // Bind edit
        document.querySelectorAll('.edit-product-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const id = this.dataset.id;
                const product = rawRecords.find(r => r.id === id);
                if (product) openProductForm('edit', product);
            });
        });
        // Bind decrease
        document.querySelectorAll('.decrease-product-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const id = this.dataset.id;
                const product = rawRecords.find(r => r.id === id);
                if (!product) return;
                Swal.fire({
                    title: 'Remove Quantity',
                    html: 'Product: <strong>' + product.productname + '</strong><br>Available: ' + product.availablequantity +
                          '<br><input type="number" id="decreaseQty" class="swal2-input" min="1" max="' + product.availablequantity + '" placeholder="Quantity to remove">',
                    showCancelButton: true,
                    confirmButtonText: 'Remove',
                    preConfirm: () => {
                        const q = parseInt(document.getElementById('decreaseQty').value);
                        if (!q || q <= 0 || q > product.availablequantity) {
                            Swal.showValidationMessage('Invalid quantity');
                            return false;
                        }
                        return q;
                    }
                }).then(result => {
                    if (result.isConfirmed) {
                        fetch(window.contextPath + '/production/decreaseQuantity', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'id=' + id + '&quantity=' + result.value
                        }).then(r => r.json()).then(d => {
                            if (d.success) { Swal.fire('Done!', '', 'success'); refreshProductList(); }
                            else Swal.fire('Error', d.message, 'error');
                        });
                    }
                });
            });
        });
    }

    window.deleteProduct = function(id) {
        Swal.fire({
            title: 'Delete product?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33'
        }).then(result => {
            if (result.isConfirmed) {
                fetch(window.contextPath + '/production/deleteProduct?id=' + id)
                    .then(r => r.json())
                    .then(d => {
                        if (d.success) { Swal.fire('Deleted!', '', 'success'); refreshProductList(); }
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

        const sorted = [...filtered].sort((a, b) => new Date(a.registerdate) - new Date(b.registerdate));
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
            const key = getKey(r.registerdate);
            if (!groups[key]) groups[key] = { date: key, sum: 0, count: 0 };
            groups[key].sum += (r[metric] || 0);
            groups[key].count++;
        });

        const keys = Object.keys(groups).sort();
        return keys.map(key => {
            const g = groups[key];
            return {
                date: key,
                value: metric === 'cost' ? (g.sum / g.count) : g.sum
            };
        });
    }

    function renderChart() {
        const data = aggregateChartData();
        if (!data.length) { if (chartInstance) { chartInstance.destroy(); chartInstance = null; } return; }

        const metric = document.getElementById('chartMetricSelect').value;
        const chartType = document.getElementById('chartTypeSelect').value;
        const ctx = document.getElementById('productionChart').getContext('2d');
        if (chartInstance) chartInstance.destroy();

        const labels = data.map(d => d.date);
        const values = data.map(d => d.value);
        const color = metric === 'availablequantity' ? '#10b981' : metric === 'initialquantity' ? '#3b82f6' : '#f59e0b';

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
                        ticks: { callback: v => metric === 'cost' ? '$' + v : v }
                    }
                }
            }
        });
    }

    // Attach chart control events
    ['chartMetricSelect','chartTimeUnitSelect','chartFlockFilterSelect','chartTypeSelect'].forEach(id => {
        document.getElementById(id).addEventListener('change', renderChart);
    });

    // Search filter
    document.getElementById('searchInput').addEventListener('input', e => {
        const term = e.target.value.toLowerCase();
        document.querySelectorAll('#tableBody tr').forEach(row => {
            row.style.display = row.textContent.toLowerCase().includes(term) ? '' : 'none';
        });
    });

    // Init
    document.addEventListener('DOMContentLoaded', refreshProductList);
    document.getElementById('addProductBtn')?.addEventListener('click', () => openProductForm('add'));
</script>
</body>
</html>