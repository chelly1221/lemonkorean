/**
 * Character Items Management Page
 * Admin UI for managing character customization items
 */

const CharacterItemsPage = (() => {
  const CATEGORIES = [
    'body', 'skin_color', 'hair', 'eyes', 'eyebrows', 'nose', 'mouth',
    'top', 'bottom', 'shoes', 'hat', 'accessory',
    'pet', 'wallpaper', 'floor', 'furniture'
  ];

  const RARITIES = ['common', 'rare', 'epic', 'legendary'];

  const RARITY_COLORS = {
    common: '#6c757d',
    rare: '#0d6efd',
    epic: '#6f42c1',
    legendary: '#fd7e14',
  };

  let currentPage = 1;
  let currentCategory = '';

  async function render() {
    const app = document.getElementById('app');
    app.innerHTML = `
      ${Sidebar.render()}
      <main class="main-content">
        ${Header.render('Character Items', 'Manage character customization items')}
        <div class="content-area p-4">
          <!-- Stats -->
          <div id="category-stats" class="row mb-4"></div>

          <!-- Filters -->
          <div class="card mb-4">
            <div class="card-body">
              <div class="row g-3">
                <div class="col-md-4">
                  <select id="filter-category" class="form-select" onchange="CharacterItemsPage.filterChanged()">
                    <option value="">All Categories</option>
                    ${CATEGORIES.map(c => `<option value="${c}">${c}</option>`).join('')}
                  </select>
                </div>
                <div class="col-md-3">
                  <select id="filter-rarity" class="form-select" onchange="CharacterItemsPage.filterChanged()">
                    <option value="">All Rarities</option>
                    ${RARITIES.map(r => `<option value="${r}">${r.charAt(0).toUpperCase() + r.slice(1)}</option>`).join('')}
                  </select>
                </div>
                <div class="col-md-3">
                  <select id="filter-active" class="form-select" onchange="CharacterItemsPage.filterChanged()">
                    <option value="">All Status</option>
                    <option value="true" selected>Active Only</option>
                    <option value="false">Inactive Only</option>
                  </select>
                </div>
                <div class="col-md-2">
                  <button class="btn btn-primary w-100" onclick="CharacterItemsPage.showCreateModal()">
                    <i class="fas fa-plus me-1"></i> New Item
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Items Grid -->
          <div id="items-grid" class="row g-3"></div>

          <!-- Pagination -->
          <div id="pagination-area" class="mt-4"></div>
        </div>
      </main>
    `;

    Sidebar.updateActive();
    await loadStats();
    await loadItems();
  }

  async function loadStats() {
    try {
      const data = await API.characterItems.getStats();
      const container = document.getElementById('category-stats');

      if (!data.success || !data.data.length) {
        container.innerHTML = '';
        return;
      }

      container.innerHTML = data.data.map(stat => `
        <div class="col-md-3 col-sm-6 mb-2">
          <div class="card border-0 bg-light">
            <div class="card-body py-2 px-3">
              <div class="d-flex justify-content-between align-items-center">
                <span class="text-muted small">${stat.category}</span>
                <span class="badge bg-primary">${stat.active_count}/${stat.count}</span>
              </div>
            </div>
          </div>
        </div>
      `).join('');
    } catch (error) {
      console.error('[CHARACTER-ITEMS] Error loading stats:', error);
    }
  }

  async function loadItems(page = 1) {
    currentPage = page;
    const category = document.getElementById('filter-category')?.value || '';
    const rarity = document.getElementById('filter-rarity')?.value || '';
    const is_active = document.getElementById('filter-active')?.value || '';

    try {
      const data = await API.characterItems.list({ page, limit: 20, category, rarity, is_active });
      const container = document.getElementById('items-grid');

      if (!data.success || !data.data.length) {
        container.innerHTML = `
          <div class="col-12 text-center py-5">
            <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
            <p class="text-muted">No items found</p>
          </div>
        `;
        return;
      }

      container.innerHTML = data.data.map(item => `
        <div class="col-lg-3 col-md-4 col-sm-6">
          <div class="card h-100 ${!item.is_active ? 'opacity-50' : ''}">
            <div class="card-body">
              <div class="d-flex justify-content-between align-items-start mb-2">
                <span class="badge" style="background-color: ${RARITY_COLORS[item.rarity] || '#6c757d'}">
                  ${item.rarity}
                </span>
                <span class="badge bg-secondary">${item.category}</span>
              </div>
              <h6 class="card-title mb-1">${item.name}</h6>
              <p class="text-muted small mb-2">${item.description || '-'}</p>
              <div class="d-flex justify-content-between align-items-center">
                <span class="fw-bold">
                  ${item.price === 0 ? '<span class="text-success">Free</span>' : `🍋 ${item.price}`}
                </span>
                <div>
                  ${item.is_bundled ? '<i class="fas fa-cube text-info me-1" title="Bundled"></i>' : ''}
                  ${item.is_default ? '<i class="fas fa-star text-warning me-1" title="Default"></i>' : ''}
                </div>
              </div>
              <div class="mt-2 small text-muted">
                <code>${item.asset_key}</code>
              </div>
            </div>
            <div class="card-footer bg-transparent border-0 pt-0">
              <div class="btn-group btn-group-sm w-100">
                <button class="btn btn-outline-primary" onclick="CharacterItemsPage.showEditModal(${item.id})">
                  <i class="fas fa-edit"></i> Edit
                </button>
                <button class="btn btn-outline-danger" onclick="CharacterItemsPage.deactivateItem(${item.id})">
                  <i class="fas fa-ban"></i> ${item.is_active ? 'Deactivate' : 'Activate'}
                </button>
              </div>
            </div>
          </div>
        </div>
      `).join('');

      // Pagination
      if (data.pagination && data.pagination.totalPages > 1) {
        const paginationArea = document.getElementById('pagination-area');
        paginationArea.innerHTML = Pagination.render(data.pagination, 'CharacterItemsPage.loadItems');
      }
    } catch (error) {
      console.error('[CHARACTER-ITEMS] Error loading items:', error);
      Toast.error('Failed to load items');
    }
  }

  function filterChanged() {
    loadItems(1);
  }

  function showCreateModal(item = null) {
    const isEdit = !!item;
    const modalHTML = `
      <div class="modal fade" id="itemModal" tabindex="-1">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">${isEdit ? 'Edit Character Item' : 'New Character Item'}</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
              <form id="itemForm"${isEdit ? ` data-edit-id="${item.id}"` : ''}>
                <div class="mb-3">
                  <label class="form-label">Category *</label>
                  <select class="form-select" name="category" required>
                    ${CATEGORIES.map(c => `<option value="${c}"${item && item.category === c ? ' selected' : ''}>${c}</option>`).join('')}
                  </select>
                </div>
                <div class="mb-3">
                  <label class="form-label">Name *</label>
                  <input type="text" class="form-control" name="name" required value="${item ? item.name : ''}">
                </div>
                <div class="mb-3">
                  <label class="form-label">Description</label>
                  <textarea class="form-control" name="description" rows="2">${item ? (item.description || '') : ''}</textarea>
                </div>
                <div class="mb-3">
                  <label class="form-label">Asset Key *</label>
                  <input type="text" class="form-control" name="asset_key" required
                    placeholder="assets/character/hair/my_hair.svg" value="${item ? item.asset_key : ''}">
                </div>
                <div class="row mb-3">
                  <div class="col-6">
                    <label class="form-label">Asset Type</label>
                    <select class="form-select" name="asset_type">
                      <option value="svg"${item && item.asset_type === 'svg' ? ' selected' : ''}>SVG</option>
                      <option value="png"${item && item.asset_type === 'png' ? ' selected' : ''}>PNG</option>
                    </select>
                  </div>
                  <div class="col-6">
                    <label class="form-label">Rarity</label>
                    <select class="form-select" name="rarity">
                      ${RARITIES.map(r => `<option value="${r}"${item && item.rarity === r ? ' selected' : ''}>${r.charAt(0).toUpperCase() + r.slice(1)}</option>`).join('')}
                    </select>
                  </div>
                </div>
                <div class="row mb-3">
                  <div class="col-6">
                    <label class="form-label">Price (lemons)</label>
                    <input type="number" class="form-control" name="price" value="${item ? item.price : 0}" min="0">
                  </div>
                  <div class="col-6">
                    <label class="form-label">Render Order</label>
                    <input type="number" class="form-control" name="render_order" value="${item ? item.render_order : 0}">
                  </div>
                </div>
                <div class="row mb-3">
                  <div class="col-4">
                    <div class="form-check">
                      <input type="checkbox" class="form-check-input" name="is_bundled" id="isBundled"${item && item.is_bundled ? ' checked' : ''}>
                      <label class="form-check-label" for="isBundled">Bundled</label>
                    </div>
                  </div>
                  <div class="col-4">
                    <div class="form-check">
                      <input type="checkbox" class="form-check-input" name="is_default" id="isDefault"${item && item.is_default ? ' checked' : ''}>
                      <label class="form-check-label" for="isDefault">Default</label>
                    </div>
                  </div>
                </div>
              </form>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
              <button type="button" class="btn btn-primary" onclick="CharacterItemsPage.saveItem()">
                <i class="fas fa-save me-1"></i> Save
              </button>
            </div>
          </div>
        </div>
      </div>
    `;

    // Remove existing modal
    const existing = document.getElementById('itemModal');
    if (existing) existing.remove();

    document.body.insertAdjacentHTML('beforeend', modalHTML);
    const modal = new bootstrap.Modal(document.getElementById('itemModal'));
    modal.show();
  }

  async function showEditModal(id) {
    try {
      const data = await API.characterItems.getById(id);
      if (!data.success) {
        Toast.error('Failed to load item');
        return;
      }

      showCreateModal(data.data);
    } catch (error) {
      console.error('[CHARACTER-ITEMS] Error loading item for edit:', error);
      Toast.error('Failed to load item');
    }
  }

  async function saveItem() {
    const form = document.getElementById('itemForm');
    if (!form) return;

    const editId = form.dataset.editId;
    const body = {
      category: form.querySelector('[name="category"]').value,
      name: form.querySelector('[name="name"]').value,
      description: form.querySelector('[name="description"]').value || null,
      asset_key: form.querySelector('[name="asset_key"]').value,
      asset_type: form.querySelector('[name="asset_type"]').value,
      rarity: form.querySelector('[name="rarity"]').value,
      price: parseInt(form.querySelector('[name="price"]').value) || 0,
      render_order: parseInt(form.querySelector('[name="render_order"]').value) || 0,
      is_bundled: form.querySelector('[name="is_bundled"]').checked,
      is_default: form.querySelector('[name="is_default"]').checked,
    };

    try {
      let result;
      if (editId) {
        result = await API.characterItems.update(editId, body);
      } else {
        result = await API.characterItems.create(body);
      }

      if (result.success) {
        Toast.success(editId ? 'Item updated' : 'Item created');
        const modal = bootstrap.Modal.getInstance(document.getElementById('itemModal'));
        modal.hide();
        await loadItems(currentPage);
        await loadStats();
      } else {
        Toast.error(result.error || 'Failed to save item');
      }
    } catch (error) {
      console.error('[CHARACTER-ITEMS] Error saving item:', error);
      Toast.error('Failed to save item');
    }
  }

  async function deactivateItem(id) {
    if (!confirm('Are you sure you want to toggle this item\'s active status?')) return;

    try {
      const current = await API.characterItems.getById(id);
      if (!current.success) {
        Toast.error('Failed to get item');
        return;
      }

      const newActive = !current.data.is_active;
      const result = await API.characterItems.update(id, { is_active: newActive });

      if (result.success) {
        Toast.success(newActive ? 'Item activated' : 'Item deactivated');
        await loadItems(currentPage);
        await loadStats();
      }
    } catch (error) {
      console.error('[CHARACTER-ITEMS] Error toggling item:', error);
      Toast.error('Failed to update item');
    }
  }

  return {
    render,
    loadItems,
    filterChanged,
    showCreateModal,
    showEditModal,
    saveItem,
    deactivateItem,
  };
})();
