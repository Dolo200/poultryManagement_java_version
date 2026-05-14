<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
    <title>Sign Up - PoultryPro | Join Smart Poultry Farming</title>

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
        
        .animate-float-bg {
            animation: float-bg 8s ease-in-out infinite;
        }
        
        .animate-float-slow {
            animation: float-slow 6s ease-in-out infinite;
        }
        
        .animate-pulse-glow {
            animation: pulse-glow 4s ease-in-out infinite;
        }
        
        /* Form focus effects */
        input:focus, select:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.3);
            border-color: #f59e0b;
            transform: scale(1.01);
        }
        
        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }
        
        ::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
        }
        
        ::-webkit-scrollbar-thumb {
            background: #f59e0b;
            border-radius: 4px;
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
        
        /* Card entrance animation */
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
        
        .card-appear {
            animation: card-appear 0.6s ease-out;
        }
    </style>
</head>

<body class="min-h-screen overflow-x-hidden relative">
    
    <!-- Stunning Video/Image Background with Overlay -->
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
        
        <!-- Floating Feathers (Subtle) -->
        <div class="absolute top-40 right-20 text-3xl text-white/10 animate-float-slow">🪶</div>
        <div class="absolute bottom-40 left-20 text-2xl text-white/10 animate-float-slow" style="animation-delay: 3s;">🪶</div>
        <div class="absolute top-60 left-1/4 text-2xl text-white/10 animate-float-slow" style="animation-delay: 1s;">🍂</div>
    </div>

    <!-- Main Container -->
    <div class="relative z-20 min-h-screen flex items-center justify-center p-4 md:p-8">
        
        <!-- Signup Card -->
        <div class="glass-card rounded-3xl shadow-2xl w-full max-w-2xl transform transition-all duration-300 card-appear">
            
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

            <!-- Form Container with Scroll -->
            <div class="max-h-[70vh] overflow-y-auto px-6 md:px-8 py-6">
                
                <div class="text-center mb-6">
                    <h3 class="text-2xl font-bold text-gray-800">Create Your Account</h3>
                    <p class="text-gray-500 text-sm mt-1">Join 10,000+ farmers and start your free 14-day trial</p>
                </div>

                <!-- Signup Form -->
                <form action="${pageContext.request.contextPath}/AuthServlet" method="post" class="space-y-4" id="signupForm" name="signup">
                   
                    <input type="hidden" name="action" value="signup">
                    
                    <!-- Full Name -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            <i class="fas fa-user mr-2 text-amber-500"></i>
                            Full Name *
                        </label>
                        <div class="relative group">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-user text-gray-400 group-focus-within:text-amber-500 transition-colors"></i>
                            </div>
                            <input type="text" name="name" required
                                   class="block w-full pl-10 pr-3 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-amber-500 focus:border-transparent transition-all bg-white/90"
                                   placeholder="John Doe">
                        </div>
                    </div>

                    <!-- Email -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            <i class="fas fa-envelope mr-2 text-amber-500"></i>
                            Email Address *
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

                    <!-- Telephone and Country in Same Row -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <!-- Telephone Number -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-phone mr-2 text-amber-500"></i>
                                Telephone *
                            </label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-phone text-gray-400 group-focus-within:text-amber-500 transition-colors"></i>
                                </div>
                                <input type="tel" name="telephone" required
                                       class="block w-full pl-10 pr-3 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-amber-500 focus:border-transparent transition-all bg-white/90"
                                       placeholder="+237 6XX XXX XXX">
                            </div>
                        </div>

                        <!-- Country (with Cameroon as first option) -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-globe mr-2 text-amber-500"></i>
                                Country *
                            </label>
                            <div class="relative group">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-globe text-gray-400 group-focus-within:text-amber-500 transition-colors"></i>
                                </div>
                                <select name="country" required
                                        class="block w-full pl-10 pr-10 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-amber-500 focus:border-transparent appearance-none bg-white/90">
                                    <option value="" disabled selected>Select country</option>
                                    <option value="CM">🇨🇲 Cameroon</option>
                                    <option value="NG">🇳🇬 Nigeria</option>
                                    <option value="KE">🇰🇪 Kenya</option>
                                    <option value="ZA">🇿🇦 South Africa</option>
                                    <option value="GH">🇬🇭 Ghana</option>
                                    <option value="US">🇺🇸 United States</option>
                                    <option value="UK">🇬🇧 United Kingdom</option>
                                    <option value="CA">🇨🇦 Canada</option>
                                    <option value="FR">🇫🇷 France</option>
                                    <option value="Other">🌍 Other</option>
                                </select>
                                <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                                    <i class="fas fa-chevron-down text-gray-400"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Job/Role -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            <i class="fas fa-briefcase mr-2 text-amber-500"></i>
                            I am a *
                        </label>
                        <div class="relative group">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-briefcase text-gray-400 group-focus-within:text-amber-500 transition-colors"></i>
                            </div>
                            <select name="role" required
                                    class="block w-full pl-10 pr-10 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-amber-500 focus:border-transparent appearance-none bg-white/90">
                                <option value="" disabled selected>Select your role</option>
                                <option value="farm_owner">👨‍🌾 Farm Owner</option>
                                <option value="veterinarian">🐕 Veterinarian</option>
                                <option value="food_supplier">🚚 Food Supplier</option>
                                <option value="buyer">🛒 Buyer / Distributor</option>
                            </select>
                            <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                                <i class="fas fa-chevron-down text-gray-400"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Password -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            <i class="fas fa-lock mr-2 text-amber-500"></i>
                            Password *
                        </label>
                        <div class="relative group">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-lock text-gray-400 group-focus-within:text-amber-500 transition-colors"></i>
                            </div>
                            <input type="password" id="password" name="password" required
                                   class="block w-full pl-10 pr-10 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-amber-500 focus:border-transparent transition-all bg-white/90"
                                   placeholder="Create a strong password">
                            <button type="button" onclick="togglePassword('password', 'toggleIcon1')" 
                                    class="absolute inset-y-0 right-0 pr-3 flex items-center">
                                <i id="toggleIcon1" class="fas fa-eye text-gray-400 hover:text-amber-500 transition-colors"></i>
                            </button>
                        </div>
                        <!-- Password strength indicator -->
                        <div class="mt-2">
                            <div class="flex space-x-1">
                                <div class="strength-bar flex-1 h-1 bg-gray-200 rounded"></div>
                                <div class="strength-bar flex-1 h-1 bg-gray-200 rounded"></div>
                                <div class="strength-bar flex-1 h-1 bg-gray-200 rounded"></div>
                                <div class="strength-bar flex-1 h-1 bg-gray-200 rounded"></div>
                            </div>
                            <p id="strengthText" class="text-xs text-gray-500 mt-1"></p>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            <i class="fas fa-check-circle mr-2 text-amber-500"></i>
                            Confirm Password *
                        </label>
                        <div class="relative group">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-check-circle text-gray-400 group-focus-within:text-amber-500 transition-colors"></i>
                            </div>
                            <input type="password" id="confirmPassword" name="confirmPassword" required
                                   class="block w-full pl-10 pr-10 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-amber-500 focus:border-transparent transition-all bg-white/90"
                                   placeholder="Confirm your password">
                            <button type="button" onclick="togglePassword('confirmPassword', 'toggleIcon2')" 
                                    class="absolute inset-y-0 right-0 pr-3 flex items-center">
                                <i id="toggleIcon2" class="fas fa-eye text-gray-400 hover:text-amber-500 transition-colors"></i>
                            </button>
                        </div>
                        <p id="passwordMatchError" class="text-xs text-red-500 mt-1 hidden">Passwords do not match</p>
                    </div>

                    <!-- Terms and Conditions -->
                    <div class="flex items-start">
                        <input type="checkbox" id="terms" name="terms" required class="mt-1 w-4 h-4 text-amber-500 border-gray-300 rounded focus:ring-amber-500">
                        <label for="terms" class="ml-2 text-sm text-gray-600">
                            I agree to the <a href="#" class="text-amber-600 hover:underline">Terms of Service</a> and 
                            <a href="#" class="text-amber-600 hover:underline">Privacy Policy</a>
                        </label>
                    </div>

                    <!-- Submit Button with Shine Effect -->
                    <button type="submit"
                            class="btn-shine w-full bg-gradient-to-r from-amber-500 to-amber-600 text-white py-3 rounded-xl font-semibold hover:from-amber-600 hover:to-amber-700 transform hover:-translate-y-0.5 transition-all duration-200 shadow-lg hover:shadow-xl relative">
                        <i class="fas fa-user-plus mr-2"></i>
                        Create Free Account
                    </button>

                    <!-- Benefits with Icons -->
                    <div class="grid grid-cols-3 gap-2 text-center text-xs text-gray-600 pt-2">
                        <div class="flex items-center justify-center gap-1">
                            <i class="fas fa-calendar-alt text-green-500"></i>
                            <span>14-day trial</span>
                        </div>
                        <div class="flex items-center justify-center gap-1">
                            <i class="fas fa-credit-card text-green-500"></i>
                            <span>No card required</span>
                        </div>
                        <div class="flex items-center justify-center gap-1">
                            <i class="fas fa-times-circle text-green-500"></i>
                            <span>Cancel anytime</span>
                        </div>
                    </div>
                </form>

                <!-- Sign In Link -->
                <div class="text-center border-t border-gray-200 pt-6 mt-6">
                    <p class="text-sm text-gray-600">
                        Already have an account?
                        <a href="login.jsp" class="font-semibold text-amber-600 hover:text-amber-700 hover:underline ml-1 transition-colors">
                            Sign in here
                        </a>
                    </p>
                </div>
                
                <!-- Trust Badge -->
                <div class="mt-4 text-center">
                    <div class="inline-flex items-center gap-2 text-xs text-gray-500">
                        <i class="fas fa-shield-alt text-amber-500"></i>
                        <span>Secure & Encrypted</span>
                        <span class="w-1 h-1 bg-gray-300 rounded-full"></span>
                        <i class="fas fa-headset text-amber-500"></i>
                        <span>24/7 Support</span>
                        <span class="w-1 h-1 bg-gray-300 rounded-full"></span>
                        <i class="fas fa-star text-amber-500"></i>
                        <span>4.9/5 Rating</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Toggle password visibility
        function togglePassword(inputId, iconId) {
            const passwordInput = document.getElementById(inputId);
            const toggleIcon = document.getElementById(iconId);
            
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

        // Password strength checker
        const passwordInput = document.getElementById('password');
        const strengthBars = document.querySelectorAll('.strength-bar');
        const strengthText = document.getElementById('strengthText');

        if(passwordInput) {
            passwordInput.addEventListener('input', function() {
                const password = this.value;
                const strength = checkPasswordStrength(password);
                
                strengthBars.forEach((bar, index) => {
                    bar.classList.remove('bg-red-500', 'bg-orange-500', 'bg-yellow-500', 'bg-green-500');
                    bar.classList.add('bg-gray-200');
                    
                    if(index < strength.score) {
                        bar.classList.remove('bg-gray-200');
                        if(strength.score === 1) bar.classList.add('bg-red-500');
                        else if(strength.score === 2) bar.classList.add('bg-orange-500');
                        else if(strength.score === 3) bar.classList.add('bg-yellow-500');
                        else if(strength.score >= 4) bar.classList.add('bg-green-500');
                    }
                });
                
                strengthText.textContent = strength.message;
                strengthText.className = `text-xs mt-1 ${strength.color}`;
            });
        }

        function checkPasswordStrength(password) {
            let score = 0;
            if (!password) return { score: 0, message: 'Enter a password', color: 'text-gray-500' };
            
            if (password.length >= 8) score++;
            if (password.match(/[a-z]/) && password.match(/[A-Z]/)) score++;
            if (password.match(/\d/)) score++;
            if (password.match(/[^a-zA-Z\d]/)) score++;
            
            const messages = {
                1: { text: 'Weak password', color: 'text-red-500' },
                2: { text: 'Fair password', color: 'text-orange-500' },
                3: { text: 'Good password', color: 'text-yellow-600' },
                4: { text: 'Strong password!', color: 'text-green-500' }
            };
            
            return { 
                score: score, 
                message: messages[score]?.text || 'Very weak password',
                color: messages[score]?.color || 'text-red-500'
            };
        }

        // Confirm password validation
        const confirmPassword = document.getElementById('confirmPassword');
        const passwordMatchError = document.getElementById('passwordMatchError');
        
        function validatePasswordMatch() {
            if (passwordInput && confirmPassword && passwordInput.value !== confirmPassword.value && confirmPassword.value !== '') {
                passwordMatchError.classList.remove('hidden');
                return false;
            } else if(passwordMatchError) {
                passwordMatchError.classList.add('hidden');
                return true;
            }
            return true;
        }
        
        if(passwordInput && confirmPassword) {
            passwordInput.addEventListener('input', validatePasswordMatch);
            confirmPassword.addEventListener('input', validatePasswordMatch);
        }
        
        // Form validation before submit
        const signupForm = document.getElementById('signupForm');
        if(signupForm) {
            signupForm.addEventListener('submit', function(e) {
                if (!validatePasswordMatch()) {
                    e.preventDefault();
                    alert('Please make sure your passwords match.');
                }
            });
        }
    </script>
</body>
</html>