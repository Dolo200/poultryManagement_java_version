<%-- 
    Document   : landingpage
    Created on : Mar 18, 2026, 11:24:07 AM
    Author     : Administrator
--%>

 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PoultryPro</title>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- AOS Animation Library -->
    <link href="https://unpkg.com/aos@2.3.4/dist/aos.css" rel="stylesheet">

</head>
<body class="bg-gray-50">
    
  
    <jsp:include page="../components/landingPageComponent/navbar.jsp" />
    <jsp:include page="../components/landingPageComponent/hero.jsp" />
    <jsp:include page="../components/landingPageComponent/stats.jsp" />
    <jsp:include page="../components/landingPageComponent/features.jsp" />
    <jsp:include page="../components/landingPageComponent/testimonials.jsp" />
    <jsp:include page="../components/landingPageComponent/cta.jsp" />
    <jsp:include page="../components/landingPageComponent/footer.jsp" />

    <!-- AOS Script -->
    <script src="https://unpkg.com/aos@2.3.4/dist/aos.js"></script>
    <script>
        AOS.init();
    </script>

</body>
</html>