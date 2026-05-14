<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="farmFormOverlay" class="fixed inset-0 bg-black/30 z-40 hidden transition-opacity duration-300" onclick="closeFarmForm()"></div>

<div id="farmFormPanel" class="fixed top-0 right-0 h-full w-full max-w-md bg-white dark:bg-gray-900 shadow-2xl z-50 transform translate-x-full transition-transform duration-300 ease-in-out flex flex-col">

    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gradient-to-r from-amber-50 to-emerald-50 dark:from-gray-800 dark:to-gray-900">
        <h2 class="text-xl font-bold text-gray-800 dark:text-white" id="farmFormTitle">Add Farm</h2>
        <button onclick="closeFarmForm()" class="p-2 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300">
            <i class="fas fa-times"></i>
        </button>
    </div>

    <div id="farmFormProgress" class="h-1 bg-gray-200 dark:bg-gray-700 hidden">
        <div class="h-full bg-amber-500 transition-all duration-500" style="width: 0%"></div>
    </div>

    <div class="flex-1 overflow-y-auto p-6 space-y-6">
        <form id="farmForm" onsubmit="submitFarmForm(event)">
            <input type="hidden" name="id" id="farmId" />
            <!-- NEW: current user ID – filled from session -->
            <input type="hidden" name="userId" id="userIdInput" value="${sessionScope.user.id}" />

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Farm Name</label>
                <input type="text" name="farmName" id="farmName" required
                       class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Address</label>
                <input type="text" name="address" id="farmAddress"
                       class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Size (acres)</label>
                <input type="number" name="size" id="farmSize" min="0" step="0.01"
                       class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Chicken Groups</label>
                <select name="assignedFlock" id="flockSelect" multiple size="4"
                        class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500">
                </select>
                <p class="text-xs text-gray-400 mt-1">Hold Ctrl/Cmd to select multiple</p>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Staff</label>
                <select name="assignedManager" id="staffSelect" multiple size="4"
                        class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500">
                </select>
                <p class="text-xs text-gray-400 mt-1">Hold Ctrl/Cmd to select multiple</p>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Pin Color</label>
                <div class="flex items-center space-x-3">
                    <input type="color" name="pinColor" id="pinColor" value="#3B82F6"
                           class="h-10 w-10 border border-gray-300 dark:border-gray-600 rounded cursor-pointer" />
                    <span class="text-sm text-gray-600 dark:text-gray-400">Click to choose</span>
                </div>
            </div>

            <div class="pt-4 border-t border-gray-200 dark:border-gray-700">
                <button type="submit" id="farmFormSubmitBtn"
                        class="w-full bg-gradient-to-r from-amber-500 to-amber-600 text-white py-3 rounded-lg font-semibold hover:shadow-lg transition-all disabled:opacity-50">
                    <span id="submitBtnText">Save Farm</span>
                    <span id="submitBtnSpinner" class="hidden"><i class="fas fa-spinner fa-spin ml-2"></i></span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    let isEditMode = false;

    // DOM refs
    const overlay = document.getElementById('farmFormOverlay');
    const panel = document.getElementById('farmFormPanel');
    const progressBarContainer = document.getElementById('farmFormProgress');
    const progressBar = progressBarContainer.querySelector('div');
    const form = document.getElementById('farmForm');
    const farmFormTitle = document.getElementById('farmFormTitle');
    const farmIdField = document.getElementById('farmId');
    const farmNameField = document.getElementById('farmName');
    const farmAddressField = document.getElementById('farmAddress');
    const farmSizeField = document.getElementById('farmSize');
    const flockSelect = document.getElementById('flockSelect');
    const staffSelect = document.getElementById('staffSelect');
    const pinColorField = document.getElementById('pinColor');
    const submitBtn = document.getElementById('farmFormSubmitBtn');
    const submitBtnText = document.getElementById('submitBtnText');
    const submitBtnSpinner = document.getElementById('submitBtnSpinner');
    const userIdInput = document.getElementById('userIdInput');

    window.openFarmForm = function(mode = 'add', farmData = null) {
        isEditMode = mode === 'edit';
        farmFormTitle.textContent = isEditMode ? 'Edit Farm' : 'Add Farm';

        // Reset
        form.reset();
        flockSelect.innerHTML = '';
        staffSelect.innerHTML = '';
        farmIdField.value = '';
        pinColorField.value = '#3B82F6';
        // userIdInput value is preserved from session, no need to reset

        // Populate dropdowns from global arrays (window.flocks, window.staffs)
        if (window.flocks) {
            window.flocks.forEach(f => {
                const opt = document.createElement('option');
                opt.value = f.id;
                opt.textContent = f.groupName;
                flockSelect.appendChild(opt);
            });
        }
        if (window.staffs) {
            window.staffs.forEach(s => {
                const opt = document.createElement('option');
                opt.value = s.id;
                opt.textContent = s.staffName || s.email;
                staffSelect.appendChild(opt);
            });
        }

        if (isEditMode && farmData) {
            farmIdField.value = farmData.id || '';
            farmNameField.value = farmData.farmName || '';
            farmAddressField.value = farmData.address || '';
            farmSizeField.value = farmData.size || '';
            if (farmData.pinColor) pinColorField.value = farmData.pinColor;

            // Pre-select flocks
            if (farmData.assignedFlocks && Array.isArray(farmData.assignedFlocks)) {
                Array.from(flockSelect.options).forEach(opt => {
                    opt.selected = farmData.assignedFlocks.some(f => f.id === opt.value || f.id === opt.value);
                });
            }
            // Pre-select staff
            if (farmData.assignedManager && Array.isArray(farmData.assignedManager)) {
                Array.from(staffSelect.options).forEach(opt => {
                    opt.selected = farmData.assignedManager.includes(opt.value);
                });
            }
        }

        overlay.classList.remove('hidden');
        panel.classList.remove('translate-x-full');
        document.body.style.overflow = 'hidden';
    };

    window.closeFarmForm = function() {
        overlay.classList.add('hidden');
        panel.classList.add('translate-x-full');
        document.body.style.overflow = '';
    };

    overlay.addEventListener('click', window.closeFarmForm);

    async function submitFarmForm(e) {
        e.preventDefault();
        const selectedFlocks = Array.from(flockSelect.selectedOptions).map(opt => opt.value);
        const selectedStaffs = Array.from(staffSelect.selectedOptions).map(opt => opt.value);

        // Build form data – include the hidden userId
        const formData = {
            id: farmIdField.value,
            userId: userIdInput.value,          // <-- current user ID
            farmName: farmNameField.value,
            address: farmAddressField.value,
            size: farmSizeField.value ? parseFloat(farmSizeField.value) : null,
            assignedFlock: selectedFlocks,
            assignedManager: selectedStaffs,
            pinColor: pinColorField.value
        };

        progressBarContainer.classList.remove('hidden');
        submitBtn.disabled = true;
        submitBtnText.textContent = 'Saving...';
        submitBtnSpinner.classList.remove('hidden');

        let progress = 0;
        const progressInterval = setInterval(() => {
            progress += 10;
            if (progress > 90) clearInterval(progressInterval);
            progressBar.style.width = progress + '%';
        }, 200);

        try {
            const url = isEditMode ? window.contextPath + '/farm/updateFarm' : window.contextPath + '/farm/addFarm';
            const response = await fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({
                    ...formData,
                    assignedFlock: formData.assignedFlock.join(','),
                    assignedManager: formData.assignedManager.join(',')
                })
            });

            clearInterval(progressInterval);
            const result = await response.json();

            if (result.success) {
                progressBar.style.width = '100%';
                if (window.refreshFarmList) await window.refreshFarmList();
                setTimeout(() => {
                    closeFarmForm();
                    progressBarContainer.classList.add('hidden');
                    progressBar.style.width = '0%';
                    submitBtn.disabled = false;
                    submitBtnText.textContent = 'Save Farm';
                    submitBtnSpinner.classList.add('hidden');
                }, 400);
            } else {
                throw new Error(result.message || 'Unknown error');
            }
        } catch (error) {
            clearInterval(progressInterval);
            alert('Error: ' + error.message);
            progressBarContainer.classList.add('hidden');
            progressBar.style.width = '0%';
            submitBtn.disabled = false;
            submitBtnText.textContent = 'Save Farm';
            submitBtnSpinner.classList.add('hidden');
        }
    }
</script>