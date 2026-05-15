package controllers;

import dao.ChickenGroupFacade;
import dao.PoultryFarmFacade;
import dao.UsersFacade;
import dao.FarmStaffFacade;
import dao.VaccinationFacade;              
import models.ChickenGroup;
import models.PoultryFarm;
import models.Users;
import models.FarmStaff;
import models.Vaccination;                  
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

@WebServlet(name = "ChickenGroupServlet",
            urlPatterns = {"/flock/flocks", "/flock/addGroup", "/flock/updateGroup", "/flock/deleteGroup"})
public class ChickenGroupServlet extends HttpServlet {

    @EJB
    private ChickenGroupFacade chickenGroupFacade;
    @EJB
    private PoultryFarmFacade farmFacade;
    @EJB
    private UsersFacade usersFacade;
    @EJB
    private FarmStaffFacade farmStaffFacade;
    @EJB
    private VaccinationFacade vaccinationFacade;    // ✅ ADDED

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/flock/deleteGroup".equals(servletPath)) {
            handleDelete(request, response);
            return;
        }
        handleList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        switch (servletPath) {
            case "/flock/addGroup":
                handleAdd(request, response);
                break;
            case "/flock/updateGroup":
                handleUpdate(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Users currentUser = (Users) (session != null ? session.getAttribute("user") : null);
        if (currentUser == null) {
            request.getRequestDispatcher("/web/containers/auth/login.jsp").forward(request, response);
            return;
        }

        try {
            List<PoultryFarm> userFarms;
            boolean isOwner = "farm_owner".equalsIgnoreCase(currentUser.getRole());

            if (isOwner) {
                userFarms = farmFacade.findAll().stream()
                        .filter(f -> f.getUserId() != null && f.getUserId().getId().equals(currentUser.getId()))
                        .collect(Collectors.toList());
            } else {
                List<FarmStaff> staffAssignments = farmStaffFacade.findByStaff(currentUser);
                userFarms = staffAssignments.stream()
                        .map(FarmStaff::getFarmId)
                        .filter(Objects::nonNull)
                        .distinct()
                        .collect(Collectors.toList());
            }

            // ---------- Build farm data list for the JSON ----------
            List<Map<String, Object>> farmDataList = new ArrayList<>();
            for (PoultryFarm farm : userFarms) {
                Map<String, Object> farmMap = new HashMap<>();
                farmMap.put("id", farm.getId().toString());
                farmMap.put("farmName", farm.getFarmName());
                farmMap.put("address", farm.getAddress());
                farmDataList.add(farmMap);
            }

            // Fetch fresh chicken groups directly from DB
            List<BigDecimal> farmIds = userFarms.stream()
                    .map(PoultryFarm::getId)
                    .collect(Collectors.toList());

            List<ChickenGroup> allGroups = farmIds.isEmpty()
                    ? Collections.emptyList()
                    : chickenGroupFacade.findByFarmIds(farmIds);

            // Build group data list
            List<Map<String, Object>> groupDataList = new ArrayList<>();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            for (ChickenGroup cg : allGroups) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", cg.getId().toString());
                map.put("groupName", cg.getName());
                map.put("farmId", cg.getFarmId() != null ? cg.getFarmId().getId().toString() : null);
                map.put("farmName", cg.getFarmId() != null ? cg.getFarmId().getFarmName() : "N/A");
                map.put("type", cg.getType());
                map.put("quantity", cg.getQuantity() != null ? cg.getQuantity().intValue() : 0);
                map.put("cost", cg.getCost() != null ? cg.getCost().doubleValue() : 0.0);
                map.put("receiveAge", cg.getReceiveAge() != null ? cg.getReceiveAge().intValue() : 0);
                map.put("currentAge", cg.getCurrentAge() != null ? cg.getCurrentAge().intValue() : 0);
                map.put("receiveDate", cg.getReceiveDate() != null ? sdf.format(cg.getReceiveDate()) : null);
                map.put("origin", cg.getOrigin());
                groupDataList.add(map);
            }

            // Stats
            Map<String, Object> stats = new HashMap<>();
            stats.put("total", groupDataList.size());
            stats.put("layerCount", groupDataList.stream().filter(g -> "layer".equalsIgnoreCase((String) g.get("type"))).count());
            stats.put("broilerCount", groupDataList.stream().filter(g -> "broiler".equalsIgnoreCase((String) g.get("type"))).count());
            stats.put("totalBirds", groupDataList.stream().mapToInt(g -> (Integer) g.get("quantity")).sum());

            // Search
            String search = request.getParameter("search");
            if (search != null && !search.trim().isEmpty()) {
                String term = search.toLowerCase();
                groupDataList = groupDataList.stream()
                        .filter(g -> String.valueOf(g.get("groupName")).toLowerCase().contains(term) ||
                                     String.valueOf(g.get("farmName")).toLowerCase().contains(term) ||
                                     String.valueOf(g.get("origin")).toLowerCase().contains(term))
                        .collect(Collectors.toList());
            }

            // Sort
            String sortBy = request.getParameter("sortBy");
            String sortDir = request.getParameter("sortDir");
            if (sortBy != null && !sortBy.isEmpty()) {
                boolean asc = sortDir == null || !"desc".equalsIgnoreCase(sortDir);
                groupDataList.sort((a, b) -> {
                    Comparable va = (Comparable) a.get(sortBy);
                    Comparable vb = (Comparable) b.get(sortBy);
                    if (va == null && vb == null) return 0;
                    if (va == null) return asc ? 1 : -1;
                    if (vb == null) return asc ? -1 : 1;
                    return asc ? va.compareTo(vb) : vb.compareTo(va);
                });
            }

            boolean wantJson = "application/json".equals(request.getHeader("Accept")) ||
                               "json".equalsIgnoreCase(request.getParameter("format"));

            if (wantJson) {
                response.setContentType("application/json; charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.print(toJson(groupDataList, stats, farmDataList));
            } else {
                request.setAttribute("groups", groupDataList);
                request.setAttribute("stats", stats);
                request.setAttribute("isOwner", isOwner);
                request.getRequestDispatcher("/web/containers/farmer/chicken-group/chicken-group.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // ---------- Unified toJson method ----------
    private String toJson(List<Map<String, Object>> groups,
                          Map<String, Object> stats,
                          List<Map<String, Object>> farms) {
        StringBuilder sb = new StringBuilder("{");

        // GROUPS
        sb.append("\"groups\":[");
        for (int i = 0; i < groups.size(); i++) {
            Map<String, Object> g = groups.get(i);
            sb.append("{");
            for (String key : g.keySet()) {
                sb.append("\"").append(key).append("\":");
                Object val = g.get(key);
                if (val == null) sb.append("null");
                else if (val instanceof String) sb.append("\"").append(((String) val).replace("\"", "\\\"")).append("\"");
                else sb.append(val);
                sb.append(",");
            }
            if (!g.isEmpty()) sb.setLength(sb.length() - 1);
            sb.append("}");
            if (i < groups.size() - 1) sb.append(",");
        }
        sb.append("],");

        // FARMS
        sb.append("\"farms\":[");
        for (int i = 0; i < farms.size(); i++) {
            Map<String, Object> f = farms.get(i);
            sb.append("{");
            for (String key : f.keySet()) {
                sb.append("\"").append(key).append("\":");
                Object val = f.get(key);
                if (val == null) {
                    sb.append("null");
                } else {
                    sb.append("\"").append(val.toString().replace("\"", "\\\"")).append("\"");
                }
                sb.append(",");
            }
            if (!f.isEmpty()) sb.setLength(sb.length() - 1);
            sb.append("}");
            if (i < farms.size() - 1) sb.append(",");
        }
        sb.append("],");

        // STATS
        sb.append("\"stats\":{");
        for (String key : stats.keySet()) {
            sb.append("\"").append(key).append("\":").append(stats.get(key)).append(",");
        }
        if (!stats.isEmpty()) sb.setLength(sb.length() - 1);
        sb.append("}}");

        return sb.toString();
    }

    // ================== ADD ==================
    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            HttpSession session = request.getSession(false);
            Users currentUser = (Users) session.getAttribute("user");
            if (currentUser == null || !"farm_owner".equalsIgnoreCase(currentUser.getRole())) {
                out.print("{\"success\":false, \"message\":\"Only farm owners can add groups\"}");
                return;
            }

            ChickenGroup group = new ChickenGroup();
            // ID is auto‑generated by DB trigger – do not set
            populateGroupFromRequest(group, request);
            chickenGroupFacade.create(group);

            // ✅ AUTO‑SCHEDULE DEFAULT VACCINES
            createDefaultVaccinations(group);

            out.print("{\"success\":true, \"message\":\"Group created\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false, \"message\":\"" + e.getMessage() + "\"}");
        }
    }

    // ================== AUTO‑SCHEDULING METHODS ==================
    private void createDefaultVaccinations(ChickenGroup group) {
        String type = group.getType() != null ? group.getType().toLowerCase() : "";
        if (type.equals("layer")) {
            addVaccineIfNotExists(group, "Marek's Disease", "Marek's Disease", 1);
            addVaccineIfNotExists(group, "Newcastle Disease", "Newcastle Disease", 7);
            addVaccineIfNotExists(group, "Infectious Bronchitis", "Infectious Bronchitis", 14);
            addVaccineIfNotExists(group, "Gumboro", "Gumboro", 21);
            addVaccineIfNotExists(group, "Fowl Pox", "Fowl Pox", 56);
            addVaccineIfNotExists(group, "Avian Influenza", "Avian Influenza", 70);
        } else if (type.equals("broiler")) {
            addVaccineIfNotExists(group, "Newcastle Disease", "Newcastle Disease", 1);
            addVaccineIfNotExists(group, "Gumboro", "Gumboro", 7);
            addVaccineIfNotExists(group, "Infectious Bronchitis", "Infectious Bronchitis", 14);
        }
    }

    private void addVaccineIfNotExists(ChickenGroup group, String vaccineName, String disease, int ageDays) {
        List<Vaccination> existing = vaccinationFacade.findByChickenGroup(group.getId());
        boolean already = existing.stream().anyMatch(v ->
            v.getVaccineName() != null && v.getVaccineName().equalsIgnoreCase(vaccineName)
        );
        if (!already) {
            Vaccination v = new Vaccination();
            v.setChickenGroup(group);
            v.setVaccineName(vaccineName);
            v.setDisease(disease);
            v.setAgeDays(ageDays);
            if (group.getReceiveDate() != null) {
                Calendar cal = Calendar.getInstance();
                cal.setTime(group.getReceiveDate());
                cal.add(Calendar.DAY_OF_MONTH, ageDays);
                v.setDueDate(cal.getTime());
            }
            v.setStatus("pending");
            v.setAlertActive(true);
            v.setReminderDays(7);
            vaccinationFacade.create(v);
        }
    }

    // ================== UPDATE ==================
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            HttpSession session = request.getSession(false);
            Users currentUser = (Users) session.getAttribute("user");
            if (currentUser == null || !"farm_owner".equalsIgnoreCase(currentUser.getRole())) {
                out.print("{\"success\":false, \"message\":\"Only farm owners can edit groups\"}");
                return;
            }

            BigDecimal id = new BigDecimal(request.getParameter("id"));
            ChickenGroup group = chickenGroupFacade.find(id);
            if (group == null) {
                out.print("{\"success\":false, \"message\":\"Group not found\"}");
                return;
            }
            populateGroupFromRequest(group, request);
            chickenGroupFacade.edit(group);
            out.print("{\"success\":true, \"message\":\"Group updated\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false, \"message\":\"" + e.getMessage() + "\"}");
        }
    }

    // ================== DELETE ==================
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            HttpSession session = request.getSession(false);
            Users currentUser = (Users) session.getAttribute("user");
            if (currentUser == null || !"farm_owner".equalsIgnoreCase(currentUser.getRole())) {
                out.print("{\"success\":false, \"message\":\"Only farm owners can delete groups\"}");
                return;
            }

            BigDecimal id = new BigDecimal(request.getParameter("id"));
            ChickenGroup group = chickenGroupFacade.find(id);
            if (group != null) {
                chickenGroupFacade.remove(group);
                out.print("{\"success\":true, \"message\":\"Group deleted\"}");
            } else {
                out.print("{\"success\":false, \"message\":\"Group not found\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false, \"message\":\"" + e.getMessage() + "\"}");
        }
    }

    // ================== HELPERS ==================
    private void populateGroupFromRequest(ChickenGroup group, HttpServletRequest request) {
        group.setName(request.getParameter("groupName"));
        group.setType(request.getParameter("type"));

        String qty = request.getParameter("quantity");
        if (qty != null && !qty.isEmpty()) group.setQuantity(new BigInteger(qty));

        String cost = request.getParameter("cost");
        if (cost != null && !cost.isEmpty()) group.setCost(new BigDecimal(cost));

        String receiveAge = request.getParameter("receiveAge");
        if (receiveAge != null && !receiveAge.isEmpty()) group.setReceiveAge(new BigInteger(receiveAge));

        String currentAge = request.getParameter("currentAge");
        if (currentAge != null && !currentAge.isEmpty()) group.setCurrentAge(new BigInteger(currentAge));

        String receiveDate = request.getParameter("receiveDate");
        if (receiveDate != null && !receiveDate.isEmpty()) {
            try { group.setReceiveDate(new SimpleDateFormat("yyyy-MM-dd").parse(receiveDate)); } catch (Exception ignored) {}
        }

        group.setOrigin(request.getParameter("origin"));

        // Farm assignment
        String farmIdStr = request.getParameter("farmId");
        if (farmIdStr != null && !farmIdStr.isEmpty()) {
            PoultryFarm farm = farmFacade.find(new BigDecimal(farmIdStr));
            group.setFarmId(farm);
        }
    }
}