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

  const MEDIA_BASE = window.location.origin + '/media/';

  let currentPage = 1;
  let currentCategory = '';
  let _spriteAnimId = null;
  let _spriteImg = null;
  let _previewRow = 0;

  async function render() {
    const app = document.getElementById('app');
    app.innerHTML = `
      ${Sidebar.render()}
      <main class="main-content">
        ${Header.render('Character Items')}
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

  function renderSpriteThumbnail(item) {
    const meta = item.metadata || {};
    if (item.asset_type === 'spritesheet' && meta.spritesheet_key) {
      const url = MEDIA_BASE + meta.spritesheet_key;
      const fw = meta.frameWidth || 32;
      const fh = meta.frameHeight || 48;
      return `
        <div class="text-center mb-2">
          <div style="width:${fw}px;height:${fh}px;margin:0 auto;overflow:hidden;
            background:url('${url}') 0 0 no-repeat;background-size:auto;
            image-rendering:pixelated;border:1px solid #dee2e6;border-radius:4px;">
          </div>
        </div>`;
    }
    return '';
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
              ${renderSpriteThumbnail(item)}
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
    cleanupAnimation();
    const isEdit = !!item;
    const meta = (item && item.metadata) || {};
    const isSpritesheet = item && item.asset_type === 'spritesheet';

    const modalHTML = `
      <div class="modal fade" id="itemModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">${isEdit ? 'Edit Character Item' : 'New Character Item'}</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
              <form id="itemForm"${isEdit ? ` data-edit-id="${item.id}"` : ''}>
                <div class="row">
                  <!-- Left column: basic fields -->
                  <div class="col-md-6">
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
                        <select class="form-select" name="asset_type" onchange="CharacterItemsPage.onAssetTypeChange()">
                          <option value="svg"${item && item.asset_type === 'svg' ? ' selected' : ''}>SVG</option>
                          <option value="png"${item && item.asset_type === 'png' ? ' selected' : ''}>PNG</option>
                          <option value="spritesheet"${isSpritesheet ? ' selected' : ''}>Spritesheet</option>
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
                  </div>

                  <!-- Right column: sprite section -->
                  <div class="col-md-6" id="spriteSection" style="display:${isSpritesheet ? 'block' : 'none'};">
                    <div class="card bg-light">
                      <div class="card-body">
                        <h6 class="card-title mb-3"><i class="fas fa-image me-1"></i> Sprite Settings</h6>

                        <!-- Upload -->
                        <div class="mb-3">
                          <label class="form-label">Upload Sprite PNG</label>
                          <input type="file" class="form-control" id="spriteFileInput" accept=".png,image/png"
                            onchange="CharacterItemsPage.handleSpriteFileSelected(this.files[0])">
                        </div>

                        <!-- Preview Canvas -->
                        <div class="mb-3 text-center">
                          <canvas id="spritePreviewCanvas" width="96" height="144"
                            style="border:1px solid #dee2e6;border-radius:4px;image-rendering:pixelated;background:#f8f9fa;"></canvas>
                          <div class="mt-2 btn-group btn-group-sm">
                            <button type="button" class="btn btn-outline-secondary active" onclick="CharacterItemsPage.previewDirection(0, this)">Front</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="CharacterItemsPage.previewDirection(1, this)">Back</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="CharacterItemsPage.previewDirection(2, this)">Right</button>
                          </div>
                        </div>

                        <!-- Frame Metadata -->
                        <div class="row g-2 mb-3">
                          <div class="col-6">
                            <label class="form-label small">Frame Width</label>
                            <input type="number" class="form-control form-control-sm" name="frameWidth" value="${meta.frameWidth || 32}" min="1">
                          </div>
                          <div class="col-6">
                            <label class="form-label small">Frame Height</label>
                            <input type="number" class="form-control form-control-sm" name="frameHeight" value="${meta.frameHeight || 48}" min="1">
                          </div>
                          <div class="col-6">
                            <label class="form-label small">Columns</label>
                            <input type="number" class="form-control form-control-sm" name="frameColumns" value="${meta.frameColumns || 5}" min="1">
                          </div>
                          <div class="col-6">
                            <label class="form-label small">Rows</label>
                            <input type="number" class="form-control form-control-sm" name="frameRows" value="${meta.frameRows || 4}" min="1">
                          </div>
                        </div>

                        <!-- Current Key -->
                        ${meta.spritesheet_key ? `<div class="small text-muted"><strong>Key:</strong> <code>${meta.spritesheet_key}</code></div>` : ''}
                      </div>
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
    const modalEl = document.getElementById('itemModal');
    const modal = new bootstrap.Modal(modalEl);

    // Cleanup animation when modal is hidden
    modalEl.addEventListener('hidden.bs.modal', () => cleanupAnimation());

    modal.show();

    // If editing a spritesheet item with existing key, init preview
    if (isSpritesheet && meta.spritesheet_key) {
      initSpritePreview(meta.spritesheet_key, meta);
    }
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

  function onAssetTypeChange() {
    const assetType = document.querySelector('[name="asset_type"]').value;
    const section = document.getElementById('spriteSection');
    if (section) {
      section.style.display = assetType === 'spritesheet' ? 'block' : 'none';
    }
  }

  async function handleSpriteFileSelected(file) {
    if (!file) return;

    const form = document.getElementById('itemForm');
    const category = form.querySelector('[name="category"]').value;
    const editId = form.dataset.editId;

    try {
      const formData = new FormData();
      formData.append('sprite', file);
      formData.append('category', category);
      if (editId) {
        formData.append('itemId', editId);
      }

      Toast.info('Uploading sprite...');
      const result = await API.characterItems.uploadSprite(formData);

      if (result.success) {
        Toast.success('Sprite uploaded');

        // Auto-set asset_key to the uploaded key
        form.querySelector('[name="asset_key"]').value = result.data.key;

        // Init preview
        const meta = {
          frameWidth: parseInt(form.querySelector('[name="frameWidth"]').value) || 32,
          frameHeight: parseInt(form.querySelector('[name="frameHeight"]').value) || 48,
          frameColumns: parseInt(form.querySelector('[name="frameColumns"]').value) || 5,
          frameRows: parseInt(form.querySelector('[name="frameRows"]').value) || 4,
        };
        initSpritePreview(result.data.key, meta);
      }
    } catch (error) {
      console.error('[CHARACTER-ITEMS] Sprite upload failed:', error);
      Toast.error('Upload failed: ' + error.message);
    }
  }

  function initSpritePreview(key, meta) {
    cleanupAnimation();
    _previewRow = 0;

    const url = MEDIA_BASE + key;
    _spriteImg = new Image();
    _spriteImg.crossOrigin = 'anonymous';
    _spriteImg.onload = () => {
      animatePreview(meta);
    };
    _spriteImg.onerror = () => {
      console.warn('[CHARACTER-ITEMS] Failed to load sprite image:', url);
    };
    _spriteImg.src = url;
  }

  function animatePreview(meta) {
    const canvas = document.getElementById('spritePreviewCanvas');
    if (!canvas || !_spriteImg) return;

    const ctx = canvas.getContext('2d');
    const fw = meta.frameWidth || 32;
    const fh = meta.frameHeight || 48;
    const cols = meta.frameColumns || 5;
    const scale = 3;

    canvas.width = fw * scale;
    canvas.height = fh * scale;
    ctx.imageSmoothingEnabled = false;

    let frameIndex = 0;
    const fps = 8;
    let lastTime = 0;
    const interval = 1000 / fps;

    function draw(timestamp) {
      _spriteAnimId = requestAnimationFrame(draw);

      if (timestamp - lastTime < interval) return;
      lastTime = timestamp;

      const sx = (frameIndex % cols) * fw;
      const sy = _previewRow * fh;

      ctx.clearRect(0, 0, canvas.width, canvas.height);
      ctx.drawImage(_spriteImg, sx, sy, fw, fh, 0, 0, fw * scale, fh * scale);

      frameIndex = (frameIndex + 1) % cols;
    }

    _spriteAnimId = requestAnimationFrame(draw);
  }

  function previewDirection(row, btn) {
    _previewRow = row;

    // Update active button
    if (btn) {
      const group = btn.parentElement;
      group.querySelectorAll('.btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
    }

    // Restart animation with current meta from form inputs
    if (_spriteImg && _spriteImg.complete) {
      cleanupAnimation();
      const form = document.getElementById('itemForm');
      if (form) {
        const meta = {
          frameWidth: parseInt(form.querySelector('[name="frameWidth"]').value) || 32,
          frameHeight: parseInt(form.querySelector('[name="frameHeight"]').value) || 48,
          frameColumns: parseInt(form.querySelector('[name="frameColumns"]').value) || 5,
        };
        animatePreview(meta);
      }
    }
  }

  function cleanupAnimation() {
    if (_spriteAnimId) {
      cancelAnimationFrame(_spriteAnimId);
      _spriteAnimId = null;
    }
  }

  async function saveItem() {
    const form = document.getElementById('itemForm');
    if (!form) return;

    const editId = form.dataset.editId;
    const assetType = form.querySelector('[name="asset_type"]').value;

    const body = {
      category: form.querySelector('[name="category"]').value,
      name: form.querySelector('[name="name"]').value,
      description: form.querySelector('[name="description"]').value || null,
      asset_key: form.querySelector('[name="asset_key"]').value,
      asset_type: assetType,
      rarity: form.querySelector('[name="rarity"]').value,
      price: parseInt(form.querySelector('[name="price"]').value) || 0,
      render_order: parseInt(form.querySelector('[name="render_order"]').value) || 0,
      is_bundled: form.querySelector('[name="is_bundled"]').checked,
      is_default: form.querySelector('[name="is_default"]').checked,
    };

    // Build metadata for spritesheet items
    if (assetType === 'spritesheet') {
      const spriteMeta = {
        frameWidth: parseInt(form.querySelector('[name="frameWidth"]').value) || 32,
        frameHeight: parseInt(form.querySelector('[name="frameHeight"]').value) || 48,
        frameColumns: parseInt(form.querySelector('[name="frameColumns"]').value) || 5,
        frameRows: parseInt(form.querySelector('[name="frameRows"]').value) || 4,
      };

      if (editId) {
        // Merge with existing metadata (preserve spritesheet_key etc.)
        try {
          const existing = await API.characterItems.getById(editId);
          if (existing.success && existing.data.metadata) {
            body.metadata = { ...existing.data.metadata, ...spriteMeta };
          } else {
            body.metadata = spriteMeta;
          }
        } catch {
          body.metadata = spriteMeta;
        }
      } else {
        body.metadata = spriteMeta;
      }
    }

    try {
      let result;
      if (editId) {
        result = await API.characterItems.update(editId, body);
      } else {
        result = await API.characterItems.create(body);
      }

      if (result.success) {
        Toast.success(editId ? 'Item updated' : 'Item created');
        cleanupAnimation();
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
    onAssetTypeChange,
    handleSpriteFileSelected,
    previewDirection,
  };
})();
