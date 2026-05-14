package controllers;

import dao.ChickenGroupFacade;
import dao.MortalityFacade;
import dao.UsersFacade;
import dao.FarmStaffFacade;
import models.ChickenGroup;
import models.Mortality;
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
import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "MortalityServlet",
            urlPatterns = {"/mortality/records", "/mortality/addRecord",
                           "/mortality/updateRecord", "/mortality/deleteRecord"})
public class MortalityServlet extends HttpServlet {

    @EJB
    private MortalityFacade mortalityFacade;
    @EJB
    private ChickenGroupFacade chickenGroupFacade;
    @EJB
    private UsersFacade usersFacade;
    @EJB
    private FarmStaffFacade farmStaffFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/mortality/deleteRecord".equals(servletPath)) {
            handleDelete(request, response);
        } else {
            handleList(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        switch (servletPath) {
            case "/mortality/addRecord": handleAdd(request, response); break;
            case "/mortality/updateRecord": handleUpdate(request, response); break;
            default: response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
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
            // 1. Get farms the current user can access
            List<PoultryFarm> accessibleFarms = getAccessibleFarms(currentUser);
            List<BigDecimal> farmIds = accessibleFarms.stream()
                    .map(PoultryFarm::getId)
                    .collect(Collectors.toList());

            // 2. Get chicken groups for those farms
            List<ChickenGroup> userGroups = farmIds.isEmpty() ?
                    Collections.emptyList() :
                    chickenGroupFacade.findByFarmIds(farmIds);

            // 3. Build map of group ID -> initial stock (for later calculation)
            Map<BigDecimal, Integer> initialStockMap = new HashMap<>();
            for (ChickenGroup g : userGroups) {
                int stock = g.getQuantity() != null ? g.getQuantity().intValue() : 0;
                initialStockMap.put(g.getId(), stock);
            }

            List<BigDecimal> groupIds = new ArrayList<>(initialStockMap.keySet());

            // 4. Fetch mortality records for those groups
            List<Mortality> allRecords = groupIds.isEmpty() ?
                    Collections.emptyList() :
                    mortalityFacade.findByChickenGroupIds(groupIds);

            // 5. Group records by chicken group, sort by date, compute cumulative deaths & rate
            Map<BigDecimal, String> groupNameMap = userGroups.stream()
                    .collect(Collectors.toMap(ChickenGroup::getId, ChickenGroup::getName));

            List<Map<String, Object>> recordsList = new ArrayList<>();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            // Group by group ID
            Map<BigDecimal, List<Mortality>> recordsByGroup = allRecords.stream()
                    .collect(Collectors.groupingBy(r -> r.getChickenGroupId().getId()));

            for (Map.Entry<BigDecimal, List<Mortality>> entry : recordsByGroup.entrySet()) {
                BigDecimal gid = entry.getKey();
                String flockName = groupNameMap.getOrDefault(gid, "Unknown");
                Integer initialStock = initialStockMap.getOrDefault(gid, 0);

                // Sort by date ascending
                List<Mortality> sorted = entry.getValue().stream()
                        .sorted(Comparator.comparing(Mortality::getDateOfDeath))
                        .collect(Collectors.toList());

                int cumulative = 0;
                for (Mortality m : sorted) {
                    int deaths = m.getNumberOfDeath() != null ? m.getNumberOfDeath().intValue() : 0;
                    cumulative += deaths;
                    double mortalityRate = initialStock > 0 ? (cumulative * 100.0 / initialStock) : 0.0;

                    Map<String, Object> map = new HashMap<>();
                    map.put("id", m.getId().toString());
                    map.put("flockName", flockName);
                    map.put("flockId", gid.toString());
                    map.put("date", m.getDateOfDeath() != null ? sdf.format(m.getDateOfDeath()) : null);
                    map.put("numberOfDeaths", deaths);
                    map.put("age", m.getAgeOfDeath() != null ? m.getAgeOfDeath().intValue() : 0);
                    map.put("cause", m.getCause());
                    map.put("location", m.getLocation());
                    map.put("actionTaken", m.getActionTaken());
                    map.put("initialStock", initialStock);
                    map.put("cumulativeMortality", cumulative);
                    map.put("mortalityRate", Math.round(mortalityRate * 100.0) / 100.0);

                    recordsList.add(map);
                }
            }

            // 6. Build stats
            int totalDeaths = recordsList.stream().mapToInt(r -> (int) r.get("numberOfDeaths")).sum();
            long totalStock = initialStockMap.values().stream().mapToLong(Integer::longValue).sum();
            double overallRate = totalStock > 0 ? (totalDeaths * 100.0 / totalStock) : 0.0;
            long highRisk = recordsList.stream().filter(r -> (double) r.get("mortalityRate") > 5.0).count();

            Map<String, Object> stats = new HashMap<>();
            stats.put("totalDeaths", totalDeaths);
            stats.put("totalInitialStock", totalStock);
            stats.put("overallMortalityRate", Math.round(overallRate * 100.0) / 100.0);
            stats.put("highRiskCases", highRisk);

            // 7. Build flocks dropdown list (for the form)
            List<Map<String, String>> flockList = userGroups.stream().map(g -> {
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
                out.print(toJson(recordsList, stats, flockList));
            } else {
                request.setAttribute("records", recordsList);
                request.setAttribute("stats", stats);
                request.setAttribute("flockList", flockList);
                request.setAttribute("isOwner", "farm_owner".equalsIgnoreCase(currentUser.getRole()));
                request.getRequestDispatcher("/web/containers/farmer/mortality/mortality.jsp").forward(request, response);
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
            HttpSession session = request.getSession(false);
            Users currentUser = (Users) session.getAttribute("user");
            if (currentUser == null || !"farm_owner".equalsIgnoreCase(currentUser.getRole())) {
                out.print("{\"success\":false, \"message\":\"Only farm owners can add records\"}");
                return;
            }

            Mortality m = new Mortality();
            populateMortalityFromRequest(m, request);
            mortalityFacade.create(m);
            out.print("{\"success\":true, \"message\":\"Record created\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false, \"message\":\"" + e.getMessage() + "\"}");
        }
    }

    // ==================== UPDATE ====================
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            HttpSession session = request.getSession(false);
            Users currentUser = (Users) session.getAttribute("user");
            if (currentUser == null || !"farm_owner".equalsIgnoreCase(currentUser.getRole())) {
                out.print("{\"success\":false, \"message\":\"Only farm owners can edit records\"}");
                return;
            }

            BigDecimal id = new BigDecimal(request.getParameter("id"));
            Mortality m = mortalityFacade.find(id);
            if (m == null) {
                out.print("{\"success\":false, \"message\":\"Record not found\"}");
                return;
            }
            populateMortalityFromRequest(m, request);
            mortalityFacade.edit(m);
            out.print("{\"success\":true, \"message\":\"Record updated\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false, \"message\":\"" + e.getMessage() + "\"}");
        }
    }

    // ==================== DELETE ====================
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            HttpSession session = request.getSession(false);
            Users currentUser = (Users) session.getAttribute("user");
            if (currentUser == null || !"farm_owner".equalsIgnoreCase(currentUser.getRole())) {
                out.print("{\"success\":false, \"message\":\"Only farm owners can delete records\"}");
                return;
            }

            BigDecimal id = new BigDecimal(request.getParameter("id"));
            Mortality m = mortalityFacade.find(id);
            if (m != null) {
                mortalityFacade.remove(m);
                out.print("{\"success\":true, \"message\":\"Record deleted\"}");
            } else {
                out.print("{\"success\":false, \"message\":\"Record not found\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false, \"message\":\"" + e.getMessage() + "\"}");
        }
    }

    // ==================== HELPERS ====================
    private List<PoultryFarm> getAccessibleFarms(Users currentUser) {
        // We need PoultryFarmFacade to get farms. Let's inject it.
        // Since it's not currently injected, we can either add @EJB for PoultryFarmFacade
        // or fetch via chicken groups. For simplicity, let's add PoultryFarmFacade.
        // I'll assume we can use farmFacade that we already have? Actually we don't have it.
        // Quick solution: inject PoultryFarmFacade. I'll add it as a field.
        return getAccessibleFarmsUsingFacade(currentUser);
    }

    // We'll add a PoultryFarmFacade field for this
    @EJB
    private dao.PoultryFarmFacade farmFacade;

    private List<PoultryFarm> getAccessibleFarmsUsingFacade(Users currentUser) {
        if ("farm_owner".equalsIgnoreCase(currentUser.getRole())) {
            // Owner: farms where userId matches
            return farmFacade.findAll().stream()
                    .filter(f -> f.getUserId() != null && f.getUserId().getId().equals(currentUser.getId()))
                    .collect(Collectors.toList());
        } else {
            // Staff: get farms from FarmStaff assignments
            List<FarmStaff> assignments = farmStaffFacade.findByStaff(currentUser);
            return assignments.stream()
                    .map(FarmStaff::getFarmId)
                    .filter(Objects::nonNull)
                    .distinct()
                    .collect(Collectors.toList());
        }
    }

    private void populateMortalityFromRequest(Mortality m, HttpServletRequest request) {
        // Flock
        String flockId = request.getParameter("flockId");
        if (flockId != null && !flockId.isEmpty()) {
            ChickenGroup group = chickenGroupFacade.find(new BigDecimal(flockId));
            m.setChickenGroupId(group);
        }
        // Date
        String dateStr = request.getParameter("date");
        if (dateStr != null && !dateStr.isEmpty()) {
            try { m.setDateOfDeath(new SimpleDateFormat("yyyy-MM-dd").parse(dateStr)); } catch (Exception ignored) {}
        }
        // Number of deaths
        String deaths = request.getParameter("numberOfDeaths");
        if (deaths != null && !deaths.isEmpty()) m.setNumberOfDeath(new BigInteger(deaths));
        // Age
        String age = request.getParameter("age");
        if (age != null && !age.isEmpty()) m.setAgeOfDeath(new BigInteger(age));
        // Cause
        m.setCause(request.getParameter("cause"));
        // Location
        m.setLocation(request.getParameter("location"));
        // Action taken
        m.setActionTaken(request.getParameter("actionTaken"));
        // initialStock, cumulativeDeath, mortalityRate are computed on the fly; not set from request
    }

    // ==================== JSON BUILDER ====================
    private String toJson(List<Map<String, Object>> records, Map<String, Object> stats, List<Map<String, String>> flocks) {
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"records\":");
        sb.append(jsonList(records));
        sb.append(",\"stats\":");
        sb.append(jsonMap(stats));
        sb.append(",\"flocks\":");
        sb.append(jsonListSimple(flocks));
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

    private String jsonListSimple(List<Map<String, String>> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            sb.append(jsonStringMap(list.get(i)));
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
            else if (val instanceof Number) sb.append(val);
            else sb.append("\"").append(val.toString().replace("\"", "\\\"")).append("\"");
            sb.append(",");
        }
        if (!map.isEmpty()) sb.setLength(sb.length() - 1);
        return sb.append("}").toString();
    }

    private String jsonStringMap(Map<String, String> map) {
        StringBuilder sb = new StringBuilder("{");
        for (Map.Entry<String, String> e : map.entrySet()) {
            sb.append("\"").append(e.getKey()).append("\":");
            sb.append("\"").append(e.getValue().replace("\"", "\\\"")).append("\"");
            sb.append(",");
        }
        if (!map.isEmpty()) sb.setLength(sb.length() - 1);
        return sb.append("}").toString();
    }
}