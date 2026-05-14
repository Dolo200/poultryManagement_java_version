package controllers;

import dao.UsersFacade;
import dao.PoultryFarmFacade;
import dao.FarmStaffFacade;
import models.Users;
import models.PoultryFarm;
import models.FarmStaff;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
//import jakarta.ws.rs.Path;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "StaffServlet",
            urlPatterns = {"/staff/records", "/staff/addStaff",
                           "/staff/updateStaff", "/staff/deleteStaff",
                           "/staff/toggleStatus"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)   // 5 MB
public class StaffServlet extends HttpServlet {

    @EJB private UsersFacade usersFacade;
    @EJB private PoultryFarmFacade farmFacade;
    @EJB private FarmStaffFacade farmStaffFacade;

    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/staff/deleteStaff".equals(path)) {
            handleDelete(request, response);
        } else {
            handleList(request, response);
        }
    }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/staff/addStaff": handleAdd(request, response); break;
            case "/staff/updateStaff": handleUpdate(request, response); break;
            case "/staff/toggleStatus": handleToggleStatus(request, response); break;
            default: response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    // ==================== LIST ====================
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users currentUser = (Users) (session != null ? session.getAttribute("user") : null);
        if (currentUser == null || !"farm_owner".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/web/containers/auth/login.jsp");
            return;
        }

        try {
            List<Users> allUsers = usersFacade.findAll();
            List<Users> staffUsers = allUsers.stream()
                    .filter(u -> "staff".equalsIgnoreCase(u.getRole()))
                    .collect(Collectors.toList());

            List<Map<String, Object>> staffList = new ArrayList<>();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            for (Users staff : staffUsers) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", staff.getId().toString());
                map.put("staffName", staff.getName());
                map.put("email", staff.getEmail());
                map.put("phone", staff.getTelephone());
                map.put("gender", staff.getGender());
                // status – if the field doesn't exist yet, default to "active"
                map.put("status", staff.getStatus() != null ? staff.getStatus() : "active");

                // Fetch assigned farms
                List<FarmStaff> assignments = farmStaffFacade.findByStaff(staff);
                List<Map<String, String>> farms = assignments.stream()
                        .map(fs -> {
                            PoultryFarm f = fs.getFarmId();
                            Map<String, String> fm = new HashMap<>();
                            fm.put("id", f.getId().toString());
                            fm.put("farmName", f.getFarmName());
                            return fm;
                        })
                        .collect(Collectors.toList());
                map.put("farms", farms);
                map.put("farmsJson", farmsToString(farms));

                // Photo
                map.put("photo", staff.getPhoto());

                // Hire date – skip if column missing (just use null)
                try {
                    map.put("hireDate", staff.getHireDate() != null ? sdf.format(staff.getHireDate()) : null);
                } catch (Exception ignore) {
                    map.put("hireDate", null);
                }

                // Salary – skip if column missing
                try {
                    map.put("salary", staff.getSalary() != null ? staff.getSalary().doubleValue() : 0.0);
                } catch (Exception ignore) {
                    map.put("salary", 0.0);
                }

                staffList.add(map);
            }

            // Farms dropdown
            List<PoultryFarm> userFarms = farmFacade.findAll().stream()
                    .filter(f -> f.getUserId() != null && f.getUserId().getId().equals(currentUser.getId()))
                    .collect(Collectors.toList());
            List<Map<String, String>> farmList = userFarms.stream().map(f -> {
                Map<String, String> m = new HashMap<>();
                m.put("id", f.getId().toString());
                m.put("farmName", f.getFarmName());
                return m;
            }).collect(Collectors.toList());

            boolean wantJson = "application/json".equals(request.getHeader("Accept"))
                    || "json".equalsIgnoreCase(request.getParameter("format"));

            if (wantJson) {
                response.setContentType("application/json; charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.print(toJson(staffList, farmList));
            } else {
                request.setAttribute("staffList", staffList);
                request.setAttribute("farmList", farmList);
                request.getRequestDispatcher("/web/containers/farmer/staff/staff.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // ==================== ADD ====================
    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Users staff = new Users();
            staff.setRole("staff");
            staff.setStatus("active");

            // ** Temporarily skip hireDate if column missing **
            try {
                staff.setHireDate(new Date());
            } catch (Exception ignore) { }

            populateStaffFromRequest(staff, request, true);
            usersFacade.create(staff);
            assignFarmsToStaff(staff, request.getParameterValues("assignToFarm"));
            out.print("{\"success\":true, \"message\":\"Staff created\"}");
        } catch (Exception e) {
            e.printStackTrace();   // prints to GlassFish log
            // Return clean JSON with escaped message
            String msg = e.getMessage();
            if (msg == null) msg = "Unknown error";
            out.print("{\"success\":false, \"message\":\"" + escapeJson(msg) + "\"}");
        }
    }

    // ==================== UPDATE ====================
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            BigDecimal id = new BigDecimal(request.getParameter("id"));
            Users staff = usersFacade.find(id);
            if (staff == null) {
                out.print("{\"success\":false, \"message\":\"Staff not found\"}");
                return;
            }
            populateStaffFromRequest(staff, request, false);
            usersFacade.edit(staff);
            assignFarmsToStaff(staff, request.getParameterValues("assignToFarm"));
            out.print("{\"success\":true, \"message\":\"Staff updated\"}");
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if (msg == null) msg = "Unknown error";
            out.print("{\"success\":false, \"message\":\"" + escapeJson(msg) + "\"}");
        }
    }

    // ==================== DELETE ====================
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            BigDecimal id = new BigDecimal(request.getParameter("id"));
            Users staff = usersFacade.find(id);
            if (staff != null) {
                List<FarmStaff> assignments = farmStaffFacade.findByStaff(staff);
                for (FarmStaff fs : assignments) farmStaffFacade.remove(fs);
                usersFacade.remove(staff);
                out.print("{\"success\":true, \"message\":\"Staff deleted\"}");
            } else {
                out.print("{\"success\":false, \"message\":\"Staff not found\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if (msg == null) msg = "Unknown error";
            out.print("{\"success\":false, \"message\":\"" + escapeJson(msg) + "\"}");
        }
    }

    // ==================== TOGGLE STATUS ====================
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            BigDecimal id = new BigDecimal(request.getParameter("id"));
            Users staff = usersFacade.find(id);
            if (staff == null) {
                out.print("{\"success\":false, \"message\":\"Staff not found\"}");
                return;
            }
            String newStatus = "active".equalsIgnoreCase(staff.getStatus()) ? "blocked" : "active";
            staff.setStatus(newStatus);
            usersFacade.edit(staff);
            out.print("{\"success\":true, \"message\":\"Status changed to " + newStatus + "\", \"newStatus\":\"" + newStatus + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if (msg == null) msg = "Unknown error";
            out.print("{\"success\":false, \"message\":\"" + escapeJson(msg) + "\"}");
        }
    }

    // ==================== HELPERS ====================
    private void populateStaffFromRequest(Users staff, HttpServletRequest request, boolean isNew) throws Exception {
        staff.setName(request.getParameter("staffName"));
        staff.setEmail(request.getParameter("email"));
        staff.setGender(request.getParameter("gender"));
        staff.setTelephone(request.getParameter("phone"));

        String password = request.getParameter("password");
        if (isNew || (password != null && !password.trim().isEmpty())) {
            staff.setPassword(password);
        }

        // Salary – only if column exists
        try {
            String salaryStr = request.getParameter("salary");
            if (salaryStr != null && !salaryStr.trim().isEmpty()) {
                staff.setSalary(new BigDecimal(salaryStr));
            } else if (!isNew) {
                // keep old value (do nothing)
            }
        } catch (Exception ignore) { }

        
        // Photo upload
        Part filePart = request.getPart("photo");

        if (filePart != null && filePart.getSize() > 0) {
            String uploadRoot = request.getServletContext().getRealPath("/assets/images");
            if (uploadRoot == null) {
                uploadRoot = new File("src/main/webapp/assets/images").getAbsolutePath();
            }

            File uploadDir = new File(uploadRoot);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String originalName = Paths.get(filePart.getSubmittedFileName())
                                       .getFileName()
                                       .toString();

            String fileName = UUID.randomUUID() + "_" + originalName;
            Path uploadPath = Paths.get(uploadRoot, fileName);

            Files.copy(
                filePart.getInputStream(),
                uploadPath,
                StandardCopyOption.REPLACE_EXISTING
            );

            staff.setPhoto("assets/images/" + fileName);
        }
    }

    private void assignFarmsToStaff(Users staff, String[] farmIds) {
        List<FarmStaff> existing = farmStaffFacade.findByStaff(staff);
        for (FarmStaff fs : existing) farmStaffFacade.remove(fs);

        if (farmIds != null) {
            for (String fid : farmIds) {
                if (fid == null || fid.trim().isEmpty()) continue;
                PoultryFarm farm = farmFacade.find(new BigDecimal(fid));
                if (farm != null) {
                    FarmStaff fs = new FarmStaff();
                    fs.setFarmId(farm);
                    fs.setStaffId(staff);
                    farmStaffFacade.create(fs);
                }
            }
        }
    }

    private String farmsToString(List<Map<String, String>> farms) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < farms.size(); i++) {
            sb.append("{\"id\":\"").append(farms.get(i).get("id"))
              .append("\",\"farmName\":\"").append(escapeJson(farms.get(i).get("farmName")))
              .append("\"}");
            if (i < farms.size()-1) sb.append(",");
        }
        return sb.append("]").toString();
    }

    /** Escapes a string for safe insertion into JSON */
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    private String toJson(List<Map<String, Object>> staff, List<Map<String, String>> farms) {
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"staff\":[");
        for (int i=0; i<staff.size(); i++) {
            sb.append(jsonMap(staff.get(i)));
            if (i < staff.size()-1) sb.append(",");
        }
        sb.append("],\"farms\":");
        sb.append(jsonSimpleList(farms));
        sb.append("}");
        return sb.toString();
    }

    private String jsonMap(Map<String, ?> map) {
        StringBuilder sb = new StringBuilder("{");
        for (Map.Entry<String, ?> e : map.entrySet()) {
            sb.append("\"").append(e.getKey()).append("\":");
            Object val = e.getValue();
            if (val == null) sb.append("null");
            else if (val instanceof String) sb.append("\"").append(escapeJson((String)val)).append("\"");
            else if (val instanceof Number) sb.append(val);
            else if (val instanceof List) {
                sb.append("[");
                List<?> list = (List<?>) val;
                for (int j=0; j<list.size(); j++) {
                    sb.append(jsonMap((Map<String,?>) list.get(j)));
                    if (j < list.size()-1) sb.append(",");
                }
                sb.append("]");
            } else sb.append("\"").append(escapeJson(val.toString())).append("\"");
            sb.append(",");
        }
        if (!map.isEmpty()) sb.setLength(sb.length()-1);
        return sb.append("}").toString();
    }

    private String jsonSimpleList(List<Map<String,String>> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i=0; i<list.size(); i++) {
            sb.append("{");
            for (Map.Entry<String,String> entry : list.get(i).entrySet()) {
                sb.append("\"").append(entry.getKey()).append("\":\"")
                  .append(escapeJson(entry.getValue())).append("\",");
            }
            if (!list.get(i).isEmpty()) sb.setLength(sb.length()-1);
            sb.append("}");
            if (i<list.size()-1) sb.append(",");
        }
        return sb.append("]").toString();
    }
}