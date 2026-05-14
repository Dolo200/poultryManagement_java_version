<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="staffFormOverlay" class="fixed inset-0 bg-black/30 z-40 hidden" onclick="closeStaffForm()"></div>
<div id="staffFormPanel" class="fixed top-0 right-0 h-full w-full max-w-lg bg-white dark:bg-gray-900 shadow-2xl z-50 transform translate-x-full transition-transform duration-300 flex flex-col">
    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gradient-to-r from-blue-50 to-amber-50 dark:from-gray-800 dark:to-gray-900">
        <h2 id="staffFormTitle" class="text-xl font-bold text-gray-800 dark:text-white">Add Staff Member</h2>
        <button onclick="closeStaffForm()" class="p-2 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300">
            <i class="fas fa-times"></i>
        </button>
    </div>
    <div id="staffFormProgress" class="h-1 bg-gray-200 dark:bg-gray-700 hidden">
        <div class="h-full bg-blue-500 transition-all duration-500" style="width:0%"></div>
    </div>
    <div class="flex-1 overflow-y-auto p-6 space-y-5">
        <form id="staffForm" onsubmit="submitStaffForm(event)" enctype="multipart/form-data">
            <input type="hidden" name="id" id="staffId" />
            <input type="hidden" name="role" value="staff" />

            <!-- Farms (multiple select) -->
            <div>
                <label class="block text-sm font-medium mb-1">Assigned Farms</label>
                <select name="assignToFarm" id="farmsSelect" multiple size="4" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
                    <option value="">-- Select farms --</option>
                </select>
                <p id="farmsError" class="text-red-500 text-xs mt-1 hidden"></p>
            </div>

            <!-- Name -->
            <div>
                <label class="block text-sm font-medium mb-1">Full Name</label>
                <input type="text" name="staffName" id="staffName" required class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <!-- Gender -->
            <div>
                <label class="block text-sm font-medium mb-1">Gender</label>
                <select name="gender" id="gender" class="w-full px-4 py-2 border rounded-lg">
                    <option value="">Select Gender</option>
                    <option value="male">Male</option>
                    <option value="female">Female</option>
                </select>
            </div>

            <!-- Email -->
            <div>
                <label class="block text-sm font-medium mb-1">Email</label>
                <input type="email" name="email" id="email" required class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <!-- Phone (with country code) -->
            <div>
                <label class="block text-sm font-medium mb-1">Phone</label>
                <input type="tel" name="phone" id="phone" placeholder="+237..." class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <!-- Password (only for new staff) -->
            <div>
                <label class="block text-sm font-medium mb-1">Password</label>
                <input type="password" name="password" id="password" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
                <p class="text-xs text-gray-400 mt-1">Leave blank to keep current password (when editing)</p>
            </div>

            <!-- Confirm Password -->
            <div>
                <label class="block text-sm font-medium mb-1">Confirm Password</label>
                <input type="password" name="confirmPassword" id="confirmPassword" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <!-- Salary (optional) -->
            <div>
                <label class="block text-sm font-medium mb-1">Salary</label>
                <input type="number" name="salary" id="salary" min="0" step="0.01" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <!-- Photo upload -->
            <div>
                <label class="block text-sm font-medium mb-1">Staff Photo</label>
                <div class="flex flex-col items-start gap-2">
                    <div id="photoPreviewContainer" class="hidden">
                        <img id="photoPreview" src="" class="w-24 h-24 object-cover rounded border" />
                        <button type="button" onclick="clearPhoto()" class="text-red-600 text-sm mt-1">Remove</button>
                    </div>
                    <input type="file" id="photoFile" name="photo" accept="image/jpeg,image/png" class="border rounded p-2 w-full" onchange="previewPhoto(this)">
                </div>
            </div>

            <!-- Submit -->
            <div class="pt-4 border-t border-gray-200 dark:border-gray-700">
                <button type="submit" id="staffFormSubmitBtn" class="w-full bg-gradient-to-r from-blue-500 to-blue-600 text-white py-3 rounded-lg font-semibold hover:shadow-lg disabled:opacity-50">
                    <span id="submitBtnText">Save Staff</span>
                    <span id="submitBtnSpinner" class="hidden"><i class="fas fa-spinner fa-spin ml-2"></i></span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    console.log('staff-form-panel.jsp loaded');

    let isStaffEditMode = false;

    // DOM refs
    const staffOverlay = document.getElementById('staffFormOverlay');
    const staffPanel = document.getElementById('staffFormPanel');
    const staffProgressContainer = document.getElementById('staffFormProgress');
    const staffProgressBar = staffProgressContainer.querySelector('div');
    const staffForm = document.getElementById('staffForm');
    const staffTitle = document.getElementById('staffFormTitle');
    const staffIdField = document.getElementById('staffId');
    const farmsSelect = document.getElementById('farmsSelect');
    const staffNameInput = document.getElementById('staffName');
    const genderSelect = document.getElementById('gender');
    const emailInput = document.getElementById('email');
    const phoneInput = document.getElementById('phone');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const salaryInput = document.getElementById('salary');
    const photoFileInput = document.getElementById('photoFile');
    const photoPreview = document.getElementById('photoPreview');
    const photoPreviewContainer = document.getElementById('photoPreviewContainer');
    const submitBtn = document.getElementById('staffFormSubmitBtn');
    const submitBtnText = document.getElementById('submitBtnText');
    const submitBtnSpinner = document.getElementById('submitBtnSpinner');

    // Populate farms dropdown from window.farmList (set by staff.jsp)
    function populateFarmsSelect(selectedFarmIds) {
        console.log('populateFarmsSelect called, selectedFarmIds:', selectedFarmIds);
        farmsSelect.innerHTML = '';
        if (window.farmList) {
            window.farmList.forEach(f => {
                const opt = document.createElement('option');
                opt.value = f.id;
                opt.textContent = f.farmName;
                if (selectedFarmIds && selectedFarmIds.includes(f.id)) opt.selected = true;
                farmsSelect.appendChild(opt);
            });
            console.log('Farms dropdown populated with', window.farmList.length, 'farms');
        } else {
            console.warn('window.farmList is empty or undefined');
        }
    }

    window.openStaffForm = function(mode, staffData) {
        console.log('openStaffForm called, mode:', mode, 'data:', staffData);
        isStaffEditMode = mode === 'edit';
        staffTitle.textContent = isStaffEditMode ? 'Edit Staff' : 'Add Staff';
        staffForm.reset();
        staffIdField.value = '';
        hideStaffErrors();
        photoPreviewContainer.classList.add('hidden');
        photoFileInput.value = '';

        populateFarmsSelect(staffData?.assignedFarmIds || []);

        if (isStaffEditMode && staffData) {
            staffIdField.value = staffData.id;
            staffNameInput.value = staffData.staffName || '';
            genderSelect.value = staffData.gender || '';
            emailInput.value = staffData.email || '';
            phoneInput.value = staffData.phone || '';
            salaryInput.value = staffData.salary || '';
            if (staffData.photo) {
                const photoPath = staffData.photo.startsWith('http') ? staffData.photo : window.contextPath + '/' + staffData.photo;
                console.log('Setting photo preview:', photoPath);
                photoPreview.src = photoPath;
                photoPreviewContainer.classList.remove('hidden');
            }
        }

        staffOverlay.classList.remove('hidden');
        staffPanel.classList.remove('translate-x-full');
        document.body.style.overflow = 'hidden';
    };

    window.closeStaffForm = function() {
        console.log('closeStaffForm called');
        staffOverlay.classList.add('hidden');
        staffPanel.classList.add('translate-x-full');
        document.body.style.overflow = '';
    };

    staffOverlay.addEventListener('click', window.closeStaffForm);

    function previewPhoto(input) {
        const file = input.files[0];
        if (file) {
            console.log('Photo selected:', file.name);
            const reader = new FileReader();
            reader.onload = (e) => {
                photoPreview.src = e.target.result;
                photoPreviewContainer.classList.remove('hidden');
            };
            reader.readAsDataURL(file);
        }
    }

    function clearPhoto() {
        console.log('clearPhoto called');
        photoPreviewContainer.classList.add('hidden');
        photoFileInput.value = '';
    }

    function hideStaffErrors() {
        ['farmsError'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.classList.add('hidden');
        });
    }

    async function submitStaffForm(e) {
        e.preventDefault();
        console.log('submitStaffForm called');
        hideStaffErrors();
        const formData = new FormData(staffForm);
        // Log form entries (except file content)
        for (let pair of formData.entries()) {
            if (pair[1] instanceof File) {
                console.log(pair[0], '=', 'File:' + pair[1].name);
            } else {
                console.log(pair[0], '=', pair[1]);
            }
        }

        const pwd = formData.get('password');
        const confirmPwd = formData.get('confirmPassword');
        if (pwd && pwd !== confirmPwd) {
            alert('Passwords do not match');
            return;
        }

        staffProgressContainer.classList.remove('hidden');
        submitBtn.disabled = true;
        submitBtnText.textContent = 'Saving...';
        submitBtnSpinner.classList.remove('hidden');

        let progress = 0;
        const interval = setInterval(() => {
            progress += 10;
            if (progress > 90) clearInterval(interval);
            staffProgressBar.style.width = progress + '%';
        }, 200);

        try {
            const url = isStaffEditMode ? window.contextPath + '/staff/updateStaff' : window.contextPath + '/staff/addStaff';
            console.log('POST to:', url);
            const resp = await fetch(url, { method: 'POST', body: formData });
            clearInterval(interval);
            const result = await resp.json();
            console.log('Server response:', result);
            if (result.success) {
                staffProgressBar.style.width = '100%';
                if (window.refreshStaffList) await window.refreshStaffList();
                setTimeout(() => {
                    closeStaffForm();
                    staffProgressContainer.classList.add('hidden');
                    staffProgressBar.style.width = '0%';
                    submitBtn.disabled = false;
                    submitBtnText.textContent = 'Save Staff';
                    submitBtnSpinner.classList.add('hidden');
                }, 400);
            } else {
                throw new Error(result.message);
            }
        } catch (err) {
            console.error('Submit error:', err);
            clearInterval(interval);
            alert('Error: ' + err.message);
            staffProgressContainer.classList.add('hidden');
            staffProgressBar.style.width = '0%';
            submitBtn.disabled = false;
            submitBtnText.textContent = 'Save Staff';
            submitBtnSpinner.classList.add('hidden');
        }
    }
</script>