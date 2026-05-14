<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="mortalityFormOverlay" class="fixed inset-0 bg-black/30 z-40 hidden" onclick="closeMortalityForm()"></div>
<div id="mortalityFormPanel" class="fixed top-0 right-0 h-full w-full max-w-lg bg-white dark:bg-gray-900 shadow-2xl z-50 transform translate-x-full transition-transform duration-300 flex flex-col">

    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gradient-to-r from-red-50 to-amber-50 dark:from-gray-800 dark:to-gray-900">
        <h2 class="text-xl font-bold text-gray-800 dark:text-white" id="mortalityFormTitle">Add Mortality Record</h2>
        <button onclick="closeMortalityForm()" class="p-2 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300">
            <i class="fas fa-times"></i>
        </button>
    </div>

    <div id="mortalityFormProgress" class="h-1 bg-gray-200 dark:bg-gray-700 hidden">
        <div class="h-full bg-red-500 transition-all duration-500" style="width:0%"></div>
    </div>

    <div class="flex-1 overflow-y-auto p-6 space-y-5">
        <form id="mortalityForm" onsubmit="submitMortalityForm(event)">
            <input type="hidden" name="id" id="mortalityId" />

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Flock</label>
                <select name="flockId" id="flockSelect" required
                        class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-red-500">
                    <option value="">-- Select a Flock --</option>
                </select>
                <p id="flockError" class="text-red-500 text-xs mt-1 hidden"></p>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Date of Death</label>
                <input type="date" name="date" id="dateInput" required
                       class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-red-500">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Number of Deaths</label>
                <input type="number" name="numberOfDeaths" id="numberOfDeathsInput" min="1" required
                       class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-red-500">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Age (days)</label>
                <input type="number" name="age" id="ageInput" min="0"
                       class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-red-500">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Cause / Symptoms</label>
                <input type="text" name="cause" id="causeInput"
                       class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-red-500">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Death Location</label>
                <input type="text" name="location" id="locationInput"
                       class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-red-500">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Action Taken</label>
                <input type="text" name="actionTaken" id="actionTakenInput"
                       class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-red-500">
            </div>

            <div class="pt-4 border-t border-gray-200 dark:border-gray-700">
                <button type="submit" id="mortalityFormSubmitBtn"
                        class="w-full bg-gradient-to-r from-red-500 to-red-600 text-white py-3 rounded-lg font-semibold hover:shadow-lg transition-all disabled:opacity-50">
                    <span id="submitBtnText">Save Record</span>
                    <span id="submitBtnSpinner" class="hidden"><i class="fas fa-spinner fa-spin ml-2"></i></span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    let isMortalityEditMode = false;

    // DOM refs
    const mortalityOverlay = document.getElementById('mortalityFormOverlay');
    const mortalityPanel = document.getElementById('mortalityFormPanel');
    const mortalityProgressContainer = document.getElementById('mortalityFormProgress');
    const mortalityProgressBar = mortalityProgressContainer.querySelector('div');
    const mortalityForm = document.getElementById('mortalityForm');
    const mortalityTitle = document.getElementById('mortalityFormTitle');
    const mortalityIdField = document.getElementById('mortalityId');
    const flockSelect = document.getElementById('flockSelect');
    const dateInput = document.getElementById('dateInput');
    const numberOfDeathsInput = document.getElementById('numberOfDeathsInput');
    const ageInput = document.getElementById('ageInput');
    const causeInput = document.getElementById('causeInput');
    const locationInput = document.getElementById('locationInput');
    const actionTakenInput = document.getElementById('actionTakenInput');
    const submitBtn = document.getElementById('mortalityFormSubmitBtn');
    const submitBtnText = document.getElementById('submitBtnText');
    const submitBtnSpinner = document.getElementById('submitBtnSpinner');

    // Populate flock dropdown from window.flocks (set by main page)
    function populateFlockSelect(selectedId) {
        flockSelect.innerHTML = '<option value="">-- Select a Flock --</option>';
        if (window.flocks) {
            window.flocks.forEach(f => {
                const opt = document.createElement('option');
                opt.value = f.id;
                opt.textContent = f.flockName || f.name;
                if (f.id === selectedId) opt.selected = true;
                flockSelect.appendChild(opt);
            });
        }
    }

    window.openMortalityForm = function(mode, recordData) {
        isMortalityEditMode = mode === 'edit';
        mortalityTitle.textContent = isMortalityEditMode ? 'Edit Mortality Record' : 'Add Mortality Record';

        mortalityForm.reset();
        mortalityIdField.value = '';
        hideMortalityErrors();

        populateFlockSelect(recordData?.flockId || '');

        if (isMortalityEditMode && recordData) {
            mortalityIdField.value = recordData.id || '';
            dateInput.value = recordData.date || '';
            numberOfDeathsInput.value = recordData.numberOfDeaths || '';
            ageInput.value = recordData.age || '';
            causeInput.value = recordData.cause || '';
            locationInput.value = recordData.location || '';
            actionTakenInput.value = recordData.actionTaken || '';
        }

        mortalityOverlay.classList.remove('hidden');
        mortalityPanel.classList.remove('translate-x-full');
        document.body.style.overflow = 'hidden';
    };

    window.closeMortalityForm = function() {
        mortalityOverlay.classList.add('hidden');
        mortalityPanel.classList.add('translate-x-full');
        document.body.style.overflow = '';
    };

    mortalityOverlay.addEventListener('click', window.closeMortalityForm);

    function hideMortalityErrors() {
        ['flockError'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.classList.add('hidden');
        });
    }

    async function submitMortalityForm(e) {
        e.preventDefault();
        hideMortalityErrors();

        const formData = new FormData(mortalityForm);
        const flockId = formData.get('flockId');
        if (!flockId) {
            document.getElementById('flockError').classList.remove('hidden');
            document.getElementById('flockError').textContent = 'Please select a flock';
            return;
        }

        mortalityProgressContainer.classList.remove('hidden');
        submitBtn.disabled = true;
        submitBtnText.textContent = 'Saving...';
        submitBtnSpinner.classList.remove('hidden');

        // Simulate progress
        let progress = 0;
        const interval = setInterval(() => {
            progress += 10;
            if (progress > 90) clearInterval(interval);
            mortalityProgressBar.style.width = progress + '%';
        }, 200);

        try {
            const url = isMortalityEditMode
                ? window.contextPath + '/mortality/updateRecord'
                : window.contextPath + '/mortality/addRecord';
            const params = new URLSearchParams();
            for (let [k, v] of formData.entries()) params.append(k, v);

            const resp = await fetch(url, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params
            });
            clearInterval(interval);
            const result = await resp.json();

            if (result.success) {
                mortalityProgressBar.style.width = '100%';
                if (window.refreshMortalityList) await window.refreshMortalityList();
                setTimeout(() => {
                    closeMortalityForm();
                    mortalityProgressContainer.classList.add('hidden');
                    mortalityProgressBar.style.width = '0%';
                    submitBtn.disabled = false;
                    submitBtnText.textContent = 'Save Record';
                    submitBtnSpinner.classList.add('hidden');
                }, 400);
            } else {
                throw new Error(result.message);
            }
        } catch (err) {
            clearInterval(interval);
            alert('Error: ' + err.message);
            mortalityProgressContainer.classList.add('hidden');
            mortalityProgressBar.style.width = '0%';
            submitBtn.disabled = false;
            submitBtnText.textContent = 'Save Record';
            submitBtnSpinner.classList.add('hidden');
        }
    }
</script>