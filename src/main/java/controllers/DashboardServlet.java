package controllers;

import dao.ChickenGroupFacade;
import dao.PoultryFarmFacade;
import dao.UsersFacade;
import dao.FarmStaffFacade;
import dao.InventoryProductFacade;
import models.ChickenGroup;
import models.PoultryFarm;
import models.Users;
import models.FarmStaff;
import models.InventoryProduct;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @EJB private PoultryFarmFacade farmFacade;
    @EJB private ChickenGroupFacade chickenGroupFacade;
    @EJB private UsersFacade usersFacade;
    @EJB private FarmStaffFacade farmStaffFacade;
    @EJB private InventoryProductFacade productFacade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users currentUser = (Users) (session != null ? session.getAttribute("user") : null);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/web/containers/auth/login.jsp");
            return;
        }

        try {
            // ----- Farms accessible by the user -----
            List<PoultryFarm> userFarms;
            if ("farm_owner".equalsIgnoreCase(currentUser.getRole())) {
                userFarms = farmFacade.findAll().stream()
                        .filter(f -> f.getUserId() != null && f.getUserId().getId().equals(currentUser.getId()))
                        .collect(Collectors.toList());
            } else {
                List<FarmStaff> assignments = farmStaffFacade.findByStaff(currentUser);
                userFarms = assignments.stream()
                        .map(FarmStaff::getFarmId)
                        .filter(Objects::nonNull)
                        .distinct()
                        .collect(Collectors.toList());
            }
            int totalFarms = userFarms.size();

            // ----- Chicken groups (flocks) -----
            List<BigDecimal> farmIds = userFarms.stream().map(PoultryFarm::getId).collect(Collectors.toList());
            List<ChickenGroup> allGroups = farmIds.isEmpty()
                    ? Collections.emptyList()
                    : chickenGroupFacade.findByFarmIds(farmIds);
            int totalFlocks = allGroups.size();

            // ----- Staff members (users with role "staff" assigned to these farms) -----
            Set<BigDecimal> staffIds = new HashSet<>();
            for (PoultryFarm farm : userFarms) {
                if (farm.getFarmStaffList() != null) {
                    for (FarmStaff fs : farm.getFarmStaffList()) {
                        if (fs.getStaffId() != null) staffIds.add(fs.getStaffId().getId());
                    }
                }
            }
            int totalStaff = staffIds.size();

            // ----- Products (inventory) -----
            List<BigDecimal> groupIds = allGroups.stream().map(ChickenGroup::getId).collect(Collectors.toList());
            List<InventoryProduct> products = groupIds.isEmpty()
                    ? Collections.emptyList()
                    : productFacade.findByChickenGroupIds(groupIds);
            int totalProducts = products.size();

            // ----- Recent activity (last 5 flocks by receive date) -----
            List<ChickenGroup> recentFlocks = allGroups.stream()
                    .sorted(Comparator.comparing(ChickenGroup::getReceiveDate, Comparator.nullsLast(Comparator.reverseOrder())))
                    .limit(5)
                    .collect(Collectors.toList());

            // Chart data (static for now – you can compute real values later)
            String revenueLabels = "['Mon','Tue','Wed','Thu','Fri','Sat','Sun']";
            String revenueData = "[120, 190, 300, 500, 200, 300, 450]";
            String ordersLabels = "['Mon','Tue','Wed','Thu','Fri','Sat','Sun']";
            String ordersData = "[5, 8, 12, 7, 10, 15, 9]";

            request.setAttribute("totalFarms", totalFarms);
            request.setAttribute("totalFlocks", totalFlocks);
            request.setAttribute("totalStaff", totalStaff);
            request.setAttribute("totalPostedGoods", totalProducts);  // reuse products as posted goods for now
            request.setAttribute("recentFlocks", recentFlocks);
            request.setAttribute("revenueLabels", revenueLabels);
            request.setAttribute("revenueData", revenueData);
            request.setAttribute("ordersLabels", ordersLabels);
            request.setAttribute("ordersData", ordersData);

            request.getRequestDispatcher("/web/containers/farmer/dashboard/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}