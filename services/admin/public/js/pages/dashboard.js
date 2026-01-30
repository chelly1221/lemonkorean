/**
 * Dashboard Page
 *
 * 관리자 대시보드 - 통계 및 차트
 */

const DashboardPage = (() => {
  let currentPeriod = '1d';
  let charts = {}; // Chart.js 인스턴스 저장

  /**
   * 대시보드 페이지 렌더링
   */
  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('대시보드')}
          <div class="content-container">
            <!-- 기간 선택 -->
            <div class="mb-4">
              <div class="btn-group" role="group">
                <button type="button" class="btn btn-outline-primary active" data-period="1d">오늘</button>
                <button type="button" class="btn btn-outline-primary" data-period="7d">7일</button>
                <button type="button" class="btn btn-outline-primary" data-period="30d">30일</button>
                <button type="button" class="btn btn-outline-primary" data-period="365d">1년</button>
              </div>
            </div>

            <!-- 통계 카드 -->
            <div class="row mb-4" id="stats-cards">
              <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card">
                  <div class="icon bg-primary">
                    <i class="fas fa-users"></i>
                  </div>
                  <div class="stats-value" id="total-users">-</div>
                  <div class="stats-label">총 사용자</div>
                </div>
              </div>
              <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card">
                  <div class="icon bg-success">
                    <i class="fas fa-book"></i>
                  </div>
                  <div class="stats-value" id="total-lessons">-</div>
                  <div class="stats-label">총 레슨</div>
                </div>
              </div>
              <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card">
                  <div class="icon bg-warning">
                    <i class="fas fa-chart-line"></i>
                  </div>
                  <div class="stats-value" id="completion-rate">-</div>
                  <div class="stats-label">평균 완료율</div>
                </div>
              </div>
              <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card">
                  <div class="icon bg-info">
                    <i class="fas fa-language"></i>
                  </div>
                  <div class="stats-value" id="total-vocabulary">-</div>
                  <div class="stats-label">총 단어</div>
                </div>
              </div>
            </div>

            <!-- 차트 -->
            <div class="row mb-4">
              <div class="col-lg-8 mb-3">
                <div class="chart-container">
                  <h5 class="mb-3">사용자 증가 추이</h5>
                  <canvas id="user-growth-chart"></canvas>
                </div>
              </div>
              <div class="col-lg-4 mb-3">
                <div class="chart-container">
                  <h5 class="mb-3">레슨 완료율</h5>
                  <canvas id="completion-chart"></canvas>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-12">
                <div class="chart-container">
                  <h5 class="mb-3">참여도 지표</h5>
                  <canvas id="engagement-chart"></canvas>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;

    Router.render(layout);
    Sidebar.updateActive();

    // 이벤트 리스너 등록
    attachEventListeners();

    // 데이터 로드
    await loadData();
  }

  /**
   * 이벤트 리스너 등록
   */
  function attachEventListeners() {
    // 기간 선택 버튼
    document.querySelectorAll('[data-period]').forEach((btn) => {
      btn.addEventListener('click', async (e) => {
        // 활성 상태 변경
        document.querySelectorAll('[data-period]').forEach((b) => b.classList.remove('active'));
        e.target.classList.add('active');

        // 기간 변경
        currentPeriod = e.target.dataset.period;

        // 데이터 다시 로드
        await loadData();
      });
    });
  }

  /**
   * 데이터 로드
   */
  async function loadData() {
    try {
      // 병렬로 API 호출
      const [overview, userAnalytics, engagement, contentStats] = await Promise.all([
        API.analytics.getOverview({ period: currentPeriod }),
        API.analytics.getUserAnalytics({ period: currentPeriod }),
        API.analytics.getEngagement({ period: currentPeriod }),
        API.analytics.getContentStats(),
      ]);

      // 통계 카드 업데이트
      updateStatsCards(overview, contentStats);

      // 차트 업데이트
      updateUserGrowthChart(userAnalytics);
      updateCompletionChart(overview);
      updateEngagementChart(engagement);
    } catch (error) {
      console.error('[DashboardPage] 데이터 로드 에러:', error);
      Toast.error('대시보드 데이터를 불러올 수 없습니다.');
    }
  }

  /**
   * 통계 카드 업데이트
   */
  function updateStatsCards(overview, contentStats) {
    // Extract data from nested structure
    const totalUsers = overview?.data?.users?.total_users || overview?.users?.total_users || 0;
    const totalLessons = contentStats?.data?.totalLessons || contentStats?.totalLessons || 0;
    const avgCompletionRate = overview?.data?.progress?.avg_completion_rate || overview?.progress?.avg_completion_rate || 0;
    const totalVocabulary = contentStats?.data?.totalVocabulary || contentStats?.totalVocabulary || 0;

    // Debug log
    console.log('[Dashboard] Stats:', {
      overview: overview?.data || overview,
      contentStats: contentStats?.data || contentStats,
      totalUsers,
      totalLessons,
      avgCompletionRate,
      totalVocabulary
    });

    document.getElementById('total-users').textContent = Formatters.formatNumber(totalUsers);
    document.getElementById('total-lessons').textContent = Formatters.formatNumber(totalLessons);
    document.getElementById('completion-rate').textContent = Formatters.formatPercent(avgCompletionRate);
    document.getElementById('total-vocabulary').textContent = Formatters.formatNumber(totalVocabulary);
  }

  /**
   * 사용자 증가 추이 차트 업데이트
   */
  function updateUserGrowthChart(response) {
    const ctx = document.getElementById('user-growth-chart');
    if (!ctx) return;

    // 기존 차트 파괴
    if (charts.userGrowth) {
      charts.userGrowth.destroy();
    }

    // 데이터 준비 - unwrap data from response
    const data = response?.data || response || {};
    const labels = data.dates || [];
    const values = data.userCounts || [];

    // 차트 생성
    charts.userGrowth = new Chart(ctx, {
      type: 'line',
      data: {
        labels,
        datasets: [
          {
            label: '사용자 수',
            data: values,
            borderColor: Constants.CHART_COLORS.PRIMARY,
            backgroundColor: 'rgba(13, 110, 253, 0.1)',
            tension: 0.4,
            fill: true,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false,
          },
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              precision: 0,
            },
          },
        },
      },
    });
  }

  /**
   * 레슨 완료율 차트 업데이트
   */
  function updateCompletionChart(response) {
    const ctx = document.getElementById('completion-chart');
    if (!ctx) return;

    // 기존 차트 파괴
    if (charts.completion) {
      charts.completion.destroy();
    }

    // 데이터 준비 - unwrap data from response
    const data = response?.data || response || {};
    const avgCompletionRate = data?.progress?.avg_completion_rate || 0;
    const completedRate = avgCompletionRate * 100;
    const incompleteRate = 100 - completedRate;

    // 차트 생성
    charts.completion = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ['완료', '미완료'],
        datasets: [
          {
            data: [completedRate, incompleteRate],
            backgroundColor: [Constants.CHART_COLORS.SUCCESS, Constants.CHART_COLORS.SECONDARY],
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
          },
        },
      },
    });
  }

  /**
   * 참여도 지표 차트 업데이트
   */
  function updateEngagementChart(response) {
    const ctx = document.getElementById('engagement-chart');
    if (!ctx) return;

    // 기존 차트 파괴
    if (charts.engagement) {
      charts.engagement.destroy();
    }

    // 데이터 준비 - unwrap data from response
    const data = response?.data || response || {};
    const labels = data.dates || [];
    const avgStudyTime = data.avgStudyTimes || [];
    const activeUsers = data.activeUsers || [];

    // 차트 생성
    charts.engagement = new Chart(ctx, {
      type: 'bar',
      data: {
        labels,
        datasets: [
          {
            label: '평균 학습 시간 (분)',
            data: avgStudyTime,
            backgroundColor: Constants.CHART_COLORS.INFO,
            yAxisID: 'y',
          },
          {
            label: '활성 사용자',
            data: activeUsers,
            backgroundColor: Constants.CHART_COLORS.WARNING,
            yAxisID: 'y1',
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
          mode: 'index',
          intersect: false,
        },
        scales: {
          y: {
            type: 'linear',
            display: true,
            position: 'left',
            title: {
              display: true,
              text: '평균 학습 시간 (분)',
            },
          },
          y1: {
            type: 'linear',
            display: true,
            position: 'right',
            title: {
              display: true,
              text: '활성 사용자',
            },
            grid: {
              drawOnChartArea: false,
            },
          },
        },
      },
    });
  }

  // Public API 반환
  return {
    render,
  };
})();
