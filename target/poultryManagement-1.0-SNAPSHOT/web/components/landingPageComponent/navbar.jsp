<%-- 
    Document   : navbar
    Created on : Mar 18, 2026, 11:25:56 AM
    Author     : Administrator
--%>
<!--
<nav class="fixed w-full bg-white shadow z-50">
    <div class="container mx-auto flex justify-between items-center p-4">

        <div class="text-2xl font-bold text-amber-500">
            <i class="fas fa-drumstick-bite"></i> PoultryPro
        </div>

        <div class="hidden md:flex space-x-6">
            <a href="#features" class="hover:text-amber-500">Features</a>
            <a href="#testimonials" class="hover:text-amber-500">Testimonials</a>
            <a href="#pricing" class="hover:text-amber-500">Pricing</a>
        </div>

        <div class="space-x-3">
            <a href="login.jsp" class="bg-amber-500 text-white px-4 py-2 rounded">
                <i class="fas fa-sign-in-alt"></i> Login
            </a>
            <a href="login.jsp" class="bg-blue-600 text-white px-4 py-2 rounded">
                Get Started
            </a>
        </div>

    </div>
</nav>-->


<nav class="fixed w-full bg-white/90 backdrop-blur-md shadow-lg z-50 transition-all duration-300" id="navbar">
    <div class="container mx-auto flex justify-between items-center px-4 py-3">

        <!-- Logo with hover effect -->
        <a href="#" class="flex items-center space-x-2 group">
            <div class="text-3xl text-amber-500 group-hover:text-amber-600 transition-colors duration-300">
                <i class="fas fa-drumstick-bite"></i>
            </div>
            <div>
                <span class="text-2xl font-bold bg-gradient-to-r from-amber-500 to-amber-700 bg-clip-text text-transparent">
                    PoultryPro
                </span>
                <!--<span class="hidden sm:inline-block text-xs font-medium text-gray-500 ml-1">?</span>-->
            </div>
        </a>

        <!-- Desktop Navigation with active state -->
        <div class="hidden md:flex items-center space-x-8">
            <a href="#features" class="nav-link text-gray-700 hover:text-amber-500 font-medium transition-colors duration-200 relative group">
                Features
                <span class="absolute bottom-0 left-0 w-0 h-0.5 bg-amber-500 group-hover:w-full transition-all duration-300"></span>
            </a>
            <a href="#testimonials" class="nav-link text-gray-700 hover:text-amber-500 font-medium transition-colors duration-200 relative group">
                Testimonials
                <span class="absolute bottom-0 left-0 w-0 h-0.5 bg-amber-500 group-hover:w-full transition-all duration-300"></span>
            </a>
            <a href="#pricing" class="nav-link text-gray-700 hover:text-amber-500 font-medium transition-colors duration-200 relative group">
                Pricing
                <span class="absolute bottom-0 left-0 w-0 h-0.5 bg-amber-500 group-hover:w-full transition-all duration-300"></span>
            </a>
            
                     <a href="<%= request.getContextPath() %>/web/containers/farmer/dashboard/dashboard.jsp" class="nav-link text-gray-700 hover:text-amber-500 font-medium transition-colors duration-200 relative group">
                dashboard
                <span class="absolute bottom-0 left-0 w-0 h-0.5 bg-amber-500 group-hover:w-full transition-all duration-300"></span>
            </a>
                <!--<a href="%= request.getContextPath() %>/web/components/layout/layout.jspweb/containers/farmer/dashboard/dashboard.jsp"></a>-->
            <!-- New dropdown for more options -->
            <div class="relative group">
                <button class="flex items-center space-x-1 text-gray-700 hover:text-amber-500 font-medium transition-colors duration-200">
                    <span>Resources</span>
                    <i class="fas fa-chevron-down text-xs group-hover:rotate-180 transition-transform duration-200"></i>
                </button>
                <div class="absolute top-full right-0 mt-2 w-48 bg-white rounded-lg shadow-xl opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-300 transform group-hover:translate-y-0 translate-y-2">
                    <a href="#blog" class="block px-4 py-2 text-gray-700 hover:bg-amber-50 hover:text-amber-500 transition-colors duration-200">
                        <i class="fas fa-blog w-5 text-amber-500"></i> Blog
                    </a>
                    <a href="#guides" class="block px-4 py-2 text-gray-700 hover:bg-amber-50 hover:text-amber-500 transition-colors duration-200">
                        <i class="fas fa-book w-5 text-amber-500"></i> Guides
                    </a>
                    <a href="#support" class="block px-4 py-2 text-gray-700 hover:bg-amber-50 hover:text-amber-500 transition-colors duration-200">
                        <i class="fas fa-headset w-5 text-amber-500"></i> Support
                    </a>
                </div>
            </div>  
        </div>

        <!-- Action Buttons with improved design -->
        <div class="flex items-center space-x-3">
            <a href="<%= request.getContextPath() %>/web/containers/auth/login.jsp" class="hidden sm:inline-flex items-center space-x-2 text-gray-700 hover:text-amber-500 font-medium transition-colors duration-200 group">
                <i class="fas fa-sign-in-alt group-hover:translate-x-1 transition-transform duration-200"></i>
                <span>Login</span>
            </a>
            
            
            <!-- Mobile menu button (visible only on mobile) -->
            <button class="md:hidden text-2xl text-gray-700 hover:text-amber-500 transition-colors duration-200" id="mobile-menu-btn">
                <i class="fas fa-bars"></i>
            </button>
            
            <a href="register.jsp" class="bg-gradient-to-r from-amber-500 to-amber-600 text-white px-6 py-2.5 rounded-lg font-medium hover:from-amber-600 hover:to-amber-700 transition-all duration-300 transform hover:scale-105 hover:shadow-lg inline-flex items-center space-x-2">
                <span>Get Started</span>
                <i class="fas fa-arrow-right text-sm"></i>
            </a>
        </div>
    </div>

    <!-- Mobile Menu (hidden by default) -->
    <div class="md:hidden hidden bg-white border-t border-gray-100" id="mobile-menu">
        <div class="container mx-auto px-4 py-3 space-y-3">
            <a href="#features" class="block py-2 text-gray-700 hover:text-amber-500 font-medium transition-colors duration-200">
                <i class="fas fa-star w-6 text-amber-500"></i> Features
            </a>
            <a href="#testimonials" class="block py-2 text-gray-700 hover:text-amber-500 font-medium transition-colors duration-200">
                <i class="fas fa-comment w-6 text-amber-500"></i> Testimonials
            </a>
            <a href="#pricing" class="block py-2 text-gray-700 hover:text-amber-500 font-medium transition-colors duration-200">
                <i class="fas fa-tag w-6 text-amber-500"></i> Pricing
            </a>
            <div class="border-t border-gray-100 pt-3">
                <a href="<%= request.getContextPath() %>/web/containers/auth/login.jsp" class="block py-2 text-gray-700 hover:text-amber-500 font-medium transition-colors duration-200">
                    <i class="fas fa-sign-in-alt w-6 text-amber-500"></i> Login
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- Add this JavaScript for mobile menu toggle and scroll effects -->
<script>
    // Mobile menu toggle
    document.getElementById('mobile-menu-btn').addEventListener('click', function() {
        const mobileMenu = document.getElementById('mobile-menu');
        mobileMenu.classList.toggle('hidden');
        
        // Toggle icon between bars and times
        const icon = this.querySelector('i');
        if (mobileMenu.classList.contains('hidden')) {
            icon.classList.remove('fa-times');
            icon.classList.add('fa-bars');
        } else {
            icon.classList.remove('fa-bars');
            icon.classList.add('fa-times');
        }
    });

    // Navbar scroll effect
    window.addEventListener('scroll', function() {
        const navbar = document.getElementById('navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('shadow-xl', 'bg-white');
            navbar.classList.remove('bg-white/90', 'backdrop-blur-md');
        } else {
            navbar.classList.remove('shadow-xl', 'bg-white');
            navbar.classList.add('bg-white/90', 'backdrop-blur-md');
        }
    });

    // Active link highlighting based on scroll position
    const sections = document.querySelectorAll('section[id]');
    window.addEventListener('scroll', function() {
        let current = '';
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            const sectionHeight = section.clientHeight;
            if (scrollY >= (sectionTop - 200)) {
                current = section.getAttribute('id');
            }
        });

        document.querySelectorAll('.nav-link').forEach(link => {
            link.classList.remove('text-amber-500');
            if (link.getAttribute('href') === `#${current}`) {
                link.classList.add('text-amber-500');
            }
        });
    });
</script>

<!-- Add this CSS for smooth transitions -->
<style>
    .nav-link {
        position: relative;
    }
    
    .nav-link::after {
        content: '';
        position: absolute;
        bottom: -4px;
        left: 0;
        width: 0;
        height: 2px;
        background: linear-gradient(to right, #f59e0b, #d97706);
        transition: width 0.3s ease;
    }
    
    .nav-link:hover::after {
        width: 100%;
    }
    
    #mobile-menu {
        animation: slideDown 0.3s ease-out;
    }
    
    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
</style>