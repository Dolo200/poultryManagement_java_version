<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="feedFormOverlay" class="fixed inset-0 bg-black/30 z-40 hidden" onclick="closeFeedForm()"></div>
<div id="feedFormPanel" class="fixed top-0 right-0 h-full w-full max-w-lg bg-white dark:bg-gray-900 shadow-2xl z-50 transform translate-x-full transition-transform duration-300 flex flex-col">
    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gradient-to-r from-amber-50 to-emerald-50 dark:from-gray-800 dark:to-gray-900">
        <h2 id="feedFormTitle" class="text-xl font-bold text-gray-800 dark:text-white">Add Feed Record</h2>
        <button onclick="closeFeedForm()" class="p-2 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300">
            <i class="fas fa-times"></i>
        </button>
    </div>
    <div id="feedFormProgress" class="h-1 bg-gray-200 dark:bg-gray-700 hidden">
        <div class="h-full bg-amber-500 transition-all duration-500" style="width:0%"></div>
    </div>
    <div class="flex-1 overflow-y-auto p-6 space-y-5">
        <form id="feedForm" onsubmit="submitFeedForm(event)">
            <input type="hidden" name="id" id="feedId" />

            <div>
                <label class="block text-sm font-medium mb-1">Flock</label>
                <select name="flockId" id="flockSelect" required class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
                    <option value="">-- Select flock --</option>
                </select>
                <p id="flockError" class="text-red-500 text-xs mt-1 hidden"></p>
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Feed Batch ID</label>
                <input type="text" name="feedBatchId" id="feedBatchId" required class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Feed Name</label>
                <input type="text" name="feedName" id="feedName" required class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Delivery Date</label>
                <input type="date" name="deliveryDate" id="deliveryDate" required class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Quantity per Delivery</label>
                <input type="number" name="quantityPerDelivery" id="quantityPerDelivery" required min="0" step="0.01" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Crude Protein (%)</label>
                <input type="number" name="crudeProtein" id="crudeProtein" min="0" step="0.01" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Cost per Bag</label>
                <input type="number" name="costPerBag" id="costPerBag" min="0" step="0.01" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Consumption per Day (kg)</label>
                <input type="number" name="consumptionPerDay" id="consumptionPerDay" min="0" step="0.01" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Notes</label>
                <textarea name="notes" id="notes" rows="2" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white"></textarea>
            </div>

            <div class="pt-4 border-t border-gray-200 dark:border-gray-700">
                <button type="submit" id="feedFormSubmitBtn" class="w-full bg-gradient-to-r from-amber-500 to-amber-600 text-white py-3 rounded-lg font-semibold hover:shadow-lg disabled:opacity-50">
                    <span id="submitBtnText">Save Record</span>
                    <span id="submitBtnSpinner" class="hidden"><i class="fas fa-spinner fa-spin ml-2"></i></span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    let isFeedEditMode = false;
    const feedOverlay = document.getElementById('feedFormOverlay');
    const feedPanel = document.getElementById('feedFormPanel');
    const feedProgressContainer = document.getElementById('feedFormProgress');
    const feedProgressBar = feedProgressContainer.querySelector('div');
    const feedForm = document.getElementById('feedForm');
    const feedTitle = document.getElementById('feedFormTitle');
    const feedIdField = document.getElementById('feedId');
    const flockSelect = document.getElementById('flockSelect');
    const feedBatchIdInput = document.getElementById('feedBatchId');
    const feedNameInput = document.getElementById('feedName');
    const deliveryDateInput = document.getElementById('deliveryDate');
    const quantityPerDeliveryInput = document.getElementById('quantityPerDelivery');
    const crudeProteinInput = document.getElementById('crudeProtein');
    const costPerBagInput = document.getElementById('costPerBag');
    const consumptionPerDayInput = document.getElementById('consumptionPerDay');
    const notesInput = document.getElementById('notes');
    const submitBtn = document.getElementById('feedFormSubmitBtn');
    const submitBtnText = document.getElementById('submitBtnText');
    const submitBtnSpinner = document.getElementById('submitBtnSpinner');

    function populateFlockSelect(selectedFlockId) {
        flockSelect.innerHTML = '<option value="">-- Select flock --</option>';
        if (window.flocks) {
            window.flocks.forEach(f => {
                const opt = document.createElement('option');
                opt.value = f.id;
                opt.textContent = f.flockName;
                if (f.id === selectedFlockId) opt.selected = true;
                flockSelect.appendChild(opt);
            });
        }
        console.log('Flock dropdown populated, selected:', selectedFlockId);
    }

    window.openFeedForm = function(mode, data) {
        console.log('openFeedForm', mode, data);
        isFeedEditMode = mode === 'edit';
        feedTitle.textContent = isFeedEditMode ? 'Edit Feed Record' : 'Add Feed Record';
        feedForm.reset();
        feedIdField.value = '';
        hideFeedErrors();
        populateFlockSelect(data?.flockId || '');

        if (isFeedEditMode && data) {
            feedIdField.value = data.id;
            feedBatchIdInput.value = data.feedBatchId || '';
            feedNameInput.value = data.feedName || '';
            deliveryDateInput.value = data.deliveryDate || '';
            quantityPerDeliveryInput.value = data.quantityPerDelivery || '';
            crudeProteinInput.value = data.crudeProtein || '';
            costPerBagInput.value = data.costPerBag || '';
            consumptionPerDayInput.value = data.consumptionPerDay || '';
            notesInput.value = data.notes || '';
        }

        feedOverlay.classList.remove('hidden');
        feedPanel.classList.remove('translate-x-full');
        document.body.style.overflow = 'hidden';
    };

    window.closeFeedForm = function() {
        feedOverlay.classList.add('hidden');
        feedPanel.classList.add('translate-x-full');
        document.body.style.overflow = '';
    };

    feedOverlay.addEventListener('click', window.closeFeedForm);

    function hideFeedErrors() {
        document.getElementById('flockError')?.classList.add('hidden');
    }

    async function submitFeedForm(e) {
        e.preventDefault();
        console.log('Submitting feed form');
        const formData = new FormData(feedForm);
        if (!formData.get('flockId')) {
            document.getElementById('flockError').classList.remove('hidden');
            return;
        }

        feedProgressContainer.classList.remove('hidden');
        submitBtn.disabled = true;
        submitBtnText.textContent = 'Saving...';
        submitBtnSpinner.classList.remove('hidden');

        let progress = 0;
        const interval = setInterval(() => {
            progress += 10; if (progress > 90) clearInterval(interval);
            feedProgressBar.style.width = progress + '%';
        }, 200);

        try {
            const url = isFeedEditMode ? window.contextPath + '/feed/updateFeed' : window.contextPath + '/feed/addFeed';
            console.log('POST to:', url);
            const params = new URLSearchParams(formData);
            const resp = await fetch(url, { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params });
            console.log('Response status:', resp.status);
            const result = await resp.json();
            console.log('Response body:', result);
            clearInterval(interval);
            if (result.success) {
                feedProgressBar.style.width = '100%';
                if (window.refreshFeedList) await window.refreshFeedList();
                setTimeout(() => {
                    closeFeedForm();
                    feedProgressContainer.classList.add('hidden');
                    feedProgressBar.style.width = '0%';
                    submitBtn.disabled = false;
                    submitBtnText.textContent = 'Save Record';
                    submitBtnSpinner.classList.add('hidden');
                }, 400);
            } else {
                throw new Error(result.message);
            }
        } catch (err) {
            console.error('Submit error:', err);
            clearInterval(interval);
            alert('Error: ' + err.message);
            feedProgressContainer.classList.add('hidden');
            feedProgressBar.style.width = '0%';
            submitBtn.disabled = false;
            submitBtnText.textContent = 'Save Record';
            submitBtnSpinner.classList.add('hidden');
        }
    }
</script>