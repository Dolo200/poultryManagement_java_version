<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ===== OVERLAY + PANEL ===== -->
<div id="groupFormOverlay" class="fixed inset-0 bg-black/30 z-40 hidden transition-opacity duration-300" onclick="closeGroupForm()"></div>

<div id="groupFormPanel" class="fixed top-0 right-0 h-full w-full max-w-lg bg-white dark:bg-gray-900 shadow-2xl z-50 transform translate-x-full transition-transform duration-300 ease-in-out flex flex-col">

    <!-- Header -->
    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gradient-to-r from-amber-50 to-emerald-50 dark:from-gray-800 dark:to-gray-900">
        <h2 class="text-xl font-bold text-gray-800 dark:text-white" id="groupFormTitle">Add Chicken Group</h2>
        <button onclick="closeGroupForm()" class="p-2 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300">
            <i class="fas fa-times"></i>
        </button>
    </div>

    <!-- Progress bar -->
    <div id="groupFormProgress" class="h-1 bg-gray-200 dark:bg-gray-700 hidden">
        <div class="h-full bg-amber-500 transition-all duration-500" style="width: 0%"></div>
    </div>

    <!-- Form -->
    <div class="flex-1 overflow-y-auto p-6 space-y-6">
        <form id="groupForm" onsubmit="submitGroupForm(event)">   <!-- no enctype → URL encoded -->
            <input type="hidden" name="id" id="groupId" />

            <!-- ===== FARM SECTION ===== -->
            <div class="border border-gray-200 dark:border-gray-700 rounded-xl p-4">
                <h3 class="text-sm font-semibold text-gray-700 dark:text-gray-300 flex items-center gap-2 mb-3">
                    <i class="fas fa-tractor text-amber-500"></i> Farm Information
                </h3>
                <div class="space-y-3">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Select Farm</label>
                        <select name="farmId" id="farmSelect" required
                                class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500"
                                onchange="handleFarmChange(this.value)">
                            <option value="">-- Select a farm --</option>
                        </select>
                        <p id="farmError" class="text-red-500 text-xs mt-1 hidden"></p>
                    </div>
                    <div id="farmStats" class="bg-gray-50 dark:bg-gray-700/50 p-3 rounded-lg hidden space-y-2">
                        <p class="text-xs font-semibold text-gray-700 dark:text-gray-300">Farm Statistics:</p>
                        <div class="flex flex-wrap gap-2" id="farmStatsContent"></div>
                    </div>
                </div>
            </div>

            <!-- ===== BASIC INFO ===== -->
            <div class="border border-gray-200 dark:border-gray-700 rounded-xl p-4">
                <h3 class="text-sm font-semibold text-gray-700 dark:text-gray-300 flex items-center gap-2 mb-3">
                    <i class="fas fa-hashtag text-green-500"></i> Basic Information
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Group Name</label>
                        <input type="text" name="groupName" id="groupName" required
                               class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500"
                               placeholder="e.g., FARM-BROILER-001" />
                        <p class="text-xs text-gray-400 mt-1">Suggested names are auto‑generated</p>
                        <p id="groupNameError" class="text-red-500 text-xs mt-1 hidden"></p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Type</label>
                        <select name="type" id="typeSelect" required
                                class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500"
                                onchange="handleTypeChange(this.value)">
                            <option value="">-- Select type --</option>
                            <option value="broiler">Broiler (meat production)</option>
                            <option value="layer">Layer (egg production)</option>
                            <option value="parent">Parent Stock (breeding)</option>
                            <option value="other">Other</option>
                        </select>
                        <p id="typeError" class="text-red-500 text-xs mt-1 hidden"></p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Quantity</label>
                        <input type="number" name="quantity" id="quantity" min="1" step="1"
                               class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500"
                               placeholder="Number of chicks" />
                        <p id="quantityError" class="text-red-500 text-xs mt-1 hidden"></p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Total Cost ($)</label>
                        <input type="number" name="cost" id="cost" min="0" step="0.01"
                               class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500"
                               placeholder="0.00" />
                        <p id="costError" class="text-red-500 text-xs mt-1 hidden"></p>
                    </div>
                </div>
            </div>

            <!-- ===== ORIGIN & TIMELINE ===== -->
            <div class="border border-gray-200 dark:border-gray-700 rounded-xl p-4">
                <h3 class="text-sm font-semibold text-gray-700 dark:text-gray-300 flex items-center gap-2 mb-3">
                    <i class="fas fa-calendar text-orange-500"></i> Origin & Timeline
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Origin / Supplier</label>
                        <input type="text" name="origin" id="origin"
                               class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500"
                               placeholder="e.g., Hatchery name" />
                        <p id="originError" class="text-red-500 text-xs mt-1 hidden"></p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Receive Age (weeks)</label>
                        <input type="number" name="receiveAge" id="receiveAge" min="0" step="1"
                               class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500"
                               placeholder="0" />
                        <p id="receiveAgeError" class="text-red-500 text-xs mt-1 hidden"></p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Receive Date</label>
                        <input type="date" name="receiveDate" id="receiveDate"
                               class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-amber-500"
                               max="" />
                        <p id="receiveDateError" class="text-red-500 text-xs mt-1 hidden"></p>
                    </div>
                    <div>
                        <p class="text-xs text-gray-500 mt-2" id="timelineHint"></p>
                    </div>
                </div>
            </div>

            <!-- ===== IMAGE UPLOAD (commented out – no image sending yet) ===== -->
            <!--
            <div class="border border-gray-200 dark:border-gray-700 rounded-xl p-4">
                <h3 class="text-sm font-semibold text-gray-700 dark:text-gray-300 flex items-center gap-2 mb-3">
                    <i class="fas fa-upload text-purple-500"></i> Group Image
                </h3>
                <div class="flex flex-col items-center gap-3">
                    <div id="imagePreviewContainer" class="hidden w-full text-center">... </div>
                    <div id="imageEmptyState" class="...">...</div>
                    <label class="..."><i class="fas fa-upload mr-2"></i> Choose Image
                        <input type="file" id="groupImageFile" name="groupImageFile" accept="image/*" class="hidden" onchange="handleImageSelect(this)" />
                    </label>
                    <p id="imageError" class="text-red-500 text-xs hidden"></p>
                </div>
            </div>
            -->

            <!-- ===== VALIDATION SUMMARY ===== -->
            <div id="validationSummary" class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-700 rounded-lg p-4 hidden">
                <h4 class="text-sm font-semibold text-red-700 dark:text-red-400">Please fix the following fields:</h4>
                <ul id="errorList" class="list-disc list-inside text-xs text-red-600 dark:text-red-300 mt-2"></ul>
            </div>

            <!-- Submit -->
            <div class="pt-4 border-t border-gray-200 dark:border-gray-700">
                <button type="submit" id="groupFormSubmitBtn"
                        class="w-full bg-gradient-to-r from-amber-500 to-amber-600 text-white py-3 rounded-lg font-semibold hover:shadow-lg transition-all disabled:opacity-50">
                    <span id="submitBtnText">Save Group</span>
                    <span id="submitBtnSpinner" class="hidden"><i class="fas fa-spinner fa-spin ml-2"></i></span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // ===== GLOBAL STATE =====
    let isGroupEditMode = false;

    // DOM refs
    const overlay = document.getElementById('groupFormOverlay');
    const panel = document.getElementById('groupFormPanel');
    const progressBarContainer = document.getElementById('groupFormProgress');
    const progressBar = progressBarContainer.querySelector('div');
    const form = document.getElementById('groupForm');
    const title = document.getElementById('groupFormTitle');
    const farmSelect = document.getElementById('farmSelect');
    const typeSelect = document.getElementById('typeSelect');
    const groupNameField = document.getElementById('groupName');
    const quantityField = document.getElementById('quantity');
    const costField = document.getElementById('cost');
    const receiveAgeField = document.getElementById('receiveAge');
    const receiveDateField = document.getElementById('receiveDate');
    const originField = document.getElementById('origin');
    const groupIdField = document.getElementById('groupId');
    const submitBtn = document.getElementById('groupFormSubmitBtn');
    const submitBtnText = document.getElementById('submitBtnText');
    const submitBtnSpinner = document.getElementById('submitBtnSpinner');

    // ===== INITIALIZATION =====
    document.addEventListener('DOMContentLoaded', () => {
        receiveDateField.max = new Date().toISOString().split('T')[0];
    });

    // ===== FARM DROPDOWN =====
    function initFarmSelect(selectedFarmId) {
        farmSelect.innerHTML = '<option value="">-- Select a farm --</option>';
        if (window.farms && window.farms.length) {
            window.farms.forEach(farm => {
                const opt = document.createElement('option');
                opt.value = farm.id;
                opt.textContent = farm.farmName + ' (' + (farm.address || '') + ')';
                if (farm.id === selectedFarmId) opt.selected = true;
                farmSelect.appendChild(opt);
            });
        }
        if (selectedFarmId) handleFarmChange(selectedFarmId);
    }

    // ===== OPEN / CLOSE =====
    window.openGroupForm = function(mode = 'add', groupData = null) {
        isGroupEditMode = mode === 'edit';
        title.textContent = isGroupEditMode ? 'Edit Chicken Group' : 'Add Chicken Group';

        form.reset();
        groupIdField.value = '';
        // removeImage();  // not used
        hideAllErrors();

        initFarmSelect(groupData?.farmId || '');

        if (isGroupEditMode && groupData) {
            groupIdField.value = groupData.id || '';
            groupNameField.value = groupData.groupName || '';
            typeSelect.value = groupData.type || '';
            quantityField.value = groupData.quantity || '';
            costField.value = groupData.cost || '';
            receiveAgeField.value = groupData.receiveAge || '';
            receiveDateField.value = groupData.receiveDate ? groupData.receiveDate.split('T')[0] : '';
            originField.value = groupData.origin || '';
            // No image preview for now
        }

        overlay.classList.remove('hidden');
        panel.classList.remove('translate-x-full');
        document.body.style.overflow = 'hidden';
    };

    window.closeGroupForm = function() {
        overlay.classList.add('hidden');
        panel.classList.add('translate-x-full');
        document.body.style.overflow = '';
    };

    overlay.addEventListener('click', window.closeGroupForm);

    // ===== FARM STATS & AUTO NAME =====
    window.handleFarmChange = function(farmId) {
        const statsDiv = document.getElementById('farmStats');
        const contentDiv = document.getElementById('farmStatsContent');
        if (!farmId || !window.groupsData) {
            statsDiv.classList.add('hidden');
        } else {
            const farmGroups = window.groupsData.filter(g => g.farmId === farmId) || [];
            const active = farmGroups.filter(g => g.status !== 'completed').length;
            const types = [...new Set(farmGroups.map(g => g.type))];
            contentDiv.innerHTML = '';
            contentDiv.innerHTML += `<span class="bg-gray-200 dark:bg-gray-600 text-xs rounded-full px-2 py-1">${farmGroups.length} total</span>`;
            contentDiv.innerHTML += `<span class="bg-blue-100 dark:bg-blue-900 text-xs rounded-full px-2 py-1">${active} active</span>`;
            types.forEach(t => {
                contentDiv.innerHTML += `<span class="bg-amber-100 dark:bg-amber-900 text-xs rounded-full px-2 py-1">${t}</span>`;
            });
            statsDiv.classList.remove('hidden');
        }
        if (typeSelect.value) suggestName(farmId, typeSelect.value);
    };

    window.handleTypeChange = function(type) {
        const hint = document.getElementById('timelineHint');
        switch (type) {
            case 'broiler': hint.textContent = 'Broilers: 6-8 weeks to market'; break;
            case 'layer': hint.textContent = 'Layers: start laying at 18-20 weeks'; break;
            case 'parent': hint.textContent = 'Parent stock: long-term breeding'; break;
            default: hint.textContent = '';
        }
        if (farmSelect.value) suggestName(farmSelect.value, type);
    };

    function suggestName(farmId, type) {
        if (!farmId || !type) return;
        const farm = window.farms?.find(f => f.id === farmId);
        if (!farm) return;
        const farmCode = (farm.farmName || 'FRM').substring(0, 3).toUpperCase();
        const typeCode = type.substring(0, 1).toUpperCase();
        const count = (window.groupsData || []).filter(g => g.farmId === farmId && g.type === type).length;
        groupNameField.value = `${farmCode}-${typeCode}${count + 1}`;
    }

    // ===== IMAGE HANDLING (completely commented out) =====
    // function handleImageSelect(input) { ... }
    // function showImagePreview(src) { ... }
    // function removeImage() { ... }

    // ===== FORM SUBMISSION (with console logging) =====
    async function submitGroupForm(e) {
        e.preventDefault();
        hideAllErrors();

        // Create FormData from the form (no file → simple key‑value)
        const formData = new FormData(form);
        const farmId = formData.get('farmId');
        if (!farmId) {
            showFieldError('farmError', 'Please select a farm');
            return;
        }

        // ---- Console log all submitted fields ----
        console.log('Submitting chicken group form...');
        console.log('isEditMode:', isGroupEditMode);
        console.log('Fields:');
        for (let pair of formData.entries()) {
            console.log(`  ${pair[0]}:`, pair[1]);
        }

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
            const url = isGroupEditMode
                ? window.contextPath + '/flock/updateGroup'
                : window.contextPath + '/flock/addGroup';
            console.log('Fetch URL:', url);

            // Send as URL‑encoded (FormData will be sent as multipart; to avoid that,
            // we’ll convert to URLSearchParams because we have no file.
            const urlParams = new URLSearchParams();
            for (let [key, val] of formData.entries()) {
                urlParams.append(key, val);
            }

            const response = await fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: urlParams
            });

            clearInterval(progressInterval);
            const result = await response.json();
            console.log('Server response:', result);

            if (result.success) {
                progressBar.style.width = '100%';
                await (window.refreshGroupList ? window.refreshGroupList() : Promise.resolve());
                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    icon: 'success',
                    title: isGroupEditMode ? 'Group updated!' : 'Group created!',
                    showConfirmButton: false,
                    timer: 2000,
                    timerProgressBar: true
                });
                setTimeout(() => {
                    closeGroupForm();
                    progressBarContainer.classList.add('hidden');
                    progressBar.style.width = '0%';
                    submitBtn.disabled = false;
                    submitBtnText.textContent = 'Save Group';
                    submitBtnSpinner.classList.add('hidden');
                }, 400);
            } else {
                throw new Error(result.message || 'Unknown error');
            }
        } catch (error) {
            console.error('Submit error:', error);
            clearInterval(progressInterval);
            Swal.fire({
                icon: 'error',
                title: 'Save Failed',
                text: error.message || 'Something went wrong.',
            });
            progressBarContainer.classList.add('hidden');
            progressBar.style.width = '0%';
            submitBtn.disabled = false;
            submitBtnText.textContent = 'Save Group';
            submitBtnSpinner.classList.add('hidden');
        }
    }

    // ===== FIELD ERRORS =====
    function showFieldError(elementId, message) {
        const el = document.getElementById(elementId);
        if (el) {
            el.textContent = message;
            el.classList.remove('hidden');
        }
    }

    function hideAllErrors() {
        const errorIds = ['farmError','groupNameError','typeError','quantityError','costError',
                          'receiveAgeError','receiveDateError','originError'];
        errorIds.forEach(id => {
            const el = document.getElementById(id);
            if (el) el.classList.add('hidden');
        });
        document.getElementById('validationSummary').classList.add('hidden');
        document.getElementById('errorList').innerHTML = '';
    }
</script>