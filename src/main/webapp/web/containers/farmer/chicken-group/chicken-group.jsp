<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoultryPro - Chicken Groups</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body class="bg-gray-50 dark:bg-gray-900">

    <%@ include file="../../../components/layout/layout2.0.jsp" %>
    <%@ include file="../../../components/forms/chicken-group-form-panel.jsp" %>

    
    <div id="mainContent" class="transition-all duration-300" style="margin-left: 280px; padding-top: 64px;">
        <div class="container mx-auto px-6 py-8">

            <!-- Page Header with actions -->
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6">
                <div>
                    <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Chicken Groups</h1>
                    <p class="text-gray-600 dark:text-gray-400 mt-1">Manage your poultry groups</p>
                </div>
                <div class="flex items-center space-x-3 mt-4 sm:mt-0">
                    <button onclick="window.refreshGroupList()" class="p-3 bg-white dark:bg-gray-800 rounded-xl shadow hover:shadow-lg text-gray-600 dark:text-gray-300 transition">
                        <i class="fas fa-sync-alt"></i>
                    </button>
                    <c:if test="${sessionScope.userRole eq 'farm_owner'}">
                        <button id="addGroupBtn" class="bg-gradient-to-r from-amber-500 to-amber-600 text-white px-5 py-3 rounded-xl font-semibold shadow-md hover:shadow-xl transition flex items-center gap-2">
                            <i class="fas fa-plus"></i> Add New Group
                        </button>
                    </c:if>
                </div>
            </div>

            <!-- Sub Navigation Card -->
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-2 mb-6 border border-gray-200 dark:border-gray-700">
                <nav class="flex space-x-2">
                    <a href="flocks" class="px-4 py-2.5 rounded-lg bg-amber-500 text-white font-semibold shadow">
                        <i class="fas fa-feather-alt mr-2"></i> Chicken Groups
                    </a>
                    <a href="../mortality/mortality.jsp" class="px-4 py-2.5 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                        <i class="fas fa-skull mr-2"></i> Mortality Tracking
                    </a>
                </nav>
            </div>

            <!-- Stats Cards -->
            <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
                <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border border-gray-200 dark:border-gray-700">
                    <div class="flex items-center justify-between">
                        <span class="text-sm font-medium text-gray-600 dark:text-gray-400">Total Groups</span>
                        <i class="fas fa-box text-amber-500 text-xl"></i>
                    </div>
                    <p class="text-3xl font-bold text-gray-900 dark:text-white mt-2 stats-total">0</p>
                </div>
                <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border border-gray-200 dark:border-gray-700">
                    <div class="flex items-center justify-between">
                        <span class="text-sm font-medium text-gray-600 dark:text-gray-400">Layers</span>
                        <i class="fas fa-egg text-yellow-500 text-xl"></i>
                    </div>
                    <p class="text-3xl font-bold text-yellow-600 mt-2 stats-layer">0</p>
                </div>
                <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border border-gray-200 dark:border-gray-700">
                    <div class="flex items-center justify-between">
                        <span class="text-sm font-medium text-gray-600 dark:text-gray-400">Broilers</span>
                        <i class="fas fa-drumstick-bite text-red-500 text-xl"></i>
                    </div>
                    <p class="text-3xl font-bold text-red-600 mt-2 stats-broiler">0</p>
                </div>
                <div class="bg-white dark:bg-gray-800 rounded-2xl shadow p-5 border border-gray-200 dark:border-gray-700">
                    <div class="flex items-center justify-between">
                        <span class="text-sm font-medium text-gray-600 dark:text-gray-400">Total Birds</span>
                        <i class="fas fa-crow text-blue-500 text-xl"></i>
                    </div>
                    <p class="text-3xl font-bold text-gray-900 dark:text-white mt-2 stats-totalBirds">0</p>
                </div>
            </div>

            <!-- Table Card -->
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow border border-gray-200 dark:border-gray-700 overflow-hidden">
                <!-- Search -->
                <div class="p-4 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900/50">
                    <div class="relative max-w-md">
                        <i class="fas fa-search absolute left-3 top-3.5 text-gray-400"></i>
                        <input type="text" id="searchInput" placeholder="Search groups..."
                               class="w-full pl-10 pr-4 py-3 border border-gray-300 dark:border-gray-600 rounded-xl bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500">
                    </div>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50 dark:bg-gray-900/50 border-b border-gray-200 dark:border-gray-700">
                            <tr>
                                <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Name</th>
                                <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Farm</th>
                                <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Type</th>
                                <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Qty</th>
                                <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Cost</th>
                                <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Age</th>
                                <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Received</th>
                                <th class="px-4 py-4 text-left text-xs font-semibold text-gray-700 dark:text-gray-300 uppercase">Origin</th>
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

    <!-- ===== SCRIPTS ===== -->
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
        window.isOwner = ${sessionScope.userRole eq 'farm_owner'};

        document.addEventListener('DOMContentLoaded', () => {
            window.refreshGroupList();
        });

        window.refreshGroupList = async function() {
    try {
        const url = window.contextPath + '/flock/flocks?format=json&_=' + Date.now();
        console.log('Fetching:', url);
        const resp = await fetch(url, { headers: { 'Accept': 'application/json' } });
        console.log('Response status:', resp.status);
        if (!resp.ok) {
            const text = await resp.text();
            console.error('Server error body:', text);
            throw new Error('Server error');
        }
        const data = await resp.json();
        console.log('Received data:', data);

        // Store globally
        window.groupsData = data.groups || [];
        window.farms = data.farms || [];

        // Stats
        document.querySelector('.stats-total').textContent = data.stats?.total ?? 0;
        document.querySelector('.stats-layer').textContent = data.stats?.layerCount ?? 0;
        document.querySelector('.stats-broiler').textContent = data.stats?.broilerCount ?? 0;
        document.querySelector('.stats-totalBirds').textContent = data.stats?.totalBirds ?? 0;

        updateTable(window.groupsData);
    } catch (e) {
        console.error('Refresh failed:', e);
        alert('Failed to load groups. Check console.');
    }
};

    function updateTable(groups) {
            const tbody = document.getElementById('tableBody');
            if (!groups.length) {
                tbody.innerHTML = `<tr><td colspan="9" class="px-4 py-16 text-center text-gray-500">No chicken groups found.</td></tr>`;
                return;
            }
            tbody.innerHTML = groups.map(g => `
                <tr class="border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700/30">
                    <td class="px-4 py-4 font-medium text-gray-900 dark:text-white">\${g.groupName || ''}</td>
                    <td class="px-4 py-4 text-gray-600 dark:text-gray-300">\${g.farmName || ''}</td>
                    <td class="px-4 py-4"><span class="px-2 py-1 text-xs rounded-full capitalize \${typeBadge(g.type)}">\${g.type || 'N/A'}</span></td>
                    <td class="px-4 py-4 font-semibold">\${g.quantity || 0}</td>
                    <td class="px-4 py-4 font-semibold text-green-600 dark:text-green-400">\${Number(g.cost || 0).toFixed(2)}</td>
                    <td class="px-4 py-4">\${g.receiveAge || 0} → \${g.currentAge || 0}</td>
                    <td class="px-4 py-4 text-sm">\${g.receiveDate || ''}</td>
                    <td class="px-4 py-4">\${g.origin || ''}</td>
                    <td class="px-4 py-4 text-center">
                        <div class="flex justify-center space-x-2">
                            <button class="edit-group-btn p-2 bg-blue-50 dark:bg-blue-900/30 text-blue-600 rounded-lg hover:bg-blue-100" data-id="\${g.id}" \${!window.isOwner ? 'style="display:none"' : ''}><i class="fas fa-edit"></i></button>
                            <button onclick="deleteGroup('\${g.id}')" class="p-2 bg-red-50 dark:bg-red-900/30 text-red-600 rounded-lg hover:bg-red-100" \${!window.isOwner ? 'style="display:none"' : ''}><i class="fas fa-trash"></i></button>
                        </div>
                    </td>
                </tr>
            `).join('');
            if (window.isOwner) {
                document.querySelectorAll('.edit-group-btn').forEach(btn => {
                    btn.addEventListener('click', () => {
                        const id = btn.dataset.id;
                        const group = groups.find(g => g.id === id);
                        if (group) openGroupForm('edit', group);
                    });
                });
            }
        }

        function typeBadge(type) {
            switch((type || '').toLowerCase()) {
                case 'broiler': return 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200';
                case 'layer': return 'bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-200';
                default: return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-200';
            }
        }

        window.deleteGroup = function(id) {
            if (!window.isOwner) return;
            Swal.fire({
                title: 'Delete this group?',
                text: "You can't undo this action.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                confirmButtonText: 'Yes, delete'
            }).then(result => {
                if (result.isConfirmed) {
                    fetch(window.contextPath + '/flock/deleteGroup?id=' + id)
                        .then(r => r.json())
                        .then(data => {
                            if (data.success) {
                                Swal.fire('Deleted!', '', 'success');
                                window.refreshGroupList();
                            } else {
                                Swal.fire('Error', data.message, 'error');
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

        document.getElementById('addGroupBtn')?.addEventListener('click', () => openGroupForm('add'));
    </script>
</body>
</html>