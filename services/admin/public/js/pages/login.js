/**
 * Login Page
 *
 * 관리자 로그인 페이지
 */

const LoginPage = (() => {
  /**
   * 로그인 페이지 렌더링
   */
  async function render() {
    const html = `
      <div class="login-page">
        <div class="login-card">
          <div class="logo">
            <h1>🍋 柠檬韩语</h1>
            <p>관리자 페이지</p>
          </div>
          <form id="login-form">
            <div class="mb-3">
              <label for="email" class="form-label">이메일</label>
              <input type="email" class="form-control" id="email" placeholder="admin@lemon.com" required autofocus>
              <div class="invalid-feedback"></div>
            </div>
            <div class="mb-3">
              <label for="password" class="form-label">비밀번호</label>
              <input type="password" class="form-control" id="password" placeholder="비밀번호를 입력하세요" required>
              <div class="invalid-feedback"></div>
            </div>
            <div class="d-grid">
              <button type="submit" class="btn btn-primary btn-lg" id="login-btn">
                <i class="fas fa-sign-in-alt me-2"></i>로그인
              </button>
            </div>
          </form>
        </div>
      </div>
    `;

    Router.render(html);

    // 이벤트 리스너 등록
    attachEventListeners();
  }

  /**
   * 이벤트 리스너 등록
   */
  function attachEventListeners() {
    const form = document.getElementById('login-form');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const loginBtn = document.getElementById('login-btn');

    // 폼 제출
    form.addEventListener('submit', async (e) => {
      e.preventDefault();

      const email = emailInput.value.trim();
      const password = passwordInput.value;

      // 유효성 검사
      const validation = Validators.validateForm(
        { email, password },
        {
          email: { required: true, email: true },
          password: { required: true, minLength: 6 },
        }
      );

      // 에러 표시 초기화
      clearErrors();

      if (!validation.isValid) {
        displayErrors(validation.errors);
        return;
      }

      // 로그인 시도
      await handleLogin(email, password, loginBtn);
    });
  }

  /**
   * 로그인 처리
   *
   * @param {string} email - 이메일
   * @param {string} password - 비밀번호
   * @param {HTMLElement} loginBtn - 로그인 버튼
   */
  async function handleLogin(email, password, loginBtn) {
    // 버튼 비활성화
    loginBtn.disabled = true;
    loginBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>로그인 중...';

    try {
      // API 호출
      const response = await API.auth.login({ email, password });

      // 토큰 및 사용자 정보 저장
      if (response.token && response.user) {
        Auth.login(response.token, response.user);

        // 대시보드로 이동
        Router.navigate('/dashboard');

        Toast.success('로그인 성공!');
      } else {
        throw new Error('로그인 응답이 올바르지 않습니다.');
      }
    } catch (error) {
      console.error('[LoginPage] 로그인 에러:', error);

      // 에러 메시지 표시
      let errorMessage = error.message;

      // 일반적인 에러 메시지 매핑
      if (errorMessage.includes('401') || errorMessage.includes('Unauthorized')) {
        errorMessage = '이메일 또는 비밀번호가 올바르지 않습니다.';
      } else if (errorMessage.includes('403') || errorMessage.includes('Forbidden')) {
        errorMessage = '관리자 권한이 없습니다.';
      } else if (errorMessage.includes('network') || errorMessage.includes('fetch')) {
        errorMessage = '서버에 연결할 수 없습니다.';
      }

      Toast.error(errorMessage);

      // 버튼 다시 활성화
      loginBtn.disabled = false;
      loginBtn.innerHTML = '<i class="fas fa-sign-in-alt me-2"></i>로그인';
    }
  }

  /**
   * 에러 표시
   *
   * @param {Object} errors - 에러 객체
   */
  function displayErrors(errors) {
    for (const [field, message] of Object.entries(errors)) {
      const input = document.getElementById(field);
      if (input) {
        input.classList.add('is-invalid');
        const feedback = input.nextElementSibling;
        if (feedback && feedback.classList.contains('invalid-feedback')) {
          feedback.textContent = message;
        }
      }
    }
  }

  /**
   * 에러 표시 초기화
   */
  function clearErrors() {
    document.querySelectorAll('.is-invalid').forEach((input) => {
      input.classList.remove('is-invalid');
    });
    document.querySelectorAll('.invalid-feedback').forEach((feedback) => {
      feedback.textContent = '';
    });
  }

  // Public API 반환
  return {
    render,
  };
})();
