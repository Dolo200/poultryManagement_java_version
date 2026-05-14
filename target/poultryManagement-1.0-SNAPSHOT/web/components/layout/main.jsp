<%-- 
    Document   : main
    Created on : Mar 20, 2026, 6:58:12 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>






<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    <title>PoultryPro - Smart Poultry Management</title>
    
     Tailwind CSS 
    <script src="https://cdn.tailwindcss.com"></script>
    
     Font Awesome 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    
    <style>
        /* Main Content Transition */
        #mainContent {
            transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            min-height: 100vh;
            padding-top: 4rem;
        }
        
        /* Smooth page transitions */
        .page-transition {
            animation: pageFadeIn 0.4s ease-out;
        }
        
        @keyframes pageFadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Custom scrollbar for main content */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        
        ::-webkit-scrollbar-thumb {
            background: #f59e0b;
            border-radius: 4px;
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: #d97706;
        }
        
        .dark ::-webkit-scrollbar-track {
            background: #1f2937;
        }
    </style>
</head>
<body class="bg-gray-100 dark:bg-gray-900">
    
     Include Sidebar 
    <jsp:include page="sidebar.jsp" />
    
     Include Navbar 
    <jsp:include page="navbar.jsp" />
    
     Main Content 
    <div id="mainContent" class="page-transition">
        <div class="container mx-auto px-6 py-8">
            <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-lg p-6">
                <h2 class="text-2xl font-bold text-gray-800 dark:text-white mb-4">
                    Welcome Back, <%= session.getAttribute("username") != null ? session.getAttribute("username") : "Farmer" %>!
                </h2>
                <p class="text-gray-600 dark:text-gray-300 mb-6">
                    Here's what's happening with your poultry farm today.
                </p>
                
                 Stats Grid 
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl p-6 text-white transform hover:scale-105 transition-all duration-300">
                        <i class="fas fa-egg text-3xl mb-3"></i>
                        <h3 class="text-lg font-semibold">Total Flocks</h3>
                        <p class="text-3xl font-bold mt-2">1,234</p>
                        <p class="text-sm mt-2 opacity-80">+12% from last month</p>
                    </div>
                    <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-xl p-6 text-white transform hover:scale-105 transition-all duration-300">
                        <i class="fas fa-users text-3xl mb-3"></i>
                        <h3 class="text-lg font-semibold">Staff Members</h3>
                        <p class="text-3xl font-bold mt-2">45</p>
                        <p class="text-sm mt-2 opacity-80">Active workers</p>
                    </div>
                    <div class="bg-gradient-to-br from-amber-500 to-amber-600 rounded-xl p-6 text-white transform hover:scale-105 transition-all duration-300">
                        <i class="fas fa-chart-line text-3xl mb-3"></i>
                        <h3 class="text-lg font-semibold">Revenue</h3>
                        <p class="text-3xl font-bold mt-2">$12,345</p>
                        <p class="text-sm mt-2 opacity-80">+18% this month</p>
                    </div>
                    <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl p-6 text-white transform hover:scale-105 transition-all duration-300">
                        <i class="fas fa-shopping-cart text-3xl mb-3"></i>
                        <h3 class="text-lg font-semibold">Orders</h3>
                        <p class="text-3xl font-bold mt-2">89</p>
                        <p class="text-sm mt-2 opacity-80">Pending: 12</p>
                    </div>
                </div>
                
                 Recent Activity 
                <div class="bg-gray-50 dark:bg-gray-700/50 rounded-xl p-6">
                    <h3 class="text-lg font-semibold text-gray-800 dark:text-white mb-4">Recent Activity</h3>
                    <div class="space-y-3">
                        <div class="flex items-center space-x-3 p-3 hover:bg-white dark:hover:bg-gray-700 rounded-lg transition-colors">
                            <div class="w-10 h-10 bg-green-100 dark:bg-green-900/30 rounded-full flex items-center justify-center">
                                <i class="fas fa-check text-green-600"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm font-medium text-gray-800 dark:text-gray-200">Order #12345 completed</p>
                                <p class="text-xs text-gray-500">2 minutes ago</p>
                            </div>
                        </div>
                        <div class="flex items-center space-x-3 p-3 hover:bg-white dark:hover:bg-gray-700 rounded-lg transition-colors">
                            <div class="w-10 h-10 bg-blue-100 dark:bg-blue-900/30 rounded-full flex items-center justify-center">
                                <i class="fas fa-plus text-blue-600"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm font-medium text-gray-800 dark:text-gray-200">New flock added - Broiler (2,500 birds)</p>
                                <p class="text-xs text-gray-500">1 hour ago</p>
                            </div>
                        </div>
                        <div class="flex items-center space-x-3 p-3 hover:bg-white dark:hover:bg-gray-700 rounded-lg transition-colors">
                            <div class="w-10 h-10 bg-amber-100 dark:bg-amber-900/30 rounded-full flex items-center justify-center">
                                <i class="fas fa-chart-line text-amber-600"></i>
                            </div>
                            <div class="flex-1">
                                <p class="text-sm font-medium text-gray-800 dark:text-gray-200">Daily production target achieved</p>
                                <p class="text-xs text-gray-500">3 hours ago</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Sync main content margin with sidebar
        function updateMainContentMargin() {
            const mainContent = document.getElementById('mainContent');
            if (window.sidebarManager && mainContent) {
                if (window.sidebarManager.isMobile) {
                    mainContent.style.marginLeft = '0';
                } else {
                    mainContent.style.marginLeft = window.sidebarManager.isCollapsed ? '80px' : '280px';
                }
            }
        }
        
        // Listen for sidebar state changes
        window.addEventListener('sidebarStateChanged', updateMainContentMargin);
        window.addEventListener('resize', updateMainContentMargin);
        
        // Initial update
        setTimeout(updateMainContentMargin, 100);
    </script>
</body>
</html>