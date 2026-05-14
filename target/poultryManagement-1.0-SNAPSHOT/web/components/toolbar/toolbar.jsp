<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    String currentPage = request.getParameter("page");
    if (username == null) username = "Farmer";
    if (currentPage == null) currentPage = "dashboard";
%>

<div id="topNavbar" class="fixed top-0 right-0 h-16 bg-white dark:bg-gray-900 shadow-lg border-b border-gray-200 dark:border-gray-800 z-40 transition-all duration-300"
     style="left: 280px;">
    <div class="h-full px-4 flex items-center justify-between">
        
        <!-- Left Section -->
        <div class="flex items-center space-x-4">
            <!-- Mobile Menu Button -->
            <button id="mobileMenuBtn" 
                    class="lg:hidden p-2 rounded-lg text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-amber-500"
                    aria-label="Open menu">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                </svg>
            </button>
            
            <!-- Page Title with Icon -->
            <div class="flex items-center space-x-3">
                <div class="w-8 h-8 bg-gradient-to-r from-amber-500 to-amber-600 rounded-lg flex items-center justify-center shadow-md">
                    <i class="fas fa-chart-line text-white text-sm"></i>
                </div>
                <h1 class="text-xl font-bold bg-gradient-to-r from-gray-800 to-gray-600 dark:from-gray-200 dark:to-gray-400 bg-clip-text text-transparent">
                    <%= currentPage.substring(0,1).toUpperCase() + currentPage.substring(1) %>
                </h1>
            </div>
            
            <!-- Breadcrumb (Desktop) -->
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
            
            <!-- Search Bar (Desktop) -->
            <div class="hidden md:flex items-center bg-gray-100 dark:bg-gray-800 rounded-lg px-3 py-2 transition-all duration-300">
                <i class="fas fa-search text-gray-400 text-sm"></i>
                <input type="text" 
                       placeholder="Search..." 
                       class="bg-transparent border-none focus:outline-none text-sm text-gray-700 dark:text-gray-300 ml-2 w-48"
                       id="globalSearch">
            </div>
            
            <!-- Dark Mode Toggle -->
            <button id="darkModeToggle" 
                    class="relative p-2 rounded-lg text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 transition-all duration-200 group"
                    aria-label="Toggle dark mode">
                <i id="darkModeIcon" class="fas fa-moon text-lg"></i>
                <span class="absolute -top-8 left-1/2 transform -translate-x-1/2 bg-gray-800 text-white text-xs px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity whitespace-nowrap pointer-events-none">
                    Toggle theme
                </span>
            </button>
            
            <!-- Notifications -->
            <div class="relative">
                <button id="notificationBtn" 
                        class="relative p-2 rounded-lg text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 transition-all duration-200 group"
                        aria-label="Notifications">
                    <i class="fas fa-bell text-lg"></i>
                    <span id="notificationBadge" class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full animate-pulse"></span>
                </button>
                
                <div id="notificationDropdown" 
                     class="absolute right-0 mt-2 w-80 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 hidden z-50 overflow-hidden">
                    <div class="p-3 border-b border-gray-200 dark:border-gray-700">
                        <h3 class="font-semibold text-gray-800 dark:text-white">Notifications</h3>
                    </div>
                    <div class="max-h-96 overflow-y-auto">
                        <div class="p-3 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors cursor-pointer">
                            <p class="text-sm text-gray-800 dark:text-gray-200">New order received #12345</p>
                            <p class="text-xs text-gray-500 mt-1">2 minutes ago</p>
                        </div>
                        <div class="p-3 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors cursor-pointer">
                            <p class="text-sm text-gray-800 dark:text-gray-200">Flock health alert: Temperature dropped</p>
                            <p class="text-xs text-gray-500 mt-1">1 hour ago</p>
                        </div>
                    </div>
                    <div class="p-2 border-t border-gray-200 dark:border-gray-700 text-center">
                        <a href="?page=notifications" class="text-xs text-amber-600 hover:text-amber-700">View all</a>
                    </div>
                </div>
            </div>
            
            <!-- User Menu -->
            <div class="relative">
                <button id="userMenuBtn" 
                        class="flex items-center space-x-2 p-1 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-all duration-200 group"
                        aria-label="User menu">
                    <div class="w-8 h-8 bg-gradient-to-r from-amber-500 to-amber-600 rounded-full flex items-center justify-center shadow-md">
                        <i class="fas fa-user text-white text-sm"></i>
                    </div>
                    <span class="hidden md:block text-sm font-medium text-gray-700 dark:text-gray-300"><%= username %></span>
                    <i class="hidden md:block fas fa-chevron-down text-gray-400 text-xs"></i>
                </button>
                
                <div id="userDropdown" 
                     class="absolute right-0 mt-2 w-64 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 hidden z-50">
                    <div class="p-4 border-b border-gray-200 dark:border-gray-700">
                        <div class="flex items-center space-x-3">
                            <div class="w-10 h-10 bg-gradient-to-r from-amber-500 to-amber-600 rounded-full flex items-center justify-center">
                                <i class="fas fa-user text-white"></i>
                            </div>
                            <div>
                                <p class="font-semibold text-gray-800 dark:text-white"><%= username %></p>
                                <p class="text-xs text-gray-500 dark:text-gray-400 capitalize"><%= role != null ? role : "Guest" %></p>
                            </div>
                        </div>
                    </div>
                    <div class="py-2">
                        <a href="?page=profile" class="flex items-center px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                            <i class="fas fa-user-circle w-5 text-amber-500"></i>
                            <span class="ml-3">My Profile</span>
                        </a>
                        <a href="?page=settings" class="flex items-center px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                            <i class="fas fa-cog w-5 text-amber-500"></i>
                            <span class="ml-3">Settings</span>
                        </a>
                        <div class="border-t border-gray-200 dark:border-gray-700 my-1"></div>
                        <a href="logout.jsp" class="flex items-center px-4 py-2 text-sm text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20">
                            <i class="fas fa-sign-out-alt w-5"></i>
                            <span class="ml-3">Logout</span>
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
        <input type="text" 
               placeholder="Search..." 
               class="bg-transparent border-none focus:outline-none text-sm text-gray-700 dark:text-gray-300 ml-2 flex-1"
               id="mobileSearch">
    </div>
</div>

<style>
    /* Navbar transitions */
    #topNavbar {
        transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    
    /* Mobile navbar */
    @media (max-width: 1023px) {
        #topNavbar {
            left: 0 !important;
        }
    }
    
    /* Dropdown animations */
    @keyframes dropdownSlide {
        from {
            opacity: 0;
            transform: scale(0.95) translateY(-10px);
        }
        to {
            opacity: 1;
            transform: scale(1) translateY(0);
        }
    }
    
    #notificationDropdown:not(.hidden),
    #userDropdown:not(.hidden) {
        animation: dropdownSlide 0.2s ease-out;
    }
</style>

<script>
    // Navbar Manager
    class NavbarManager {
        constructor() {
            this.navbar = document.getElementById('topNavbar');
            this.mobileMenuBtn = document.getElementById('mobileMenuBtn');
            this.darkModeToggle = document.getElementById('darkModeToggle');
            this.notificationBtn = document.getElementById('notificationBtn');
            this.userMenuBtn = document.getElementById('userMenuBtn');
            this.notificationDropdown = document.getElementById('notificationDropdown');
            this.userDropdown = document.getElementById('userDropdown');
            this.darkModeIcon = document.getElementById('darkModeIcon');
            this.notificationBadge = document.getElementById('notificationBadge');
            this.searchInput = document.getElementById('globalSearch');
            this.mobileSearch = document.getElementById('mobileSearch');
            this.mobileSearchBar = document.getElementById('mobileSearchBar');
            
            this.init();
        }
        
        init() {
            this.bindEvents();
            this.loadTheme();
            this.setupSearch();
            this.setupKeyboardShortcuts();
            this.listenToSidebar();
            this.updateNavbarPosition();
            
            setTimeout(() => this.updateNavbarPosition(), 100);
        }
        
        bindEvents() {
            // Mobile menu button
            if (this.mobileMenuBtn) {
                this.mobileMenuBtn.addEventListener('click', () => {
                    if (window.sidebarManager) {
                        window.sidebarManager.openMobile();
                    }
                });
            }
            
            // Dark mode toggle
            if (this.darkModeToggle) {
                this.darkModeToggle.addEventListener('click', () => this.toggleDarkMode());
            }
            
            // Notifications
            if (this.notificationBtn) {
                this.notificationBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    this.toggleNotifications();
                });
            }
            
            // User menu
            if (this.userMenuBtn) {
                this.userMenuBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    this.toggleUserMenu();
                });
            }
            
            // Close dropdowns on outside click
            document.addEventListener('click', (event) => {
                if (this.notificationDropdown && !this.notificationDropdown.contains(event.target) && 
                    !this.notificationBtn?.contains(event.target)) {
                    this.notificationDropdown.classList.add('hidden');
                }
                
                if (this.userDropdown && !this.userDropdown.contains(event.target) && 
                    !this.userMenuBtn?.contains(event.target)) {
                    this.userDropdown.classList.add('hidden');
                }
            });
        }
        
        listenToSidebar() {
            window.addEventListener('sidebarStateChanged', () => {
                this.updateNavbarPosition();
            });
            
            window.addEventListener('resize', () => {
                this.updateNavbarPosition();
            });
        }
        
        updateNavbarPosition() {
            if (!this.navbar) return;
            
            // On mobile, navbar takes full width
            if (window.innerWidth < 1024) {
                this.navbar.style.left = '0';
                return;
            }
            
            // On desktop, adjust based on sidebar state
            if (window.sidebarManager) {
                const width = window.sidebarManager.isCollapsed ? 80 : 280;
                this.navbar.style.left = width + 'px';
            } else {
                const savedCollapsed = localStorage.getItem('sidebarCollapsed');
                const left = savedCollapsed === 'true' ? '80px' : '280px';
                this.navbar.style.left = left;
            }
        }
        
        toggleDarkMode() {
            const isDark = document.documentElement.classList.toggle('dark');
            
            if (this.darkModeIcon) {
                if (isDark) {
                    this.darkModeIcon.classList.remove('fa-moon');
                    this.darkModeIcon.classList.add('fa-sun');
                } else {
                    this.darkModeIcon.classList.remove('fa-sun');
                    this.darkModeIcon.classList.add('fa-moon');
                }
            }
            
            localStorage.setItem('theme', isDark ? 'dark' : 'light');
        }
        
        loadTheme() {
            if (localStorage.getItem('theme') === 'dark') {
                document.documentElement.classList.add('dark');
                if (this.darkModeIcon) {
                    this.darkModeIcon.classList.remove('fa-moon');
                    this.darkModeIcon.classList.add('fa-sun');
                }
            }
        }
        
        toggleNotifications() {
            if (this.userDropdown) this.userDropdown.classList.add('hidden');
            if (this.notificationDropdown) {
                this.notificationDropdown.classList.toggle('hidden');
            }
            if (this.notificationBadge && !this.notificationDropdown?.classList.contains('hidden')) {
                this.notificationBadge.style.display = 'none';
            }
        }
        
        toggleUserMenu() {
            if (this.notificationDropdown) this.notificationDropdown.classList.add('hidden');
            if (this.userDropdown) {
                this.userDropdown.classList.toggle('hidden');
            }
        }
        
        setupSearch() {
            const handleSearch = (e) => {
                const searchTerm = e.target.value.toLowerCase();
                window.dispatchEvent(new CustomEvent('globalSearch', { detail: { term: searchTerm } }));
            };
            
            if (this.searchInput) this.searchInput.addEventListener('input', handleSearch);
            if (this.mobileSearch) this.mobileSearch.addEventListener('input', handleSearch);
        }
        
        setupKeyboardShortcuts() {
            document.addEventListener('keydown', (e) => {
                if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                    e.preventDefault();
                    if (this.searchInput && window.innerWidth >= 768) {
                        this.searchInput.focus();
                    } else if (this.mobileSearchBar) {
                        this.mobileSearchBar.classList.remove('hidden');
                        this.mobileSearch?.focus();
                    }
                }
                
                if ((e.ctrlKey || e.metaKey) && e.key === 'd') {
                    e.preventDefault();
                    this.toggleDarkMode();
                }
            });
        }
    }
    
    // Initialize navbar
    let navbarManager;
    document.addEventListener('DOMContentLoaded', () => {
        navbarManager = new NavbarManager();
        window.navbarManager = navbarManager;
    });
    
    window.addEventListener('pageshow', () => {
        if (navbarManager) {
            setTimeout(() => navbarManager.updateNavbarPosition(), 50);
        }
    });
</script>