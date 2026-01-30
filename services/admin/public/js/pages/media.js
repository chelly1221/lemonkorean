/**
 * Media Page
 *
 * 미디어 관리 페이지 (파일 업로드, 목록)
 */

const MediaPage = (() => {
  let currentType = '';

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('미디어 관리')}
          <div class="content-container">
            <!-- 파일 업로드 영역 -->
            <div class="row mb-4">
              <div class="col-12">
                <div class="upload-area" id="upload-area">
                  <i class="fas fa-cloud-upload-alt"></i>
                  <h5 class="mt-3">파일을 드래그하거나 클릭하여 업로드</h5>
                  <p class="upload-text">이미지, 오디오, 비디오 또는 문서</p>
                  <input type="file" id="file-input" style="display: none;" multiple>
                </div>
                <div class="upload-progress mt-3" id="upload-progress" style="display: none;">
                  <div class="progress">
                    <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 파일 타입 필터 -->
            <div class="mb-3">
              <div class="btn-group" role="group">
                <button type="button" class="btn btn-outline-primary active" data-type="">전체</button>
                <button type="button" class="btn btn-outline-primary" data-type="images">이미지</button>
                <button type="button" class="btn btn-outline-primary" data-type="audio">오디오</button>
                <button type="button" class="btn btn-outline-primary" data-type="video">비디오</button>
                <button type="button" class="btn btn-outline-primary" data-type="documents">문서</button>
              </div>
            </div>

            <!-- 미디어 갤러리 -->
            <div class="row" id="media-gallery">
              <div class="col-12 text-center">
                <div class="spinner-border text-primary" role="status"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
    Router.render(layout);
    Sidebar.updateActive();
    attachEventListeners();
    await loadMedia();
  }

  function attachEventListeners() {
    const uploadArea = document.getElementById('upload-area');
    const fileInput = document.getElementById('file-input');

    // 드래그 앤 드롭
    uploadArea.addEventListener('click', () => fileInput.click());
    uploadArea.addEventListener('dragover', (e) => {
      e.preventDefault();
      uploadArea.classList.add('drag-over');
    });
    uploadArea.addEventListener('dragleave', () => {
      uploadArea.classList.remove('drag-over');
    });
    uploadArea.addEventListener('drop', (e) => {
      e.preventDefault();
      uploadArea.classList.remove('drag-over');
      const files = e.dataTransfer.files;
      handleFiles(files);
    });

    // 파일 선택
    fileInput.addEventListener('change', (e) => {
      handleFiles(e.target.files);
    });

    // 타입 필터
    document.querySelectorAll('[data-type]').forEach((btn) => {
      btn.addEventListener('click', (e) => {
        document.querySelectorAll('[data-type]').forEach((b) => b.classList.remove('active'));
        e.target.classList.add('active');
        currentType = e.target.dataset.type;
        loadMedia();
      });
    });
  }

  async function handleFiles(files) {
    for (const file of files) {
      await uploadFile(file);
    }
    await loadMedia();
  }

  async function uploadFile(file) {
    const progressBar = document.querySelector('.progress-bar');
    const progressContainer = document.getElementById('upload-progress');
    progressContainer.style.display = 'block';

    const formData = new FormData();
    formData.append('file', file);
    formData.append('type', getFileType(file.name));

    try {
      progressBar.style.width = '50%';
      await API.media.upload(formData);
      progressBar.style.width = '100%';
      Toast.success(`${file.name} 업로드 완료`);

      setTimeout(() => {
        progressContainer.style.display = 'none';
        progressBar.style.width = '0%';
      }, 1000);
    } catch (error) {
      Toast.error(`${file.name} 업로드 실패: ${error.message}`);
      progressContainer.style.display = 'none';
    }
  }

  function getFileType(filename) {
    const ext = filename.split('.').pop().toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].includes(ext)) return 'images';
    if (['mp3', 'wav', 'ogg', 'm4a'].includes(ext)) return 'audio';
    if (['mp4', 'webm', 'mov'].includes(ext)) return 'video';
    return 'documents';
  }

  async function loadMedia() {
    try {
      const response = await API.media.list({ type: currentType });
      const files = response.data || [];
      renderGallery(files);
    } catch (error) {
      console.error('[MediaPage] Error loading media:', error);
      Toast.error('미디어 목록을 불러올 수 없습니다.');
    }
  }

  function renderGallery(files) {
    const gallery = document.getElementById('media-gallery');
    if (files.length === 0) {
      gallery.innerHTML = '<div class="col-12 text-center">미디어 파일이 없습니다.</div>';
      return;
    }

    gallery.innerHTML = files.map(file => `
      <div class="col-md-3 mb-3">
        <div class="card">
          <div class="card-body">
            <h6 class="card-title text-truncate">${file.name}</h6>
            <p class="card-text small text-muted">${Formatters.formatFileSize(file.size)}</p>
            <button class="btn btn-sm btn-outline-secondary" onclick="MediaPage.copyURL('${file.url}')">
              <i class="fas fa-copy"></i> URL 복사
            </button>
            <button class="btn btn-sm btn-danger" onclick="MediaPage.deleteFile('${file.type}', '${file.key}')">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
      </div>
    `).join('');
  }

  function copyURL(url) {
    navigator.clipboard.writeText(url);
    Toast.success('URL이 복사되었습니다.');
  }

  async function deleteFile(type, key) {
    Modal.confirm('이 파일을 삭제하시겠습니까?', async () => {
      try {
        await API.media.delete(type, key);
        Toast.success('파일이 삭제되었습니다.');
        await loadMedia();
      } catch (error) {
        Toast.error(error.message);
      }
    });
  }

  return { render, copyURL, deleteFile };
})();
