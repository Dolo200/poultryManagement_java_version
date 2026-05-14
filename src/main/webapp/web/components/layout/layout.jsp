<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>layout</title>
         
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    
        <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    
    <!-- Chart.js for Analytics -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script src="../../../assets/js/d1content.js" type="text/javascript"></script>
    <link href="../../../assets/css/d1content.css" rel="stylesheet" type="text/css"/>
</head>
<body class="bg-gray-50 dark:bg-gray-900">

    <!-- Toolbar -->
    <jsp:include page="../toolbar/toolbar.jsp" />
    
    <!-- Sidebar -->
    <jsp:include page="../sidebar/sidebar.jsp" />
   
    <!-- Main Area -->
    <div class="flex-1 flex flex-col">

       <!-- Dynamic Content -->
        <main class="p-6">
           <%
    String contentPage = request.getParameter("d1contentPage");
    if (contentPage != null) {
%>

    <jsp:include page="<%= contentPage %>" />

<%
    }
%>
        </main>

    </div>

</body>
</html>

