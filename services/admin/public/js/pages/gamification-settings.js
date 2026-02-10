/**
 * Gamification Settings Page
 *
 * Ad configuration and lemon reward parameters management
 * Pattern: IIFE like app-theme.js
 */

const GamificationSettingsPage = (() => {
  let currentSettings = null;
  let activeTab = 'ads';

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('게임화 설정')}
          <div class="content-container">

            <div class="alert alert-info mb-4">
              <i class="fas fa-info-circle me-2"></i>
              <strong>참고:</strong> 광고 ID와 레몬 보상 파라미터를 관리합니다. Flutter 앱은 시작 시 이 설정을 서버에서 로드합니다.
            </div>

            <!-- Tab Navigation -->
            <ul class="nav nav-tabs mb-4" role="tablist">
              <li class="nav-item">
                <a class="nav-link active" id="ads-tab" data-tab="ads" href="#" onclick="GamificationSettingsPage.switchTab('ads'); return false;">
                  <i class="fas fa-ad me-2"></i>광고 설정
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" id="lemons-tab" data-tab="lemons" href="#" onclick="GamificationSettingsPage.switchTab('lemons'); return false;">
                  <i class="fas fa-lemon me-2"></i>레몬 설정
                </a>
              </li>
            </ul>

            <!-- Tab Content -->
            <div id="tab-content">
              <!-- Populated by switchTab() -->
            </div>

          </div>
        </div>
      </div>
    `;

    Router.render(layout);
    await loadSettings();
    switchTab('ads');
  }

  function switchTab(tabName) {
    activeTab = tabName;

    document.querySelectorAll('.nav-link').forEach(link => {
      link.classList.remove('active');
    });
    const tabEl = document.querySelector(`[data-tab="${tabName}"]`);
    if (tabEl) tabEl.classList.add('active');

    const tabContent = document.getElementById('tab-content');
    switch (tabName) {
      case 'ads':
        tabContent.innerHTML = renderAdsTab();
        break;
      case 'lemons':
        tabContent.innerHTML = renderLemonsTab();
        break;
    }
  }

  async function loadSettings() {
    try {
      const response = await fetch('/api/admin/gamification/settings');
      if (!response.ok) throw new Error('Failed to load settings');
      currentSettings = await response.json();
    } catch (error) {
      console.error('[GamificationSettings] Load error:', error);
      Toast.error('설정을 불러오지 못했습니다: ' + error.message);
    }
  }

  // ==================== Ads Tab ====================
  function renderAdsTab() {
    if (!currentSettings) {
      return '<div class="text-center py-4"><div class="spinner-border text-primary"></div></div>';
    }

    return `
      <div class="card">
        <div class="card-header">
          <h5 class="card-title mb-0"><i class="fas fa-mobile-alt me-2"></i>AdMob (모바일)</h5>
        </div>
        <div class="card-body">
          <div class="mb-3">
            <label class="form-label">AdMob App ID</label>
            <input type="text" class="form-control" id="admob_app_id"
                   value="${escapeHtml(currentSettings.admob_app_id || '')}"
                   placeholder="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX">
            <div class="form-text">Google AdMob 앱 ID</div>
          </div>
          <div class="mb-3">
            <label class="form-label">AdMob Rewarded Ad Unit ID</label>
            <input type="text" class="form-control" id="admob_rewarded_ad_id"
                   value="${escapeHtml(currentSettings.admob_rewarded_ad_id || '')}"
                   placeholder="ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX">
            <div class="form-text">보상형 광고 단위 ID (레몬 나무 수확 시 표시)</div>
          </div>
        </div>
      </div>

      <div class="card mt-3">
        <div class="card-header">
          <h5 class="card-title mb-0"><i class="fas fa-globe me-2"></i>AdSense (웹)</h5>
        </div>
        <div class="card-body">
          <div class="mb-3">
            <label class="form-label">AdSense Publisher ID</label>
            <input type="text" class="form-control" id="adsense_publisher_id"
                   value="${escapeHtml(currentSettings.adsense_publisher_id || '')}"
                   placeholder="ca-pub-XXXXXXXXXXXXXXXX">
          </div>
          <div class="mb-3">
            <label class="form-label">AdSense Ad Slot</label>
            <input type="text" class="form-control" id="adsense_ad_slot"
                   value="${escapeHtml(currentSettings.adsense_ad_slot || '')}"
                   placeholder="XXXXXXXXXX">
          </div>
        </div>
      </div>

      <div class="card mt-3">
        <div class="card-header">
          <h5 class="card-title mb-0"><i class="fas fa-toggle-on me-2"></i>활성화</h5>
        </div>
        <div class="card-body">
          <div class="form-check form-switch mb-3">
            <input class="form-check-input" type="checkbox" id="ads_enabled"
                   ${currentSettings.ads_enabled ? 'checked' : ''}>
            <label class="form-check-label" for="ads_enabled">모바일 광고 활성화</label>
          </div>
          <div class="form-check form-switch mb-3">
            <input class="form-check-input" type="checkbox" id="web_ads_enabled"
                   ${currentSettings.web_ads_enabled ? 'checked' : ''}>
            <label class="form-check-label" for="web_ads_enabled">웹 광고 활성화</label>
          </div>
        </div>
      </div>

      <div class="mt-4">
        <button class="btn btn-primary" onclick="GamificationSettingsPage.saveAdSettings()">
          <i class="fas fa-save me-2"></i>광고 설정 저장
        </button>
      </div>
    `;
  }

  async function saveAdSettings() {
    const data = {
      admob_app_id: document.getElementById('admob_app_id').value.trim(),
      admob_rewarded_ad_id: document.getElementById('admob_rewarded_ad_id').value.trim(),
      adsense_publisher_id: document.getElementById('adsense_publisher_id').value.trim(),
      adsense_ad_slot: document.getElementById('adsense_ad_slot').value.trim(),
      ads_enabled: document.getElementById('ads_enabled').checked,
      web_ads_enabled: document.getElementById('web_ads_enabled').checked,
    };

    try {
      const token = Auth.getToken();
      const response = await fetch('/api/admin/gamification/ad-settings', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        const err = await response.json();
        throw new Error(err.error || 'Failed to save');
      }

      currentSettings = await response.json();
      Toast.success('광고 설정이 저장되었습니다.');
    } catch (error) {
      console.error('[GamificationSettings] Save ad error:', error);
      Toast.error('저장 실패: ' + error.message);
    }
  }

  // ==================== Lemons Tab ====================
  function renderLemonsTab() {
    if (!currentSettings) {
      return '<div class="text-center py-4"><div class="spinner-border text-primary"></div></div>';
    }

    return `
      <div class="card">
        <div class="card-header">
          <h5 class="card-title mb-0"><i class="fas fa-star me-2"></i>레몬 보상 기준</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label class="form-label">레몬 3개 점수 임계값 (%)</label>
              <input type="number" class="form-control" id="lemon_3_threshold"
                     value="${currentSettings.lemon_3_threshold}" min="0" max="100">
              <div class="form-text">이 점수 이상이면 레몬 3개 획득</div>
            </div>
            <div class="col-md-6 mb-3">
              <label class="form-label">레몬 2개 점수 임계값 (%)</label>
              <input type="number" class="form-control" id="lemon_2_threshold"
                     value="${currentSettings.lemon_2_threshold}" min="0" max="100">
              <div class="form-text">이 점수 이상이면 레몬 2개 획득 (미만이면 1개)</div>
            </div>
          </div>
        </div>
      </div>

      <div class="card mt-3">
        <div class="card-header">
          <h5 class="card-title mb-0"><i class="fas fa-crown me-2"></i>보스 퀴즈</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label class="form-label">보스 퀴즈 보너스 레몬</label>
              <input type="number" class="form-control" id="boss_quiz_bonus"
                     value="${currentSettings.boss_quiz_bonus}" min="1" max="50">
              <div class="form-text">보스 퀴즈 통과 시 보너스로 받는 레몬 수</div>
            </div>
            <div class="col-md-6 mb-3">
              <label class="form-label">보스 퀴즈 통과 기준 (%)</label>
              <input type="number" class="form-control" id="boss_quiz_pass_percent"
                     value="${currentSettings.boss_quiz_pass_percent}" min="0" max="100">
              <div class="form-text">이 점수 이상이면 보스 퀴즈 통과</div>
            </div>
          </div>
        </div>
      </div>

      <div class="card mt-3">
        <div class="card-header">
          <h5 class="card-title mb-0"><i class="fas fa-tree me-2"></i>레몬 나무</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label class="form-label">나무 최대 레몬 수</label>
              <input type="number" class="form-control" id="max_tree_lemons"
                     value="${currentSettings.max_tree_lemons}" min="1" max="20">
              <div class="form-text">나무에 동시에 표시할 수 있는 최대 레몬 수</div>
            </div>
          </div>
        </div>
      </div>

      <div class="mt-4 d-flex gap-2">
        <button class="btn btn-primary" onclick="GamificationSettingsPage.saveLemonSettings()">
          <i class="fas fa-save me-2"></i>레몬 설정 저장
        </button>
        <button class="btn btn-outline-danger" onclick="GamificationSettingsPage.resetSettings()">
          <i class="fas fa-undo me-2"></i>기본값 복원
        </button>
      </div>
    `;
  }

  async function saveLemonSettings() {
    const data = {
      lemon_3_threshold: parseInt(document.getElementById('lemon_3_threshold').value, 10),
      lemon_2_threshold: parseInt(document.getElementById('lemon_2_threshold').value, 10),
      boss_quiz_bonus: parseInt(document.getElementById('boss_quiz_bonus').value, 10),
      boss_quiz_pass_percent: parseInt(document.getElementById('boss_quiz_pass_percent').value, 10),
      max_tree_lemons: parseInt(document.getElementById('max_tree_lemons').value, 10),
    };

    // Client-side validation
    if (data.lemon_3_threshold <= data.lemon_2_threshold) {
      Toast.error('레몬 3개 임계값은 레몬 2개 임계값보다 커야 합니다.');
      return;
    }

    try {
      const token = Auth.getToken();
      const response = await fetch('/api/admin/gamification/lemon-settings', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        const err = await response.json();
        throw new Error(err.error || 'Failed to save');
      }

      currentSettings = await response.json();
      Toast.success('레몬 설정이 저장되었습니다.');
    } catch (error) {
      console.error('[GamificationSettings] Save lemon error:', error);
      Toast.error('저장 실패: ' + error.message);
    }
  }

  async function resetSettings() {
    if (!confirm('모든 게임화 설정을 기본값으로 복원하시겠습니까?')) return;

    try {
      const token = Auth.getToken();
      const response = await fetch('/api/admin/gamification/reset', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
      });

      if (!response.ok) {
        const err = await response.json();
        throw new Error(err.error || 'Failed to reset');
      }

      const result = await response.json();
      currentSettings = result.settings;
      Toast.success('기본값으로 복원되었습니다.');
      switchTab(activeTab); // Re-render current tab
    } catch (error) {
      console.error('[GamificationSettings] Reset error:', error);
      Toast.error('복원 실패: ' + error.message);
    }
  }

  function escapeHtml(str) {
    const div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
  }

  return {
    render,
    switchTab,
    saveAdSettings,
    saveLemonSettings,
    resetSettings,
  };
})();
