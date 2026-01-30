/**
 * Modal Component
 *
 * Bootstrap Modal을 사용한 다이얼로그 시스템
 *
 * 사용 예시:
 * Modal.confirm('정말 삭제하시겠습니까?', () => {
 *   // 확인 버튼 클릭 시 실행
 * });
 *
 * Modal.alert('저장되었습니다!');
 *
 * Modal.custom({
 *   title: '레슨 수정',
 *   body: '<form>...</form>',
 *   onConfirm: () => { ... }
 * });
 */

const Modal = (() => {
  let modalCounter = 0;

  /**
   * 모달 생성 및 표시
   *
   * @param {Object} options - 모달 옵션
   * @param {string} options.title - 제목
   * @param {string} options.body - 본문 HTML
   * @param {string} options.size - 크기 ('sm'|'lg'|'xl')
   * @param {boolean} options.backdrop - 백드롭 클릭 시 닫기 (기본값: true)
   * @param {string} options.confirmText - 확인 버튼 텍스트 (기본값: '확인')
   * @param {string} options.confirmClass - 확인 버튼 클래스 (기본값: 'btn-primary')
   * @param {string} options.cancelText - 취소 버튼 텍스트 (기본값: '취소')
   * @param {boolean} options.showCancel - 취소 버튼 표시 여부 (기본값: true)
   * @param {Function} options.onConfirm - 확인 버튼 클릭 시 콜백
   * @param {Function} options.onCancel - 취소 버튼 클릭 시 콜백
   * @param {Function} options.onClose - 모달 닫힐 때 콜백
   *
   * @example
   * Modal.create({
   *   title: '사용자 정보',
   *   body: '<div>...</div>',
   *   confirmText: '저장',
   *   onConfirm: () => { console.log('저장'); }
   * });
   */
  function create(options = {}) {
    const {
      title = '알림',
      body = '',
      size = '',
      backdrop = true,
      confirmText = '확인',
      confirmClass = 'btn-primary',
      cancelText = '취소',
      showCancel = true,
      onConfirm = null,
      onCancel = null,
      onClose = null,
    } = options;

    // 고유 ID 생성
    const modalId = `modal-${++modalCounter}`;
    const sizeClass = size ? `modal-${size}` : '';

    // 모달 HTML 생성
    const modalHTML = `
      <div class="modal fade" id="${modalId}" tabindex="-1" aria-hidden="true" data-bs-backdrop="${backdrop ? 'true' : 'static'}">
        <div class="modal-dialog ${sizeClass}">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">${title}</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              ${body}
            </div>
            <div class="modal-footer">
              ${showCancel ? `<button type="button" class="btn btn-secondary" data-action="cancel">${cancelText}</button>` : ''}
              <button type="button" class="btn ${confirmClass}" data-action="confirm">${confirmText}</button>
            </div>
          </div>
        </div>
      </div>
    `;

    // Body에 추가
    document.body.insertAdjacentHTML('beforeend', modalHTML);

    // 모달 엘리먼트 가져오기
    const modalElement = document.getElementById(modalId);
    const bsModal = new bootstrap.Modal(modalElement);

    // 확인 버튼 이벤트
    const confirmBtn = modalElement.querySelector('[data-action="confirm"]');
    if (confirmBtn) {
      confirmBtn.addEventListener('click', async () => {
        if (onConfirm) {
          // onConfirm이 Promise를 반환하면 대기
          try {
            const result = await onConfirm();
            // false를 반환하면 모달을 닫지 않음
            if (result !== false) {
              bsModal.hide();
            }
          } catch (error) {
            console.error('[Modal] onConfirm 에러:', error);
            Toast.error(error.message || '처리 중 오류가 발생했습니다.');
          }
        } else {
          bsModal.hide();
        }
      });
    }

    // 취소 버튼 이벤트
    const cancelBtn = modalElement.querySelector('[data-action="cancel"]');
    if (cancelBtn) {
      cancelBtn.addEventListener('click', () => {
        if (onCancel) {
          onCancel();
        }
        bsModal.hide();
      });
    }

    // 모달 닫힐 때 이벤트
    modalElement.addEventListener('hidden.bs.modal', () => {
      if (onClose) {
        onClose();
      }
      // DOM에서 제거
      modalElement.remove();
    });

    // 모달 표시
    bsModal.show();

    // 모달 인스턴스 반환
    return {
      element: modalElement,
      instance: bsModal,
      hide: () => bsModal.hide(),
    };
  }

  /**
   * 확인 다이얼로그
   *
   * @param {string} message - 메시지
   * @param {Function} onConfirm - 확인 시 콜백
   * @param {Object} options - 추가 옵션
   *
   * @example
   * Modal.confirm('정말 삭제하시겠습니까?', () => {
   *   // 삭제 로직
   * });
   */
  function confirm(message, onConfirm, options = {}) {
    return create({
      title: options.title || '확인',
      body: `<p class="mb-0">${message}</p>`,
      confirmText: options.confirmText || '확인',
      confirmClass: options.confirmClass || 'btn-danger',
      cancelText: options.cancelText || '취소',
      showCancel: true,
      onConfirm,
      ...options,
    });
  }

  /**
   * 알림 다이얼로그 (확인 버튼만)
   *
   * @param {string} message - 메시지
   * @param {Function} onConfirm - 확인 시 콜백
   * @param {Object} options - 추가 옵션
   *
   * @example
   * Modal.alert('저장되었습니다!');
   */
  function alert(message, onConfirm = null, options = {}) {
    return create({
      title: options.title || '알림',
      body: `<p class="mb-0">${message}</p>`,
      confirmText: '확인',
      confirmClass: 'btn-primary',
      showCancel: false,
      onConfirm,
      ...options,
    });
  }

  /**
   * 커스텀 모달
   *
   * @param {Object} options - 모달 옵션 (create 함수와 동일)
   *
   * @example
   * Modal.custom({
   *   title: '레슨 수정',
   *   body: '<form>...</form>',
   *   size: 'lg',
   *   onConfirm: () => {
   *     // 폼 제출 로직
   *   }
   * });
   */
  function custom(options) {
    return create(options);
  }

  /**
   * 로딩 모달 (진행 중)
   *
   * @param {string} message - 로딩 메시지 (기본값: '처리 중...')
   *
   * @returns {Object} 모달 인스턴스 (hide 메서드로 닫을 수 있음)
   *
   * @example
   * const loading = Modal.loading('업로드 중...');
   * // 작업 완료 후
   * loading.hide();
   */
  function loading(message = '처리 중...') {
    const modalHTML = `
      <div class="modal fade" id="modal-loading" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-body text-center py-4">
              <div class="spinner-border text-primary mb-3" role="status">
                <span class="visually-hidden">Loading...</span>
              </div>
              <p class="mb-0">${message}</p>
            </div>
          </div>
        </div>
      </div>
    `;

    // 기존 로딩 모달이 있으면 제거
    const existing = document.getElementById('modal-loading');
    if (existing) {
      existing.remove();
    }

    // Body에 추가
    document.body.insertAdjacentHTML('beforeend', modalHTML);

    // 모달 엘리먼트 가져오기
    const modalElement = document.getElementById('modal-loading');
    const bsModal = new bootstrap.Modal(modalElement);

    // 모달 표시
    bsModal.show();

    // 모달 인스턴스 반환
    return {
      element: modalElement,
      instance: bsModal,
      hide: () => {
        bsModal.hide();
        // 모달이 완전히 숨겨진 후 DOM에서 제거
        modalElement.addEventListener('hidden.bs.modal', () => {
          modalElement.remove();
        }, { once: true });
      },
    };
  }

  /**
   * show - custom의 별칭 (호환성)
   */
  function show(options) {
    return custom(options);
  }

  /**
   * hide - 현재 열려있는 모달 닫기
   */
  function hide() {
    const openModals = document.querySelectorAll('.modal.show');
    openModals.forEach(modal => {
      const bsModal = bootstrap.Modal.getInstance(modal);
      if (bsModal) {
        bsModal.hide();
      }
    });
  }

  // Public API 반환
  return {
    create,
    confirm,
    alert,
    custom,
    loading,
    show,
    hide,
  };
})();
