<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoultryPro - Farms</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- SweetAlert2 CSS & JS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


</head>
<body class="bg-gray-50">

    <%@ include file="../../../components/layout/layout2.0.jsp" %>

    <div id="mainContent" class="transition-all duration-300" style="margin-left: 280px; padding-top: 64px;">
        <div class="container mx-auto px-6 py-8">

            <!-- Header -->
            <div class="mb-6 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                <div>
                    <h2 class="text-3xl font-bold text-gray-800">Farm Management</h2>
                    <p class="text-gray-600 mt-1">Manage your poultry farms and their operations</p>
                </div>
                <div class="flex items-center space-x-3">
                    <button onclick="window.refreshFarmList()" class="p-3 bg-gray-100 rounded-lg hover:bg-gray-200" title="Refresh">
                        <i class="fas fa-sync-alt text-gray-600"></i>
                    </button>
                    <div class="flex bg-gray-100 rounded-lg p-1">
                        <button id="tableViewBtn" class="px-3 py-2 rounded-md bg-white shadow-sm text-green-600">Table</button>
                        <button id="gridViewBtn" class="px-3 py-2 rounded-md text-gray-600 hover:text-gray-800">Grid</button>
                    </div>
                    <c:if test="${sessionScope.role ne 'staff'}">
                        <button id="addFarmBtn" class="bg-gradient-to-r from-green-500 to-green-600 text-white px-4 py-2 rounded-lg font-medium hover:shadow-lg">
                            <i class="fas fa-plus mr-2"></i>Add New Farm
                        </button>
                    </c:if>
                </div>
            </div>

            <!-- Sub Navigation -->
            <div class="bg-white rounded-2xl shadow-lg mb-6 p-2">
                <nav class="flex space-x-1">
                    <a href="farms" class="px-4 py-2 rounded-lg bg-green-500 text-white font-semibold shadow flex items-center gap-2">
                        <i class="fas fa-tractor"></i> Farms
                    </a>
                    <a href="map.jsp" class="px-4 py-2 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-700 border border-transparent hover:border-green-200 flex items-center gap-2">
                        <i class="fas fa-map-marker-alt"></i> Map
                    </a>
                    <a href="farm-analytics" class="px-4 py-2 rounded-lg text-gray-700 hover:bg-green-50 hover:text-green-700 border border-transparent hover:border-green-200 flex items-center gap-2">
                        <i class="fas fa-chart-bar"></i> Analytics
                    </a>
                </nav>
            </div>

            <!-- Stats (EL expressions here are plain JSP → safe) -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6" id="statsContainer">
                <div class="bg-white rounded-2xl shadow-lg p-6"><p class="text-sm text-gray-600">Total Farms</p><p class="text-2xl font-bold mt-1 stats-total">${stats.total}</p></div>
                <div class="bg-white rounded-2xl shadow-lg p-6"><p class="text-sm text-gray-600">With Chicken Groups</p><p class="text-2xl font-bold mt-1 stats-withGroups">${stats.withGroups}</p></div>
                <div class="bg-white rounded-2xl shadow-lg p-6"><p class="text-sm text-gray-600">Staff Assigned</p><p class="text-2xl font-bold mt-1 stats-withStaff">${stats.withStaff}</p></div>
                <div class="bg-white rounded-2xl shadow-lg p-6"><p class="text-sm text-gray-600">Total Size</p><p class="text-2xl font-bold mt-1 stats-totalSize">${stats.totalSize} acres</p></div>
            </div>

            <!-- Search & Controls -->
            <div class="bg-white rounded-2xl shadow-lg mb-6 p-6">
                <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                    <form class="flex-1 max-w-2xl relative" onsubmit="return false;">
                        <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input type="text" id="searchInput" placeholder="Search farms..."
                               class="w-full pl-10 pr-10 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-green-500">
                        <button type="button" onclick="clearSearch()" class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600">✕</button>
                    </form>
                    <div class="flex items-center space-x-3">
                        <%@ include file="../../../components/sort/sort-dropdown.jsp" %>
                    </div>
                </div>
            </div>

            <!-- Table View -->
            <div id="tableView" class="bg-white rounded-2xl shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b border-gray-200">
                            <tr>
                                <th class="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase">Farm Name</th>
                                <th class="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase">Address</th>
                                <th class="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase">Size</th>
                                <th class="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase">Chicken Groups</th>
                                <th class="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase">Staff</th>
                                <th class="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase">Pin Color</th>
                                <th class="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase">Created</th>
                                <th class="px-6 py-4 text-center text-xs font-semibold text-gray-700 uppercase">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <!-- dynamically populated -->
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Grid View -->
            <div id="gridView" class="hidden grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-6">
                <!-- dynamically populated -->
            </div>

        </div>
    </div>

    <!-- ===== INCLUDES ===== -->
    <%@ include file="../../../components/forms/farm-form-panel.jsp" %>

    <!-- ===== JAVASCRIPT (all `\${` are escaped for JSP) ===== -->
    <script>
        window.contextPath = '${pageContext.request.contextPath}';

        // Initial data from JSP (safe EL → JavaScript values)
        const initialFarms = [
            <c:forEach items="${farms}" var="farm" varStatus="s">
                {
                    id: "${farm.id}",
                    farmName: "<c:out value="${farm.farmName}" escapeXml="true"/>",
                    address: "<c:out value="${farm.address}" escapeXml="true"/>",
                    size: ${farm.size},
                    pinColor: "${farm.pinColor}",
                    createdAt: "<c:out value="${farm.createdAt}" escapeXml="true"/>",
                    chickenGroups: [
                        <c:forEach items="${farm.chickenGroups}" var="g" varStatus="gs">
                            { id: "${g.id}", groupName: "<c:out value="${g.groupName}" escapeXml="true"/>" }${!gs.last ? ',' : ''}
                        </c:forEach>
                    ],
                    staffNames: [
                        <c:forEach items="${farm.staffNames}" var="staff" varStatus="st">
                            "<c:out value="${staff}" escapeXml="true"/>"${!st.last ? ',' : ''}
                        </c:forEach>
                    ],
                    assignedManagerIds: [
                        <c:forEach items="${farm.assignedManagerIds}" var="mid" varStatus="ms">
                            "${mid}"${!ms.last ? ',' : ''}
                        </c:forEach>
                    ],
                    chickenGroupsJson: '<c:out value="${farm.chickenGroupsJson}" escapeXml="false"/>',
                    assignedManagerIdsJson: '<c:out value="${farm.assignedManagerIdsJson}" escapeXml="false"/>'
                }${!s.last ? ',' : ''}
            </c:forEach>
        ];

        // Populate table/grid on page load
        document.addEventListener('DOMContentLoaded', () => {
    // 1. If the server provided initial data, use it instantly
    if (typeof initialFarms !== 'undefined' && initialFarms.length > 0) {
        updateTable(initialFarms);
        updateGrid(initialFarms);
    }
    // 2. Nevertheless, fetch fresh data from the server via AJAX
    //    This ensures data always appears, even if the JSP was loaded
    //    directly without the servlet having populated attributes.
    window.refreshFarmList();
});

        // ========================
        //  REFRESH (AJAX)
        // ========================
        window.refreshFarmList = async function() {
            try {
                const resp = await fetch(window.contextPath + '/farm/farms?format=json', {
                    headers: { 'Accept': 'application/json' }
                });
                if (!resp.ok) throw new Error('Server error');
                const data = await resp.json();
                document.querySelector('.stats-total').textContent = data.stats.total;
                document.querySelector('.stats-withGroups').textContent = data.stats.withGroups;
                document.querySelector('.stats-withStaff').textContent = data.stats.withStaff;
                document.querySelector('.stats-totalSize').textContent = data.stats.totalSize + ' acres';
                updateTable(data.farms);
                updateGrid(data.farms);
                window.flocks = data.flockList;
                window.staffs = data.staffList;
                bindEditButtons();
            } catch (error) {
                console.error('Failed to refresh farm list', error);
            }
        };

        // ========================
        //  TABLE BUILDER
        // ========================
        function updateTable(farms) {
            const tbody = document.getElementById('tableBody');
            if (!farms.length) {
                tbody.innerHTML = '<tr><td colspan="8" class="px-6 py-16 text-center"><i class="fas fa-tractor text-4xl text-gray-300 mb-4"></i><p class="text-lg font-semibold text-gray-900">No Farms Available</p></td></tr>';
                return;
            }
            // All \${ inside the template are JavaScript literals, safe from JSP
            tbody.innerHTML = farms.map(farm => {
                return `
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 font-medium text-gray-900">\${farm.farmName || ''}</td>
                    <td class="px-6 py-4 text-sm text-gray-600">\${farm.address || ''}</td>
                    <td class="px-6 py-4 text-sm">\${farm.size}</td>
                    <td class="px-6 py-4">
                        \${(farm.chickenGroups || []).map(g => '<span class="inline-block bg-gray-100 rounded-full px-2 py-1 text-xs font-medium text-gray-700 mr-1 mb-1">' + g.groupName + '</span>').join('')}
                        \${!(farm.chickenGroups || []).length ? '<span class="text-gray-400 text-sm">None</span>' : ''}
                    </td>
                    <td class="px-6 py-4 text-sm">
                        \${(farm.staffNames || []).map(s => '<span class="inline-block bg-blue-100 text-blue-800 rounded-full px-2 py-1 text-xs mr-1 mb-1">' + s + '</span>').join('')}
                        \${!(farm.staffNames || []).length ? '<span class="text-gray-400">No staff</span>' : ''}
                    </td>
                    <td class="px-6 py-4">
                        <div class="flex items-center space-x-2">
                            <div class="w-4 h-4 rounded-full" style="background-color: \${farm.pinColor || 'blue'};"></div>
                            <span class="capitalize">\${farm.pinColor || 'blue'}</span>
                        </div>
                    </td>
                    <td class="px-6 py-4 text-sm text-gray-600">\${new Date(farm.createdAt).toLocaleDateString()}</td>
                    <td class="px-6 py-4 text-center">
                        <div class="flex items-center justify-center space-x-2">
                            <button class="p-2 bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100" title="View"><i class="fas fa-eye"></i></button>
                            \${renderEditButton(farm)}
                        </div>
                    </td>
                </tr>`;
            }).join('');
            bindEditButtons();
        }

        // ========================
        //  GRID BUILDER
        // ========================
        function updateGrid(farms) {
            const grid = document.getElementById('gridView');
            if (!farms.length) {
                grid.innerHTML = '<div class="col-span-3 text-center py-16 text-gray-500">No farms to show</div>';
                return;
            }
            grid.innerHTML = farms.map(farm => {
                return `
                <div class="bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <h3 class="text-xl font-bold text-gray-900">\${farm.farmName || ''}</h3>
                            <p class="text-sm text-gray-600 flex items-center mt-1"><i class="fas fa-map-marker-alt mr-1"></i>\${farm.address || ''}</p>
                        </div>
                        <div class="w-6 h-6 rounded-full" style="background-color: \${farm.pinColor || 'blue'};"></div>
                    </div>
                    <div class="space-y-3 text-sm">
                        <div class="flex justify-between"><span class="text-gray-500">Size</span><span class="font-medium">\${farm.size} acres</span></div>
                        <div>
                            <span class="text-gray-500">Chicken Groups</span>
                            <div class="flex flex-wrap gap-1 mt-1">\${(farm.chickenGroups || []).map(g => '<span class="inline-block bg-gray-100 rounded-full px-2 py-1 text-xs">' + g.groupName + '</span>').join('')}\${!(farm.chickenGroups || []).length ? '<span class="text-gray-400">None</span>' : ''}</div>
                        </div>
                        <div>
                            <span class="text-gray-500">Staff</span>
                            <div class="flex flex-wrap gap-1 mt-1">\${(farm.staffNames || []).map(s => '<span class="inline-block bg-blue-100 text-blue-800 rounded-full px-2 py-1 text-xs">' + s + '</span>').join('')}\${!(farm.staffNames || []).length ? '<span class="text-gray-400">None</span>' : ''}</div>
                        </div>
                        <div class="flex justify-between pt-3 border-t text-xs">
                            <span class="text-gray-500">Created \${new Date(farm.createdAt).toLocaleDateString()}</span>
                            <div class="flex space-x-2">
                                <button class="p-1 hover:bg-gray-100 rounded" title="View"><i class="fas fa-eye text-gray-600"></i></button>
                                \${renderEditButton(farm)}
                            </div>
                        </div>
                    </div>
                </div>`;
            }).join('');
            bindEditButtons();
        }

        // ========================
        //  EDIT BUTTON & ROLE CHECK
        // ========================
        function renderEditButton(farm) {
            if ('${sessionScope.role}' === 'staff') return '';
            return `
                <button class="edit-farm-btn p-2 bg-green-50 text-green-600 rounded-lg hover:bg-green-100"
                        data-id="\${farm.id}" data-name="\${farm.farmName}" data-address="\${farm.address}"
                        data-size="\${farm.size}" data-color="\${farm.pinColor}"
                        data-flocks='\${farm.chickenGroupsJson}' data-managers='\${farm.assignedManagerIdsJson}'
                        title="Edit farm"><i class="fas fa-edit"></i></button>
                <button onclick="deleteFarm('\${farm.id}')" class="p-2 bg-red-50 text-red-600 rounded-lg hover:bg-red-100" title="Delete"><i class="fas fa-trash"></i></button>
            `;
        }

        function bindEditButtons() {
            document.querySelectorAll('.edit-farm-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    const farmData = {
                        id: this.dataset.id,
                        farmName: this.dataset.name,
                        address: this.dataset.address,
                        size: this.dataset.size,
                        pinColor: this.dataset.color,
                        assignedFlocks: JSON.parse(this.dataset.flocks || '[]'),
                        assignedManager: JSON.parse(this.dataset.managers || '[]')
                    };
                    openFarmForm('edit', farmData);
                });
            });
        }

        // ========================
        //  DELETE (AJAX)
        // ========================
      // ===== DELETE (SweetAlert2) =====
    window.deleteFarm = function(id) {
    Swal.fire({
        title: 'Are you sure?',
        text: "This farm will be permanently deleted!",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch(window.contextPath + '/farm/deleteFarm?id=' + id)
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        Swal.fire(
                            'Deleted!',
                            'The farm has been removed.',
                            'success'
                        );
                        window.refreshFarmList();
                    } else {
                        Swal.fire(
                            'Error!',
                            data.message || 'Failed to delete farm.',
                            'error'
                        );
                    }
                })
                .catch(() => {
                    Swal.fire(
                        'Error!',
                        'Network or server error.',
                        'error'
                    );
                });
        }
    });
};

        // ========================
        //  SEARCH (client side)
        // ========================
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const term = e.target.value.toLowerCase();
            document.querySelectorAll('#tableBody tr').forEach(row => {
                row.style.display = row.textContent.toLowerCase().includes(term) ? '' : 'none';
            });
            document.querySelectorAll('#gridView > div').forEach(card => {
                card.style.display = card.textContent.toLowerCase().includes(term) ? '' : 'none';
            });
        });

        // ========================
        //  TOGGLE TABLE / GRID
        // ========================
        document.getElementById('tableViewBtn').addEventListener('click', function() {
            document.getElementById('tableView').classList.remove('hidden');
            document.getElementById('gridView').classList.add('hidden');
            this.classList.add('bg-white','shadow-sm','text-green-600');
            document.getElementById('gridViewBtn').classList.remove('bg-white','shadow-sm','text-green-600');
        });
        document.getElementById('gridViewBtn').addEventListener('click', function() {
            document.getElementById('gridView').classList.remove('hidden');
            document.getElementById('tableView').classList.add('hidden');
            this.classList.add('bg-white','shadow-sm','text-green-600');
            document.getElementById('tableViewBtn').classList.remove('bg-white','shadow-sm','text-green-600');
        });

        // ========================
        //  ADD FARM BUTTON
        // ========================
        document.getElementById('addFarmBtn')?.addEventListener('click', () => openFarmForm('add'));
    </script>
</body>
</html>