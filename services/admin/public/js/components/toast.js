/**
 * Toast Notification Component
 *
 * Bootstrap Toast를 사용한 알림 시스템
 *
 * 사용 예시:
 * Toast.success('저장되었습니다!');
 * Toast.error('오류가 발생했습니다.');
 * Toast.warning('주의하세요.');
 * Toast.info('정보 메시지입니다.');
 */

const Toast = (() => {
  // Toast 컨테이너
  const container = document.getElementById('toast-container');

  /**
   * Toast 생성 및 표시
   *
   * @param {string} message - 메시지
   * @param {string} type - 타입 ('success'|'error'|'warning'|'info')
   * @param {number} duration - 표시 시간 (밀리초, 기본값: 3000)
   *
   * @example
   * Toast.show('저장되었습니다!', 'success');
   * Toast.show('오류 발생', 'error', 5000);
   */
  function show(message, type = 'info', duration = 3000) {
    // 아이콘 매핑
    const icons = {
      success: 'fa-check-circle',
      error: 'fa-exclamation-circle',
      warning: 'fa-exclamation-triangle',
      info: 'fa-info-circle',
    };

    // 제목 매핑
    const titles = {
      success: '성공',
      error: '오류',
      warning: '경고',
      info: '알림',
    };

    // Bootstrap 색상 매핑
    const colors = {
      success: 'text-success',
      error: 'text-danger',
      warning: 'text-warning',
      info: 'text-info',
    };

    const icon = icons[type] || icons.info;
    const title = titles[type] || titles.info;
    const color = colors[type] || colors.info;

    // Toast HTML 생성
    const toastId = `toast-${Date.now()}`;
    const toastHTML = `
      <div id="${toastId}" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header">
          <i class="fas ${icon} ${color} me-2"></i>
          <strong class="me-auto">${title}</strong>
          <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body">
          ${message}
        </div>
      </div>
    `;

    // 컨테이너에 추가
    container.insertAdjacentHTML('beforeend', toastHTML);

    // Bootstrap Toast 초기화
    const toastElement = document.getElementById(toastId);
    const bsToast = new bootstrap.Toast(toastElement, {
      autohide: true,
      delay: duration,
    });

    // Toast 표시
    bsToast.show();

    // Toast 제거 (숨겨진 후)
    toastElement.addEventListener('hidden.bs.toast', () => {
      toastElement.remove();
    });
  }

  /**
   * 성공 메시지 표시
   *
   * @param {string} message - 메시지
   * @param {number} duration - 표시 시간
   *
   * @example
   * Toast.success('저장되었습니다!');
   */
  function success(message, duration = 3000) {
    show(message, 'success', duration);
  }

  /**
   * 에러 메시지 표시
   *
   * @param {string} message - 메시지
   * @param {number} duration - 표시 시간
   *
   * @example
   * Toast.error('오류가 발생했습니다.');
   */
  function error(message, duration = 5000) {
    show(message, 'error', duration);
  }

  /**
   * 경고 메시지 표시
   *
   * @param {string} message - 메시지
   * @param {number} duration - 표시 시간
   *
   * @example
   * Toast.warning('주의하세요.');
   */
  function warning(message, duration = 4000) {
    show(message, 'warning', duration);
  }

  /**
   * 정보 메시지 표시
   *
   * @param {string} message - 메시지
   * @param {number} duration - 표시 시간
   *
   * @example
   * Toast.info('정보 메시지입니다.');
   */
  function info(message, duration = 3000) {
    show(message, 'info', duration);
  }

  // Public API 반환
  return {
    show,
    success,
    error,
    warning,
    info,
  };
})();
