<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
    <title>Login - PoultryPro | Smart Poultry Management</title>

    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        /* Floating animations for background elements */
        @keyframes float-bg {
            0%, 100% { transform: translateY(0px) translateX(0px); }
            33% { transform: translateY(-20px) translateX(10px); }
            66% { transform: translateY(10px) translateX(-10px); }
        }
        
        @keyframes float-slow {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-15px) rotate(5deg); }
        }
        
        @keyframes pulse-glow {
            0%, 100% { opacity: 0.4; transform: scale(1); }
            50% { opacity: 0.8; transform: scale(1.05); }
        }
        
        @keyframes shine {
            0% { transform: translateX(-100%) rotate(45deg); }
            100% { transform: translateX(200%) rotate(45deg); }
        }
        
        @keyframes card-appear {
            0% {
                opacity: 0;
                transform: scale(0.95) translateY(30px);
            }
            100% {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }
        
        .animate-float-bg {
            animation: float-bg 8s ease-in-out infinite;
        }
        
        .animate-float-slow {
            animation: float-slow 6s ease-in-out infinite;
        }
        
        .animate-pulse-glow {
            animation: pulse-glow 4s ease-in-out infinite;
        }
        
        .card-appear {
            animation: card-appear 0.6s ease-out;
        }
        
        /* Form focus effects */
        input:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.3);
            border-color: #f59e0b;
            transform: scale(1.01);
        }
        
        /* Smooth transition for all elements */
        * {
            transition: all 0.2s ease;
        }
        
        /* Password toggle button hover effect */
        .toggle-password:hover {
            transform: scale(1.1);
        }
        
        /* Glass morphism effect */
        .glass-card {
            background: rgba(255, 255, 255, 0.97);
            backdrop-filter: blur(10px);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        /* Button shine effect */
        .btn-shine {
            position: relative;
            overflow: hidden;
        }
        
        .btn-shine::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(115deg, rgba(255,255,255,0) 0%, rgba(255,255,255,0.3) 50%, rgba(255,255,255,0) 100%);
            transform: translateX(-100%) rotate(45deg);
            animation: shine 3s infinite;
        }
        
        /* Social button hover effect */
        .social-btn {
            transition: all 0.3s ease;
        }
        
        .social-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
    </style>
</head>

<body class="min-h-screen overflow-x-hidden relative">
    
    <!-- Stunning Background - Same as Signup Page -->
    <div class="fixed inset-0 z-0">
        <!-- Background Image - Modern Poultry Farm with Sunset -->
        <img src="https://images.pexels.com/photos/6059050/pexels-photo-6059050.jpeg?auto=compress&cs=tinysrgb&w=1600" 
             alt="Modern Poultry Farm" 
             class="w-full h-full object-cover">
        
        <!-- Dynamic Gradient Overlay -->
        <div class="absolute inset-0 bg-gradient-to-br from-amber-900/80 via-amber-800/70 to-orange-900/80"></div>
        
        <!-- Animated Pattern Overlay -->
        <div class="absolute inset-0 opacity-20">
            <svg class="w-full h-full" xmlns="http://www.w3.org/2000/svg">
                <defs>
                    <pattern id="chicken-pattern" x="0" y="0" width="60" height="60" patternUnits="userSpaceOnUse">
                        <circle cx="30" cy="30" r="8" fill="white" opacity="0.3"/>
                        <path d="M25 30 L35 30 M30 25 L30 35" stroke="white" stroke-width="1.5" opacity="0.3"/>
                    </pattern>
                </defs>
                <rect width="100%" height="100%" fill="url(#chicken-pattern)"/>
            </svg>
        </div>
        
        <!-- Floating Golden Orbs -->
        <div class="absolute top-20 left-10 w-64 h-64 bg-amber-400 rounded-full filter blur-3xl opacity-20 animate-float-bg"></div>
        <div class="absolute bottom-20 right-10 w-80 h-80 bg-orange-500 rounded-full filter blur-3xl opacity-20 animate-float-bg" style="animation-delay: 2s;"></div>
        <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-amber-300 rounded-full filter blur-3xl opacity-10 animate-pulse-glow"></div>
        
        <!-- Subtle Floating Elements -->
        <div class="absolute top-40 right-20 text-3xl text-white/10 animate-float-slow">🪶</div>
        <div class="absolute bottom-40 left-20 text-2xl text-white/10 animate-float-slow" style="animation-delay: 3s;">🪶</div>
        <div class="absolute top-60 left-1/4 text-2xl text-white/10 animate-float-slow" style="animation-delay: 1s;">🍂</div>
    </div>

    <!-- Main Container -->
    <div class="relative z-20 min-h-screen flex items-center justify-center p-4 md:p-8">
        
        <!-- Login Card -->
        <div class="glass-card rounded-3xl shadow-2xl w-full max-w-md transform transition-all duration-300 card-appear">
            
            <!-- Header with Brand - Enhanced -->
            <div class="relative overflow-hidden rounded-t-3xl">
                <div class="absolute inset-0 bg-gradient-to-r from-amber-600 via-amber-500 to-orange-500"></div>
                <div class="absolute top-0 left-0 w-full h-20 bg-white/10 skew-y-3"></div>
                <div class="relative px-6 md:px-8 pt-8 pb-6 text-center">
                    <div class="inline-flex items-center justify-center w-24 h-24 bg-white/20 backdrop-blur-sm rounded-2xl shadow-lg transform hover:scale-105 transition-all duration-300 mb-4 border border-white/30">
                        <i class="fas fa-drumstick-bite text-white text-6xl"></i>
                    </div>
                    <h2 class="text-4xl md:text-5xl font-bold text-white tracking-tight">
                        PoultryPro
                    </h2>
                    <div class="flex items-center justify-center gap-2 mt-2">
                        <div class="w-8 h-0.5 bg-white/60 rounded-full"></div>
                        <p class="text-amber-100 text-sm font-medium">Smart Poultry Management Platform</p>
                        <div class="w-8 h-0.5 bg-white/60 rounded-full"></div>
                    </div>
                </div>
            </div>

            <!-- Welcome Message -->
            <div class="px-8 text-center mt-6 mb-4">
                <h3 class="text-2xl font-bold text-gray-800">Welcome Back!</h3>
                <p class="text-gray-500 text-sm mt-1">Sign in to access your dashboard</p>
            </div>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/AuthServlet" method="post" class="px-8 pb-6 space-y-5">
                
                <input type="hidden" name="action" value="login">
                
                <!-- Email Field -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-envelope mr-2 text-amber-500"></i>
                        Email Address
                    </label>
                    <div class="relative group">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-envelope text-gray-400 group-focus-within:text-amber-500 transition-colors"></i>
                        </div>
                        <input type="email" name="email" required
                               class="block w-full pl-10 pr-3 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-amber-500 focus:border-transparent transition-all bg-white/90"
                               placeholder="farmer@example.com">
                    </div>
                </div>

                <!-- Password Field -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        <i class="fas fa-lock mr-2 text-amber-500"></i>
                        Password
                    </label>
                    <div class="relative group">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-400 group-focus-within:text-amber-500 transition-colors"></i>
                        </div>
                        <input type="password" id="password" name="password" required
                               class="block w-full pl-10 pr-10 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-amber-500 focus:border-transparent transition-all bg-white/90"
                               placeholder="••••••••">
                        <button type="button" onclick="togglePassword()" 
                                class="absolute inset-y-0 right-0 pr-3 flex items-center toggle-password">
                            <i id="toggleIcon" class="fas fa-eye text-gray-400 hover:text-amber-500 transition-colors"></i>
                        </button>
                    </div>
                </div>

                <!-- Remember Me & Forgot Password -->
                <div class="flex items-center justify-between text-sm">
                    <label class="flex items-center cursor-pointer">
                        <input type="checkbox" name="remember" class="w-4 h-4 text-amber-500 border-gray-300 rounded focus:ring-amber-500">
                        <span class="ml-2 text-gray-600">Remember me</span>
                    </label>
                    <a href="forgot-password.jsp" class="text-amber-600 hover:text-amber-700 hover:underline transition-colors">
                        Forgot password?
                    </a>
                </div>

                <!-- Submit Button with Shine Effect -->
                <button type="submit"
                        class="btn-shine w-full bg-gradient-to-r from-amber-500 to-amber-600 text-white py-3 rounded-xl font-semibold hover:from-amber-600 hover:to-amber-700 transform hover:-translate-y-0.5 transition-all duration-200 shadow-lg hover:shadow-xl relative">
                    <i class="fas fa-sign-in-alt mr-2"></i>
                    Sign In
                </button>

                <!-- Divider -->
                <div class="relative my-6">
                    <div class="absolute inset-0 flex items-center">
                        <div class="w-full border-t border-gray-300"></div>
                    </div>
                    <div class="relative flex justify-center text-sm">
                        <span class="px-3 bg-white/90 text-gray-500">Or continue with</span>
                    </div>
                </div>

                <!-- Social Login Options -->
                <div class="grid grid-cols-2 gap-3">
                    <button type="button" class="social-btn flex items-center justify-center gap-2 px-4 py-2.5 border border-gray-300 rounded-xl hover:bg-gray-50 transition-all bg-white/90">
                        <i class="fab fa-google text-red-500"></i>
                        <span class="text-sm font-medium text-gray-700">Google</span>
                    </button>
                    <button type="button" class="social-btn flex items-center justify-center gap-2 px-4 py-2.5 border border-gray-300 rounded-xl hover:bg-gray-50 transition-all bg-white/90">
                        <i class="fab fa-facebook-f text-blue-600"></i>
                        <span class="text-sm font-medium text-gray-700">Facebook</span>
                    </button>
                </div>

                <!-- Demo Credentials -->
                <div class="mt-4 p-3 bg-amber-50/90 rounded-xl border border-amber-200 backdrop-blur-sm">
                    <p class="text-xs text-amber-800 text-center">
                        <i class="fas fa-info-circle mr-1"></i>
                        <span class="font-medium">Demo Credentials:</span> demo@poultrypro.com / demo123
                    </p>
                </div>
            </form>

            <!-- Sign Up Link -->
            <div class="px-8 pb-6 text-center border-t border-gray-200 pt-6">
                <p class="text-sm text-gray-600">
                    Don't have an account?
                    <a href="signup.jsp" class="font-semibold text-amber-600 hover:text-amber-700 hover:underline ml-1 transition-colors">
                        Create free account
                    </a>
                </p>
            </div>

            <!-- Trust Badge -->
            <div class="px-8 pb-8 text-center">
                <div class="inline-flex items-center gap-3 text-xs text-gray-500">
                    <div class="flex items-center gap-1">
                        <i class="fas fa-shield-alt text-amber-500"></i>
                        <span>Secure Login</span>
                    </div>
                    <span class="w-1 h-1 bg-gray-300 rounded-full"></span>
                    <div class="flex items-center gap-1">
                        <i class="fas fa-headset text-amber-500"></i>
                        <span>24/7 Support</span>
                    </div>
                    <span class="w-1 h-1 bg-gray-300 rounded-full"></span>
                    <div class="flex items-center gap-1">
                        <i class="fas fa-star text-amber-500"></i>
                        <span>4.9/5 Rating</span>
                    </div>
                </div>
            </div>

            <!-- Footer Links -->
            <div class="px-8 pb-6 text-center">
                <div class="flex justify-center space-x-4 text-xs text-gray-400">
                    <a href="#" class="hover:text-amber-500 transition-colors">Privacy Policy</a>
                    <span>•</span>
                    <a href="#" class="hover:text-amber-500 transition-colors">Terms of Service</a>
                    <span>•</span>
                    <a href="#" class="hover:text-amber-500 transition-colors">Contact Support</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Success/Error Message Area -->
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <div class="fixed bottom-4 right-4 bg-red-500 text-white px-6 py-3 rounded-lg shadow-lg z-50 animate-slide-up">
            <i class="fas fa-exclamation-circle mr-2"></i>
            <%= error %>
            <button onclick="this.parentElement.remove()" class="ml-4 hover:text-red-200">
                <i class="fas fa-times"></i>
            </button>
        </div>
    <%
        }
        
        String success = request.getParameter("success");
        if (success != null) {
    %>
        <div class="fixed bottom-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50 animate-slide-up">
            <i class="fas fa-check-circle mr-2"></i>
            <%= success %>
            <button onclick="this.parentElement.remove()" class="ml-4 hover:text-green-200">
                <i class="fas fa-times"></i>
            </button>
        </div>
    <%
        }
    %>

    <script>
        // Toggle password visibility
        function togglePassword() {
            const passwordInput = document.getElementById("password");
            const toggleIcon = document.getElementById("toggleIcon");
            
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                toggleIcon.classList.remove("fa-eye");
                toggleIcon.classList.add("fa-eye-slash");
            } else {
                passwordInput.type = "password";
                toggleIcon.classList.remove("fa-eye-slash");
                toggleIcon.classList.add("fa-eye");
            }
        }

        // Add loading state on form submit
        document.querySelector("form").addEventListener("submit", function(e) {
            const submitBtn = this.querySelector("button[type='submit']");
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Signing in...';
            submitBtn.disabled = true;
            
            // Restore button if form doesn't submit after 5 seconds (error case)
            setTimeout(() => {
                if (submitBtn.disabled) {
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }
            }, 5000);
        });

        // Auto-hide error/success messages after 5 seconds
        setTimeout(() => {
            const errorMsg = document.querySelector('.bg-red-500');
            const successMsg = document.querySelector('.bg-green-500');
            if (errorMsg) {
                errorMsg.style.opacity = '0';
                setTimeout(() => errorMsg.remove(), 300);
            }
            if (successMsg) {
                successMsg.style.opacity = '0';
                setTimeout(() => successMsg.remove(), 300);
            }
        }, 5000);
    </script>
</body>
</html>