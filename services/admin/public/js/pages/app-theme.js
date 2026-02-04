/**
 * App Theme Page
 *
 * Flutter app theme configuration (colors, logos, fonts)
 * Note: Separate from Design page (which controls admin dashboard theme)
 */

const AppThemePage = (() => {
  let currentSettings = null;
  let activeTab = 'colors'; // colors, media, fonts

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('앱 테마 설정')}
          <div class="content-container">

            <div class="alert alert-info mb-4">
              <i class="fas fa-info-circle me-2"></i>
              <strong>참고:</strong> 이 설정은 Flutter 앱과 웹 앱의 디자인을 제어합니다. 관리자 대시보드 디자인은 "디자인 설정" 메뉴에서 변경할 수 있습니다.
            </div>

            <!-- Tab Navigation -->
            <ul class="nav nav-tabs mb-4" role="tablist">
              <li class="nav-item">
                <a class="nav-link active" id="colors-tab" data-tab="colors" href="#" onclick="AppThemePage.switchTab('colors'); return false;">
                  <i class="fas fa-palette me-2"></i>색상 설정
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" id="media-tab" data-tab="media" href="#" onclick="AppThemePage.switchTab('media'); return false;">
                  <i class="fas fa-images me-2"></i>로고 및 파비콘
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" id="fonts-tab" data-tab="fonts" href="#" onclick="AppThemePage.switchTab('fonts'); return false;">
                  <i class="fas fa-font me-2"></i>폰트
                </a>
              </li>
            </ul>

            <!-- Tab Content -->
            <div id="tab-content">
              <!-- Will be populated by switchTab() -->
            </div>

          </div>
        </div>
      </div>
    `;

    Router.render(layout);
    await loadSettings();
    switchTab('colors');
  }

  function switchTab(tabName) {
    activeTab = tabName;

    // Update tab navigation
    document.querySelectorAll('.nav-link').forEach(link => {
      link.classList.remove('active');
    });
    document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');

    // Render tab content
    const tabContent = document.getElementById('tab-content');
    switch (tabName) {
      case 'colors':
        tabContent.innerHTML = renderColorsTab();
        setupColorPickers();
        break;
      case 'media':
        tabContent.innerHTML = renderMediaTab();
        break;
      case 'fonts':
        tabContent.innerHTML = renderFontsTab();
        break;
    }
  }

  function renderColorsTab() {
    const settings = currentSettings || {};
    return `
      <div class="row">
        <div class="col-12">
          <div class="table-card">
            <div class="card-header">
              <h5 class="card-title">앱 색상 구성</h5>
            </div>
            <div class="card-body">
              <form id="colors-form" onsubmit="return false;">

                <!-- Brand Colors -->
                <h6 class="mb-3 mt-3"><i class="fas fa-tag me-2"></i>브랜드 색상</h6>
                <div class="row">
                  ${renderColorInput('primary_color', 'Primary Color', settings.primary_color || '#FFEF5F')}
                  ${renderColorInput('secondary_color', 'Secondary Color', settings.secondary_color || '#4CAF50')}
                  ${renderColorInput('accent_color', 'Accent Color', settings.accent_color || '#FF9800')}
                </div>

                <!-- Status Colors -->
                <h6 class="mb-3 mt-4"><i class="fas fa-exclamation-circle me-2"></i>상태 색상</h6>
                <div class="row">
                  ${renderColorInput('error_color', 'Error', settings.error_color || '#F44336')}
                  ${renderColorInput('success_color', 'Success', settings.success_color || '#4CAF50')}
                  ${renderColorInput('warning_color', 'Warning', settings.warning_color || '#FF9800')}
                  ${renderColorInput('info_color', 'Info', settings.info_color || '#2196F3')}
                </div>

                <!-- Text Colors -->
                <h6 class="mb-3 mt-4"><i class="fas fa-font me-2"></i>텍스트 색상</h6>
                <div class="row">
                  ${renderColorInput('text_primary', 'Primary Text', settings.text_primary || '#212121')}
                  ${renderColorInput('text_secondary', 'Secondary Text', settings.text_secondary || '#757575')}
                  ${renderColorInput('text_hint', 'Hint Text', settings.text_hint || '#BDBDBD')}
                </div>

                <!-- Background Colors -->
                <h6 class="mb-3 mt-4"><i class="fas fa-fill-drip me-2"></i>배경 색상</h6>
                <div class="row">
                  ${renderColorInput('background_light', 'Light Background', settings.background_light || '#FAFAFA')}
                  ${renderColorInput('background_dark', 'Dark Background', settings.background_dark || '#303030')}
                  ${renderColorInput('card_background', 'Card Background', settings.card_background || '#FFFFFF')}
                </div>

                <!-- Lesson Stage Colors -->
                <h6 class="mb-3 mt-4"><i class="fas fa-graduation-cap me-2"></i>레슨 단계 색상</h6>
                <div class="row">
                  ${renderColorInput('stage1_color', 'Stage 1 (Intro)', settings.stage1_color || '#2196F3')}
                  ${renderColorInput('stage2_color', 'Stage 2 (Vocabulary)', settings.stage2_color || '#4CAF50')}
                  ${renderColorInput('stage3_color', 'Stage 3 (Grammar)', settings.stage3_color || '#FF9800')}
                  ${renderColorInput('stage4_color', 'Stage 4 (Practice)', settings.stage4_color || '#9C27B0')}
                </div>
                <div class="row">
                  ${renderColorInput('stage5_color', 'Stage 5 (Dialogue)', settings.stage5_color || '#E91E63')}
                  ${renderColorInput('stage6_color', 'Stage 6 (Quiz)', settings.stage6_color || '#F44336')}
                  ${renderColorInput('stage7_color', 'Stage 7 (Summary)', settings.stage7_color || '#607D8B')}
                </div>

                <div class="d-flex gap-2 mt-4">
                  <button type="button" class="btn btn-primary" onclick="AppThemePage.saveColors()">
                    <i class="fas fa-save me-2"></i>색상 저장
                  </button>
                  <button type="button" class="btn btn-warning" onclick="AppThemePage.resetSettings()">
                    <i class="fas fa-undo me-2"></i>모두 기본값으로 복원
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  function renderColorInput(fieldName, label, defaultValue) {
    return `
      <div class="col-md-4 mb-3">
        <label class="form-label">${label}</label>
        <div class="input-group">
          <input type="color" class="form-control form-control-color" id="${fieldName}" value="${defaultValue}">
          <input type="text" class="form-control" id="${fieldName}_hex" value="${defaultValue}" pattern="^#[0-9A-Fa-f]{6}$" maxlength="7">
        </div>
      </div>
    `;
  }

  function renderMediaTab() {
    const settings = currentSettings || {};
    return `
      <div class="row">
        <div class="col-lg-6">
          <div class="table-card mb-4">
            <div class="card-header">
              <h5 class="card-title">스플래시 로고</h5>
            </div>
            <div class="card-body">
              <p class="text-muted">앱 시작 시 표시되는 로고 (PNG, JPEG, SVG, WebP - 최대 5MB)</p>
              <input type="file" class="form-control mb-2" id="splash-logo-file" accept="image/png,image/jpeg,image/svg+xml,image/webp">
              <button type="button" class="btn btn-sm btn-primary" onclick="AppThemePage.uploadSplashLogo()">
                <i class="fas fa-upload me-1"></i>업로드
              </button>
              <div id="splash-logo-preview" class="mt-3">
                ${settings.splash_logo_url ? `
                  <div class="alert alert-info">
                    <strong>현재 스플래시 로고:</strong><br>
                    <img src="${settings.splash_logo_url}" alt="Splash Logo" style="max-width: 200px; margin-top: 10px;">
                  </div>
                ` : '<p class="text-muted">업로드된 로고가 없습니다.</p>'}
              </div>
            </div>
          </div>
        </div>

        <div class="col-lg-6">
          <div class="table-card mb-4">
            <div class="card-header">
              <h5 class="card-title">로그인 로고</h5>
            </div>
            <div class="card-body">
              <p class="text-muted">로그인 화면에 표시되는 로고 (PNG, JPEG, SVG, WebP - 최대 5MB)</p>
              <input type="file" class="form-control mb-2" id="login-logo-file" accept="image/png,image/jpeg,image/svg+xml,image/webp">
              <button type="button" class="btn btn-sm btn-primary" onclick="AppThemePage.uploadLoginLogo()">
                <i class="fas fa-upload me-1"></i>업로드
              </button>
              <div id="login-logo-preview" class="mt-3">
                ${settings.login_logo_url ? `
                  <div class="alert alert-info">
                    <strong>현재 로그인 로고:</strong><br>
                    <img src="${settings.login_logo_url}" alt="Login Logo" style="max-width: 200px; margin-top: 10px;">
                  </div>
                ` : '<p class="text-muted">업로드된 로고가 없습니다.</p>'}
              </div>
            </div>
          </div>
        </div>

        <div class="col-lg-6">
          <div class="table-card">
            <div class="card-header">
              <h5 class="card-title">파비콘</h5>
            </div>
            <div class="card-body">
              <p class="text-muted">웹 앱 파비콘 (ICO, PNG - 최대 1MB)</p>
              <input type="file" class="form-control mb-2" id="favicon-file" accept="image/x-icon,image/vnd.microsoft.icon,image/png">
              <button type="button" class="btn btn-sm btn-primary" onclick="AppThemePage.uploadFavicon()">
                <i class="fas fa-upload me-1"></i>업로드
              </button>
              <div id="favicon-preview" class="mt-3">
                ${settings.favicon_url ? `
                  <div class="alert alert-info">
                    <strong>현재 파비콘:</strong><br>
                    <img src="${settings.favicon_url}" alt="Favicon" style="width: 32px; height: 32px; margin-top: 10px;">
                  </div>
                ` : '<p class="text-muted">업로드된 파비콘이 없습니다.</p>'}
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  function renderFontsTab() {
    const settings = currentSettings || {};
    const googleFonts = [
      'NotoSansKR',
      'Roboto',
      'Open Sans',
      'Lato',
      'Montserrat',
      'Noto Sans',
      'Poppins',
      'Inter',
      'Raleway',
      'Ubuntu'
    ];

    return `
      <div class="row">
        <div class="col-lg-6">
          <div class="table-card mb-4">
            <div class="card-header">
              <h5 class="card-title">Google Fonts 선택</h5>
            </div>
            <div class="card-body">
              <p class="text-muted">구글 폰트 라이브러리에서 폰트를 선택하세요.</p>
              <select class="form-select mb-3" id="google-font-select">
                ${googleFonts.map(font => `
                  <option value="${font}" ${settings.font_family === font && settings.font_source === 'google' ? 'selected' : ''}>${font}</option>
                `).join('')}
              </select>
              <button type="button" class="btn btn-primary" onclick="AppThemePage.setGoogleFont()">
                <i class="fas fa-check me-2"></i>폰트 적용
              </button>

              <div class="mt-4 p-3" style="border: 1px solid #ddd; border-radius: 8px; background: #f8f9fa;">
                <h6>폰트 미리보기</h6>
                <div id="font-preview" style="font-size: 16px; line-height: 1.8;">
                  <p style="font-family: ${settings.font_family || 'NotoSansKR'};">
                    안녕하세요 Hello 1234567890<br>
                    한국어 학습 앱입니다.<br>
                    Korean Learning Application
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="col-lg-6">
          <div class="table-card">
            <div class="card-header">
              <h5 class="card-title">커스텀 폰트 업로드</h5>
            </div>
            <div class="card-body">
              <p class="text-muted">TTF 또는 OTF 폰트 파일을 업로드하세요 (최대 10MB)</p>
              <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>주의:</strong> 상업적 사용이 허가된 폰트만 업로드하세요. 라이선스 위반 책임은 업로더에게 있습니다.
              </div>
              <input type="file" class="form-control mb-2" id="custom-font-file" accept=".ttf,.otf">
              <button type="button" class="btn btn-primary" onclick="AppThemePage.uploadCustomFont()">
                <i class="fas fa-upload me-2"></i>폰트 업로드
              </button>

              ${settings.font_source === 'custom' && settings.custom_font_url ? `
                <div class="alert alert-info mt-3">
                  <strong>현재 커스텀 폰트:</strong><br>
                  ${settings.font_family}<br>
                  <a href="${settings.custom_font_url}" target="_blank" class="btn btn-sm btn-secondary mt-2">
                    <i class="fas fa-download me-1"></i>다운로드
                  </a>
                </div>
              ` : ''}
            </div>
          </div>
        </div>

        <div class="col-12 mt-3">
          <div class="alert alert-info">
            <i class="fas fa-info-circle me-2"></i>
            <strong>현재 설정:</strong> ${settings.font_family || 'NotoSansKR'} (${settings.font_source === 'google' ? 'Google Fonts' : settings.font_source === 'custom' ? '커스텀 폰트' : '시스템 폰트'})
          </div>
        </div>
      </div>
    `;
  }

  async function loadSettings() {
    try {
      const response = await fetch('/api/admin/app-theme/settings');
      if (!response.ok) throw new Error('Failed to load settings');

      currentSettings = await response.json();
    } catch (error) {
      console.error('Failed to load settings:', error);
      Toast.error('설정을 불러오는데 실패했습니다.');
    }
  }

  function setupColorPickers() {
    const colorFields = [
      'primary_color', 'secondary_color', 'accent_color',
      'error_color', 'success_color', 'warning_color', 'info_color',
      'text_primary', 'text_secondary', 'text_hint',
      'background_light', 'background_dark', 'card_background',
      'stage1_color', 'stage2_color', 'stage3_color', 'stage4_color',
      'stage5_color', 'stage6_color', 'stage7_color'
    ];

    colorFields.forEach(field => {
      const colorInput = document.getElementById(field);
      const hexInput = document.getElementById(field + '_hex');

      if (!colorInput || !hexInput) return;

      // Color picker changes hex input
      colorInput.addEventListener('input', (e) => {
        hexInput.value = e.target.value.toUpperCase();
      });

      // Hex input changes color picker
      hexInput.addEventListener('input', (e) => {
        const value = e.target.value;
        if (/^#[0-9A-Fa-f]{6}$/.test(value)) {
          colorInput.value = value;
        }
      });
    });
  }

  async function saveColors() {
    try {
      const colorFields = [
        'primary_color', 'secondary_color', 'accent_color',
        'error_color', 'success_color', 'warning_color', 'info_color',
        'text_primary', 'text_secondary', 'text_hint',
        'background_light', 'background_dark', 'card_background',
        'stage1_color', 'stage2_color', 'stage3_color', 'stage4_color',
        'stage5_color', 'stage6_color', 'stage7_color'
      ];

      const colors = {};
      colorFields.forEach(field => {
        const input = document.getElementById(field);
        if (input) {
          colors[field] = input.value;
        }
      });

      const response = await fetch('/api/admin/app-theme/colors', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${Auth.getToken()}`
        },
        body: JSON.stringify(colors)
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Failed to save colors');
      }

      currentSettings = await response.json();
      Toast.success('색상이 저장되었습니다. 앱을 재시작하면 적용됩니다.');
    } catch (error) {
      console.error('Failed to save colors:', error);
      Toast.error(error.message || '색상 저장에 실패했습니다.');
    }
  }

  async function uploadSplashLogo() {
    const fileInput = document.getElementById('splash-logo-file');
    const file = fileInput.files[0];

    if (!file) {
      Toast.error('파일을 선택해주세요.');
      return;
    }

    if (file.size > 5 * 1024 * 1024) {
      Toast.error('파일 크기가 5MB를 초과합니다.');
      return;
    }

    try {
      const formData = new FormData();
      formData.append('logo', file);

      const response = await fetch('/api/admin/app-theme/splash-logo', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Auth.getToken()}`
        },
        body: formData
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Failed to upload splash logo');
      }

      const result = await response.json();
      currentSettings = result.settings;

      document.getElementById('splash-logo-preview').innerHTML = `
        <div class="alert alert-success">
          <strong>업로드 완료!</strong><br>
          <img src="${currentSettings.splash_logo_url}" alt="Splash Logo" style="max-width: 200px; margin-top: 10px;">
        </div>
      `;

      Toast.success('스플래시 로고가 업로드되었습니다.');
    } catch (error) {
      console.error('Failed to upload splash logo:', error);
      Toast.error(error.message || '스플래시 로고 업로드에 실패했습니다.');
    }
  }

  async function uploadLoginLogo() {
    const fileInput = document.getElementById('login-logo-file');
    const file = fileInput.files[0];

    if (!file) {
      Toast.error('파일을 선택해주세요.');
      return;
    }

    if (file.size > 5 * 1024 * 1024) {
      Toast.error('파일 크기가 5MB를 초과합니다.');
      return;
    }

    try {
      const formData = new FormData();
      formData.append('logo', file);

      const response = await fetch('/api/admin/app-theme/login-logo', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Auth.getToken()}`
        },
        body: formData
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Failed to upload login logo');
      }

      const result = await response.json();
      currentSettings = result.settings;

      document.getElementById('login-logo-preview').innerHTML = `
        <div class="alert alert-success">
          <strong>업로드 완료!</strong><br>
          <img src="${currentSettings.login_logo_url}" alt="Login Logo" style="max-width: 200px; margin-top: 10px;">
        </div>
      `;

      Toast.success('로그인 로고가 업로드되었습니다.');
    } catch (error) {
      console.error('Failed to upload login logo:', error);
      Toast.error(error.message || '로그인 로고 업로드에 실패했습니다.');
    }
  }

  async function uploadFavicon() {
    const fileInput = document.getElementById('favicon-file');
    const file = fileInput.files[0];

    if (!file) {
      Toast.error('파일을 선택해주세요.');
      return;
    }

    if (file.size > 1 * 1024 * 1024) {
      Toast.error('파일 크기가 1MB를 초과합니다.');
      return;
    }

    try {
      const formData = new FormData();
      formData.append('favicon', file);

      const response = await fetch('/api/admin/app-theme/favicon', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Auth.getToken()}`
        },
        body: formData
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Failed to upload favicon');
      }

      const result = await response.json();
      currentSettings = result.settings;

      document.getElementById('favicon-preview').innerHTML = `
        <div class="alert alert-success">
          <strong>업로드 완료!</strong><br>
          <img src="${currentSettings.favicon_url}" alt="Favicon" style="width: 32px; height: 32px; margin-top: 10px;">
        </div>
      `;

      Toast.success('파비콘이 업로드되었습니다.');
    } catch (error) {
      console.error('Failed to upload favicon:', error);
      Toast.error(error.message || '파비콘 업로드에 실패했습니다.');
    }
  }

  async function setGoogleFont() {
    try {
      const fontFamily = document.getElementById('google-font-select').value;

      const response = await fetch('/api/admin/app-theme/font', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${Auth.getToken()}`
        },
        body: JSON.stringify({
          font_family: fontFamily,
          font_source: 'google'
        })
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Failed to set font');
      }

      currentSettings = await response.json();

      // Update preview
      document.getElementById('font-preview').innerHTML = `
        <p style="font-family: ${fontFamily};">
          안녕하세요 Hello 1234567890<br>
          한국어 학습 앱입니다.<br>
          Korean Learning Application
        </p>
      `;

      Toast.success('폰트가 설정되었습니다. 앱을 재시작하면 적용됩니다.');
    } catch (error) {
      console.error('Failed to set font:', error);
      Toast.error(error.message || '폰트 설정에 실패했습니다.');
    }
  }

  async function uploadCustomFont() {
    const fileInput = document.getElementById('custom-font-file');
    const file = fileInput.files[0];

    if (!file) {
      Toast.error('파일을 선택해주세요.');
      return;
    }

    if (file.size > 10 * 1024 * 1024) {
      Toast.error('파일 크기가 10MB를 초과합니다.');
      return;
    }

    try {
      const formData = new FormData();
      formData.append('font', file);

      const response = await fetch('/api/admin/app-theme/font-upload', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Auth.getToken()}`
        },
        body: formData
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Failed to upload custom font');
      }

      const result = await response.json();
      currentSettings = result.settings;

      Toast.success('커스텀 폰트가 업로드되었습니다. 페이지를 새로고침합니다.');
      setTimeout(() => {
        switchTab('fonts');
      }, 1500);
    } catch (error) {
      console.error('Failed to upload custom font:', error);
      Toast.error(error.message || '커스텀 폰트 업로드에 실패했습니다.');
    }
  }

  async function resetSettings() {
    if (!confirm('정말로 모든 앱 테마 설정을 기본값으로 복원하시겠습니까? 업로드된 모든 파일도 삭제됩니다.')) {
      return;
    }

    try {
      const response = await fetch('/api/admin/app-theme/reset', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${Auth.getToken()}`
        }
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.error || 'Failed to reset settings');
      }

      Toast.success('설정이 기본값으로 복원되었습니다. 페이지를 새로고침합니다.');
      setTimeout(() => {
        window.location.reload();
      }, 1500);
    } catch (error) {
      console.error('Failed to reset settings:', error);
      Toast.error(error.message || '설정 복원에 실패했습니다.');
    }
  }

  return {
    render,
    switchTab,
    saveColors,
    uploadSplashLogo,
    uploadLoginLogo,
    uploadFavicon,
    setGoogleFont,
    uploadCustomFont,
    resetSettings
  };
})();
