<%--
  layout2.0.jsp – Full layout with Sidebar + Top Navbar
  Requires session attributes: user, userName, userRole (set by AuthServlet)
  Logout handled by LogoutServlet (/LogoutServlet)
  Active menu item determined from current URI
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Redirect if not logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/web/containers/auth/login.jsp");
        return;
    }

    // Retrieve user info from session
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    if (userName == null) userName = "Farmer";
    if (userRole == null) userRole = "guest";

    // Compute initials (up to 2 letters, preferably first and last name)
    String initials = "";
    String[] parts = userName.trim().split("\\s+");
    if (parts.length > 0) initials += parts[0].charAt(0);
    if (parts.length > 1) initials += parts[parts.length - 1].charAt(0);
    initials = initials.toUpperCase();
    if (initials.isEmpty()) initials = "U";

    // Determine current page from query parameters or URI (for active menu state)
    String requestUri = request.getRequestURI();
    String currentPage = request.getParameter("page");
    if (currentPage == null || currentPage.isEmpty()) {
        // Detect page from URI path
        if (requestUri.contains("/farm/")) currentPage = "farm";
        else if (requestUri.contains("/chicken-group/")) currentPage = "flock";
        else if (requestUri.contains("/staff/")) currentPage = "staff";
        else if (requestUri.contains("/production/")) currentPage = "production";
        else if (requestUri.contains("/feed/")) currentPage = "feed";
        else if (requestUri.contains("/vaccination/")) currentPage = "medical";
        else if (requestUri.contains("marketplace")) currentPage = "marketplace";
        else if (requestUri.contains("settings")) currentPage = "settings";
        else if (requestUri.contains("profile")) currentPage = "profile";
        else if (requestUri.contains("/dashboard/") || requestUri.contains("dashboard.jsp")) currentPage = "dashboard";
        else currentPage = "dashboard";
    }
%>

<!-- ================= SIDEBAR ================= -->
<div id="sidebar" class="sidebar fixed top-0 left-0 h-screen bg-white dark:bg-gray-900 shadow-2xl border-r border-gray-200 dark:border-gray-800 z-50 flex flex-col transition-all duration-300 ease-out"
     data-sidebar-state="expanded">
    
    <!-- Sidebar Header (no toggle here) -->
    <div class="h-16 flex items-center px-4 border-b border-gray-100 dark:border-gray-800 bg-gradient-to-r from-amber-50 to-emerald-50 dark:from-gray-800 dark:to-gray-900">
        <div class="flex items-center space-x-3 overflow-hidden w-full">
            <div class="w-10 h-10 bg-gradient-to-r from-amber-500 to-amber-600 rounded-xl flex items-center justify-center shadow-lg flex-shrink-0">
                <i class="fas fa-drumstick-bite text-white text-xl"></i>
            </div>
            <div class="logo-text transition-all duration-300">
                <span class="font-bold text-lg bg-gradient-to-r from-amber-600 to-amber-500 bg-clip-text text-transparent whitespace-nowrap">PoultryPro</span>
                <span class="text-xs text-gray-500 dark:text-gray-400 block -mt-1 whitespace-nowrap">Smart Farming</span>
            </div>
        </div>
    </div>
    
    <!-- User Profile Section (initials instead of icon) -->
    <div class="p-4 border-b border-gray-100 dark:border-gray-800 transition-all duration-300">
        <div class="flex items-center space-x-3">
            <div class="w-12 h-12 bg-gradient-to-r from-amber-500 to-amber-600 rounded-full flex items-center justify-center shadow-md flex-shrink-0">
                <span class="text-white font-bold text-lg"><%= initials %></span>
            </div>
            <div class="user-info transition-all duration-300 overflow-hidden">
                <p class="font-semibold text-gray-800 dark:text-white text-sm whitespace-nowrap"><%= userName %></p>
                <p class="text-xs text-gray-500 dark:text-gray-400 capitalize whitespace-nowrap"><%= userRole %></p>
            </div>
        </div>
    </div>
    
    <!-- Navigation Menu -->
    <div class="flex-1 overflow-y-auto py-4 sidebar-scroll">
        <ul class="space-y-1 px-3">
            <li>
                <a href="${pageContext.request.contextPath}/web/containers/farmer/dashboard/dashboard.jsp"
                   class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "dashboard".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-tachometer-alt text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Dashboard</span>
                    <span class="sidebar-tooltip">Dashboard</span>
                </a>
            </li>
            <% if (!"staff".equalsIgnoreCase(userRole)) { %>
            <li>
                <a href="${pageContext.request.contextPath}/web/containers/farmer/farm/farms.jsp"
                   class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "farm".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-tractor text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Farm Management</span>
                    <span class="sidebar-tooltip">Farm Management</span>
                </a>
            </li>
            <% } %>
            <li>
                <a href="${pageContext.request.contextPath}/web/containers/farmer/chicken-group/chicken-group.jsp"
                   class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "flock".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-egg text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Flock Management</span>
                    <span class="sidebar-tooltip">chickenGroup Management</span>
                </a>
            </li>
            <% if ("farm_owner".equals(userRole) || "admin".equals(userRole)) { %>
            <li>
                <a href="${pageContext.request.contextPath}/web/containers/farmer/staff/staff.jsp"
                   class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "staff".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-users text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Staff Management</span>
                    <span class="sidebar-tooltip">Staff Management</span>
                </a>
            </li>
            <% } %>
            <li>
                <a href="${pageContext.request.contextPath}/web/containers/farmer/production/production.jsp"
                   class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "production".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-chart-line text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Production Management</span>
                    <span class="sidebar-tooltip">Production Management</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/web/containers/farmer/feed/feed.jsp"
                   class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "feed".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-leaf text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Feed Management</span>
                    <span class="sidebar-tooltip">Feed Management</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/web/containers/farmer/vaccination/vaccination.jsp"
                   class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "medical".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-heartbeat text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Health Records</span>
                    <span class="sidebar-tooltip">Health Records</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/?page=marketplace"
                   class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "marketplace".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-store text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Marketplace</span>
                    <span class="sidebar-tooltip">Marketplace</span>
                </a>
            </li>
            <!-- Other menu items omitted for brevity, but you can add the same pattern -->
        </ul>
    </div>
    
    <!-- Bottom Section -->
    <div class="border-t border-gray-100 dark:border-gray-800 p-4">
        <ul class="space-y-1">
            <li>
                <a href="${pageContext.request.contextPath}/?page=settings"
                   class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "settings".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-cog text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Settings</span>
                    <span class="sidebar-tooltip">Settings</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/LogoutServlet"
                   class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 transition-all duration-200 group relative">
                    <i class="fas fa-sign-out-alt text-red-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Logout</span>
                    <span class="sidebar-tooltip">Logout</span>
                </a>
            </li>
        </ul>
        
        <div class="mt-4 pt-4 text-center transition-all duration-300">
            <p class="text-xs text-gray-400 dark:text-gray-500 version-text whitespace-nowrap">PoultryPro v2.0</p>
            <p class="text-xs text-gray-400 dark:text-gray-500 mt-1 copyright-text whitespace-nowrap">© 2026 All rights reserved</p>
        </div>
    </div>
</div>

<!-- Mobile overlay -->
<div id="sidebarOverlay" class="fixed inset-0 bg-black/50 hidden z-40 transition-all duration-300" onclick="closeMobileSidebar()"></div>

<!-- ================= TOP NAVBAR ================= -->
<div id="topNavbar" class="fixed top-0 right-0 h-16 bg-white dark:bg-gray-900 shadow-lg border-b border-gray-200 dark:border-gray-800 z-40 transition-all duration-300"
     style="left: 280px;">
    <div class="h-full px-4 flex items-center justify-between">
        
        <!-- Left Section -->
        <div class="flex items-center space-x-3">
            <!-- Toggle Sidebar Button (moved here) -->
            <button id="sidebarToggleBtn" 
                    class="p-2 rounded-lg text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-amber-500"
                    aria-label="Toggle sidebar">
                <i id="sidebarToggleIcon" class="fas fa-bars text-lg"></i>
            </button>

            <!-- Page Title -->
            <h1 class="text-xl font-bold bg-gradient-to-r from-gray-800 to-gray-600 dark:from-gray-200 dark:to-gray-400 bg-clip-text text-transparent">
                <%= currentPage.substring(0,1).toUpperCase() + currentPage.substring(1) %>
            </h1>
            
            <!-- Breadcrumb -->
            <nav class="hidden md:flex items-center space-x-2 text-sm">
                <span class="text-gray-500 dark:text-gray-400">Home</span>
                <i class="fas fa-chevron-right text-gray-400 text-xs"></i>
                <span class="text-amber-600 dark:text-amber-400 font-medium">
                    <%= currentPage.substring(0,1).toUpperCase() + currentPage.substring(1) %>
                </span>
            </nav>
        </div>
        
        <!-- Right Section -->
        <div class="flex items-center space-x-2 md:space-x-3">
            <!-- Desktop Search -->
            <div class="hidden md:flex items-center bg-gray-100 dark:bg-gray-800 rounded-lg px-3 py-2">
                <i class="fas fa-search text-gray-400 text-sm"></i>
                <input type="text" placeholder="Search..." class="bg-transparent border-none focus:outline-none text-sm text-gray-700 dark:text-gray-300 ml-2 w-48" id="globalSearch">
            </div>
            
            <!-- Dark Mode Toggle -->
            <button id="darkModeToggle" class="p-2 rounded-lg text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 transition-all duration-200">
                <i id="darkModeIcon" class="fas fa-moon text-lg"></i>
            </button>
            
            <!-- Notifications -->
            <div class="relative">
                <button id="notificationBtn" class="relative p-2 rounded-lg text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800">
                    <i class="fas fa-bell text-lg"></i>
                    <span id="notificationBadge" class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full animate-pulse"></span>
                </button>
                <div id="notificationDropdown" class="absolute right-0 mt-2 w-80 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 hidden z-50">
                    <div class="p-3 border-b border-gray-200 dark:border-gray-700">
                        <h3 class="font-semibold text-gray-800 dark:text-white">Notifications</h3>
                    </div>
                    <div class="max-h-96 overflow-y-auto">
                        <div class="p-3 hover:bg-gray-50 dark:hover:bg-gray-700">
                            <p class="text-sm text-gray-800 dark:text-gray-200">New order received #12345</p>
                            <p class="text-xs text-gray-500 mt-1">2 minutes ago</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- User Menu (initials) -->
            <div class="relative">
                <button id="userMenuBtn" class="flex items-center space-x-2 p-1 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800">
                    <div class="w-8 h-8 bg-gradient-to-r from-amber-500 to-amber-600 rounded-full flex items-center justify-center shadow-md">
                        <span class="text-white font-bold text-sm"><%= initials %></span>
                    </div>
                    <span class="hidden md:block text-sm font-medium text-gray-700 dark:text-gray-300"><%= userName %></span>
                    <i class="hidden md:block fas fa-chevron-down text-gray-400 text-xs"></i>
                </button>
                <div id="userDropdown" class="absolute right-0 mt-2 w-64 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 hidden z-50">
                    <div class="p-4 border-b border-gray-200 dark:border-gray-700">
                        <div class="flex items-center space-x-3">
                            <div class="w-10 h-10 bg-gradient-to-r from-amber-500 to-amber-600 rounded-full flex items-center justify-center">
                                <span class="text-white font-bold"><%= initials %></span>
                            </div>
                            <div>
                                <p class="font-semibold text-gray-800 dark:text-white"><%= userName %></p>
                                <p class="text-xs text-gray-500 dark:text-gray-400 capitalize"><%= userRole %></p>
                            </div>
                        </div>
                    </div>
                    <div class="py-2">
                        <a href="${pageContext.request.contextPath}/?page=profile" class="flex items-center px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                            <i class="fas fa-user-circle w-5 text-amber-500"></i> <span class="ml-3">My Profile</span>
                        </a>
                        <div class="border-t border-gray-200 dark:border-gray-700 my-1"></div>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" class="flex items-center px-4 py-2 text-sm text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20">
                            <i class="fas fa-sign-out-alt w-5"></i> <span class="ml-3">Logout</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Mobile Search Bar -->
<div id="mobileSearchBar" class="fixed top-16 left-0 right-0 bg-white dark:bg-gray-900 shadow-md p-3 z-30 hidden md:hidden">
    <div class="flex items-center bg-gray-100 dark:bg-gray-800 rounded-lg px-3 py-2">
        <i class="fas fa-search text-gray-400"></i>
        <input type="text" placeholder="Search..." class="bg-transparent border-none focus:outline-none text-sm text-gray-700 dark:text-gray-300 ml-2 flex-1" id="mobileSearch">
    </div>
</div>

<!-- ================= STYLES ================= -->
<style>
    .sidebar { width: 280px; transition: width 0.3s, transform 0.3s; }
    .sidebar.collapsed { width: 80px; }
    @media (max-width: 1023px) {
        .sidebar { transform: translateX(-100%); width: 280px; }
        .sidebar.mobile-open { transform: translateX(0); }
    }
    .sidebar-link { position: relative; overflow: hidden; }
    .sidebar-link::before {
        content: ''; position: absolute; left: 0; top: 0;
        width: 3px; height: 100%;
        background: linear-gradient(135deg, #f59e0b, #d97706);
        transform: translateX(-100%); transition: transform 0.3s;
    }
    .sidebar-link.active::before, .sidebar-link:hover::before { transform: translateX(0); }
    .sidebar-link.active {
        background: linear-gradient(135deg, #fef3c7, #fed7aa);
        color: #d97706;
    }
    .dark .sidebar-link.active {
        background: linear-gradient(135deg, #1f2937, #374151);
        color: #f59e0b;
    }
    .sidebar-tooltip {
        position: absolute; left: 70px; top: 50%; transform: translateY(-50%);
        background: #1f2937; color: white; padding: 6px 12px; border-radius: 8px;
        font-size: 12px; white-space: nowrap; z-index: 100;
        opacity: 0; visibility: hidden; pointer-events: none;
        transition: all 0.2s;
    }
    .sidebar-tooltip::before {
        content: ''; position: absolute; left: -6px; top: 50%; transform: translateY(-50%);
        border: 6px solid; border-color: transparent #1f2937 transparent transparent;
    }
    .sidebar.collapsed .sidebar-link:hover .sidebar-tooltip { opacity: 1; visibility: visible; }
    .sidebar.collapsed .menu-text, .sidebar.collapsed .user-info,
    .sidebar.collapsed .logo-text .text-xs, .sidebar.collapsed .version-text,
    .sidebar.collapsed .copyright-text { display: none; }
    .sidebar.collapsed .sidebar-link { justify-content: center; padding: 12px 0; }
    .sidebar.collapsed .sidebar-link i { margin: 0; }
    #topNavbar { transition: left 0.3s; }
    @media (max-width: 1023px) { #topNavbar { left: 0 !important; } }
</style>

<!-- ================= SCRIPTS ================= -->
<script>
    // Sidebar Manager
    class SidebarManager {
        constructor() {
            this.sidebar = document.getElementById('sidebar');
            this.toggleBtn = document.getElementById('sidebarToggleBtn');
            this.toggleIcon = document.getElementById('sidebarToggleIcon');
            this.isCollapsed = false;
            this.isMobileOpen = false;
            this.isDesktop = window.innerWidth >= 1024;
            this.init();
        }
        init() {
            if (this.isDesktop) {
                if (localStorage.getItem('sidebarCollapsed') === 'true') this.collapse();
                else this.expand();
            } else {
                this.sidebar.classList.remove('mobile-open');
            }
            this.updateIcon();
            this.bindEvents();
            this.setupResizeHandler();
            this.dispatchState();
        }
        bindEvents() { this.toggleBtn.addEventListener('click', () => this.toggle()); }
        toggle() {
            if (this.isDesktop) {
                if (this.isCollapsed) this.expand(); else this.collapse();
            } else {
                if (this.isMobileOpen) this.closeMobile(); else this.openMobile();
            }
        }
        collapse() {
            this.sidebar.classList.add('collapsed');
            this.isCollapsed = true;
            localStorage.setItem('sidebarCollapsed', 'true');
            this.updateIcon();
            this.dispatchState();
        }
        expand() {
            this.sidebar.classList.remove('collapsed');
            this.isCollapsed = false;
            localStorage.setItem('sidebarCollapsed', 'false');
            this.updateIcon();
            this.dispatchState();
        }
        openMobile() {
            this.sidebar.classList.add('mobile-open');
            this.isMobileOpen = true;
            document.getElementById('sidebarOverlay').classList.remove('hidden');
            document.body.style.overflow = 'hidden';
        }
        closeMobile() {
            this.sidebar.classList.remove('mobile-open');
            this.isMobileOpen = false;
            document.getElementById('sidebarOverlay').classList.add('hidden');
            document.body.style.overflow = '';
        }
        updateIcon() {
            if (this.toggleIcon) {
                if (this.isDesktop) {
                    this.toggleIcon.className = this.isCollapsed ? 'fas fa-chevron-right text-lg' : 'fas fa-chevron-left text-lg';
                } else {
                    this.toggleIcon.className = 'fas fa-bars text-lg';
                }
            }
        }
        dispatchState() {
            const mainContent = document.getElementById('mainContent');
            if (mainContent) {
                mainContent.style.marginLeft = !this.isDesktop ? '0' : (this.isCollapsed ? '80px' : '280px');
            }
            window.dispatchEvent(new CustomEvent('sidebarStateChanged', {
                detail: { isCollapsed: this.isCollapsed, isDesktop: this.isDesktop, width: this.isCollapsed ? 80 : 280 }
            }));
        }
        setupResizeHandler() {
            window.addEventListener('resize', () => {
                const wasDesktop = this.isDesktop;
                this.isDesktop = window.innerWidth >= 1024;
                if (this.isDesktop && !wasDesktop) {
                    this.sidebar.classList.remove('mobile-open');
                    this.isMobileOpen = false;
                    document.getElementById('sidebarOverlay').classList.add('hidden');
                    document.body.style.overflow = '';
                    this.init();
                } else if (!this.isDesktop && wasDesktop) {
                    this.sidebar.classList.remove('collapsed');
                    this.isCollapsed = false;
                }
                this.updateIcon();
                this.dispatchState();
            });
        }
    }

    // Navbar Manager
    class NavbarManager {
        constructor() {
            this.navbar = document.getElementById('topNavbar');
            this.darkModeToggle = document.getElementById('darkModeToggle');
            this.darkModeIcon = document.getElementById('darkModeIcon');
            this.notificationBtn = document.getElementById('notificationBtn');
            this.notificationDropdown = document.getElementById('notificationDropdown');
            this.userMenuBtn = document.getElementById('userMenuBtn');
            this.userDropdown = document.getElementById('userDropdown');
            this.init();
        }
        init() {
            this.listenToSidebar();
            this.loadTheme();
            this.bindEvents();
            this.updateNavbarPosition();
        }
        bindEvents() {
            this.darkModeToggle?.addEventListener('click', () => this.toggleDarkMode());
            this.notificationBtn?.addEventListener('click', (e) => {
                e.stopPropagation();
                this.userDropdown?.classList.add('hidden');
                this.notificationDropdown?.classList.toggle('hidden');
            });
            this.userMenuBtn?.addEventListener('click', (e) => {
                e.stopPropagation();
                this.notificationDropdown?.classList.add('hidden');
                this.userDropdown?.classList.toggle('hidden');
            });
            document.addEventListener('click', (event) => {
                if (!this.notificationBtn?.contains(event.target) && !this.notificationDropdown?.contains(event.target))
                    this.notificationDropdown?.classList.add('hidden');
                if (!this.userMenuBtn?.contains(event.target) && !this.userDropdown?.contains(event.target))
                    this.userDropdown?.classList.add('hidden');
            });
        }
        toggleDarkMode() {
            const isDark = document.documentElement.classList.toggle('dark');
            if (this.darkModeIcon) {
                this.darkModeIcon.className = isDark ? 'fas fa-sun text-lg' : 'fas fa-moon text-lg';
            }
            localStorage.setItem('theme', isDark ? 'dark' : 'light');
        }
        loadTheme() {
            if (localStorage.getItem('theme') === 'dark') {
                document.documentElement.classList.add('dark');
                if (this.darkModeIcon) this.darkModeIcon.className = 'fas fa-sun text-lg';
            }
        }
        listenToSidebar() {
            window.addEventListener('sidebarStateChanged', () => this.updateNavbarPosition());
            window.addEventListener('resize', () => this.updateNavbarPosition());
        }
        updateNavbarPosition() {
            if (!this.navbar) return;
            if (window.innerWidth < 1024) {
                this.navbar.style.left = '0';
            } else {
                const width = window.sidebarManager?.isCollapsed ? 80 : 280;
                this.navbar.style.left = width + 'px';
            }
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        window.sidebarManager = new SidebarManager();
        window.navbarManager = new NavbarManager();
        updateActiveNavItem();
    });

    // Update active nav item based on current page
    function updateActiveNavItem() {
        const currentUrl = window.location.pathname;
        const currentPage = new URLSearchParams(window.location.search).get('page') || extractPageFromUrl(currentUrl);
        
        // Remove active class from all sidebar links
        document.querySelectorAll('.sidebar-link').forEach(link => {
            link.classList.remove('active');
        });
        
        // Add active class to matching link
        document.querySelectorAll('.sidebar-link').forEach(link => {
            const href = link.getAttribute('href');
            if (href && (
                (currentPage === 'dashboard' && href.includes('dashboard')) ||
                (currentPage === 'farm' && href.includes('/farm/')) ||
                (currentPage === 'flock' && href.includes('/chicken-group/')) ||
                (currentPage === 'staff' && href.includes('/staff/')) ||
                (currentPage === 'production' && href.includes('/production/')) ||
                (currentPage === 'feed' && href.includes('/feed/')) ||
                (currentPage === 'medical' && href.includes('/vaccination/')) ||
                (currentPage === 'marketplace' && href.includes('marketplace')) ||
                (currentPage === 'settings' && href.includes('settings')) ||
                (currentPage === 'profile' && href.includes('profile'))
            )) {
                link.classList.add('active');
            }
        });
    }

    // Extract page name from URL
    function extractPageFromUrl(url) {
        if (url.includes('/farm/')) return 'farm';
        if (url.includes('/chicken-group/')) return 'flock';
        if (url.includes('/staff/')) return 'staff';
        if (url.includes('/production/')) return 'production';
        if (url.includes('/feed/')) return 'feed';
        if (url.includes('/vaccination/')) return 'medical';
        if (url.includes('marketplace')) return 'marketplace';
        if (url.includes('settings')) return 'settings';
        if (url.includes('profile')) return 'profile';
        if (url.includes('dashboard')) return 'dashboard';
        return 'dashboard';
    }

    // Listen for navigation changes
    window.addEventListener('popstate', updateActiveNavItem);
    
    function closeMobileSidebar() {
        window.sidebarManager?.closeMobile();
    }
</script>