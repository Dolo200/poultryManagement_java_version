<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoultryPro - Mortality Tracking</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="bg-gray-50 dark:bg-gray-900">

<%@ include file="../../../components/layout/layout2.0.jsp" %>
<%@ include file="../../../components/forms/mortality-form-panel.jsp" %>

<div id="mainContent" class="transition-all duration-300" style="margin-left: 280px; padding-top: 64px;">
    <div class="container mx-auto px-6 py-8">

        <!-- Page Header & Add button -->
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6">
            <div>
                <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Mortality Tracking</h1>
                <p class="text-gray-600 dark:text-gray-400 mt-1">Monitor flock mortality patterns</p>
            </div>
            <div class="flex items-center space-x-3 mt-4 sm:mt-0">
                <button onclick="refreshMortalityList()" class="p-3 bg-white dark:bg-gray-800 rounded-xl shadow hover:shadow-lg text-gray-600 dark:text-gray-300">
                    <i class="fas fa-sync-alt"></i>
                </button>
                <c:if test="${sessionScope.userRole eq 'farm_owner'}">
                    <button id="addRecordBtn" class="bg-gradient-to-r from-red-500 to-red-600 text-white px-5 py-3 rounded-xl font-semibold shadow-md hover:shadow-xl flex items-center gap-2">
                        <i class="fas fa-plus"></i> Add Record
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Sub Navigation -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-2 mb-6 border border-gray-200 dark:border-gray-700">
            <nav class="flex space-x-2">
                <a href="../chicken-group/chicken-group.jsp" class="px-4 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                    <i class="fas fa-feather-alt mr-2"></i> Chicken Groups
                </a>
                <a href="mortality.jsp" class="px-4 py-2.5 rounded-lg bg-red-500 text-white font-semibold shadow">
                    <i class="fas fa-cross mr-2"></i> Mortality Tracking
                </a>
            </nav>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border border-gray-200 dark:border-gray-700">
                <div class="flex items-center justify-between">
                    <span class="text-sm font-medium text-gray-600 dark:text-gray-400">Total Deaths</span>
                    <i class="fas fa-skull-crossbones text-red-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold text-gray-900 dark:text-white mt-2 stats-totalDeaths">0</p>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border border-gray-200 dark:border-gray-700">
                <div class="flex items-center justify-between">
                    <span class="text-sm font-medium text-gray-600 dark:text-gray-400">Initial Stock</span>
                    <i class="fas fa-chicken text-blue-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold text-gray-900 dark:text-white mt-2 stats-totalStock">0</p>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border border-gray-200 dark:border-gray-700">
                <div class="flex items-center justify-between">
                    <span class="text-sm font-medium text-gray-600 dark:text-gray-400">Mortality Rate</span>
                    <i class="fas fa-chart-line text-orange-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold text-orange-600 mt-2 stats-overallRate">0%</p>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border border-gray-200 dark:border-gray-700">
                <div class="flex items-center justify-between">
                    <span class="text-sm font-medium text-gray-600 dark:text-gray-400">High Risk Cases</span>
                    <i class="fas fa-exclamation-triangle text-yellow-500 text-xl"></i>
                </div>
                <p class="text-3xl font-bold text-yellow-600 mt-2 stats-highRisk">0</p>
            </div>
        </div>

        <!-- Chart Card with Controls -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow mb-6 border border-gray-200 dark:border-gray-700">
            <div class="p-6 border-b border-gray-200 dark:border-gray-700">
                <h2 class="text-xl font-bold text-gray-900 dark:text-white">Mortality Trends</h2>
            </div>
            <!-- Chart Controls -->
            <div class="p-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900/50 flex flex-wrap gap-3">
                <select id="metricSelect" class="px-4 py-2 border rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option value="mortalityRate">Mortality Rate</option>
                    <option value="numberOfDeaths">Deaths per Period</option>
                    <option value="cumulativeMortality">Cumulative Deaths</option>
                    <option value="alive">Still Alive</option>
                </select>
                <select id="timeUnitSelect" class="px-4 py-2 border rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option value="day">Daily</option>
                    <option value="week">Weekly</option>
                    <option value="month">Monthly</option>
                </select>
                <!-- Multi‑select for flock comparison -->
                <select id="flockFilterSelect" multiple size="3"
                        class="px-4 py-2 border rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option value="all">All Flocks (aggregated)</option>
                </select>
                <select id="chartTypeSelect" class="px-4 py-2 border rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option value="line">Line Chart</option>
                    <option value="bar">Bar Chart</option>
                    <option value="area">Area Chart</option>
                </select>
            </div>
            <!-- Canvas for the chart -->
            <div class="p-6">
                <canvas id="mortalityChart" height="80"></canvas>
            </div>
        </div>

        <!-- Table Card -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl shadow border border-gray-200 dark:border-gray-700 overflow-hidden">
            <div class="p-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900/50">
                <div class="relative max-w-md">
                    <i class="fas fa-search absolute left-3 top-3.5 text-gray-400"></i>
                    <input type="text" id="searchInput" placeholder="Search records..."
                           class="w-full pl-10 pr-4 py-3 border border-gray-300 dark:border-gray-600 rounded-xl bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-red-500">
                </div>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 dark:bg-gray-900/50 border-b border-gray-200 dark:border-gray-700">
                        <tr>
                            <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Flock</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Date</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Deaths</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Age</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Cause</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Location</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Action</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Initial Stock</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Cumulative</th>
                            <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Rate</th>
                            <th class="px-4 py-4 text-center text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Actions</th>
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
    // ==================== GLOBALS ====================
    window.contextPath = '${pageContext.request.contextPath}';
    window.isOwner = ${sessionScope.userRole eq 'farm_owner'};

    let chartInstance = null;
    let rawRecords = [];   // used for chart; window.mortalityData still used for table/edit

    // Helper: ISO week number
    function getWeekNumber(date) {
        const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
        const dayNum = d.getUTCDay() || 7;
        d.setUTCDate(d.getUTCDate() + 4 - dayNum);
        const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
        const weekNo = Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
        return d.getUTCFullYear() + '-W' + weekNo.toString().padStart(2, '0');
    }

    // Main refresh function
    window.refreshMortalityList = async function() {
        try {
            const url = window.contextPath + '/mortality/records?format=json&_=' + Date.now();
            const resp = await fetch(url, { headers: { 'Accept': 'application/json' } });
            if (!resp.ok) throw new Error('Server error');
            const data = await resp.json();

            // Store globally
            window.mortalityData = data.records || [];
            rawRecords = window.mortalityData;        // used for chart
            window.flocks = data.flocks || [];

            // Stats
            document.querySelector('.stats-totalDeaths').textContent = data.stats?.totalDeaths ?? 0;
            document.querySelector('.stats-totalStock').textContent = data.stats?.totalInitialStock ?? 0;
            document.querySelector('.stats-overallRate').textContent = (data.stats?.overallMortalityRate ?? 0) + '%';
            document.querySelector('.stats-highRisk').textContent = data.stats?.highRiskCases ?? 0;

            // Populate multi‑select flock dropdown (preserve selections if possible)
            const flockSelect = document.getElementById('flockFilterSelect');
            const currentValues = Array.from(flockSelect.selectedOptions).map(o => o.value);
            flockSelect.innerHTML = '<option value="all">All Flocks (aggregated)</option>';
            (data.flocks || []).forEach(f => {
                const opt = document.createElement('option');
                opt.value = f.id;
                opt.textContent = f.flockName;
                if (currentValues.includes(f.id)) opt.selected = true;
                flockSelect.appendChild(opt);
            });
            // If "all" was selected, keep it selected; otherwise remove its selection to avoid confusion
            if (currentValues.includes('all')) {
                flockSelect.querySelector('option[value="all"]').selected = true;
            }

            updateTable(window.mortalityData);
            renderChart();   // reads rawRecords & dropdowns
        } catch (e) {
            console.error('Refresh failed', e);
        }
    };

    // ===== TABLE =====
    function updateTable(records) {
        const tbody = document.getElementById('tableBody');
        if (!records.length) {
            tbody.innerHTML = '<tr><td colspan="11" class="px-4 py-16 text-center text-gray-500">No mortality records found.</td></tr>';
            return;
        }
        tbody.innerHTML = records.map(r => `
            <tr class="border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700/30">
                <td class="px-4 py-4 font-medium">\${r.flockName || ''}</td>
                <td class="px-4 py-4">\${r.date || ''}</td>
                <td class="px-4 py-4"><span class="px-2 py-1 text-xs font-medium rounded-full \${r.numberOfDeaths > 10 ? 'bg-red-100 text-red-800' : 'bg-gray-100 text-gray-800'}">\${r.numberOfDeaths}</span></td>
                <td class="px-4 py-4">\${r.age || ''}</td>
                <td class="px-4 py-4">\${r.cause || ''}</td>
                <td class="px-4 py-4">\${r.location || ''}</td>
                <td class="px-4 py-4">\${r.actionTaken || ''}</td>
                <td class="px-4 py-4">\${r.initialStock}</td>
                <td class="px-4 py-4">\${r.cumulativeMortality}</td>
                <td class="px-4 py-4"><span class="\${r.mortalityRate > 5 ? 'text-red-600 font-bold' : 'text-green-600'}">\${r.mortalityRate}%</span></td>
                <td class="px-4 py-4 text-center">
                    <div class="flex justify-center space-x-2">
                        <button class="edit-mortality-btn p-2 bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100" data-id="\${r.id}" \${!window.isOwner ? 'style="display:none"' : ''}><i class="fas fa-edit"></i></button>
                        <button onclick="deleteMortalityRecord('\${r.id}')" class="p-2 bg-red-50 text-red-600 rounded-lg hover:bg-red-100" \${!window.isOwner ? 'style="display:none"' : ''}><i class="fas fa-trash"></i></button>
                    </div>
                </td>
            </tr>
        `).join('');

        // Bind edit buttons
        document.querySelectorAll('.edit-mortality-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const id = btn.dataset.id;
                const record = window.mortalityData.find(r => r.id === id);
                if (record) openMortalityForm('edit', record);
            });
        });
    }

    window.deleteMortalityRecord = function(id) {
        if (!window.isOwner) return;
        Swal.fire({
            title: 'Delete record?',
            text: "This cannot be undone.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: 'Yes, delete'
        }).then(result => {
            if (result.isConfirmed) {
                fetch(window.contextPath + '/mortality/deleteRecord?id=' + id)
                    .then(r => r.json())
                    .then(data => {
                        if (data.success) {
                            Swal.fire('Deleted!', '', 'success');
                            refreshMortalityList();
                        } else {
                            Swal.fire('Error', data.message, 'error');
                        }
                    });
            }
        });
    };

    // ===== CHART (comparison mode) =====
    function aggregateData() {
        const metric = document.getElementById('metricSelect').value;
        const timeUnit = document.getElementById('timeUnitSelect').value;
        const flockSelect = document.getElementById('flockFilterSelect');
        const selectedOptions = Array.from(flockSelect.selectedOptions).map(o => o.value);

        // If "all" is selected (or nothing), show aggregated view
        if (selectedOptions.length === 0 || selectedOptions.includes('all')) {
            const filtered = rawRecords;
            if (!filtered.length) return { datasets: [], labels: [] };

            const sorted = [...filtered].sort((a, b) => new Date(a.date) - new Date(b.date));

            const totalStock = (() => {
                const uniq = [...new Set(rawRecords.map(r => r.flockId))];
                return uniq.reduce((sum, fid) => {
                    const rec = rawRecords.find(r => r.flockId === fid);
                    return sum + (rec ? rec.initialStock : 0);
                }, 0);
            })();

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
                const key = getKey(r.date);
                if (!groups[key]) groups[key] = { deaths: 0 };
                groups[key].deaths += r.numberOfDeaths || 0;
            });

            const keys = Object.keys(groups).sort();
            let cumulative = 0;
            const dataPoints = [];
            keys.forEach(key => {
                cumulative += groups[key].deaths;
                const alive = totalStock - cumulative;
                const mortalityRate = totalStock > 0 ? (cumulative * 100.0 / totalStock) : 0;
                dataPoints.push({
                    periodLabel: key,
                    numberOfDeaths: groups[key].deaths,
                    cumulativeMortality: cumulative,
                    alive: alive,
                    mortalityRate: Math.round(mortalityRate * 100) / 100
                });
            });
            return {
                labels: dataPoints.map(d => d.periodLabel),
                datasets: [{
                    label: 'All Flocks',
                    data: dataPoints.map(d => d[metric]),
                    borderColor: '#dc2626',
                    backgroundColor: 'rgba(220,38,38,0.2)'
                }]
            };
        } else {
            // Compare selected flocks side‑by‑side
            const selectedFlocks = selectedOptions;
            const datasets = [];
            const allLabelsSet = new Set();

            selectedFlocks.forEach(flockId => {
                const flockRecords = rawRecords.filter(r => r.flockId === flockId).sort((a, b) => new Date(a.date) - new Date(b.date));
                if (!flockRecords.length) return;

                const initialStock = flockRecords[0].initialStock || 0;
                const getKey = (dateStr) => {
                    const d = new Date(dateStr);
                    if (isNaN(d)) return dateStr;
                    if (timeUnit === 'day') return dateStr;
                    if (timeUnit === 'week') return getWeekNumber(d);
                    if (timeUnit === 'month') return d.getFullYear() + '-' + (d.getMonth()+1).toString().padStart(2,'0');
                    return dateStr;
                };

                const groups = {};
                flockRecords.forEach(r => {
                    const key = getKey(r.date);
                    if (!groups[key]) groups[key] = { deaths: 0 };
                    groups[key].deaths += r.numberOfDeaths || 0;
                });

                const keys = Object.keys(groups).sort();
                keys.forEach(k => allLabelsSet.add(k));

                let cumulative = 0;
                const points = {};
                keys.forEach(key => {
                    cumulative += groups[key].deaths;
                    const alive = initialStock - cumulative;
                    const mortalityRate = initialStock > 0 ? (cumulative * 100.0 / initialStock) : 0;
                    points[key] = {
                        numberOfDeaths: groups[key].deaths,
                        cumulativeMortality: cumulative,
                        alive: alive,
                        mortalityRate: Math.round(mortalityRate * 100) / 100
                    };
                });

                const flockName = (window.flocks.find(f => f.id === flockId) || {}).flockName || flockId;

                datasets.push({
                    label: flockName,
                    data: [],
                    points: points,
                    borderColor: getColor(flockId),
                    backgroundColor: getColor(flockId, 0.2)
                });
            });

            const labels = Array.from(allLabelsSet).sort();

            datasets.forEach(ds => {
                ds.data = labels.map(label => {
                    const pt = ds.points[label];
                    return pt ? pt[metric] : null;
                });
            });

            return { labels, datasets };
        }
    }

    const colorPalette = ['#dc2626','#2563eb','#059669','#d97706','#7c3aed','#db2777','#0891b2','#65a30d','#c026d3','#ca8a04'];
    function getColor(id, alpha = 1) {
        const index = (id || '').split('').reduce((acc, c) => acc + c.charCodeAt(0), 0);
        return alpha < 1 ? colorPalette[index % colorPalette.length] + '33' : colorPalette[index % colorPalette.length];
    }

    function renderChart() {
        const { labels, datasets } = aggregateData();
        if (!datasets.length || !labels.length) {
            if (chartInstance) { chartInstance.destroy(); chartInstance = null; }
            return;
        }

        const metric = document.getElementById('metricSelect').value;
        const chartType = document.getElementById('chartTypeSelect').value;

        const ctx = document.getElementById('mortalityChart').getContext('2d');
        if (chartInstance) chartInstance.destroy();

        chartInstance = new Chart(ctx, {
            type: chartType === 'area' ? 'line' : chartType,
            data: {
                labels: labels,
                datasets: datasets.map(ds => ({
                    label: ds.label,
                    data: ds.data,
                    borderColor: ds.borderColor,
                    backgroundColor: chartType === 'area' ? ds.backgroundColor : (chartType === 'bar' ? ds.borderColor : undefined),
                    fill: chartType === 'area',
                    tension: 0.3,
                    spanGaps: true
                }))
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: true, position: 'top' },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.dataset.label || '';
                                if (label) label += ': ';
                                const value = context.parsed.y;
                                if (metric === 'mortalityRate') label += value.toFixed(2) + '%';
                                else label += value;
                                return label;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                if (metric === 'mortalityRate') return value + '%';
                                return value;
                            }
                        }
                    }
                }
            }
        });
    }

    // Attach event listeners to chart controls
    ['metricSelect','timeUnitSelect','flockFilterSelect','chartTypeSelect'].forEach(id => {
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
    document.addEventListener('DOMContentLoaded', () => {
        refreshMortalityList();
    });

    document.getElementById('addRecordBtn')?.addEventListener('click', () => openMortalityForm('add'));
</script>
</body>
</html>