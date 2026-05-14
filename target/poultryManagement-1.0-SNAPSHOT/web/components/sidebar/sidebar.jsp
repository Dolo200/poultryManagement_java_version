<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    if (username == null) username = "Farmer";
    String currentPage = request.getParameter("page");
    if (currentPage == null) currentPage = "dashboard";
%>

<div id="sidebar" class="sidebar fixed top-0 left-0 h-screen bg-white dark:bg-gray-900 shadow-2xl border-r border-gray-200 dark:border-gray-800 z-50 flex flex-col transition-all duration-300 ease-out"
     data-sidebar-state="expanded">
    
    <!-- Sidebar Header -->
    <div class="h-16 flex items-center justify-between px-4 border-b border-gray-100 dark:border-gray-800 bg-gradient-to-r from-amber-50 to-emerald-50 dark:from-gray-800 dark:to-gray-900">
        <div class="flex items-center space-x-3 overflow-hidden">
            <div class="w-10 h-10 bg-gradient-to-r from-amber-500 to-amber-600 rounded-xl flex items-center justify-center shadow-lg flex-shrink-0">
                <i class="fas fa-drumstick-bite text-white text-xl"></i>
            </div>
            <div class="logo-text transition-all duration-300">
                <span class="font-bold text-lg bg-gradient-to-r from-amber-600 to-amber-500 bg-clip-text text-transparent whitespace-nowrap">PoultryPro</span>
                <span class="text-xs text-gray-500 dark:text-gray-400 block -mt-1 whitespace-nowrap">Smart Farming</span>
            </div>
        </div>
        
        <button id="sidebarToggleBtn" 
                class="toggle-btn p-2 rounded-lg bg-white dark:bg-gray-800 shadow-sm border border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-300 hover:text-amber-600 dark:hover:text-amber-400 hover:shadow-md transition-all duration-200 flex-shrink-0"
                aria-label="Toggle sidebar">
            <i id="sidebarToggleIcon" class="fas fa-arrow-left text-sm"></i>
        </button>
    </div>
    
    <!-- User Profile Section -->
    <div class="p-4 border-b border-gray-100 dark:border-gray-800 transition-all duration-300">
        <div class="flex items-center space-x-3">
            <div class="w-12 h-12 bg-gradient-to-r from-amber-500 to-amber-600 rounded-full flex items-center justify-center shadow-md flex-shrink-0">
                <i class="fas fa-user text-white text-lg"></i>
            </div>
            <div class="user-info transition-all duration-300 overflow-hidden">
                <p class="font-semibold text-gray-800 dark:text-white text-sm whitespace-nowrap"><%= username %></p>
                <p class="text-xs text-gray-500 dark:text-gray-400 capitalize whitespace-nowrap"><%= role != null ? role : "Guest" %></p>
            </div>
        </div>
    </div>
    
    <!-- Navigation Menu -->
    <div class="flex-1 overflow-y-auto py-4 sidebar-scroll">
        <ul class="space-y-1 px-3">
            <li>
                <a href="?page=dashboard" class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "dashboard".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-tachometer-alt text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Dashboard</span>
                    <span class="sidebar-tooltip">Dashboard</span>
                </a>
            </li>
            <li>
                <a href="?page=farm" class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "farm".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-tractor text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Farm Management</span>
                    <span class="sidebar-tooltip">Farm Management</span>
                </a>
            </li>
            <li>
                <a href="?page=flock" class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "flock".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-egg text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Flock Management</span>
                    <span class="sidebar-tooltip">Flock Management</span>
                </a>
            </li>
            <% if("farmowner".equals(role) || "admin".equals(role)) { %>
            <li>
                <a href="?page=staff" class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "staff".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-users text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Staff Management</span>
                    <span class="sidebar-tooltip">Staff Management</span>
                </a>
            </li>
            <% } %>
            <li>
                <a href="?page=production" class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "production".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-chart-line text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Egg Production</span>
                    <span class="sidebar-tooltip">Egg Production</span>
                </a>
            </li>
            <li>
                <a href="?page=feed" class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "feed".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-leaf text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Feed Management</span>
                    <span class="sidebar-tooltip">Feed Management</span>
                </a>
            </li>
            <li>
                <a href="?page=medical" class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "medical".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-heartbeat text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Health Records</span>
                    <span class="sidebar-tooltip">Health Records</span>
                </a>
            </li>
            <li>
                <a href="?page=marketplace" class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "marketplace".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-store text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Marketplace</span>
                    <span class="sidebar-tooltip">Marketplace</span>
                </a>
            </li>
        </ul>
    </div>
    
    <!-- Bottom Section -->
    <div class="border-t border-gray-100 dark:border-gray-800 p-4">
        <ul class="space-y-1">
            <li>
                <a href="?page=settings" class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 transition-all duration-200 group relative <%= "settings".equals(currentPage) ? "active" : "" %>">
                    <i class="fas fa-cog text-amber-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Settings</span>
                    <span class="sidebar-tooltip">Settings</span>
                </a>
            </li>
            <li>
                <a href="logout.jsp" class="sidebar-link flex items-center space-x-3 px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 transition-all duration-200 group relative">
                    <i class="fas fa-sign-out-alt text-red-500 w-5 flex-shrink-0"></i>
                    <span class="menu-text transition-all duration-300 whitespace-nowrap">Logout</span>
                    <span class="sidebar-tooltip">Logout</span>
                </a>
            </li>
        </ul>
        
        <div class="mt-4 pt-4 text-center transition-all duration-300">
            <p class="text-xs text-gray-400 dark:text-gray-500 version-text whitespace-nowrap">PoultryPro v2.0</p>
            <p class="text-xs text-gray-400 dark:text-gray-500 mt-1 copyright-text whitespace-nowrap">© 2024 All rights reserved</p>
        </div>
    </div>
</div>

<!-- Mobile overlay -->
<div id="sidebarOverlay" class="fixed inset-0 bg-black/50 hidden z-40 transition-all duration-300" onclick="closeMobileSidebar()"></div>

<style>
    /* Base Sidebar Styles */
    .sidebar {
        width: 280px;
        transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1), transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    
    /* Desktop Collapsed State */
    .sidebar.collapsed {
        width: 80px;
    }
    
    /* Mobile Styles */
    @media (max-width: 1023px) {
        .sidebar {
            transform: translateX(-100%);
            width: 280px;
        }
        
        .sidebar.mobile-open {
            transform: translateX(0);
        }
    }
    
    /* Desktop Styles */
    @media (min-width: 1024px) {
        .sidebar.collapsed {
            width: 80px;
        }
        
        .sidebar:not(.collapsed) {
            width: 280px;
        }
    }
    
    /* Scrollbar */
    .sidebar-scroll::-webkit-scrollbar {
        width: 4px;
    }
    
    .sidebar-scroll::-webkit-scrollbar-track {
        background: #f1f1f1;
    }
    
    .sidebar-scroll::-webkit-scrollbar-thumb {
        background: #f59e0b;
        border-radius: 2px;
    }
    
    .dark .sidebar-scroll::-webkit-scrollbar-track {
        background: #1f2937;
    }
    
    /* Sidebar Links */
    .sidebar-link {
        position: relative;
        overflow: hidden;
    }
    
    .sidebar-link::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        width: 3px;
        height: 100%;
        background: linear-gradient(135deg, #f59e0b, #d97706);
        transform: translateX(-100%);
        transition: transform 0.3s ease;
    }
    
    .sidebar-link.active::before,
    .sidebar-link:hover::before {
        transform: translateX(0);
    }
    
    .sidebar-link.active {
        background: linear-gradient(135deg, #fef3c7, #fed7aa);
        color: #d97706;
    }
    
    .dark .sidebar-link.active {
        background: linear-gradient(135deg, #1f2937, #374151);
        color: #f59e0b;
    }
    
    /* Tooltips */
    .sidebar-tooltip {
        position: absolute;
        left: 70px;
        top: 50%;
        transform: translateY(-50%);
        background: #1f2937;
        color: white;
        padding: 6px 12px;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 500;
        white-space: nowrap;
        z-index: 100;
        opacity: 0;
        visibility: hidden;
        pointer-events: none;
        transition: all 0.2s ease;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }
    
    .sidebar-tooltip::before {
        content: '';
        position: absolute;
        left: -6px;
        top: 50%;
        transform: translateY(-50%);
        border-width: 6px;
        border-style: solid;
        border-color: transparent #1f2937 transparent transparent;
    }
    
    .dark .sidebar-tooltip {
        background: #374151;
    }
    
    .dark .sidebar-tooltip::before {
        border-color: transparent #374151 transparent transparent;
    }
    
    .sidebar.collapsed .sidebar-link:hover .sidebar-tooltip {
        opacity: 1;
        visibility: visible;
    }
    
    /* Collapsed state text hiding */
    .sidebar.collapsed .menu-text,
    .sidebar.collapsed .user-info,
    .sidebar.collapsed .logo-text .text-xs,
    .sidebar.collapsed .version-text,
    .sidebar.collapsed .copyright-text {
        display: none;
    }
    
    .sidebar.collapsed .sidebar-link {
        justify-content: center;
        padding: 12px 0;
    }
    
    .sidebar.collapsed .sidebar-link i {
        margin: 0;
    }
    
    /* Animation */
    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateX(-20px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }
    
    #sidebar li {
        animation: slideIn 0.3s ease-out forwards;
        opacity: 0;
    }
</style>

<script>
    // Sidebar Manager - Fully Responsive
    class SidebarManager {
        constructor() {
            this.sidebar = document.getElementById('sidebar');
            this.overlay = document.getElementById('sidebarOverlay');
            this.toggleBtn = document.getElementById('sidebarToggleBtn');
            this.toggleIcon = document.getElementById('sidebarToggleIcon');
            this.isCollapsed = false;
            this.isMobileOpen = false;
            this.isDesktop = window.innerWidth >= 1024;
            
            this.init();
        }
        
        init() {
            this.loadState();
            this.bindEvents();
            this.setupResizeHandler();
            this.setupKeyboardShortcuts();
            this.updateUI();
            this.dispatchState();
            
            // Animate sidebar items
            const items = document.querySelectorAll('#sidebar li');
            items.forEach((item, index) => {
                item.style.animationDelay = `${index * 0.05}s`;
            });
        }
        
        loadState() {
            const savedState = localStorage.getItem('sidebarCollapsed');
            
            if (this.isDesktop) {
                if (savedState === 'true') {
                    this.isCollapsed = true;
                    this.sidebar.classList.add('collapsed');
                    if (this.toggleIcon) {
                        this.toggleIcon.classList.remove('fa-arrow-left');
                        this.toggleIcon.classList.add('fa-arrow-right');
                    }
                } else {
                    this.isCollapsed = false;
                    this.sidebar.classList.remove('collapsed');
                    if (this.toggleIcon) {
                        this.toggleIcon.classList.remove('fa-arrow-right');
                        this.toggleIcon.classList.add('fa-arrow-left');
                    }
                }
            } else {
                // Mobile - always start closed
                this.isMobileOpen = false;
                this.sidebar.classList.remove('mobile-open');
            }
        }
        
        bindEvents() {
            if (this.toggleBtn) {
                this.toggleBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    this.toggle();
                });
            }
        }
        
        toggle() {
            if (this.isDesktop) {
                if (this.isCollapsed) {
                    this.expand();
                } else {
                    this.collapse();
                }
            } else {
                if (this.isMobileOpen) {
                    this.closeMobile();
                } else {
                    this.openMobile();
                }
            }
        }
        
        collapse() {
            this.sidebar.classList.add('collapsed');
            this.isCollapsed = true;
            localStorage.setItem('sidebarCollapsed', 'true');
            
            if (this.toggleIcon) {
                this.toggleIcon.classList.remove('fa-arrow-left');
                this.toggleIcon.classList.add('fa-arrow-right');
            }
            
            this.updateUI();
            this.dispatchState();
        }
        
        expand() {
            this.sidebar.classList.remove('collapsed');
            this.isCollapsed = false;
            localStorage.setItem('sidebarCollapsed', 'false');
            
            if (this.toggleIcon) {
                this.toggleIcon.classList.remove('fa-arrow-right');
                this.toggleIcon.classList.add('fa-arrow-left');
            }
            
            this.updateUI();
            this.dispatchState();
        }
        
        openMobile() {
            this.sidebar.classList.add('mobile-open');
            this.isMobileOpen = true;
            
            if (this.overlay) {
                this.overlay.classList.remove('hidden');
            }
            
            document.body.style.overflow = 'hidden';
            this.dispatchState();
        }
        
        closeMobile() {
            this.sidebar.classList.remove('mobile-open');
            this.isMobileOpen = false;
            
            if (this.overlay) {
                this.overlay.classList.add('hidden');
            }
            
            document.body.style.overflow = '';
            this.dispatchState();
        }
        
        updateUI() {
            const mainContent = document.getElementById('mainContent');
            if (mainContent) {
                if (!this.isDesktop) {
                    mainContent.style.marginLeft = '0';
                } else {
                    mainContent.style.marginLeft = this.isCollapsed ? '80px' : '280px';
                }
            }
        }
        
        setupResizeHandler() {
            let resizeTimer;
            window.addEventListener('resize', () => {
                clearTimeout(resizeTimer);
                resizeTimer = setTimeout(() => {
                    const wasDesktop = this.isDesktop;
                    this.isDesktop = window.innerWidth >= 1024;
                    
                    if (this.isDesktop && !wasDesktop) {
                        // Switched from mobile to desktop
                        this.sidebar.classList.remove('mobile-open');
                        this.isMobileOpen = false;
                        if (this.overlay) this.overlay.classList.add('hidden');
                        document.body.style.overflow = '';
                        
                        // Restore desktop state
                        const savedState = localStorage.getItem('sidebarCollapsed');
                        if (savedState === 'true') {
                            this.collapse();
                        } else {
                            this.expand();
                        }
                    } else if (!this.isDesktop && wasDesktop) {
                        // Switched from desktop to mobile
                        this.isCollapsed = false;
                        this.sidebar.classList.remove('collapsed');
                        this.isMobileOpen = false;
                        this.sidebar.classList.remove('mobile-open');
                        if (this.overlay) this.overlay.classList.add('hidden');
                        this.updateUI();
                    } else if (this.isDesktop) {
                        this.updateUI();
                    }
                    
                    this.dispatchState();
                }, 150);
            });
        }
        
        setupKeyboardShortcuts() {
            document.addEventListener('keydown', (e) => {
                if ((e.ctrlKey || e.metaKey) && e.key === 'b') {
                    e.preventDefault();
                    this.toggle();
                }
            });
        }
        
        dispatchState() {
            const event = new CustomEvent('sidebarStateChanged', {
                detail: {
                    isCollapsed: this.isCollapsed,
                    isMobileOpen: this.isMobileOpen,
                    isDesktop: this.isDesktop,
                    width: this.getWidth()
                }
            });
            window.dispatchEvent(event);
        }
        
        getWidth() {
            if (!this.isDesktop) return 0;
            return this.isCollapsed ? 80 : 280;
        }
        
        getState() {
            return {
                isCollapsed: this.isCollapsed,
                isMobileOpen: this.isMobileOpen,
                isDesktop: this.isDesktop,
                width: this.getWidth()
            };
        }
    }
    
    // Initialize sidebar
    let sidebarManager;
    document.addEventListener('DOMContentLoaded', () => {
        sidebarManager = new SidebarManager();
        window.sidebarManager = sidebarManager;
    });
    
    // Close mobile sidebar function for overlay
    function closeMobileSidebar() {
        if (window.sidebarManager) {
            window.sidebarManager.closeMobile();
        }
    }
</script>