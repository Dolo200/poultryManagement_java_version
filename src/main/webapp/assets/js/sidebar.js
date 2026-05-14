/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


// sidebar.js - Vanilla JavaScript Version

class Sidebar {
  constructor(options = {}) {
    this.sidebarVisible = options.sidebarVisible || false;
    this.mobileSidebarVisible = options.mobileSidebarVisible || false;
    this.isMobile = options.isMobile || this.checkIsMobile();
    this.isTablet = options.isTablet || this.checkIsTablet();
    this.onToggleSidebar = options.onToggleSidebar || (() => {});
    
    this.sidebarElement = null;
    this.overlayElement = null;
    this.toggleButton = null;
    
    this.init();
  }
  
  checkIsMobile() {
    return window.innerWidth < 768;
  }
  
  checkIsTablet() {
    return window.innerWidth >= 768 && window.innerWidth < 1024;
  }
  
  init() {
    this.createStyles();
    this.createSidebarHTML();
    this.bindEvents();
    this.handleResize();
  }
  
  createStyles() {
    const style = document.createElement('style');
    style.textContent = `
      /* Sidebar Animations */
      @keyframes slideIn {
        from {
          transform: translateX(-100%);
        }
        to {
          transform: translateX(0);
        }
      }
      
      @keyframes slideOut {
        from {
          transform: translateX(0);
        }
        to {
          transform: translateX(-100%);
        }
      }
      
      @keyframes fadeIn {
        from {
          opacity: 0;
        }
        to {
          opacity: 1;
        }
      }
      
      @keyframes fadeOut {
        from {
          opacity: 1;
        }
        to {
          opacity: 0;
        }
      }
      
      /* Sidebar Container */
      .sidebar-container {
        position: fixed;
        top: 0;
        left: 0;
        height: 100vh;
        background: white;
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        border-right: 1px solid #e5e7eb;
        overflow: hidden;
        z-index: 50;
        transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      }
      
      .sidebar-container.dark {
        background: #111827;
        border-right-color: #374151;
      }
      
      .sidebar-container.collapsed {
        width: 80px;
      }
      
      .sidebar-container.expanded {
        width: 280px;
      }
      
      .sidebar-container.mobile {
        position: fixed;
        left: 0;
        top: 0;
        height: 100vh;
        width: 280px;
        transform: translateX(-100%);
        transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        z-index: 50;
      }
      
      .sidebar-container.mobile.open {
        transform: translateX(0);
      }
      
      /* Overlay */
      .sidebar-overlay {
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.5);
        z-index: 40;
        animation: fadeIn 0.18s ease-out;
      }
      
      .sidebar-overlay.closing {
        animation: fadeOut 0.18s ease-out;
      }
      
      /* Sidebar Header */
      .sidebar-header {
        height: 64px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 1rem;
        border-bottom: 1px solid #f3f4f6;
        background: linear-gradient(135deg, #fef3c7 0%, #d1fae5 100%);
      }
      
      .dark .sidebar-header {
        border-bottom-color: #1f2937;
        background: linear-gradient(135deg, #1f2937 0%, #111827 100%);
      }
      
      /* Logo Styles */
      .sidebar-logo {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        text-decoration: none;
        transition: all 0.2s ease;
      }
      
      .sidebar-logo:hover {
        transform: scale(1.02);
      }
      
      .logo-icon {
        width: 40px;
        height: 40px;
        background: linear-gradient(135deg, #f59e0b, #d97706);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
      }
      
      .logo-icon i {
        font-size: 1.5rem;
        color: white;
      }
      
      .logo-text {
        font-size: 1.25rem;
        font-weight: bold;
        background: linear-gradient(135deg, #f59e0b, #d97706);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
      }
      
      .logo-text span {
        font-size: 0.75rem;
        font-weight: normal;
        color: #6b7280;
        margin-left: 0.25rem;
      }
      
      .dark .logo-text span {
        color: #9ca3af;
      }
      
      /* Toggle Button */
      .sidebar-toggle {
        padding: 0.5rem;
        border-radius: 0.5rem;
        background: white;
        border: 1px solid #e5e7eb;
        color: #6b7280;
        cursor: pointer;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      
      .sidebar-toggle:hover {
        background: #fef3c7;
        color: #f59e0b;
        transform: scale(1.05);
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }
      
      .sidebar-toggle:active {
        transform: scale(0.95);
      }
      
      .dark .sidebar-toggle {
        background: #1f2937;
        border-color: #374151;
        color: #9ca3af;
      }
      
      .dark .sidebar-toggle:hover {
        background: #374151;
        color: #f59e0b;
      }
      
      /* Navigation Container */
      .sidebar-nav {
        height: calc(100vh - 64px);
        overflow-y: auto;
        padding: 1rem;
      }
      
      .sidebar-nav.collapsed {
        padding: 1rem 0.5rem;
      }
      
      /* Scrollbar Styling */
      .sidebar-nav::-webkit-scrollbar {
        width: 4px;
      }
      
      .sidebar-nav::-webkit-scrollbar-track {
        background: #f1f1f1;
      }
      
      .sidebar-nav::-webkit-scrollbar-thumb {
        background: #f59e0b;
        border-radius: 2px;
      }
      
      .dark .sidebar-nav::-webkit-scrollbar-track {
        background: #1f2937;
      }
      
      /* Responsive */
      @media (max-width: 768px) {
        .sidebar-container:not(.mobile) {
          transform: translateX(-100%);
        }
        
        .sidebar-container.mobile.open {
          transform: translateX(0);
        }
      }
    `;
    document.head.appendChild(style);
  }
  
  createSidebarHTML() {
    // Create sidebar container
    this.sidebarElement = document.createElement('div');
    this.sidebarElement.className = `sidebar-container ${this.getSidebarClass()}`;
    
    // Create header
    const header = document.createElement('div');
    header.className = 'sidebar-header';
    
    // Logo
    const logo = document.createElement('a');
    logo.href = '#';
    logo.className = 'sidebar-logo';
    logo.innerHTML = `
      <div class="logo-icon">
        <i class="fas fa-drumstick-bite"></i>
      </div>
      <div class="logo-text">
        PoultryPro<span>™</span>
      </div>
    `;
    
    // Toggle button (desktop only)
    const toggleBtn = document.createElement('button');
    toggleBtn.className = 'sidebar-toggle';
    toggleBtn.setAttribute('aria-label', this.sidebarVisible ? 'Collapse sidebar' : 'Expand sidebar');
    toggleBtn.innerHTML = this.sidebarVisible ? '<i class="fas fa-arrow-left"></i>' : '<i class="fas fa-arrow-right"></i>';
    toggleBtn.onclick = (e) => {
      e.stopPropagation();
      this.toggleSidebar();
    };
    
    header.appendChild(logo);
    header.appendChild(toggleBtn);
    this.sidebarElement.appendChild(header);
    
    // Navigation container
    const navContainer = document.createElement('div');
    navContainer.className = `sidebar-nav ${!this.sidebarVisible && !this.isMobile ? 'collapsed' : ''}`;
    navContainer.id = 'sidebar-nav-container';
    this.sidebarElement.appendChild(navContainer);
    
    document.body.appendChild(this.sidebarElement);
    this.toggleButton = toggleBtn;
  }
  
  getSidebarClass() {
    if (this.isMobile || this.isTablet) {
      return `mobile ${this.mobileSidebarVisible ? 'open' : ''}`;
    }
    return this.sidebarVisible ? 'expanded' : 'collapsed';
  }
  
  updateSidebarState() {
    if (this.isMobile || this.isTablet) {
      if (this.mobileSidebarVisible) {
        this.sidebarElement.classList.add('open');
      } else {
        this.sidebarElement.classList.remove('open');
      }
    } else {
      if (this.sidebarVisible) {
        this.sidebarElement.classList.remove('collapsed');
        this.sidebarElement.classList.add('expanded');
        const navContainer = this.sidebarElement.querySelector('.sidebar-nav');
        if (navContainer) navContainer.classList.remove('collapsed');
      } else {
        this.sidebarElement.classList.remove('expanded');
        this.sidebarElement.classList.add('collapsed');
        const navContainer = this.sidebarElement.querySelector('.sidebar-nav');
        if (navContainer) navContainer.classList.add('collapsed');
      }
    }
    
    // Update toggle button icon
    if (this.toggleButton) {
      const isExpanded = this.isMobile || this.isTablet ? this.mobileSidebarVisible : this.sidebarVisible;
      this.toggleButton.innerHTML = isExpanded ? '<i class="fas fa-arrow-left"></i>' : '<i class="fas fa-arrow-right"></i>';
      this.toggleButton.setAttribute('aria-label', isExpanded ? 'Collapse sidebar' : 'Expand sidebar');
    }
  }
  
  showOverlay() {
    if (this.overlayElement) {
      this.overlayElement.remove();
    }
    
    this.overlayElement = document.createElement('div');
    this.overlayElement.className = 'sidebar-overlay';
    this.overlayElement.onclick = () => this.toggleSidebar();
    document.body.appendChild(this.overlayElement);
  }
  
  hideOverlay() {
    if (this.overlayElement) {
      this.overlayElement.classList.add('closing');
      setTimeout(() => {
        if (this.overlayElement) {
          this.overlayElement.remove();
          this.overlayElement = null;
        }
      }, 180);
    }
  }
  
  toggleSidebar() {
    if (this.isMobile || this.isTablet) {
      this.mobileSidebarVisible = !this.mobileSidebarVisible;
      
      if (this.mobileSidebarVisible) {
        this.showOverlay();
      } else {
        this.hideOverlay();
      }
    } else {
      this.sidebarVisible = !this.sidebarVisible;
    }
    
    this.updateSidebarState();
    
    // Trigger callback
    if (this.onToggleSidebar) {
      this.onToggleSidebar(this.sidebarVisible, this.mobileSidebarVisible);
    }
    
    // Dispatch custom event
    const event = new CustomEvent('sidebarToggled', {
      detail: {
        sidebarVisible: this.sidebarVisible,
        mobileSidebarVisible: this.mobileSidebarVisible,
        isMobile: this.isMobile,
        isTablet: this.isTablet
      }
    });
    document.dispatchEvent(event);
  }
  
  setNavbarContent(content) {
    const navContainer = document.getElementById('sidebar-nav-container');
    if (navContainer) {
      if (typeof content === 'string') {
        navContainer.innerHTML = content;
      } else if (content instanceof HTMLElement) {
        navContainer.innerHTML = '';
        navContainer.appendChild(content);
      }
    }
  }
  
  loadNavbar(navbarInstance) {
    const navContainer = document.getElementById('sidebar-nav-container');
    if (navContainer && navbarInstance && typeof navbarInstance.render === 'function') {
      navbarInstance.render(navContainer, !this.sidebarVisible && !this.isMobile);
    }
  }
  
  handleResize() {
    const wasMobile = this.isMobile;
    const wasTablet = this.isTablet;
    
    this.isMobile = this.checkIsMobile();
    this.isTablet = this.checkIsTablet();
    
    // Reclassify sidebar if needed
    if (wasMobile !== this.isMobile || wasTablet !== this.isTablet) {
      this.sidebarElement.className = `sidebar-container ${this.getSidebarClass()}`;
      
      // Hide overlay on resize
      if (this.overlayElement) {
        this.hideOverlay();
        this.mobileSidebarVisible = false;
        this.updateSidebarState();
      }
    }
  }
  
  bindEvents() {
    window.addEventListener('resize', () => this.handleResize());
    
    // Close sidebar on escape key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && (this.mobileSidebarVisible || (this.isMobile && this.mobileSidebarVisible))) {
        this.toggleSidebar();
      }
    });
  }
  
  // Public methods
  open() {
    if (this.isMobile || this.isTablet) {
      if (!this.mobileSidebarVisible) {
        this.toggleSidebar();
      }
    } else {
      if (!this.sidebarVisible) {
        this.toggleSidebar();
      }
    }
  }
  
  close() {
    if (this.isMobile || this.isTablet) {
      if (this.mobileSidebarVisible) {
        this.toggleSidebar();
      }
    } else {
      if (this.sidebarVisible) {
        this.toggleSidebar();
      }
    }
  }
  
  isOpen() {
    return this.isMobile || this.isTablet ? this.mobileSidebarVisible : this.sidebarVisible;
  }
  
  destroy() {
    if (this.sidebarElement) {
      this.sidebarElement.remove();
    }
    if (this.overlayElement) {
      this.overlayElement.remove();
    }
    window.removeEventListener('resize', () => this.handleResize());
  }
}

// Initialize sidebar when DOM is loaded
let sidebarInstance = null;

document.addEventListener('DOMContentLoaded', () => {
  // Make Sidebar globally available
  window.Sidebar = Sidebar;
  
  // Example initialization
  sidebarInstance = new Sidebar({
    sidebarVisible: true,
    mobileSidebarVisible: false,
    onToggleSidebar: (visible, mobileVisible) => {
      console.log('Sidebar toggled:', { visible, mobileVisible });
    }
  });
  
  // Example navbar integration (if Navbar class exists)
  if (window.Navbar) {
    const navbar = new window.Navbar();
    sidebarInstance.loadNavbar(navbar);
  }
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
  module.exports = Sidebar;
}