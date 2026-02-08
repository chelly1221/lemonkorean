/**
 * Cache Management Page
 * 관리자가 브라우저 캐싱을 비활성화하여 항상 최신 버전을 로드할 수 있는 페이지
 */

const CacheManagementPage = (() => {
  function getCacheDisabled() {
    return localStorage.getItem('admin_cache_disabled') === 'true';
  }

  function setCacheDisabled(disabled) {
    localStorage.setItem('admin_cache_disabled', disabled.toString());
  }

  async function render() {
    const cacheDisabled = getCacheDisabled();

    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('캐시 관리')}
          <div class="content-container">
            <div class="page-header">
              <h1><i class="fas fa-ban"></i> 캐시 비활성화 모드</h1>
              <p>브라우저 캐싱을 비활성화하여 항상 최신 버전을 로드합니다</p>
            </div>

            <!-- Current Status -->
            <div class="alert alert-${cacheDisabled ? 'warning' : 'success'}">
              <i class="fas fa-${cacheDisabled ? 'exclamation-triangle' : 'check-circle'}"></i>
              <strong>현재 상태:</strong> 캐시 ${cacheDisabled ? '비활성화됨 (Disabled)' : '활성화됨 (Enabled)'}
            </div>

            <!-- Cache Disable Toggle Card -->
            <div class="card">
              <div class="card-header">
                <h2><i class="fas fa-toggle-${cacheDisabled ? 'on' : 'off'}"></i> 캐시 비활성화 설정</h2>
              </div>
              <div class="card-body">
                <p><strong>캐시 비활성화 모드란?</strong></p>
                <p>이 모드를 활성화하면 모든 HTTP 요청에 캐시 방지 헤더와 타임스탬프가 추가되어,
                   브라우저가 항상 서버에서 최신 파일을 다운로드합니다.</p>

                <p style="margin-top: 1rem;"><strong>효과:</strong></p>
                <ul>
                  <li>JavaScript/CSS 파일 캐싱 방지</li>
                  <li>API 응답 캐싱 방지</li>
                  <li>이미지 및 정적 자산 캐싱 방지</li>
                  <li>웹 앱 배포 후 즉시 최신 버전 확인 가능</li>
                </ul>

                <p style="margin-top: 1rem;"><strong>주의:</strong> 이 모드는 성능이 저하될 수 있으므로
                   테스트/개발 목적으로만 사용하세요.</p>

                <div style="margin-top: 2rem;">
                  <button id="toggle-cache-btn" class="btn btn-${cacheDisabled ? 'success' : 'warning'} btn-lg">
                    <i class="fas fa-${cacheDisabled ? 'check' : 'ban'}"></i>
                    캐시 ${cacheDisabled ? '활성화' : '비활성화'}
                  </button>
                </div>

                <div id="status-message" style="margin-top: 1rem;"></div>
              </div>
            </div>

            <!-- Clear Cache Card -->
            <div class="card" style="margin-top: 2rem;">
              <div class="card-header">
                <h2><i class="fas fa-trash-restore"></i> 캐시 삭제 (선택사항)</h2>
              </div>
              <div class="card-body">
                <p>기존 캐시를 삭제하고 싶다면 아래 버튼을 클릭하세요.</p>
                <p><strong>삭제 항목:</strong> localStorage (lk_*), IndexedDB (lemon_korean), Service Worker 캐시, Service Worker 등록</p>
                <button id="clear-cache-btn" class="btn btn-danger">
                  <i class="fas fa-trash-alt"></i> 모든 캐시 삭제
                </button>
                <div id="clear-status" style="margin-top: 1rem;"></div>
              </div>
            </div>

            <!-- Cache Status Info -->
            <div class="card" style="margin-top: 2rem;">
              <div class="card-header">
                <h2><i class="fas fa-info-circle"></i> 캐시 상태 확인</h2>
              </div>
              <div class="card-body">
                <p>현재 브라우저의 캐시 상태를 확인합니다.</p>
                <button id="check-cache-btn" class="btn btn-secondary">
                  <i class="fas fa-sync"></i> 캐시 상태 확인
                </button>
                <div id="cache-info" style="margin-top: 1rem;"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;

    Router.render(layout);
    Sidebar.updateActive();
    attachEventListeners();

    // Apply cache disable mode if enabled
    if (cacheDisabled) {
      applyCacheDisableMode();
    }
  }

  function attachEventListeners() {
    document.getElementById('toggle-cache-btn').addEventListener('click', toggleCacheMode);
    document.getElementById('clear-cache-btn').addEventListener('click', clearAllCache);
    document.getElementById('check-cache-btn').addEventListener('click', checkCacheStatus);
  }

  function toggleCacheMode() {
    const currentlyDisabled = getCacheDisabled();
    const newState = !currentlyDisabled;

    setCacheDisabled(newState);

    const statusDiv = document.getElementById('status-message');
    statusDiv.innerHTML = `
      <div class="alert alert-success">
        <i class="fas fa-check-circle"></i>
        캐시가 ${newState ? '비활성화' : '활성화'}되었습니다.
        페이지를 새로고침합니다...
      </div>
    `;

    // Reload page after 1 second
    setTimeout(() => {
      window.location.reload();
    }, 1000);
  }

  function applyCacheDisableMode() {
    // Add cache-busting parameter to all requests
    const originalFetch = window.fetch;
    window.fetch = function(...args) {
      let url = args[0];

      // Add timestamp to URL
      if (typeof url === 'string') {
        const separator = url.includes('?') ? '&' : '?';
        url = `${url}${separator}_nocache=${Date.now()}`;
        args[0] = url;
      }

      // Add no-cache headers
      if (!args[1]) args[1] = {};
      if (!args[1].headers) args[1].headers = {};
      args[1].headers['Cache-Control'] = 'no-cache, no-store, must-revalidate';
      args[1].headers['Pragma'] = 'no-cache';
      args[1].headers['Expires'] = '0';

      return originalFetch.apply(this, args);
    };

    // Override XMLHttpRequest
    const originalOpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function(method, url, ...rest) {
      // Add timestamp to URL
      const separator = url.includes('?') ? '&' : '?';
      const newUrl = `${url}${separator}_nocache=${Date.now()}`;
      return originalOpen.call(this, method, newUrl, ...rest);
    };

    console.log('[CacheManagement] Cache disable mode activated');
  }

  async function clearAllCache() {
    const statusDiv = document.getElementById('clear-status');
    const btn = document.getElementById('clear-cache-btn');

    if (!confirm('정말 이 브라우저의 모든 캐시를 삭제하시겠습니까?\n\n삭제 항목:\n- localStorage (lk_* 키)\n- IndexedDB (lemon_korean)\n- Service Worker 캐시\n- Service Worker 등록\n\n페이지가 자동으로 새로고침됩니다.')) {
      return;
    }

    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 삭제 중...';
    statusDiv.innerHTML = '<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> 캐시 삭제 중...</div>';

    try {
      const results = [];

      // 1. Clear localStorage (lk_* keys)
      let clearedLocalStorageCount = 0;
      const keysToRemove = [];
      for (let i = 0; i < localStorage.length; i++) {
        const key = localStorage.key(i);
        if (key && key.startsWith('lk_')) {
          keysToRemove.push(key);
        }
      }
      keysToRemove.forEach(key => {
        localStorage.removeItem(key);
        clearedLocalStorageCount++;
      });
      results.push(`✅ localStorage: ${clearedLocalStorageCount}개 키 삭제`);

      // 2. Clear IndexedDB
      try {
        indexedDB.deleteDatabase('lemon_korean');
        results.push('✅ IndexedDB: lemon_korean 데이터베이스 삭제 시작');
      } catch (e) {
        results.push('⚠️ IndexedDB: 삭제 실패 - ' + e.message);
      }

      // 3. Clear Service Worker caches
      if ('caches' in window) {
        try {
          const cacheNames = await caches.keys();
          const deletePromises = cacheNames.map(cacheName => {
            console.log('Deleting cache:', cacheName);
            return caches.delete(cacheName);
          });
          await Promise.all(deletePromises);
          results.push(`✅ Service Worker 캐시: ${cacheNames.length}개 캐시 삭제`);
        } catch (e) {
          results.push('⚠️ Service Worker 캐시: 삭제 실패 - ' + e.message);
        }
      } else {
        results.push('ℹ️ Service Worker 캐시: 이 브라우저에서 사용 불가');
      }

      // 4. Unregister Service Workers
      if ('serviceWorker' in navigator) {
        try {
          const registrations = await navigator.serviceWorker.getRegistrations();
          const unregisterPromises = registrations.map(registration => {
            console.log('Unregistering service worker');
            return registration.unregister();
          });
          await Promise.all(unregisterPromises);
          results.push(`✅ Service Worker: ${registrations.length}개 등록 해제`);
        } catch (e) {
          results.push('⚠️ Service Worker: 등록 해제 실패 - ' + e.message);
        }
      } else {
        results.push('ℹ️ Service Worker: 이 브라우저에서 사용 불가');
      }

      // Show results
      statusDiv.innerHTML = `
        <div class="alert alert-success">
          <h4><i class="fas fa-check-circle"></i> 캐시 삭제 완료!</h4>
          <ul style="margin: 1rem 0 0 0; padding-left: 1.5rem;">
            ${results.map(r => `<li>${r}</li>`).join('')}
          </ul>
          <p style="margin-top: 1rem;"><strong>3초 후 페이지가 새로고침됩니다...</strong></p>
        </div>
      `;

      // Reload page after 3 seconds
      setTimeout(() => {
        window.location.reload();
      }, 3000);

    } catch (error) {
      console.error('Error clearing cache:', error);
      statusDiv.innerHTML = `
        <div class="alert alert-danger">
          <i class="fas fa-exclamation-circle"></i>
          <strong>캐시 삭제 실패:</strong> ${error.message}
        </div>
      `;
      btn.disabled = false;
      btn.innerHTML = '<i class="fas fa-trash-alt"></i> 모든 캐시 삭제';
    }
  }

  async function checkCacheStatus() {
    const infoDiv = document.getElementById('cache-info');
    const btn = document.getElementById('check-cache-btn');

    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 확인 중...';
    infoDiv.innerHTML = '<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> 캐시 상태 확인 중...</div>';

    try {
      const info = [];

      // Check localStorage
      let lkKeysCount = 0;
      for (let i = 0; i < localStorage.length; i++) {
        const key = localStorage.key(i);
        if (key && key.startsWith('lk_')) {
          lkKeysCount++;
        }
      }
      info.push(`📦 localStorage: ${lkKeysCount}개 lk_* 키`);

      // Check IndexedDB
      if ('indexedDB' in window) {
        info.push(`💾 IndexedDB: 확인 필요 (DevTools 확인)`);
      }

      // Check Service Worker caches
      if ('caches' in window) {
        const cacheNames = await caches.keys();
        info.push(`🗄️ Service Worker 캐시: ${cacheNames.length}개`);
        if (cacheNames.length > 0) {
          info.push(`   └ ${cacheNames.join(', ')}`);
        }
      }

      // Check Service Workers
      if ('serviceWorker' in navigator) {
        const registrations = await navigator.serviceWorker.getRegistrations();
        info.push(`⚙️ Service Worker 등록: ${registrations.length}개`);
      }

      infoDiv.innerHTML = `
        <div class="alert alert-secondary">
          <h5>현재 캐시 상태</h5>
          <pre style="margin-top: 1rem; background: #f8f9fa; padding: 1rem; border-radius: 4px;">${info.join('\n')}</pre>
        </div>
      `;

    } catch (error) {
      console.error('Error checking cache:', error);
      infoDiv.innerHTML = `
        <div class="alert alert-danger">
          <i class="fas fa-exclamation-circle"></i>
          <strong>캐시 상태 확인 실패:</strong> ${error.message}
        </div>
      `;
    } finally {
      btn.disabled = false;
      btn.innerHTML = '<i class="fas fa-sync"></i> 캐시 상태 확인';
    }
  }

  return {
    render
  };
})();

window.CacheManagementPage = CacheManagementPage;
