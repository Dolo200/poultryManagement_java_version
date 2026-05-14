<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="relative inline-block">
    <button id="sortFilterBtn" 
            class="flex items-center border border-gray-300 rounded-xl px-4 py-2 hover:bg-gray-50 dark:border-gray-600 dark:hover:bg-gray-800 text-gray-700 dark:text-gray-300">
        <i class="fas fa-filter mr-2"></i> Sort &amp; Filter
        <i class="fas fa-chevron-down ml-1"></i>
    </button>

    <div id="sortFilterDropdown" 
         class="absolute right-0 mt-2 w-80 md:w-96 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl shadow-xl z-50 hidden p-4">
        <div class="flex items-center justify-between mb-4 pb-3 border-b border-gray-200 dark:border-gray-700">
            <h3 class="text-lg font-semibold text-gray-800 dark:text-white">Sort &amp; Filter</h3>
            <button onclick="closeSortDropdown()" class="p-1 hover:bg-gray-100 dark:hover:bg-gray-700 rounded">
                <i class="fas fa-times text-gray-600 dark:text-gray-300"></i>
            </button>
        </div>

        <div class="mb-4">
            <label class="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2 block">Sort By</label>
            <select id="sortBySelect" class="w-full p-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                <option value="">No sorting</option>
            </select>
            <div id="sortDirectionGroup" class="mt-2 hidden flex gap-4">
                <label class="flex items-center gap-2 text-sm text-gray-700 dark:text-gray-300">
                    <input type="radio" name="sortDir" value="asc" class="text-blue-600" />
                    <i class="fas fa-arrow-up text-green-500"></i> Ascending
                </label>
                <label class="flex items-center gap-2 text-sm text-gray-700 dark:text-gray-300">
                    <input type="radio" name="sortDir" value="desc" class="text-blue-600" />
                    <i class="fas fa-arrow-down text-red-500"></i> Descending
                </label>
            </div>
        </div>

        <div>
            <h4 class="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">Filters</h4>
            <div id="filterList" class="space-y-2 max-h-60 overflow-y-auto"></div>
        </div>

        <div class="flex items-center justify-between pt-4 mt-4 border-t border-gray-200 dark:border-gray-700">
            <button onclick="clearSortFilter()" class="px-4 py-2 text-gray-600 dark:text-gray-300 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 text-sm">
                Clear All
            </button>
            <div class="flex gap-2">
                <button onclick="closeSortDropdown()" class="px-4 py-2 text-gray-700 dark:text-gray-300 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 text-sm">
                    Cancel
                </button>
                <button onclick="applySortFilter()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm">
                    Apply Filters
                </button>
            </div>
        </div>
    </div>
</div>

<script>
//    window.sortColumns = [
        <%--<c:forEach items="${sortColumns}" var="col" varStatus="s">--%>
//            {
//                key: "${col.key}",
//                type: "${col.type}",
//                label: "${col.label}"
//            }${!s.last ? ',' : ''}
        <%--</c:forEach>--%>
//    ];


               
    // 1. Try to use server-provided columns; otherwise fall back to defaults
    <c:choose>
        <c:when test="${not empty sortColumns}">
            window.sortColumns = [
                <c:forEach items="${sortColumns}" var="col" varStatus="s">
                    { key: "${col.key}", type: "${col.type}", label: "${col.label}" }${!s.last ? ',' : ''}
                </c:forEach>
            ];
        </c:when>
        <c:otherwise>
            // Default columns – adjust to match your typical farm fields
            window.sortColumns = [
                { key: "farmName", type: "text", label: "Farm Name" },
                { key: "address", type: "text", label: "Address" },
                { key: "size",    type: "number", label: "Size" },
                { key: "createdAt", type: "date", label: "Created" }
            ];
        </c:otherwise>
    </c:choose>

    



    document.getElementById('sortFilterBtn').addEventListener('click', () => {
        document.getElementById('sortFilterDropdown').classList.toggle('hidden');
    });

    window.closeSortDropdown = function() {
        document.getElementById('sortFilterDropdown').classList.add('hidden');
    };

    window.addEventListener('click', (e) => {
        const dropdown = document.getElementById('sortFilterDropdown');
        const btn = document.getElementById('sortFilterBtn');
        if (!dropdown.contains(e.target) && e.target !== btn && !btn.contains(e.target)) {
            dropdown.classList.add('hidden');
        }
    });

    document.addEventListener('DOMContentLoaded', () => {
        const columns = window.sortColumns || [];
        const sortSelect = document.getElementById('sortBySelect');
        columns.forEach(col => {
            const opt = document.createElement('option');
            opt.value = col.key;
            opt.textContent = col.label;
            sortSelect.appendChild(opt);
        });

        sortSelect.addEventListener('change', () => {
            document.getElementById('sortDirectionGroup').classList.toggle('hidden', !sortSelect.value);
        });

        const filterDiv = document.getElementById('filterList');
        columns.forEach(col => {
            const checked = new URLSearchParams(window.location.search).has('filter_' + col.key);
            const wrapper = document.createElement('div');
            wrapper.className = 'p-3 border border-gray-200 dark:border-gray-600 rounded-lg';

            const label = document.createElement('label');
            label.className = 'flex items-center gap-2 text-sm text-gray-700 dark:text-gray-300 cursor-pointer';
            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.className = 'filter-checkbox text-blue-600';
            checkbox.dataset.key = col.key;
            checkbox.checked = checked;
            label.appendChild(checkbox);

            const icon = document.createElement('i');
            const iconType = col.type === 'number' ? 'hashtag' : (col.type === 'date' ? 'calendar' : 'font');
            icon.className = 'fas fa-' + iconType + ' text-gray-400';
            label.appendChild(icon);
            label.appendChild(document.createTextNode(' ' + col.label));
            wrapper.appendChild(label);

            const valuesDiv = document.createElement('div');
            valuesDiv.className = 'filter-values mt-2 ' + (checked ? '' : 'hidden');
            valuesDiv.id = 'filter_' + col.key;
            wrapper.appendChild(valuesDiv);

            if (col.type === 'number') {
                const minInput = document.createElement('input');
                minInput.type = 'number';
                minInput.placeholder = 'Min';
                minInput.className = 'w-full p-1 border rounded mb-1 text-sm filter-min';
                minInput.dataset.key = col.key;
                valuesDiv.appendChild(minInput);

                const maxInput = document.createElement('input');
                maxInput.type = 'number';
                maxInput.placeholder = 'Max';
                maxInput.className = 'w-full p-1 border rounded text-sm filter-max';
                maxInput.dataset.key = col.key;
                valuesDiv.appendChild(maxInput);
            } else if (col.type === 'date') {
                const startInput = document.createElement('input');
                startInput.type = 'date';
                startInput.className = 'w-full p-1 border rounded mb-1 text-sm filter-start';
                startInput.dataset.key = col.key;
                valuesDiv.appendChild(startInput);

                const endInput = document.createElement('input');
                endInput.type = 'date';
                endInput.className = 'w-full p-1 border rounded text-sm filter-end';
                endInput.dataset.key = col.key;
                valuesDiv.appendChild(endInput);
            } else {
                const textInput = document.createElement('input');
                textInput.type = 'text';
                textInput.placeholder = 'Search...';
                textInput.className = 'w-full p-1 border rounded text-sm filter-value';
                textInput.dataset.key = col.key;
                valuesDiv.appendChild(textInput);
            }

            checkbox.addEventListener('change', () => {
                valuesDiv.classList.toggle('hidden', !checkbox.checked);
            });

            filterDiv.appendChild(wrapper);
        });

        const params = new URLSearchParams(window.location.search);
        const sortBy = params.get('sortBy');
        const sortDir = params.get('sortDir');
        if (sortBy) {
            sortSelect.value = sortBy;
            document.getElementById('sortDirectionGroup').classList.remove('hidden');
            const radio = document.querySelector('input[name="sortDir"][value="' + (sortDir || 'asc') + '"]');
            if (radio) radio.checked = true;
        }

        columns.forEach(col => {
            const key = col.key;
            if (col.type === 'number') {
                const min = params.get('filter_' + key + '_min');
                const max = params.get('filter_' + key + '_max');
                if (min) document.querySelector('.filter-min[data-key="' + key + '"]').value = min;
                if (max) document.querySelector('.filter-max[data-key="' + key + '"]').value = max;
            } else if (col.type === 'date') {
                const start = params.get('filter_' + key + '_start');
                const end = params.get('filter_' + key + '_end');
                if (start) document.querySelector('.filter-start[data-key="' + key + '"]').value = start;
                if (end) document.querySelector('.filter-end[data-key="' + key + '"]').value = end;
            } else {
                const val = params.get('filter_' + key);
                if (val) document.querySelector('.filter-value[data-key="' + key + '"]').value = val;
            }
        });
    });

    window.applySortFilter = function() {
        const sortBy = document.getElementById('sortBySelect').value;
        const sortDir = document.querySelector('input[name="sortDir"]:checked')?.value || 'asc';
        const params = new URLSearchParams();
        if (sortBy) {
            params.set('sortBy', sortBy);
            params.set('sortDir', sortDir);
        }
        document.querySelectorAll('.filter-checkbox:checked').forEach(cb => {
            const key = cb.dataset.key;
            const container = document.getElementById('filter_' + key);
            const col = window.sortColumns.find(c => c.key === key);
            if (!col) return;
            if (col.type === 'number') {
                const min = container.querySelector('.filter-min').value;
                const max = container.querySelector('.filter-max').value;
                if (min) params.set('filter_' + key + '_min', min);
                if (max) params.set('filter_' + key + '_max', max);
            } else if (col.type === 'date') {
                const start = container.querySelector('.filter-start').value;
                const end = container.querySelector('.filter-end').value;
                if (start) params.set('filter_' + key + '_start', start);
                if (end) params.set('filter_' + key + '_end', end);
            } else {
                const val = container.querySelector('.filter-value').value;
                if (val) params.set('filter_' + key, val);
            }
        });
        window.location.search = params.toString();
    };

    window.clearSortFilter = function() {
        window.location.search = '';
    };
</script>