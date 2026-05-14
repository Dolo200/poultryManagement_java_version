<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="productFormOverlay" class="fixed inset-0 bg-black/30 z-40 hidden" onclick="closeProductForm()"></div>
<div id="productFormPanel" class="fixed top-0 right-0 h-full w-full max-w-lg bg-white dark:bg-gray-900 shadow-2xl z-50 transform translate-x-full transition-transform duration-300 flex flex-col">
    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-700 bg-gradient-to-r from-green-50 to-emerald-50 dark:from-gray-800 dark:to-gray-900">
        <h2 id="productFormTitle" class="text-xl font-bold text-gray-800 dark:text-white">Add Product</h2>
        <button onclick="closeProductForm()" class="p-2 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300">
            <i class="fas fa-times"></i>
        </button>
    </div>
    <div id="productFormProgress" class="h-1 bg-gray-200 dark:bg-gray-700 hidden">
        <div class="h-full bg-green-500 transition-all duration-500" style="width:0%"></div>
    </div>
    <div class="flex-1 overflow-y-auto p-6 space-y-5">
        <form id="productForm" onsubmit="submitProductForm(event)">
            <input type="hidden" name="id" id="productId" />

            <div>
                <label class="block text-sm font-medium mb-1">Product Name</label>
                <input type="text" name="productname" id="productName" required class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Flock</label>
                <select name="flockId" id="flockSelect" required class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
                    <option value="">-- Select flock --</option>
                </select>
                <p id="flockError" class="text-red-500 text-xs mt-1 hidden"></p>
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Type / Category</label>
                <select name="type" id="typeSelect" required class="w-full px-4 py-2 border rounded-lg">
                    <option value="">Select type</option>
                    <option value="Egg">Egg</option>
                    <option value="Meat">Meat</option>
                    <option value="Manure">Manure</option>
                    <option value="Other">Other</option>
                </select>
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Cost</label>
                <input type="number" name="cost" id="cost" min="0" step="0.01" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Initial Quantity</label>
                <input type="number" name="initialquantity" id="initialQuantity" required min="1" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Description</label>
                <textarea name="description" id="description" rows="2" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white"></textarea>
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Storage Location</label>
                <input type="text" name="storagelocation" id="storageLocation" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div>
                <label class="block text-sm font-medium mb-1">Register Date</label>
                <input type="date" name="registerdate" id="registerDate" class="w-full px-4 py-2 border rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
            </div>

            <div class="pt-4 border-t border-gray-200 dark:border-gray-700">
                <button type="submit" id="productFormSubmitBtn" class="w-full bg-gradient-to-r from-green-500 to-green-600 text-white py-3 rounded-lg font-semibold hover:shadow-lg disabled:opacity-50">
                    <span id="submitBtnText">Save Product</span>
                    <span id="submitBtnSpinner" class="hidden"><i class="fas fa-spinner fa-spin ml-2"></i></span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    let isProductEditMode = false;
    const productOverlay = document.getElementById('productFormOverlay');
    const productPanel = document.getElementById('productFormPanel');
    const productProgressContainer = document.getElementById('productFormProgress');
    const productProgressBar = productProgressContainer.querySelector('div');
    const productForm = document.getElementById('productForm');
    const productTitle = document.getElementById('productFormTitle');
    const productIdField = document.getElementById('productId');
    const productNameInput = document.getElementById('productName');
    const flockSelect = document.getElementById('flockSelect');
    const typeSelect = document.getElementById('typeSelect');
    const costInput = document.getElementById('cost');
    const initialQuantityInput = document.getElementById('initialQuantity');
    const descriptionInput = document.getElementById('description');
    const storageLocationInput = document.getElementById('storageLocation');
    const registerDateInput = document.getElementById('registerDate');
    const submitBtn = document.getElementById('productFormSubmitBtn');
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
    }

    window.openProductForm = function(mode, data) {
        isProductEditMode = mode === 'edit';
        productTitle.textContent = isProductEditMode ? 'Edit Product' : 'Add Product';
        productForm.reset();
        productIdField.value = '';
        hideProductErrors();
        populateFlockSelect(data?.flockId || '');

        if (isProductEditMode && data) {
            productIdField.value = data.id;
            productNameInput.value = data.productname || '';
            typeSelect.value = data.type || '';
            costInput.value = data.cost || '';
            initialQuantityInput.value = data.initialquantity || '';
            descriptionInput.value = data.description || '';
            storageLocationInput.value = data.storagelocation || '';
            registerDateInput.value = data.registerdate || '';
        }

        productOverlay.classList.remove('hidden');
        productPanel.classList.remove('translate-x-full');
        document.body.style.overflow = 'hidden';
    };

    window.closeProductForm = function() {
        productOverlay.classList.add('hidden');
        productPanel.classList.add('translate-x-full');
        document.body.style.overflow = '';
    };

    productOverlay.addEventListener('click', window.closeProductForm);

    function hideProductErrors() {
        document.getElementById('flockError')?.classList.add('hidden');
    }

    async function submitProductForm(e) {
        e.preventDefault();
        const formData = new FormData(productForm);
        if (!formData.get('flockId')) {
            document.getElementById('flockError').classList.remove('hidden');
            return;
        }

        productProgressContainer.classList.remove('hidden');
        submitBtn.disabled = true;
        submitBtnText.textContent = 'Saving...';
        submitBtnSpinner.classList.remove('hidden');

        let progress = 0;
        const interval = setInterval(() => {
            progress += 10; if (progress > 90) clearInterval(interval);
            productProgressBar.style.width = progress + '%';
        }, 200);

        try {
            const url = isProductEditMode ? window.contextPath + '/production/updateProduct' : window.contextPath + '/production/addProduct';
            const params = new URLSearchParams(formData);
            const resp = await fetch(url, { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params });
            clearInterval(interval);
            const result = await resp.json();
            if (result.success) {
                productProgressBar.style.width = '100%';
                if (window.refreshProductList) await window.refreshProductList();
                setTimeout(() => {
                    closeProductForm();
                    productProgressContainer.classList.add('hidden');
                    productProgressBar.style.width = '0%';
                    submitBtn.disabled = false;
                    submitBtnText.textContent = 'Save Product';
                    submitBtnSpinner.classList.add('hidden');
                }, 400);
            } else {
                throw new Error(result.message);
            }
        } catch (err) {
            clearInterval(interval);
            alert('Error: ' + err.message);
            productProgressContainer.classList.add('hidden');
            productProgressBar.style.width = '0%';
            submitBtn.disabled = false;
            submitBtnText.textContent = 'Save Product';
            submitBtnSpinner.classList.add('hidden');
        }
    }
</script>