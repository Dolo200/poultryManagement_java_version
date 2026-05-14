package controllers;

import dao.UsersFacade;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Users;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {

    @EJB
    private UsersFacade usersFacade;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("signup".equalsIgnoreCase(action)) {
            handleSignup(request, response);
        } else if ("login".equalsIgnoreCase(action)) {
            handleLogin(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            String error = URLEncoder.encode("Email and password are required", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/web/containers/auth/login.jsp?error=" + error);
            return;
        }

        try {
            Users user = usersFacade.findByEmail(email);
            // Plain-text password check – replace with hashed password verification in production!
            if (user != null && user.getPassword().equals(password)) {
                HttpSession session = request.getSession();

                // Store full user object
                session.setAttribute("user", user);

                // Store individual attributes for easier access in JSP / JavaScript
                session.setAttribute("userEmail", user.getEmail());
                session.setAttribute("userName", user.getName());
                session.setAttribute("userRole", user.getRole());

                // Redirect to role‑specific dashboard
                String dashboardPath = getDashboardPath(user.getRole());
                response.sendRedirect(request.getContextPath() + dashboardPath);
            } else {
                String error = URLEncoder.encode("Invalid email or password", StandardCharsets.UTF_8);
                response.sendRedirect(request.getContextPath() + "/web/containers/auth/login.jsp?error=" + error);
            }
        } catch (Exception e) {
            e.printStackTrace();
            String error = URLEncoder.encode("System error, please try later", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/web/containers/auth/login.jsp?error=" + error);
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String role = request.getParameter("role");
        String country = request.getParameter("country");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Server‑side validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            telephone == null || telephone.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            country == null || country.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {

            String error = URLEncoder.encode("All fields are required", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/web/containers/auth/signup.jsp?error=" + error);
            return;
        }

        if (!password.equals(confirmPassword)) {
            String error = URLEncoder.encode("Passwords do not match", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/web/containers/auth/signup.jsp?error=" + error);
            return;
        }

        // Check if email already exists
        if (usersFacade.findByEmail(email) != null) {
            String error = URLEncoder.encode("Email already registered", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/web/containers/auth/signup.jsp?error=" + error);
            return;
        }

        try {
            Users newUser = new Users();

            // ID is assigned automatically by the database trigger
            newUser.setName(name.trim());
            newUser.setEmail(email.trim().toLowerCase());
            newUser.setTelephone(telephone.trim());
            newUser.setRole(role.trim());
            newUser.setCountry(country.trim());
            newUser.setPassword(password);   // Hash in production!

            usersFacade.create(newUser);

            String success = URLEncoder.encode("Account created successfully. Please login.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/web/containers/auth/login.jsp?success=" + success);
        } catch (Exception e) {
            e.printStackTrace();
            String error = URLEncoder.encode("Registration failed. Please try again.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/web/containers/auth/signup.jsp?error=" + error);
        }
    }

    /**
     * Maps a user’s role to the corresponding dashboard page.
     * Adjust the paths to match your actual JSP file locations.
     */
    private String getDashboardPath(String role) {
        if (role == null) role = "";

        switch (role.toLowerCase()) {
            case "farm_owner":
                return "/web/containers/farmer/dashboard/dashboard.jsp";
            case "staff":
                return "/web/containers/farmer/dashboard/dashboard.jsp";    
            case "veterinarian":
                return "/web/containers/vet/dashboard/dashboard.jsp";
            case "food_supplier":
                return "/web/containers/supplier/dashboard/dashboard.jsp";
            case "buyer":
                return "/web/containers/buyer/dashboard/dashboard.jsp";
            default:
                // Fallback dashboard for unknown roles
                return "/web/containers/dashboard/dashboard.jsp";
        }
    }
}