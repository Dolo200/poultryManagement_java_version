package controllers;

import dao.VaccinationFacade;
import dao.ChickenGroupFacade;
import dao.UsersFacade;
import dao.FarmStaffFacade;
import models.Vaccination;
import models.ChickenGroup;
import models.Users;
import models.FarmStaff;
import models.PoultryFarm;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "VaccinationServlet",
            urlPatterns = {"/vaccination/records", "/vaccination/add",
                           "/vaccination/update", "/vaccination/delete",
                           "/vaccination/toggleStatus", "/vaccination/toggleAlert"})
public class VaccinationServlet extends HttpServlet {

    @EJB private VaccinationFacade vaccinationFacade;
    @EJB private ChickenGroupFacade chickenGroupFacade;
    @EJB private UsersFacade usersFacade;
    @EJB private FarmStaffFacade farmStaffFacade;

    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/vaccination/delete".equals(path)) {
            handleDelete(request, response);
        } else {
            handleList(request, response);
        }
    }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/vaccination/add": handleAdd(request, response); break;
            case "/vaccination/update": handleUpdate(request, response); break;
            case "/vaccination/toggleStatus": handleToggleStatus(request, response); break;
            case "/vaccination/toggleAlert": handleToggleAlert(request, response); break;
            default: response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    // ==================== ACCESS CONTROL ====================
    private List<ChickenGroup> getAccessibleChickenGroups(Users currentUser) {
        List<PoultryFarm> farms;
        if ("farm_owner".equalsIgnoreCase(currentUser.getRole())) {
            farms = chickenGroupFacade.findAll().stream()
                    .map(ChickenGroup::getFarmId)
                    .filter(Objects::nonNull)
                    .distinct()
                    .filter(f -> f.getUserId() != null && f.getUserId().getId().equals(currentUser.getId()))
                    .collect(Collectors.toList());
        } else {
            List<FarmStaff> assignments = farmStaffFacade.findByStaff(currentUser);
            farms = assignments.stream()
                    .map(FarmStaff::getFarmId)
                    .filter(Objects::nonNull)
                    .distinct()
                    .collect(Collectors.toList());
        }
        List<BigDecimal> farmIds = farms.stream().map(PoultryFarm::getId).collect(Collectors.toList());
        if (farmIds.isEmpty()) return Collections.emptyList();
        return chickenGroupFacade.findByFarmIds(farmIds);
    }

    // ==================== LIST ====================
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users currentUser = (Users) (session != null ? session.getAttribute("user") : null);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/web/containers/auth/login.jsp");
            return;
        }

        try {
            List<ChickenGroup> accessibleGroups = getAccessibleChickenGroups(currentUser);
            List<BigDecimal> groupIds = accessibleGroups.stream().map(ChickenGroup::getId).collect(Collectors.toList());

            String flockIdParam = request.getParameter("flockId");
            List<Vaccination> vaccinations;
            if (flockIdParam != null && !flockIdParam.isEmpty()) {
                BigDecimal flockId = new BigDecimal(flockIdParam);
                vaccinations = vaccinationFacade.findByChickenGroup(flockId);
            } else if (!groupIds.isEmpty()) {
                vaccinations = vaccinationFacade.findByChickenGroupIds(groupIds);
            } else {
                vaccinations = Collections.emptyList();
            }

            List<Map<String, Object>> records = new ArrayList<>();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date now = new Date();

            for (Vaccination v : vaccinations) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", v.getId().toString());
                map.put("vaccineName", v.getVaccineName() != null ? v.getVaccineName() : v.getVaccine());
                map.put("disease", v.getDisease());
                map.put("dueDate", v.getDueDate() != null ? sdf.format(v.getDueDate()) : null);
                map.put("ageDays", v.getAgeDays());
                map.put("status", v.getStatus());
                map.put("alertActive", v.getAlertActive());
                map.put("reminderDays", v.getReminderDays());
                map.put("doneDate", v.getDoneDate() != null ? sdf.format(v.getDoneDate()) : null);
                map.put("flockId", v.getChickenGroup() != null ? v.getChickenGroup().getId().toString() : null);
                map.put("flockName", v.getChickenGroup() != null ? v.getChickenGroup().getName() : null);

                // overdue logic
                boolean isOverdue = false;
                if (!"done".equals(v.getStatus()) && v.getDueDate() != null) {
                    isOverdue = v.getDueDate().before(now);
                }
                map.put("isOverdue", isOverdue);

                records.add(map);
            }

            List<Map<String, String>> flockList = accessibleGroups.stream().map(g -> {
                Map<String, String> m = new HashMap<>();
                m.put("id", g.getId().toString());
                m.put("flockName", g.getName());
                return m;
            }).collect(Collectors.toList());

            boolean wantJson = "application/json".equals(request.getHeader("Accept"))
                    || "json".equalsIgnoreCase(request.getParameter("format"));

            if (wantJson) {
                response.setContentType("application/json; charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.print(toJson(records, flockList));
            } else {
                request.setAttribute("records", records);
                request.setAttribute("flockList", flockList);
                request.getRequestDispatcher("/web/containers/farmer/vaccination/vaccination.jsp").forward(request, response);
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
            Vaccination v = new Vaccination();
            v.setStatus("pending");
            v.setAlertActive(true);
            populateVaccinationFromRequest(v, request);
            vaccinationFacade.create(v);
            out.print("{\"success\":true, \"message\":\"Vaccination scheduled\"}");
        } catch (Exception e) {
            e.printStackTrace();
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
            Vaccination v = vaccinationFacade.find(id);
            if (v == null) {
                out.print("{\"success\":false, \"message\":\"Record not found\"}");
                return;
            }
            populateVaccinationFromRequest(v, request);
            vaccinationFacade.edit(v);
            out.print("{\"success\":true, \"message\":\"Record updated\"}");
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
            Vaccination v = vaccinationFacade.find(id);
            if (v != null) {
                vaccinationFacade.remove(v);
                out.print("{\"success\":true, \"message\":\"Record deleted\"}");
            } else {
                out.print("{\"success\":false, \"message\":\"Record not found\"}");
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
            Vaccination v = vaccinationFacade.find(id);
            if (v == null) {
                out.print("{\"success\":false, \"message\":\"Record not found\"}");
                return;
            }
            if ("done".equals(v.getStatus())) {
                v.setStatus("pending");
                v.setDoneDate(null);
            } else {
                v.setStatus("done");
                v.setDoneDate(new Date());
            }
            vaccinationFacade.edit(v);
            out.print("{\"success\":true, \"message\":\"Status toggled\"}");
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if (msg == null) msg = "Unknown error";
            out.print("{\"success\":false, \"message\":\"" + escapeJson(msg) + "\"}");
        }
    }

    // ==================== TOGGLE ALERT ====================
    private void handleToggleAlert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            BigDecimal id = new BigDecimal(request.getParameter("id"));
            Vaccination v = vaccinationFacade.find(id);
            if (v == null) {
                out.print("{\"success\":false, \"message\":\"Record not found\"}");
                return;
            }
            v.setAlertActive(!v.getAlertActive());
            vaccinationFacade.edit(v);
            out.print("{\"success\":true, \"message\":\"Alert toggled\"}");
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if (msg == null) msg = "Unknown error";
            out.print("{\"success\":false, \"message\":\"" + escapeJson(msg) + "\"}");
        }
    }

    // ==================== HELPERS ====================
    private void populateVaccinationFromRequest(Vaccination v, HttpServletRequest request) {
        String flockId = request.getParameter("flockId");
        if (flockId != null && !flockId.isEmpty()) {
            ChickenGroup cg = chickenGroupFacade.find(new BigDecimal(flockId));
            v.setChickenGroup(cg);
        }
        v.setVaccineName(request.getParameter("vaccineName"));
        v.setDisease(request.getParameter("disease"));
        String dueDateStr = request.getParameter("dueDate");
        if (dueDateStr != null && !dueDateStr.isEmpty()) {
            try { v.setDueDate(new SimpleDateFormat("yyyy-MM-dd").parse(dueDateStr)); } catch (Exception ignored) {}
        }
        String daysStr = request.getParameter("days");
        if (daysStr != null && !daysStr.isEmpty()) v.setAgeDays(Integer.parseInt(daysStr));
        String reminderStr = request.getParameter("reminderDays");
        if (reminderStr != null && !reminderStr.isEmpty()) v.setReminderDays(Integer.parseInt(reminderStr));
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }

    // ==================== JSON BUILDERS ====================
    private String toJson(List<Map<String, Object>> records, List<Map<String, String>> flocks) {
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"records\":");
        sb.append(jsonList(records));
        sb.append(",\"flocks\":");
        sb.append(jsonSimpleList(flocks));
        sb.append("}");
        return sb.toString();
    }

    private String jsonList(List<Map<String, Object>> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            sb.append(jsonMap(list.get(i)));
            if (i < list.size() - 1) sb.append(",");
        }
        return sb.append("]").toString();
    }

    private String jsonSimpleList(List<Map<String, String>> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            sb.append("{");
            for (Map.Entry<String, String> e : list.get(i).entrySet()) {
                sb.append("\"").append(e.getKey()).append("\":\"")
                  .append(e.getValue().replace("\"", "\\\"")).append("\",");
            }
            if (!list.get(i).isEmpty()) sb.setLength(sb.length() - 1);
            sb.append("}");
            if (i < list.size() - 1) sb.append(",");
        }
        return sb.append("]").toString();
    }

    private String jsonMap(Map<String, ?> map) {
        StringBuilder sb = new StringBuilder("{");
        for (Map.Entry<String, ?> e : map.entrySet()) {
            sb.append("\"").append(e.getKey()).append("\":");
            Object val = e.getValue();
            if (val == null) sb.append("null");
            else if (val instanceof String) sb.append("\"").append(escapeJson((String)val)).append("\"");
            else if (val instanceof Number) sb.append(val);
            else if (val instanceof Boolean) sb.append(val);
            else sb.append("\"").append(escapeJson(val.toString())).append("\"");
            sb.append(",");
        }
        if (!map.isEmpty()) sb.setLength(sb.length() - 1);
        return sb.append("}").toString();
    }
}