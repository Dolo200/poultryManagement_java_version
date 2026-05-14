package controllers;

import dao.ChickenGroupFacade;
import dao.FarmStaffFacade;
import dao.PoultryFarmFacade;
import dao.UsersFacade;
import models.ChickenGroup;
import models.FarmStaff;
import models.PoultryFarm;
import models.Users;
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

@WebServlet(name = "FarmServlet",
            urlPatterns = {"/farm/farms", "/farm/addFarm", "/farm/updateFarm", "/farm/deleteFarm"})
public class FarmServlet extends HttpServlet {

    @EJB
    private PoultryFarmFacade farmFacade;
    @EJB
    private ChickenGroupFacade chickenGroupFacade;
    @EJB
    private FarmStaffFacade farmStaffFacade;
    @EJB
    private UsersFacade usersFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/farm/deleteFarm".equals(servletPath)) {
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
            case "/farm/addFarm":
                handleAdd(request, response);
                break;
            case "/farm/updateFarm":
                handleUpdate(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    // 1. Get the logged‑in user from the session (set by AuthServlet)
    HttpSession session = request.getSession(false);
    Users currentUser = (Users) (session != null ? session.getAttribute("user") : null);

    // If for some reason there is no user, show an empty list (the layout already redirects if not logged in)
    if (currentUser == null) {
        // Forward with empty data
        request.setAttribute("farms", Collections.emptyList());
        request.setAttribute("stats", new HashMap<>());
        request.setAttribute("flockList", Collections.emptyList());
        request.setAttribute("staffList", Collections.emptyList());
        request.setAttribute("sortColumns", Collections.emptyList());
        request.getRequestDispatcher("/web/containers/farmer/farm/farms.jsp").forward(request, response);
        return;
    }

    BigDecimal currentUserId = currentUser.getId();

    // 2. Fetch all data (still needed for dropdowns)
    List<PoultryFarm> allFarms = farmFacade.findAll();
    List<ChickenGroup> allGroups = chickenGroupFacade.findAll();
    List<Users> allUsers = usersFacade.findAll();

    // 3. Filter farms: keep only those where the logged‑in user is the owner (userId)
    List<PoultryFarm> userFarms = allFarms.stream()
            .filter(farm -> farm.getUserId() != null && farm.getUserId().getId().equals(currentUserId))
            .collect(Collectors.toList());

    // Staff list (all users with role "staff") remains unchanged for the dropdown
    List<Users> staffUsers = allUsers.stream()
            .filter(u -> "staff".equalsIgnoreCase(u.getRole()))
            .collect(Collectors.toList());

    // Build the farm data list using the FILTERED farms
    List<Map<String, Object>> farmDataList = new ArrayList<>();
    for (PoultryFarm farm : userFarms) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", farm.getId().toString());
        map.put("farmName", farm.getFarmName());
        map.put("address", farm.getAddress());
        map.put("size", farm.getArea() != null ? farm.getArea().intValue() : 0);
        map.put("pinColor", farm.getPinColor());

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        map.put("createdAt", farm.getCreatedAt() != null ? sdf.format(farm.getCreatedAt()) : null);

        List<ChickenGroup> farmGroups = farm.getChickenGroupList();
        List<Map<String, String>> groupMaps = new ArrayList<>();
        if (farmGroups != null) {
            for (ChickenGroup cg : farmGroups) {
                Map<String, String> gMap = new HashMap<>();
                gMap.put("id", cg.getId().toString());
                gMap.put("groupName", cg.getName());
                groupMaps.add(gMap);
            }
        }
        map.put("chickenGroups", groupMaps);

        // Owner is separate from staff; staff assignments are fetched from the FarmStaff table.
        List<String> staffNames = new ArrayList<>();
        List<String> managerIds = new ArrayList<>();
        Users owner = farm.getUserId();
        if (owner != null) {
            map.put("ownerName", owner.getName() != null ? owner.getName() : owner.getEmail());
            map.put("ownerId", owner.getId().toString());
        }
        if (farm.getFarmStaffList() != null) {
            for (FarmStaff assignment : farm.getFarmStaffList()) {
                if (assignment != null && assignment.getStaffId() != null) {
                    Users staff = assignment.getStaffId();
                    managerIds.add(staff.getId().toString());
                    staffNames.add(staff.getName() != null ? staff.getName() : staff.getEmail());
                }
            }
        }
        map.put("staffNames", staffNames);
        map.put("assignedManagerIds", managerIds);

        map.put("chickenGroupsJson", buildGroupsJson(groupMaps));
        map.put("assignedManagerIdsJson", buildIdsJson(managerIds));

        farmDataList.add(map);
    }

    // 4. Search & sorting (on the filtered list)
    String search = request.getParameter("search");
    if (search != null && !search.trim().isEmpty()) {
        String term = search.toLowerCase();
        farmDataList = farmDataList.stream()
                .filter(f -> matches(f, term))
                .collect(Collectors.toList());
    }

    String sortBy = request.getParameter("sortBy");
    String sortDir = request.getParameter("sortDir");
    if (sortBy != null && !sortBy.isEmpty()) {
        boolean asc = sortDir == null || !"desc".equalsIgnoreCase(sortDir);
        farmDataList.sort((a, b) -> compareByKey(a, b, sortBy, asc));
    }

    // 5. Stats (based on filtered list)
    Map<String, Object> stats = new HashMap<>();
    stats.put("total", farmDataList.size());
    stats.put("withGroups", farmDataList.stream().filter(f -> !((List) f.get("chickenGroups")).isEmpty()).count());
    stats.put("withStaff", farmDataList.stream().filter(f -> !((List) f.get("staffNames")).isEmpty()).count());
    stats.put("totalSize", farmDataList.stream()
            .mapToDouble(f -> ((Number) f.get("size")).doubleValue()).sum());

    // 6. Dropdown lists (all chicken groups, all staff users) – these are NOT filtered
    List<Map<String, String>> flockList = allGroups.stream().map(g -> {
        Map<String, String> m = new HashMap<>();
        m.put("id", g.getId().toString());
        m.put("groupName", g.getName());
        return m;
    }).collect(Collectors.toList());

    List<Map<String, String>> staffList = staffUsers.stream().map(u -> {
        Map<String, String> m = new HashMap<>();
        m.put("id", u.getId().toString());
        m.put("staffName", u.getName() != null ? u.getName() : u.getEmail());
        m.put("email", u.getEmail());
        return m;
    }).collect(Collectors.toList());

    List<Map<String, String>> sortColumns = Arrays.asList(
            Map.of("key", "farmName", "type", "text", "label", "Farm Name"),
            Map.of("key", "address", "type", "text", "label", "Address"),
            Map.of("key", "size", "type", "number", "label", "Size"),
            Map.of("key", "createdAt", "type", "date", "label", "Created")
    );

    // 7. Serve JSON or forward to JSP
    boolean wantJson = "application/json".equals(request.getHeader("Accept")) ||
            "json".equalsIgnoreCase(request.getParameter("format"));

    if (wantJson) {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(buildFullJson(farmDataList, stats, flockList, staffList));
    } else {
        request.setAttribute("farms", farmDataList);
        request.setAttribute("stats", stats);
        request.setAttribute("flockList", flockList);
        request.setAttribute("staffList", staffList);
        request.setAttribute("sortColumns", sortColumns);
        request.getRequestDispatcher("/web/containers/farmer/farm/farms.jsp").forward(request, response);
    }
}

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            // Get the logged-in user from session
            HttpSession session = request.getSession(false);
            Users currentUser = (Users) (session != null ? session.getAttribute("user") : null);
            if (currentUser == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"success\":false, \"message\":\"User not logged in\"}");
                return;
            }

            PoultryFarm farm = new PoultryFarm();
            // ID is no longer set here – database trigger/sequence will assign it
            farm.setCreatedAt(new Date());
            // Set the current logged-in user as the farm owner
            farm.setUserId(currentUser);
            populateFarmFromRequest(farm, request);
            farmFacade.create(farm);
            assignGroups(farm, request.getParameterValues("assignedFlock"));
            assignFarmStaff(farm, request.getParameterValues("assignedManager"));
            out.print("{\"success\":true, \"message\":\"Farm created\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false, \"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            BigDecimal id = new BigDecimal(request.getParameter("id"));
            PoultryFarm farm = farmFacade.find(id);
            if (farm == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\":false, \"message\":\"Farm not found\"}");
                return;
            }
            populateFarmFromRequest(farm, request);
            farmFacade.edit(farm);
            assignGroups(farm, request.getParameterValues("assignedFlock"));
            assignFarmStaff(farm, request.getParameterValues("assignedManager"));
            // Farm owner is not changed from assigned staff; staff assignment is tracked separately.
            out.print("{\"success\":true, \"message\":\"Farm updated\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false, \"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            BigDecimal id = new BigDecimal(request.getParameter("id"));
            PoultryFarm farm = farmFacade.find(id);
            if (farm != null) {
                farmFacade.remove(farm);
                out.print("{\"success\":true, \"message\":\"Farm deleted\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\":false, \"message\":\"Farm not found\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false, \"message\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    // ================== HELPERS ==================
    // generateFarmId() removed – ID is assigned by DB trigger

    private void populateFarmFromRequest(PoultryFarm farm, HttpServletRequest request) {
        farm.setFarmName(request.getParameter("farmName"));
        farm.setAddress(request.getParameter("address"));
        String areaStr = request.getParameter("size");
        if (areaStr != null && !areaStr.isEmpty()) {
            farm.setArea(new BigInteger(areaStr));
        } else {
            farm.setArea(null);
        }
        String pinColor = request.getParameter("pinColor");
        if (pinColor != null && !pinColor.isEmpty()) {
            farm.setPinColor(pinColor);
        }
    }

    private void assignGroups(PoultryFarm farm, String[] groupIds) {
        if (farm.getChickenGroupList() != null) {
            for (ChickenGroup cg : farm.getChickenGroupList()) {
                cg.setFarmId(null);
                chickenGroupFacade.edit(cg);
            }
        }
        if (groupIds != null) {
            for (String gid : groupIds) {
                if (gid == null || gid.trim().isEmpty()) continue;
                ChickenGroup group = chickenGroupFacade.find(new BigDecimal(gid));
                if (group != null) {
                    group.setFarmId(farm);
                    chickenGroupFacade.edit(group);
                }
            }
        }
    }

    private void assignFarmStaff(PoultryFarm farm, String[] staffIds) {
        // Remove existing farm staff assignments for this farm
        if (farm.getFarmStaffList() != null) {
            for (FarmStaff existingAssignment : new ArrayList<>(farm.getFarmStaffList())) {
                if (existingAssignment != null) {
                    farmStaffFacade.remove(existingAssignment);
                }
            }
            farm.setFarmStaffList(new ArrayList<>());
        }

        if (staffIds != null) {
            for (String sid : staffIds) {
                if (sid == null || sid.trim().isEmpty()) continue;
                Users staff = usersFacade.find(new BigDecimal(sid));
                if (staff != null) {
                    FarmStaff assignment = new FarmStaff(nextFarmStaffId());
                    assignment.setFarmId(farm);
                    assignment.setStaffId(staff);
                    farmStaffFacade.create(assignment);
                }
            }
        }
    }

    private BigDecimal nextFarmStaffId() {
        List<FarmStaff> allAssignments = farmStaffFacade.findAll();
        BigDecimal maxId = allAssignments.stream()
                .map(FarmStaff::getId)
                .filter(Objects::nonNull)
                .max(Comparator.naturalOrder())
                .orElse(BigDecimal.ZERO);
        return maxId.add(BigDecimal.ONE);
    }

    private boolean matches(Map<String, Object> farm, String term) {
        String name = (String) farm.get("farmName");
        String addr = (String) farm.get("address");
        String groups = farm.get("chickenGroups").toString().toLowerCase();
        String staff = farm.get("staffNames").toString().toLowerCase();
        return (name != null && name.toLowerCase().contains(term))
            || (addr != null && addr.toLowerCase().contains(term))
            || groups.contains(term)
            || staff.contains(term);
    }

    private int compareByKey(Map<String, Object> a, Map<String, Object> b, String key, boolean asc) {
        Comparable va = (Comparable) a.get(key);
        Comparable vb = (Comparable) b.get(key);
        if (va == null && vb == null) return 0;
        if (va == null) return asc ? 1 : -1;
        if (vb == null) return asc ? -1 : 1;
        int cmp = va.compareTo(vb);
        return asc ? cmp : -cmp;
    }

    private String buildGroupsJson(List<Map<String, String>> groupMaps) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < groupMaps.size(); i++) {
            Map<String, String> gm = groupMaps.get(i);
            sb.append("{\"id\":\"").append(gm.get("id"))
              .append("\",\"groupName\":\"").append(escapeJson(gm.get("groupName")))
              .append("\"}");
            if (i < groupMaps.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private String buildIdsJson(List<String> ids) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < ids.size(); i++) {
            sb.append("\"").append(ids.get(i)).append("\"");
            if (i < ids.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private String buildFullJson(List<Map<String, Object>> farms, Map<String, Object> stats,
                                 List<Map<String, String>> flockList, List<Map<String, String>> staffList) {
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"farms\":"); sb.append(buildSimpleJson(farms)); sb.append(",");
        sb.append("\"stats\":"); sb.append(buildSimpleJson(stats)); sb.append(",");
        sb.append("\"flockList\":"); sb.append(buildSimpleJson(flockList)); sb.append(",");
        sb.append("\"staffList\":"); sb.append(buildSimpleJson(staffList));
        sb.append("}");
        return sb.toString();
    }

    private String buildSimpleJson(Object obj) {
        if (obj == null) return "null";
        if (obj instanceof String) return "\"" + escapeJson((String) obj) + "\"";
        if (obj instanceof Number || obj instanceof Boolean) return obj.toString();
        if (obj instanceof Map) {
            Map<?,?> m = (Map<?,?>) obj;
            StringBuilder sb = new StringBuilder("{");
            boolean first = true;
            for (Map.Entry<?,?> e : m.entrySet()) {
                if (!first) sb.append(",");
                sb.append("\"").append(e.getKey().toString()).append("\":");
                sb.append(buildSimpleJson(e.getValue()));
                first = false;
            }
            sb.append("}");
            return sb.toString();
        }
        if (obj instanceof List) {
            List<?> list = (List<?>) obj;
            StringBuilder sb = new StringBuilder("[");
            boolean first = true;
            for (Object item : list) {
                if (!first) sb.append(",");
                sb.append(buildSimpleJson(item));
                first = false;
            }
            sb.append("]");
            return sb.toString();
        }
        return "\"[complex object]\"";
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}