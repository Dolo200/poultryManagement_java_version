package controllers;

import dao.FeedConsumptionFacade;
import dao.ChickenGroupFacade;
import dao.UsersFacade;
import dao.FarmStaffFacade;
import models.FeedConsumption;
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

@WebServlet(name = "FeedConsumptionServlet",
            urlPatterns = {"/feed/records", "/feed/addFeed",
                           "/feed/updateFeed", "/feed/deleteFeed"})
public class FeedConsumptionServlet extends HttpServlet {

    @EJB private FeedConsumptionFacade feedFacade;
    @EJB private ChickenGroupFacade chickenGroupFacade;
    @EJB private UsersFacade usersFacade;
    @EJB private FarmStaffFacade farmStaffFacade;

    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/feed/deleteFeed".equals(path)) {
            handleDelete(request, response);
        } else {
            handleList(request, response);
        }
    }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/feed/addFeed": handleAdd(request, response); break;
            case "/feed/updateFeed": handleUpdate(request, response); break;
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
        List<ChickenGroup> accessibleGroups = getAccessibleChickenGroups(currentUser);
        List<BigDecimal> groupIds = accessibleGroups.stream().map(ChickenGroup::getId).collect(Collectors.toList());

        List<FeedConsumption> feeds = groupIds.isEmpty() ? Collections.emptyList()
                : feedFacade.findByChickenGroupIds(groupIds);

        List<Map<String, Object>> records = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // Helper to safely convert BigDecimal to double
        final java.util.function.Function<BigDecimal, Double> safeDouble = bd -> bd != null ? bd.doubleValue() : 0.0;

        for (FeedConsumption f : feeds) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", f.getId().toString());
            map.put("flockName", f.getFlock() != null ? f.getFlock().getName() : null);
            map.put("flockId", f.getFlock() != null ? f.getFlock().getId().toString() : null);
            map.put("feedBatchId", f.getFeedBatchId());
            map.put("feedName", f.getFeedName());
            map.put("deliveryDate", f.getDeliveryDate() != null ? sdf.format(f.getDeliveryDate()) : null);
            map.put("quantityPerDelivery", safeDouble.apply(f.getQuantityPerDelivery()));
            map.put("crudeProtein", safeDouble.apply(f.getCrudeProtein()));
            map.put("costPerBag", safeDouble.apply(f.getCostPerBag()));
            map.put("consumptionPerDay", safeDouble.apply(f.getConsumptionPerDay()));
            map.put("notes", f.getNotes());
            records.add(map);
        }

        // Cumulative feed per flock (sum of quantityPerDelivery)
        Map<String, Double> cumulativeMap = new HashMap<>();
        for (FeedConsumption f : feeds) {
            if (f.getFlock() != null) {
                String flockName = f.getFlock().getName();
                double qty = safeDouble.apply(f.getQuantityPerDelivery());
                cumulativeMap.merge(flockName, qty, Double::sum);
            }
        }
        for (Map<String, Object> rec : records) {
            rec.put("cumulativeFeedKg", cumulativeMap.getOrDefault(rec.get("flockName"), 0.0));
        }

        // Stats
        double totalConsumption = records.stream().mapToDouble(r -> (double) r.get("consumptionPerDay")).sum();
        double totalQuantity = records.stream().mapToDouble(r -> (double) r.get("quantityPerDelivery")).sum();
        double avgProtein = records.stream().mapToDouble(r -> (double) r.get("crudeProtein")).average().orElse(0);
        long activeFlocks = records.stream().map(r -> r.get("flockId")).distinct().count();

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalConsumption", totalConsumption);
        stats.put("totalQuantity", totalQuantity);
        stats.put("avgProtein", avgProtein);
        stats.put("activeFlocks", activeFlocks);

        // ========== THIS PART WAS MISSING ==========
        // Flocks dropdown (all accessible groups)
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
            out.print(toJson(records, stats, flockList));
        } else {
            request.setAttribute("records", records);
            request.setAttribute("stats", stats);
            request.setAttribute("flockList", flockList);
            request.setAttribute("isOwner", "farm_owner".equalsIgnoreCase(currentUser.getRole()));
            request.getRequestDispatcher("/web/containers/farmer/feed/feed.jsp").forward(request, response);
        }
    } catch (Exception e) {
    response.setContentType("text/plain; charset=UTF-8");
    PrintWriter out = response.getWriter();
    out.println("Error: " + e.getClass().getName() + " – " + e.getMessage());
    out.println();
    e.printStackTrace(out);   // prints full stack trace to the browser
    // e.printStackTrace();   // also to server log
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

            FeedConsumption f = new FeedConsumption();
            populateFeedFromRequest(f, request);
            feedFacade.create(f);
            out.print("{\"success\":true, \"message\":\"Record created\"}");
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
            FeedConsumption f = feedFacade.find(id);
            if (f == null) {
                out.print("{\"success\":false, \"message\":\"Record not found\"}");
                return;
            }
            populateFeedFromRequest(f, request);
            feedFacade.edit(f);
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
            FeedConsumption f = feedFacade.find(id);
            if (f != null) {
                feedFacade.remove(f);
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

    // ==================== HELPERS ====================
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

    private void populateFeedFromRequest(FeedConsumption f, HttpServletRequest request) {
        String flockId = request.getParameter("flockId");
        if (flockId != null && !flockId.isEmpty()) {
            ChickenGroup cg = chickenGroupFacade.find(new BigDecimal(flockId));
            f.setFlock(cg);
        }
        f.setFeedBatchId(request.getParameter("feedBatchId"));
        f.setFeedName(request.getParameter("feedName"));
        String date = request.getParameter("deliveryDate");
        if (date != null && !date.isEmpty()) {
            try { f.setDeliveryDate(new SimpleDateFormat("yyyy-MM-dd").parse(date)); } catch (Exception ignored) {}
        }
        String qty = request.getParameter("quantityPerDelivery");
        if (qty != null && !qty.isEmpty()) f.setQuantityPerDelivery(new BigDecimal(qty));
        String protein = request.getParameter("crudeProtein");
        if (protein != null && !protein.isEmpty()) f.setCrudeProtein(new BigDecimal(protein));
        String cost = request.getParameter("costPerBag");
        if (cost != null && !cost.isEmpty()) f.setCostPerBag(new BigDecimal(cost));
        String consumption = request.getParameter("consumptionPerDay");
        if (consumption != null && !consumption.isEmpty()) f.setConsumptionPerDay(new BigDecimal(consumption));
        f.setNotes(request.getParameter("notes"));

        // Set current user
        HttpSession session = request.getSession(false);
        if (session != null) {
            Users currentUser = (Users) session.getAttribute("user");
            if (currentUser != null) f.setUserId(currentUser);
        }
    }

    private String escapeJson(String s) {
    if (s == null) return "";
    StringBuilder sb = new StringBuilder(s.length());
    for (int i = 0; i < s.length(); i++) {
        char c = s.charAt(i);
        switch (c) {
            case '\\': sb.append("\\\\"); break;
            case '"':  sb.append("\\\""); break;
            case '\n': sb.append("\\n"); break;
            case '\r': sb.append("\\r"); break;
            case '\t': sb.append("\\t"); break;
            default:   sb.append(c);
        }
    }
    return sb.toString();
}

    private String toJson(List<Map<String, Object>> records, Map<String, Object> stats, List<Map<String, String>> flocks) {
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"records\":");
        sb.append(jsonList(records));
        sb.append(",\"stats\":");
        sb.append(jsonMap(stats));
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
            else if (val instanceof List) {
                sb.append("[");
                List<?> list = (List<?>) val;
                for (int j = 0; j < list.size(); j++) {
                    sb.append(jsonMap((Map<String, ?>) list.get(j)));
                    if (j < list.size() - 1) sb.append(",");
                }
                sb.append("]");
            } else sb.append("\"").append(escapeJson(val.toString())).append("\"");
            sb.append(",");
        }
        if (!map.isEmpty()) sb.setLength(sb.length() - 1);
        return sb.append("}").toString();
    }
}