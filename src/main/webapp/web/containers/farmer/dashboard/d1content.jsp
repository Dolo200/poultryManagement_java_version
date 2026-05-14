    

    
    


<!--<body class="bg-gradient-to-br from-gray-50 to-gray-100">-->
    
  
    <!-- Navigation Bar -->
<!--    <nav class="bg-white shadow-lg sticky top-0 z-50">
        <div class="container mx-auto px-6 py-4">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-3">
                    <div class="bg-gradient-to-r from-amber-500 to-amber-600 p-2 rounded-lg">
                        <i class="fas fa-drumstick-bite text-white text-xl"></i>
                    </div>
                    <div>
                        <h1 class="text-2xl font-bold bg-gradient-to-r from-amber-600 to-amber-500 bg-clip-text text-transparent">
                            PoultryPro
                        </h1>
                        <p class="text-xs text-gray-500">Smart Poultry Management</p>
                    </div>
                </div>
                
                <div class="flex items-center space-x-4">
                     Notifications 
                    <button class="relative text-gray-600 hover:text-amber-500 transition-colors">
                        <i class="fas fa-bell text-xl"></i>
                        <span class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full w-4 h-4 flex items-center justify-center">3</span>
                    </button>
                    
                     User Menu 
                    <div class="flex items-center space-x-3 cursor-pointer group">
                        <div class="w-10 h-10 bg-gradient-to-r from-amber-500 to-amber-600 rounded-full flex items-center justify-center text-white font-bold">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="hidden md:block">
                            <p class="text-sm font-semibold text-gray-700">Welcome back!</p>
                            <p class="text-xs text-gray-500">Farm Manager</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>
    -->
    <div class="container mx-auto px-6 py-8">
        
        <!-- Page Header -->
        <div class="mb-8">
            <h2 class="text-3xl font-bold text-gray-800">Farm Overview Dashboard</h2>
            <p class="text-gray-600 mt-1">Real-time insights and analytics for your poultry farm</p>
        </div>
        
        <!-- Stats Cards Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            
            <!-- Card 1: Total Flocks -->
          
            
            <div class="stat-card bg-white rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.1s">
                <div class="p-6">
                    <div class="flex items-center justify-between mb-4">
                        <div class="bg-blue-50 p-3 rounded-xl">
                            <i class="fas fa-egg text-blue-600 text-2xl"></i>
                        </div>
                        <span class="text-xs font-semibold text-green-600 bg-green-50 px-2 py-1 rounded-full">
                            <i class="fas fa-arrow-up mr-1"></i>+12%
                        </span>
                    </div>
                    <h3 class="text-gray-500 text-sm font-medium">Total Flocks</h3>
                    <p class="text-3xl font-bold text-gray-800 mt-1">${totalFlocks}</p>
                    <p class="text-xs text-gray-400 mt-2">${totalFarms} active farms</p>
                </div>
                <div class="bg-blue-50 px-6 py-2">
                    <a href="#" class="text-blue-600 text-xs font-medium hover:text-blue-700">View Details <i class="fas fa-arrow-right ml-1"></i></a>
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
                    <a href="#" class="text-green-600 text-xs font-medium hover:text-green-700">Manage Staff <i class="fas fa-arrow-right ml-1"></i></a>
                </div>
            </div>
            
            <!-- Card 3: Orders -->
            <div class="stat-card bg-white rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.3s">
                <div class="p-6">
                    <div class="flex items-center justify-between mb-4">
                        <div class="bg-purple-50 p-3 rounded-xl">
                            <i class="fas fa-shopping-cart text-purple-600 text-2xl"></i>
                        </div>
                        <span class="text-xs font-semibold text-green-600 bg-green-50 px-2 py-1 rounded-full">
                            <i class="fas fa-arrow-up mr-1"></i>+23%
                        </span>
                    </div>
                    <h3 class="text-gray-500 text-sm font-medium">Total Orders</h3>
                    <p class="text-3xl font-bold text-gray-800 mt-1">${totalOrders}</p>
                    <p class="text-xs text-gray-400 mt-2">Pending: ${pendingOrders}</p>
                </div>
                <div class="bg-purple-50 px-6 py-2">
                    <a href="#" class="text-purple-600 text-xs font-medium hover:text-purple-700">View Orders <i class="fas fa-arrow-right ml-1"></i></a>
                </div>
            </div>
            
            <!-- Card 4: Revenue -->
            <div class="stat-card bg-white rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.4s">
                <div class="p-6">
                    <div class="flex items-center justify-between mb-4">
                        <div class="bg-amber-50 p-3 rounded-xl">
                            <i class="fas fa-dollar-sign text-amber-600 text-2xl"></i>
                        </div>
                        <span class="text-xs font-semibold text-green-600 bg-green-50 px-2 py-1 rounded-full">
                            <i class="fas fa-arrow-up mr-1"></i>+18%
                        </span>
                    </div>
                    <h3 class="text-gray-500 text-sm font-medium">Total Revenue</h3>
                    <p class="text-3xl font-bold text-gray-800 mt-1">$${totalSalesValue}</p>
                    <p class="text-xs text-gray-400 mt-2">This month: $${monthlyRevenue}</p>
                </div>
                <div class="bg-amber-50 px-6 py-2">
                    <a href="#" class="text-amber-600 text-xs font-medium hover:text-amber-700">View Reports <i class="fas fa-arrow-right ml-1"></i></a>
                </div>
            </div>
        </div>
        
        <!-- Charts Section -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- Revenue Chart -->
            <div class="bg-white rounded-2xl shadow-md p-6 card-animate" style="animation-delay: 0.5s">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-lg font-semibold text-gray-800">Revenue Overview</h3>
                    <select class="text-sm border rounded-lg px-3 py-1 focus:outline-none focus:ring-2 focus:ring-amber-500">
                        <option>Last 7 days</option>
                        <option>Last 30 days</option>
                        <option>Last 12 months</option>
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
        
        <!-- Marketplace Section -->
        <div class="mb-8">
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">Marketplace</h2>
                    <p class="text-gray-600 text-sm">Buy and sell poultry products</p>
                </div>
                <a href="#" class="bg-gradient-to-r from-amber-500 to-amber-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:shadow-lg transition-all">
                    <i class="fas fa-plus mr-2"></i>Post New Item
                </a>
            </div>
            
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Posted Goods Card -->
                <div class="stat-card bg-gradient-to-br from-blue-50 to-blue-100 rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.7s">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-white p-3 rounded-xl shadow-sm">
                                <i class="fas fa-box-open text-blue-600 text-2xl"></i>
                            </div>
                            <i class="fas fa-arrow-right text-blue-400"></i>
                        </div>
                        <h3 class="text-gray-700 text-sm font-medium">Posted Goods</h3>
                        <p class="text-3xl font-bold text-gray-800 mt-1">${totalPostedGoods}</p>
                        <p class="text-xs text-gray-500 mt-2">Active listings</p>
                    </div>
                    <div class="bg-white/50 px-6 py-2">
                        <a href="#" class="text-blue-600 text-xs font-medium hover:text-blue-700">View Listings <i class="fas fa-arrow-right ml-1"></i></a>
                    </div>
                </div>
                
                <!-- Completed Orders Card -->
                <div class="stat-card bg-gradient-to-br from-green-50 to-green-100 rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.8s">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-white p-3 rounded-xl shadow-sm">
                                <i class="fas fa-check-circle text-green-600 text-2xl"></i>
                            </div>
                            <i class="fas fa-trophy text-green-400"></i>
                        </div>
                        <h3 class="text-gray-700 text-sm font-medium">Completed Orders</h3>
                        <p class="text-3xl font-bold text-gray-800 mt-1">${completedOrders}</p>
                        <p class="text-xs text-gray-500 mt-2">Successfully delivered</p>
                    </div>
                    <div class="bg-white/50 px-6 py-2">
                        <a href="#" class="text-green-600 text-xs font-medium hover:text-green-700">View History <i class="fas fa-arrow-right ml-1"></i></a>
                    </div>
                </div>
                
                <!-- Pending Orders Card -->
                <div class="stat-card bg-gradient-to-br from-yellow-50 to-yellow-100 rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 0.9s">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-white p-3 rounded-xl shadow-sm">
                                <i class="fas fa-clock text-yellow-600 text-2xl"></i>
                            </div>
                            <i class="fas fa-hourglass-half text-yellow-400"></i>
                        </div>
                        <h3 class="text-gray-700 text-sm font-medium">Pending Orders</h3>
                        <p class="text-3xl font-bold text-gray-800 mt-1">${pendingOrders}</p>
                        <p class="text-xs text-gray-500 mt-2">Awaiting processing</p>
                    </div>
                    <div class="bg-white/50 px-6 py-2">
                        <a href="#" class="text-yellow-600 text-xs font-medium hover:text-yellow-700">Process Now <i class="fas fa-arrow-right ml-1"></i></a>
                    </div>
                </div>
                
                <!-- Total Sales Card -->
                <div class="stat-card bg-gradient-to-br from-purple-50 to-purple-100 rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 1.0s">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <div class="bg-white p-3 rounded-xl shadow-sm">
                                <i class="fas fa-chart-line text-purple-600 text-2xl"></i>
                            </div>
                            <i class="fas fa-chart-simple text-purple-400"></i>
                        </div>
                        <h3 class="text-gray-700 text-sm font-medium">Marketplace Sales</h3>
                        <p class="text-3xl font-bold text-gray-800 mt-1">$${marketplaceSales}</p>
                        <p class="text-xs text-gray-500 mt-2">Total marketplace revenue</p>
                    </div>
                    <div class="bg-white/50 px-6 py-2">
                        <a href="#" class="text-purple-600 text-xs font-medium hover:text-purple-700">View Analytics <i class="fas fa-arrow-right ml-1"></i></a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Activity Section -->
        <div class="bg-white rounded-2xl shadow-md overflow-hidden card-animate" style="animation-delay: 1.1s">
            <div class="px-6 py-4 border-b border-gray-200">
                <h3 class="text-lg font-semibold text-gray-800">Recent Activity</h3>
            </div>
            <div class="divide-y divide-gray-200">
                <div class="px-6 py-4 flex items-center space-x-3 hover:bg-gray-50 transition-colors">
                    <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                        <i class="fas fa-check text-green-600"></i>
                    </div>
                    <div class="flex-1">
                        <p class="text-sm font-medium text-gray-800">Order #12345 completed</p>
                        <p class="text-xs text-gray-500">2 minutes ago</p>
                    </div>
                    <span class="text-xs text-green-600 bg-green-50 px-2 py-1 rounded-full">Completed</span>
                </div>
                <div class="px-6 py-4 flex items-center space-x-3 hover:bg-gray-50 transition-colors">
                    <div class="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                        <i class="fas fa-plus text-blue-600"></i>
                    </div>
                    <div class="flex-1">
                        <p class="text-sm font-medium text-gray-800">New flock added - Broiler 2,500 birds</p>
                        <p class="text-xs text-gray-500">1 hour ago</p>
                    </div>
                    <span class="text-xs text-blue-600 bg-blue-50 px-2 py-1 rounded-full">New</span>
                </div>
                <div class="px-6 py-4 flex items-center space-x-3 hover:bg-gray-50 transition-colors">
                    <div class="w-10 h-10 bg-amber-100 rounded-full flex items-center justify-center">
                        <i class="fas fa-dollar-sign text-amber-600"></i>
                    </div>
                    <div class="flex-1">
                        <p class="text-sm font-medium text-gray-800">Revenue target achieved for this month</p>
                        <p class="text-xs text-gray-500">3 hours ago</p>
                    </div>
                    <span class="text-xs text-amber-600 bg-amber-50 px-2 py-1 rounded-full">Milestone</span>
                </div>
            </div>
        </div>
    </div>
             

                      