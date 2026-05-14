<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoultryPro - Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .card-animate {
            animation: fadeInUp 0.5s ease-out forwards;
            opacity: 0;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100">

    <%@ include file="../../../components/layout/layout2.0.jsp" %>

    <div id="mainContent" class="transition-all duration-300" style="margin-left: 280px; padding-top: 64px;">
        <div class="container mx-auto px-6 py-8">

            <!-- Page Header -->
            <div class="mb-8">
                <h2 class="text-3xl font-bold text-gray-800">Farm Overview Dashboard</h2>
                <p class="text-gray-600 mt-1">Real-time insights and analytics for your poultry farm</p>
            </div>

            <!-- Stats Cards Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">

                <!-- Card 1: Chicken Groups -->
                <div class="stat-card bg-white rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.1s">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-blue-50 p-3 rounded-xl">
                                <i class="fas fa-feather-alt text-blue-600 text-2xl"></i>
                            </div>
                            <span class="text-xs font-semibold text-green-600 bg-green-50 px-2 py-1 rounded-full">
                                <i class="fas fa-arrow-up mr-1"></i>+12%
                            </span>
                        </div>
                        <h3 class="text-gray-500 text-sm font-medium">Chicken Groups</h3>
                        <p class="text-3xl font-bold text-gray-800 mt-1">${totalFlocks}</p>
                        <p class="text-xs text-gray-400 mt-2">${totalFarms} active farms</p>
                    </div>
                    <div class="bg-blue-50 px-6 py-2">
                        <a href="${pageContext.request.contextPath}/web/containers/farmer/chicken-group/chicken-group.jsp" class="text-blue-600 text-xs font-medium hover:text-blue-700">
                            View Details <i class="fas fa-arrow-right ml-1"></i>
                        </a>
                    </div>
                </div>

                <!-- Card 2: Staff -->
                <div class="stat-card bg-white rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.2s">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-green-50 p-3 rounded-xl">
                                <i class="fas fa-users text-green-600 text-2xl"></i>
                            </div>
                            <span class="text-xs font-semibold text-green-600 bg-green-50 px-2 py-1 rounded-full">
                                <i class="fas fa-arrow-up mr-1"></i>+5%
                            </span>
                        </div>
                        <h3 class="text-gray-500 text-sm font-medium">Staff Members</h3>
                        <p class="text-3xl font-bold text-gray-800 mt-1">${totalStaff}</p>
                        <p class="text-xs text-gray-400 mt-2">Active workforce</p>
                    </div>
                    <div class="bg-green-50 px-6 py-2">
                        <a href="${pageContext.request.contextPath}/web/containers/farmer/staff/staff.jsp" class="text-green-600 text-xs font-medium hover:text-green-700">
                            Manage Staff <i class="fas fa-arrow-right ml-1"></i>
                        </a>
                    </div>
                </div>

                <!-- Card 3: Products (Inventory) -->
                <div class="stat-card bg-white rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.3s">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-purple-50 p-3 rounded-xl">
                                <i class="fas fa-box-open text-purple-600 text-2xl"></i>
                            </div>
                            <span class="text-xs font-semibold text-green-600 bg-green-50 px-2 py-1 rounded-full">
                                <i class="fas fa-arrow-up mr-1"></i>+8%
                            </span>
                        </div>
                        <h3 class="text-gray-500 text-sm font-medium">Products Listed</h3>
                        <p class="text-3xl font-bold text-gray-800 mt-1">${totalPostedGoods}</p>
                        <p class="text-xs text-gray-400 mt-2">Active inventory items</p>
                    </div>
                    <div class="bg-purple-50 px-6 py-2">
                        <a href="${pageContext.request.contextPath}/web/containers/farmer/production/production.jsp" class="text-purple-600 text-xs font-medium hover:text-purple-700">
                            View Inventory <i class="fas fa-arrow-right ml-1"></i>
                        </a>
                    </div>
                </div>

                <!-- Card 4: Total Farms -->
                <div class="stat-card bg-white rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.4s">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-amber-50 p-3 rounded-xl">
                                <i class="fas fa-tractor text-amber-600 text-2xl"></i>
                            </div>
                            <span class="text-xs font-semibold text-green-600 bg-green-50 px-2 py-1 rounded-full">
                                <i class="fas fa-arrow-up mr-1"></i>+2%
                            </span>
                        </div>
                        <h3 class="text-gray-500 text-sm font-medium">Total Farms</h3>
                        <p class="text-3xl font-bold text-gray-800 mt-1">${totalFarms}</p>
                        <p class="text-xs text-gray-400 mt-2">Registered poultry farms</p>
                    </div>
                    <div class="bg-amber-50 px-6 py-2">
                        <a href="${pageContext.request.contextPath}/web/containers/farmer/farm/farms.jsp" class="text-amber-600 text-xs font-medium hover:text-amber-700">
                            Manage Farms <i class="fas fa-arrow-right ml-1"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Charts Section (Sample Graphs) -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                <!-- Revenue Chart -->
                <div class="bg-white rounded-2xl shadow-md p-6 card-animate" style="animation-delay: 0.5s">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-800">Revenue Overview</h3>
                        <select id="revenuePeriod" class="text-sm border rounded-lg px-3 py-1 focus:outline-none focus:ring-2 focus:ring-amber-500">
                            <option>Last 7 days</option>
                            <option>Last 30 days</option>
                        </select>
                    </div>
                    <canvas id="revenueChart" height="200"></canvas>
                </div>
                <!-- Orders Chart -->
                <div class="bg-white rounded-2xl shadow-md p-6 card-animate" style="animation-delay: 0.6s">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg font-semibold text-gray-800">Order Statistics</h3>
                        <i class="fas fa-chart-line text-gray-400"></i>
                    </div>
                    <canvas id="ordersChart" height="200"></canvas>
                </div>
            </div>

            <!-- Marketplace Section (Static Dummy Numbers) -->
            <div class="mb-8">
                <div class="flex items-center justify-between mb-6">
                    <div>
                        <h2 class="text-2xl font-bold text-gray-800">Marketplace</h2>
                        <p class="text-gray-600 text-sm">Buy and sell poultry products (coming soon)</p>
                    </div>
                    <a href="#" class="bg-gradient-to-r from-amber-500 to-amber-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:shadow-lg transition-all">
                        <i class="fas fa-plus mr-2"></i>Post New Item
                    </a>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div class="stat-card bg-gradient-to-br from-blue-50 to-blue-100 rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.7s">
                        <div class="p-6">
                            <div class="flex items-center justify-between mb-4">
                                <div class="bg-white p-3 rounded-xl shadow-sm">
                                    <i class="fas fa-box-open text-blue-600 text-2xl"></i>
                                </div>
                                <i class="fas fa-arrow-right text-blue-400"></i>
                            </div>
                            <h3 class="text-gray-700 text-sm font-medium">Posted Goods</h3>
                            <p class="text-3xl font-bold text-gray-800 mt-1">0</p>
                            <p class="text-xs text-gray-500 mt-2">Active listings</p>
                        </div>
                        <div class="bg-white/50 px-6 py-2">
                            <a href="#" class="text-blue-600 text-xs font-medium hover:text-blue-700">View Listings <i class="fas fa-arrow-right ml-1"></i></a>
                        </div>
                    </div>

                    <div class="stat-card bg-gradient-to-br from-green-50 to-green-100 rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.8s">
                        <div class="p-6">
                            <div class="flex items-center justify-between mb-4">
                                <div class="bg-white p-3 rounded-xl shadow-sm">
                                    <i class="fas fa-check-circle text-green-600 text-2xl"></i>
                                </div>
                                <i class="fas fa-trophy text-green-400"></i>
                            </div>
                            <h3 class="text-gray-700 text-sm font-medium">Completed Orders</h3>
                            <p class="text-3xl font-bold text-gray-800 mt-1">0</p>
                            <p class="text-xs text-gray-500 mt-2">Successfully delivered</p>
                        </div>
                        <div class="bg-white/50 px-6 py-2">
                            <a href="#" class="text-green-600 text-xs font-medium hover:text-green-700">View History <i class="fas fa-arrow-right ml-1"></i></a>
                        </div>
                    </div>

                    <div class="stat-card bg-gradient-to-br from-yellow-50 to-yellow-100 rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.9s">
                        <div class="p-6">
                            <div class="flex items-center justify-between mb-4">
                                <div class="bg-white p-3 rounded-xl shadow-sm">
                                    <i class="fas fa-clock text-yellow-600 text-2xl"></i>
                                </div>
                                <i class="fas fa-hourglass-half text-yellow-400"></i>
                            </div>
                            <h3 class="text-gray-700 text-sm font-medium">Pending Orders</h3>
                            <p class="text-3xl font-bold text-gray-800 mt-1">0</p>
                            <p class="text-xs text-gray-500 mt-2">Awaiting processing</p>
                        </div>
                        <div class="bg-white/50 px-6 py-2">
                            <a href="#" class="text-yellow-600 text-xs font-medium hover:text-yellow-700">Process Now <i class="fas fa-arrow-right ml-1"></i></a>
                        </div>
                    </div>

                    <div class="stat-card bg-gradient-to-br from-purple-50 to-purple-100 rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 1.0s">
                        <div class="p-6">
                            <div class="flex items-center justify-between mb-4">
                                <div class="bg-white p-3 rounded-xl shadow-sm">
                                    <i class="fas fa-chart-line text-purple-600 text-2xl"></i>
                                </div>
                                <i class="fas fa-chart-simple text-purple-400"></i>
                            </div>
                            <h3 class="text-gray-700 text-sm font-medium">Marketplace Sales</h3>
                            <p class="text-3xl font-bold text-gray-800 mt-1">$0</p>
                            <p class="text-xs text-gray-500 mt-2">Total marketplace revenue</p>
                        </div>
                        <div class="bg-white/50 px-6 py-2">
                            <a href="#" class="text-purple-600 text-xs font-medium hover:text-purple-700">View Analytics <i class="fas fa-arrow-right ml-1"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="bg-white rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 1.1s">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h3 class="text-lg font-semibold text-gray-800">Recent Activity</h3>
                </div>
                <div class="divide-y divide-gray-200">
                    <c:forEach items="${recentFlocks}" var="flock">
                        <div class="px-6 py-4 flex items-center space-x-3 hover:bg-gray-50 transition-colors">
                            <div class="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-plus text-blue-600"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm font-medium text-gray-800">
                                    New flock added - ${flock.name} (${flock.quantity} birds)
                                </p>
                                <p class="text-xs text-gray-500">
                                    <fmt:formatDate value="${flock.receiveDate}" pattern="yyyy-MM-dd HH:mm"/>
                                </p>
                            </div>
                            <span class="text-xs text-blue-600 bg-blue-50 px-2 py-1 rounded-full">New</span>
                        </div>
                    </c:forEach>
                    <c:if test="${empty recentFlocks}">
                        <div class="px-6 py-4 text-center text-gray-500">No recent activity</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart Initialization with Sample Data -->
    <script>
        // Revenue Chart (dummy)
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: ${revenueLabels},
                datasets: [{
                    label: 'Revenue ($)',
                    data: ${revenueData},
                    backgroundColor: 'rgba(245, 158, 11, 0.2)',
                    borderColor: '#f59e0b',
                    borderWidth: 2,
                    tension: 0.3,
                    fill: true
                }]
            },
            options: { 
                responsive: true, 
                plugins: { legend: { display: false } } 
            }
        });

        // Orders Chart (dummy)
        const ordersCtx = document.getElementById('ordersChart').getContext('2d');
        new Chart(ordersCtx, {
            type: 'bar',
            data: {
                labels: ${ordersLabels},
                datasets: [{
                    label: 'Orders',
                    data: ${ordersData},
                    backgroundColor: '#8b5cf6',
                    borderRadius: 8
                }]
            },
            options: { 
                responsive: true, 
                plugins: { legend: { display: false } } 
            }
        });
    </script>
</body>
</html>