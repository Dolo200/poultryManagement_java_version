<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PoultryPro - Farm Map</title>
    
        <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
</head>
<body class="bg-gray-50">

    <!-- ===== LAYOUT (sidebar + navbar) ===== -->
    <%@ include file="../../../components/layout/layout2.0.jsp" %>

    <div id="mainContent" class="transition-all duration-300" style="margin-left: 280px; padding-top: 64px;">
        <div class="container mx-auto px-6 py-8">

            <!-- Navigation & Controls (unchanged) -->
            <div class="bg-white rounded-2xl shadow-lg mb-6 p-6 flex flex-wrap items-center gap-4">
                <a href="farms.jsp" class="p-2 rounded-lg hover:bg-gray-100"><i class="fas fa-arrow-left"></i></a>
                <h2 class="text-xl font-semibold text-green-500">Farm Map</h2>

                <select id="farmSelect" class="border border-gray-300 rounded-lg px-3 py-2 min-w-[200px]">
                    <option value="">Select Farm to Geolocalize</option>
                    <c:forEach items="${farms}" var="farm">
                        <option value="${farm.id}">${farm.farmName}</option>
                    </c:forEach>
                </select>

                <select id="regionFilter" class="border border-gray-300 rounded-lg px-3 py-2">
                    <option value="">All Regions</option>
                    <c:forEach items="${regions}" var="region">
                        <option value="${region}">${region}</option>
                    </c:forEach>
                </select>

                <button id="addLocationBtn" class="bg-green-500 text-white px-4 py-2 rounded-lg hover:bg-green-600 disabled:opacity-50" disabled>
                    <i class="fas fa-map-marker-alt mr-2"></i>Add Location
                </button>

                <div class="flex items-center gap-2 ml-auto">
                    <label class="inline-flex items-center gap-1 text-sm">
                        <input type="checkbox" id="filterWithLocation" class="rounded"> With Location
                    </label>
                    <label class="inline-flex items-center gap-1 text-sm">
                        <input type="checkbox" id="filterWithoutLocation" class="rounded"> Without Location
                    </label>
                </div>

                <form class="flex items-center border rounded-lg px-2 ml-auto" onsubmit="return false;">
                    <i class="fas fa-search text-gray-400"></i>
                    <input type="text" id="searchInput" placeholder="Search farms..." class="p-2 outline-none w-full">
                    <button type="button" onclick="clearSearch()" class="text-gray-400 hover:text-gray-600 ml-1">✕</button>
                </form>
            </div>

            <!-- Map Container -->
            <div id="map" class="rounded-2xl shadow-lg" style="height: calc(100vh - 250px);"></div>

        </div>
    </div>

    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        // ===== STEP 1: Build farms array using EL (these  are JSP EL, perfectly fine) =====
        window.farms = [];
        <c:forEach items="${farms}" var="farm">
            window.farms.push({
                id: "${farm.id}",
                farmName: "${farm.farmName}",
                latitude: ${farm.latitude},
                longitude: ${farm.longitude},
                address: "${farm.address}",
                region: "${farm.region}",
                pinColor: "${not empty farm.pinColor ? farm.pinColor : 'blue'}",
                chickenGroups: [
                    <c:forEach items="${farm.chickenGroups}" var="group" varStatus="s">
                        { groupName: "${group.groupName}", image: "${group.image}" }${!s.last ? ',' : ''}
                    </c:forEach>
                ],
                staffNames: [
                    <c:forEach items="${farm.staffNames}" var="staff" varStatus="s">
                        "${staff}"${!s.last ? ',' : ''}
                    </c:forEach>
                ],
                canEdit: ${sessionScope.role ne 'staff'}
            });
        </c:forEach>

        // ===== STEP 2: Pure JavaScript from here (all $ escaped with \ so JSP leaves them alone) =====
        const map = L.map('map').setView([0, 0], 2);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);

        function createIcon(color, imageUrl) {
            // Use backticks – but because this is in a JSP, we must escape the opening $ of template expressions
            const svg = `\u003csvg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" width="48" height="72"\u003e
                \u003cpath fill="\${color}" d="M172.268 501.67C26.97 291.031 0 269.413 0 192 0 85.961 85.961 0 192 0s192 85.961 192 192c0 77.413-26.97 99.031-172.268 309.67-9.535 13.774-29.93 13.773-39.464 0z"/\u003e
                \u003ccircle cx="192" cy="192" r="80" fill="white"/\u003e
                \${imageUrl ? \u0060\u003cimage href="\${imageUrl}" x="112" y="112" width="160" height="160" clip-path="circle(80 at 192 192)"/\u003e\u0060 : ''}
            \u003c/svg\u003e`;
            return L.icon({
                iconUrl: 'data:image/svg+xml;base64,' + btoa(svg),
                iconSize: [48, 72],
                iconAnchor: [24, 72],
                popupAnchor: [0, -72]
            });
        }

        // Add markers and popups using JavaScript data (no EL inside popup strings)
        const markers = {};
        window.farms.forEach(farm => {
            if (farm.latitude && farm.longitude) {
                const icon = createIcon(farm.pinColor, farm.chickenGroups?.[0]?.image);
                const marker = L.marker([farm.latitude, farm.longitude], { icon: icon }).addTo(map);

                // Build popup HTML with escaped dollar signs so JSP does NOT interpret them as EL
                const popupContent = `
                    <div style="padding:8px">
                        <h3 style="text-align:center; font-weight:bold; margin-bottom:8px">\${farm.farmName}</h3>
                        <p><strong>Address:</strong> \${farm.address}</p>
                        <p><strong>Region:</strong> \${farm.region || 'N/A'}</p>
                        <p><strong>Chicken Groups:</strong> \${farm.chickenGroups?.map(g => g.groupName).join(', ') || 'None'}</p>
                        <p><strong>Staff:</strong> \${farm.staffNames?.join(', ') || 'None'}</p>
                        \${farm.canEdit ? \u0060\u003cbutton onclick="deletePin('\${farm.id}')" class="bg-red-500 text-white px-3 py-1 rounded mt-2"\u003eDelete Location\u003c/button\u003e\u0060 : ''}
                    </div>
                `;
                marker.bindPopup(popupContent);
                markers[farm.id] = marker;
            }
        });

        // Zoom to all markers
        const group = L.featureGroup(Object.values(markers));
        if (group.getBounds().isValid()) map.fitBounds(group.getBounds().pad(0.1));

        // Event handlers
        document.getElementById('farmSelect').addEventListener('change', e => {
            const id = e.target.value;
            if (id && markers[id]) {
                map.setView(markers[id].getLatLng(), 15);
            }
        });

        document.getElementById('addLocationBtn').addEventListener('click', () => {
            const farmId = document.getElementById('farmSelect').value;
            if (!farmId) { alert('Please select a farm'); return; }
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(pos => {
                    const { latitude, longitude } = pos.coords;
                    fetch('updateFarmLocation', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: `id=\${farmId}&latitude=\${latitude}&longitude=\${longitude}`
                    }).then(() => location.reload());
                }, () => alert('Unable to retrieve location'));
            }
        });

        function deletePin(farmId) {
            if (confirm('Delete location for this farm?')) {
                fetch('deleteFarmLocation?id=' + farmId, { method: 'POST' }).then(() => location.reload());
            }
        }

        // Search filtering
        document.getElementById('searchInput').addEventListener('input', e => {
            const term = e.target.value.toLowerCase();
            Object.entries(markers).forEach(([id, marker]) => {
                const farm = window.farms.find(f => f.id === id);
                if (farm && (farm.farmName.toLowerCase().includes(term) || farm.address.toLowerCase().includes(term))) {
                    marker.addTo(map);
                } else {
                    map.removeLayer(marker);
                }
            });
        });
    </script>
</body>
</html>