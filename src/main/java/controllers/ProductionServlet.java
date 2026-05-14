package controllers;

import dao.InventoryProductFacade;
import dao.ChickenGroupFacade;
import dao.UsersFacade;
import dao.FarmStaffFacade;
import models.InventoryProduct;
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

@WebServlet(name = "ProductionServlet",
            urlPatterns = {"/production/records", "/production/addProduct",
                           "/production/updateProduct", "/production/deleteProduct",
                           "/production/decreaseQuantity"})
public class ProductionServlet extends HttpServlet {

    @EJB private InventoryProductFacade inventoryFacade;
    @EJB private ChickenGroupFacade chickenGroupFacade;
    @EJB private UsersFacade usersFacade;
    @EJB private FarmStaffFacade farmStaffFacade;

    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/production/deleteProduct".equals(path)) {
            handleDelete(request, response);
        } else {
            handleList(request, response);
        }
    }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/production/addProduct": handleAdd(request, response); break;
            case "/production/updateProduct": handleUpdate(request, response); break;
            case "/production/decreaseQuantity": handleDecreaseQuantity(request, response); break;
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

            List<InventoryProduct> products = groupIds.isEmpty() ? Collections.emptyList()
                    : inventoryFacade.findByChickenGroupIds(groupIds);

            // Build list with computed cumulative
            List<Map<String, Object>> records = new ArrayList<>();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            for (InventoryProduct p : products) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", p.getId().toString());
                map.put("productname", p.getProductName());
                map.put("flockname", p.getChickenGroup() != null ? p.getChickenGroup().getName() : null);
                map.put("flockId", p.getChickenGroup() != null ? p.getChickenGroup().getId().toString() : null);
                map.put("type", p.getType());
                map.put("cost", p.getCost() != null ? p.getCost().doubleValue() : 0.0);
                map.put("initialquantity", p.getInitialQuantity());
                map.put("availablequantity", p.getAvailableQuantity());
                map.put("description", p.getDescription());
                map.put("storagelocation", p.getStorageLocation());
                map.put("registerdate", p.getRegisterDate() != null ? sdf.format(p.getRegisterDate()) : null);
                records.add(map);
            }

            // Compute flockCumulative (sum of initialQuantity per flock)
            Map<String, Integer> flockCumulativeMap = new HashMap<>();
            for (InventoryProduct p : products) {
                if (p.getChickenGroup() != null) {
                    String flockName = p.getChickenGroup().getName();
                    flockCumulativeMap.merge(flockName, p.getInitialQuantity(), Integer::sum);
                }
            }
            for (Map<String, Object> rec : records) {
                rec.put("flockCumulative", flockCumulativeMap.getOrDefault(rec.get("flockname"), 0));
            }

            // Stats
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalProducts", records.size());
            stats.put("totalInitial", records.stream().mapToInt(r -> (int) r.get("initialquantity")).sum());
            stats.put("totalAvailable", records.stream().mapToInt(r -> (int) r.get("availablequantity")).sum());

            // Flocks dropdown
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
                request.getRequestDispatcher("/web/containers/farmer/production/production.jsp").forward(request, response);
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
                out.print("{\"success\":false, \"message\":\"Only farm owners can add products\"}");
                return;
            }

            InventoryProduct p = new InventoryProduct();
            populateProductFromRequest(p, request, true);
            inventoryFacade.create(p);
            out.print("{\"success\":true, \"message\":\"Product created\"}");
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
            InventoryProduct p = inventoryFacade.find(id);
            if (p == null) {
                out.print("{\"success\":false, \"message\":\"Product not found\"}");
                return;
            }
            populateProductFromRequest(p, request, false);
            inventoryFacade.edit(p);
            out.print("{\"success\":true, \"message\":\"Product updated\"}");
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
            InventoryProduct p = inventoryFacade.find(id);
            if (p != null) {
                inventoryFacade.remove(p);
                out.print("{\"success\":true, \"message\":\"Product deleted\"}");
            } else {
                out.print("{\"success\":false, \"message\":\"Product not found\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if (msg == null) msg = "Unknown error";
            out.print("{\"success\":false, \"message\":\"" + escapeJson(msg) + "\"}");
        }
    }

    // ==================== DECREASE QUANTITY ====================
    private void handleDecreaseQuantity(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            BigDecimal id = new BigDecimal(request.getParameter("id"));
            int qtyToRemove = Integer.parseInt(request.getParameter("quantity"));
            InventoryProduct p = inventoryFacade.find(id);
            if (p == null) {
                out.print("{\"success\":false, \"message\":\"Product not found\"}");
                return;
            }
            if (p.getAvailableQuantity() < qtyToRemove) {
                out.print("{\"success\":false, \"message\":\"Insufficient available quantity\"}");
                return;
            }
            p.setAvailableQuantity(p.getAvailableQuantity() - qtyToRemove);
            inventoryFacade.edit(p);
            out.print("{\"success\":true, \"message\":\"Quantity decreased\"}");
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

    private void populateProductFromRequest(InventoryProduct p, HttpServletRequest request, boolean isNew) {
        p.setProductName(request.getParameter("productname"));
        String flockId = request.getParameter("flockId");
        if (flockId != null && !flockId.isEmpty()) {
            ChickenGroup cg = chickenGroupFacade.find(new BigDecimal(flockId));
            p.setChickenGroup(cg);
        }
        p.setType(request.getParameter("type"));
        String cost = request.getParameter("cost");
        if (cost != null && !cost.isEmpty()) p.setCost(new BigDecimal(cost));
        String initQty = request.getParameter("initialquantity");
        if (initQty != null && !initQty.isEmpty()) {
            int qty = Integer.parseInt(initQty);
            p.setInitialQuantity(qty);
            if (isNew) p.setAvailableQuantity(qty);
        }
        p.setDescription(request.getParameter("description"));
        p.setStorageLocation(request.getParameter("storagelocation"));
        String date = request.getParameter("registerdate");
        if (date != null && !date.isEmpty()) {
            try { p.setRegisterDate(new SimpleDateFormat("yyyy-MM-dd").parse(date)); } catch (Exception ignored) {}
        }
        HttpSession session = request.getSession(false);
        if (session != null) {
            Users currentUser = (Users) session.getAttribute("user");
            if (currentUser != null) p.setUserId(currentUser);
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
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