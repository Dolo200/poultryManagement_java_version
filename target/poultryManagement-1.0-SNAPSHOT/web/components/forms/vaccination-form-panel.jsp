<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="vaccineFormOverlay" class="fixed inset-0 bg-black/30 z-40 hidden" onclick="closeVaccineForm()"></div>
<div id="vaccineFormPanel" class="fixed top-0 right-0 h-full w-full max-w-lg bg-white dark:bg-gray-900 shadow-2xl z-50 transform translate-x-full transition-transform duration-300 flex flex-col">
    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gradient-to-r from-blue-50 to-purple-50 dark:from-gray-800 dark:to-gray-900">
        <h2 id="vaccineFormTitle" class="text-xl font-bold text-gray-800 dark:text-white">Schedule Vaccination</h2>
        <button onclick="closeVaccineForm()" class="p-2 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300">
            <i class="fas fa-times"></i>
        </button>
    </div>
    <div id="vaccineFormProgress" class="h-1 bg-gray-200 dark:bg-gray-700 hidden">
        <div class="h-full bg-blue-500 transition-all duration-500" style="width:0%"></div>
    </div>
    <div class="flex-1 overflow-y-auto p-6 space-y-5">
        <form id="vaccineForm" onsubmit="submitVaccineForm(event)">
            <input type="hidden" name="id" id="vaccineId" />

            <div>
                <label class="block text-sm font-medium mb-1">Flock</label>
                <select name="flockId" id="flockSelect" required class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
                    <option value="">-- Select flock --</option>
                </select>
                <p id="flockError" class="text-red-500 text-xs mt-1 hidden"></p>
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Vaccine Name</label>
                <input type="text" name="vaccineName" id="vaccineName" required class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Disease</label>
                <input type="text" name="disease" id="disease" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Due Date</label>
                <input type="date" name="dueDate" id="dueDate" required class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Age (days)</label>
                <input type="number" name="days" id="days" min="0" step="1" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Reminder (days before)</label>
                <input type="number" name="reminderDays" id="reminderDays" min="1" value="7" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div class="pt-4 border-t border-gray-200 dark:border-gray-700">
                <button type="submit" id="vaccineFormSubmitBtn" class="w-full bg-gradient-to-r from-blue-500 to-blue-600 text-white py-3 rounded-lg font-semibold hover:shadow-lg disabled:opacity-50">
                    <span id="submitBtnText">Save Vaccination</span>
                    <span id="submitBtnSpinner" class="hidden"><i class="fas fa-spinner fa-spin ml-2"></i></span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    let isVaccineEditMode = false;
    const vaccineOverlay = document.getElementById('vaccineFormOverlay');
    const vaccinePanel = document.getElementById('vaccineFormPanel');
    const vaccineProgressContainer = document.getElementById('vaccineFormProgress');
    const vaccineProgressBar = vaccineProgressContainer.querySelector('div');
    const vaccineForm = document.getElementById('vaccineForm');
    const vaccineTitle = document.getElementById('vaccineFormTitle');
    const vaccineIdField = document.getElementById('vaccineId');
    const flockSelect = document.getElementById('flockSelect');
    const vaccineNameInput = document.getElementById('vaccineName');
    const diseaseInput = document.getElementById('disease');
    const dueDateInput = document.getElementById('dueDate');
    const daysInput = document.getElementById('days');
    const reminderDaysInput = document.getElementById('reminderDays');
    const submitBtn = document.getElementById('vaccineFormSubmitBtn');
    const submitBtnText = document.getElementById('submitBtnText');
    const submitBtnSpinner = document.getElementById('submitBtnSpinner');

    function populateFlockSelect(selectedFlockId) {
        flockSelect.innerHTML = '<option value="">-- Select flock --</option>';
        if (window.flockList) {
            window.flockList.forEach(f => {
                const opt = document.createElement('option');
                opt.value = f.id;
                opt.textContent = f.flockName;
                if (f.id === selectedFlockId) opt.selected = true;
                flockSelect.appendChild(opt);
            });
        }
    }

    window.openVaccineForm = function(mode, data) {
        isVaccineEditMode = mode === 'edit';
        vaccineTitle.textContent = isVaccineEditMode ? 'Edit Vaccination' : 'Schedule Vaccination';
        vaccineForm.reset();
        vaccineIdField.value = '';
        hideVaccineErrors();
        populateFlockSelect(data?.flockId || '');

        if (isVaccineEditMode && data) {
            vaccineIdField.value = data.id;
            vaccineNameInput.value = data.vaccineName || '';
            diseaseInput.value = data.disease || '';
            dueDateInput.value = data.dueDate || '';
            daysInput.value = data.days || '';
            reminderDaysInput.value = data.reminderDays || 7;
        }

        vaccineOverlay.classList.remove('hidden');
        vaccinePanel.classList.remove('translate-x-full');
        document.body.style.overflow = 'hidden';
    };

    window.closeVaccineForm = function() {
        vaccineOverlay.classList.add('hidden');
        vaccinePanel.classList.add('translate-x-full');
        document.body.style.overflow = '';
    };

    vaccineOverlay.addEventListener('click', window.closeVaccineForm);

    function hideVaccineErrors() {
        document.getElementById('flockError')?.classList.add('hidden');
    }

    async function submitVaccineForm(e) {
        e.preventDefault();
        const formData = new FormData(vaccineForm);
        if (!formData.get('flockId')) {
            document.getElementById('flockError').classList.remove('hidden');
            return;
        }

        vaccineProgressContainer.classList.remove('hidden');
        submitBtn.disabled = true;
        submitBtnText.textContent = 'Saving...';
        submitBtnSpinner.classList.remove('hidden');

        let progress = 0;
        const interval = setInterval(() => {
            progress += 10; if (progress > 90) clearInterval(interval);
            vaccineProgressBar.style.width = progress + '%';
        }, 200);

        try {
            const url = isVaccineEditMode ? window.contextPath + '/vaccination/update' : window.contextPath + '/vaccination/add';
            const params = new URLSearchParams(formData);
            const resp = await fetch(url, { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params });
            clearInterval(interval);
            const result = await resp.json();
            if (result.success) {
                vaccineProgressBar.style.width = '100%';
                if (window.refreshVaccineList) await window.refreshVaccineList();
                setTimeout(() => {
                    closeVaccineForm();
                    vaccineProgressContainer.classList.add('hidden');
                    vaccineProgressBar.style.width = '0%';
                    submitBtn.disabled = false;
                    submitBtnText.textContent = 'Save Vaccination';
                    submitBtnSpinner.classList.add('hidden');
                }, 400);
            } else {
                throw new Error(result.message);
            }
        } catch (err) {
            clearInterval(interval);
            alert('Error: ' + err.message);
            vaccineProgressContainer.classList.add('hidden');
            vaccineProgressBar.style.width = '0%';
            submitBtn.disabled = false;
            submitBtnText.textContent = 'Save Vaccination';
            submitBtnSpinner.classList.add('hidden');
        }
    }
</script>