# 柠檬韩语 (Lemon Korean)

> 专为中文母语者打造的韩语学习平台 | 중국어 화자를 위한 한국어 학습 플랫폼

[English](#english) | [中文](#中文) | [한국어](#한국어)

---

<a name="中文"></a>

## 📖 项目简介

**柠檬韩语 (Lemon Korean)** 是一个专为中文母语者设计的韩语学习应用，采用离线优先架构，支持课程下载后无网络学习，并在网络恢复时自动同步学习进度。

### ✨ 核心特性

- **🔌 离线优先学习**: 下载课程后无需联网即可学习
- **🔄 自动同步**: 网络恢复时自动备份学习进度
- **🇨🇳 中文定制设计**: 汉字关联、发音相似度对比
- **📱 沉浸式体验**: 全屏学习模式，专注学习
- **🏗️ 微服务架构**: 可扩展的后端系统
- **🎯 7阶段课程**: 词汇→语法→练习→对话→测验→复习→总结
- **🎨 现代UI设计**: Material Design 3, 流畅动画
- **📊 SRS复习系统**: 智能复习提醒

---

## 🏗️ 架构设计

### 系统架构图

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App                           │
│                (离线优先 + 自动同步)                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  Hive    │  │ SQLite   │  │   Dio    │              │
│  │ (Lessons)│  │ (Media)  │  │  (HTTP)  │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                          ↕
                  (仅在需要时同步)
                          ↕
┌─────────────────────────────────────────────────────────┐
│                  Nginx API Gateway                       │
│              (端口80, 负载均衡 + 缓存)                   │
└─────────────────────────────────────────────────────────┘
                          ↓
        ┌─────────────────┼─────────────────┐
        ↓                 ↓                 ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Auth Service │  │Content Service│ │Progress Service│
│  (Node.js)   │  │  (Node.js)    │ │     (Go)      │
│   :3001      │  │    :3002      │ │    :3003      │
└──────────────┘  └──────────────┘  └──────────────┘
        ↓                 ↓                 ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Media Service│  │Analytics Svc │  │ Admin Service│
│     (Go)     │  │   (Python)   │  │  (Node.js)   │
│   :3004      │  │    :3005     │  │    :3006     │
└──────────────┘  └──────────────┘  └──────────────┘
        ↓                 ↓                 ↓
┌─────────────────────────────────────────────────────────┐
│                   数据层                                 │
│  ┌──────────┐  ┌──────────┐  ┌────────┐  ┌──────────┐ │
│  │PostgreSQL│  │ MongoDB  │  │ Redis  │  │  MinIO   │ │
│  │  :5432   │  │  :27017  │  │ :6379  │  │:9000/9001│ │
│  └──────────┘  └──────────┘  └────────┘  └──────────┘ │
│  ┌──────────┐                                          │
│  │ RabbitMQ │  (消息队列)                               │
│  │  :5672   │                                          │
│  └──────────┘                                          │
└─────────────────────────────────────────────────────────┘
```

### 数据流

```
用户操作 → 本地存储 (Hive/SQLite)
                ↓
        添加到同步队列 (sync_queue)
                ↓
        网络可用? ──No→ 保持队列
                │
               Yes
                ↓
        后台自动同步 → API Gateway (Nginx)
                ↓
        微服务处理 → 数据库持久化
                ↓
        返回确认 → 清除队列项
```

---

## 🔧 技术栈

### 后端服务

| 服务 | 技术栈 | 端口 | 功能 |
|------|--------|------|------|
| **Auth Service** | Node.js + Express | 3001 | JWT认证、用户管理 |
| **Content Service** | Node.js + Express | 3002 | 课程内容、词汇、语法 |
| **Progress Service** | Go + Gin | 3003 | 学习进度、SRS算法 |
| **Media Service** | Go + Gin | 3004 | 图片/音频服务 |
| **Analytics Service** | Python + FastAPI | 3005 | 日志分析、统计 |
| **Admin Service** | Node.js + Express | 3006 | 管理员面板 |

### 数据库与存储

| 组件 | 端口 | 用途 |
|------|------|------|
| **PostgreSQL** | 5432 | 结构化数据 (users, lessons, progress) |
| **MongoDB** | 27017 | 文档存储 (lesson content, logs) |
| **Redis** | 6379 | 缓存、会话、实时数据 |
| **MinIO** | 9000/9001 | 媒体文件 (S3兼容) |
| **RabbitMQ** | 5672/15672 | 消息队列、异步任务 |

### 移动端

- **Flutter 3.x** - iOS/Android跨平台
- **Hive** - 本地NoSQL数据库 (课程、进度)
- **SQLite** - 媒体文件映射
- **Dio** - HTTP客户端
- **flutter_animate** - 动画库
- **audioplayers** - 音频播放

### 基础设施

- **Docker & Docker Compose** - 容器化部署
- **Nginx** - API网关、负载均衡、缓存
- **RabbitMQ** - 消息队列

---

## 🚀 快速开始

### 前置要求

- **Docker** 20.x+ & **Docker Compose** 2.x+
- **Node.js** 18+ (开发用)
- **Go** 1.21+ (开发用)
- **Python** 3.11+ (开发用)
- **Flutter** 3.x (移动端开发)

### 安装步骤

#### 1️⃣ 克隆仓库

```bash
git clone <repository-url>
cd lemonkorean
```

#### 2️⃣ 环境变量配置

```bash
cp .env.example .env
```

编辑 `.env` 文件，设置必要的环境变量:

```env
# 数据库
DB_PASSWORD=your_secure_password
POSTGRES_DB=lemon_korean
POSTGRES_USER=lemon_user

# JWT
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=7d

# MinIO
MINIO_ACCESS_KEY=admin
MINIO_SECRET_KEY=your_secure_key
```

#### 3️⃣ 启动服务

**方法1: 使用部署脚本 (推荐)**

```bash
./scripts/deploy.sh
```

此脚本会自动执行:
- ✅ 环境变量验证
- ✅ Docker镜像构建
- ✅ 数据库迁移
- ✅ 服务启动
- ✅ 健康检查

**方法2: 手动启动**

```bash
# 构建并启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
./scripts/logs.sh
# 或
docker-compose logs -f
```

#### 4️⃣ 验证服务

访问以下地址确认服务正常运行:

- **API网关**: http://localhost
- **MinIO控制台**: http://localhost:9001
- **RabbitMQ管理界面**: http://localhost:15672 (用户名: guest, 密码: guest)

健康检查端点:
```bash
# Auth Service
curl http://localhost:3001/api/auth/health

# Content Service
curl http://localhost:3002/api/content/health

# Progress Service
curl http://localhost:3003/api/progress/health
```

#### 5️⃣ 运行Flutter应用

```bash
cd mobile/lemon_korean
flutter pub get
flutter run
```

---

## 📁 项目结构

```
lemonkorean/
├── services/                    # 微服务
│   ├── auth/                   # 认证服务 (Node.js)
│   │   ├── src/
│   │   │   ├── controllers/   # 请求处理
│   │   │   ├── services/      # 业务逻辑
│   │   │   ├── models/        # 数据模型
│   │   │   └── routes/        # 路由定义
│   │   ├── package.json
│   │   └── Dockerfile
│   ├── content/               # 内容服务 (Node.js)
│   ├── progress/              # 进度管理 (Go)
│   ├── media/                 # 媒体服务 (Go)
│   ├── analytics/             # 分析服务 (Python)
│   └── admin/                 # 管理面板 (Node.js)
│
├── mobile/                     # Flutter应用
│   └── lemon_korean/
│       ├── lib/
│       │   ├── core/          # 核心功能
│       │   │   ├── storage/   # Hive + SQLite
│       │   │   ├── network/   # Dio + API
│       │   │   └── utils/     # 工具函数
│       │   ├── data/          # 数据层
│       │   │   ├── models/    # 数据模型
│       │   │   └── repositories/
│       │   └── presentation/  # 展示层
│       │       ├── screens/   # 页面
│       │       ├── widgets/   # 组件
│       │       └── providers/ # 状态管理
│       ├── pubspec.yaml
│       └── README.md
│
├── init/                       # 数据库初始化
│   ├── postgres/              # PostgreSQL模式
│   │   └── 01_schema.sql
│   └── mongo/                 # MongoDB初始数据
│
├── nginx/                      # Nginx配置
│   └── nginx.conf
│
├── scripts/                    # 运维脚本
│   ├── deploy.sh              # 部署脚本
│   ├── backup.sh              # 备份脚本
│   ├── restore.sh             # 恢复脚本
│   ├── logs.sh                # 日志查看
│   └── README.md
│
├── docs/                       # 文档
│   └── api/                   # API文档
│
├── docker-compose.yml          # Docker编排
├── .env.example               # 环境变量示例
├── CLAUDE.md                  # 开发指南
└── README.md                  # 本文件
```

---

## 📚 开发指南

### 本地开发

#### 后端服务开发

每个服务可以独立运行:

```bash
# Auth Service (Node.js)
cd services/auth
npm install
npm run dev

# Progress Service (Go)
cd services/progress
go mod download
go run main.go

# Analytics Service (Python)
cd services/analytics
pip install -r requirements.txt
uvicorn main:app --reload --port 3005
```

#### Flutter应用开发

```bash
cd mobile/lemon_korean
flutter pub get

# iOS模拟器
flutter run

# Android模拟器
flutter run

# 生产构建
flutter build apk --release
flutter build ios --release
```

### 数据库操作

```bash
# 连接PostgreSQL
docker-compose exec postgres psql -U lemon_user -d lemon_korean

# 连接MongoDB
docker-compose exec mongo mongosh

# 连接Redis
docker-compose exec redis redis-cli

# 执行数据库迁移
docker-compose exec postgres psql -U lemon_user -d lemon_korean -f /init/postgres/01_schema.sql
```

### 代码规范

#### Flutter
- `*_screen.dart` - 页面
- `*_provider.dart` - 状态管理
- `*_model.dart` - 数据模型
- `*_repository.dart` - 数据访问
- `*_widget.dart` - 可复用组件

#### Backend
- `*.controller.js/go` - 请求处理
- `*.service.js/go` - 业务逻辑
- `*.model.js/go` - 数据模型
- `*.routes.js/go` - 路由定义

---

## 🔍 API文档

### 主要端点

#### Auth Service (`:3001`)

| 方法 | 端点 | 描述 |
|------|------|------|
| POST | `/api/auth/register` | 用户注册 |
| POST | `/api/auth/login` | 用户登录 |
| POST | `/api/auth/refresh` | 刷新token |
| GET | `/api/auth/profile` | 获取用户信息 |

#### Content Service (`:3002`)

| 方法 | 端点 | 描述 |
|------|------|------|
| GET | `/api/content/lessons` | 获取课程列表 |
| GET | `/api/content/lessons/:id` | 获取课程详情 |
| GET | `/api/content/lessons/:id/download` | 下载课程包 |
| POST | `/api/content/check-updates` | 检查课程更新 |

#### Progress Service (`:3003`)

| 方法 | 端点 | 描述 |
|------|------|------|
| GET | `/api/progress/user/:userId` | 获取用户进度 |
| POST | `/api/progress/complete` | 完成课程 |
| POST | `/api/progress/sync` | 同步离线进度 |
| GET | `/api/progress/review-schedule` | SRS复习计划 |

#### Media Service (`:3004`)

| 方法 | 端点 | 描述 |
|------|------|------|
| GET | `/media/images/:key` | 获取图片 |
| GET | `/media/audio/:key` | 获取音频 |

详细API文档: [API Documentation](./docs/api/README.md)

---

## 🧪 测试

### 后端测试

```bash
# Auth Service
docker-compose exec auth npm test

# Progress Service
cd services/progress
go test ./...

# Analytics Service
cd services/analytics
pytest
```

### Flutter测试

```bash
cd mobile/lemon_korean

# 单元测试
flutter test

# 集成测试
flutter test integration_test/

# 测试覆盖率
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## 🛠️ 运维工具

### 备份与恢复

```bash
# 创建备份
./scripts/backup.sh

# 查看可用备份
./scripts/restore.sh

# 从备份恢复
./scripts/restore.sh 20240125_020000
```

备份内容:
- ✅ PostgreSQL数据库
- ✅ MongoDB数据库
- ✅ MinIO对象存储
- ✅ 自动删除30天以上旧备份

### 日志查看

```bash
# 查看所有服务日志
./scripts/logs.sh

# 实时跟踪日志
./scripts/logs.sh -f

# 查看特定服务
./scripts/logs.sh auth

# 过去1小时日志
./scripts/logs.sh --since 1h content
```

### 服务管理

```bash
# 重启特定服务
docker-compose restart auth

# 停止所有服务
docker-compose down

# 完全清理 (包括数据卷)
docker-compose down -v

# 查看服务状态
docker-compose ps
```

---

## ⚠️ 故障排除

### 常见问题

#### 1. 端口冲突

**症状**: `Error: bind: address already in use`

**解决方案**:
```bash
# 检查端口占用
sudo lsof -i :5432  # PostgreSQL
sudo lsof -i :3001  # Auth Service

# 停止冲突进程或修改docker-compose.yml中的端口映射
docker-compose down
# 修改端口后重新启动
docker-compose up -d
```

#### 2. Docker构建失败

**症状**: `ERROR [internal] load metadata for docker.io/library/...`

**解决方案**:
```bash
# 清理Docker缓存
docker system prune -a

# 重新构建
docker-compose build --no-cache
docker-compose up -d
```

#### 3. 数据库连接失败

**症状**: `Error: connect ECONNREFUSED`

**解决方案**:
```bash
# 检查数据库容器状态
docker-compose ps postgres

# 查看数据库日志
docker-compose logs postgres

# 重启数据库
docker-compose restart postgres

# 等待PostgreSQL就绪
docker-compose exec postgres pg_isready -U lemon_user
```

#### 4. Flutter构建错误

**症状**: `Could not resolve all dependencies`

**解决方案**:
```bash
cd mobile/lemon_korean

# 清理缓存
flutter clean

# 重新获取依赖
flutter pub get

# 升级依赖
flutter pub upgrade

# 重新运行
flutter run
```

#### 5. 健康检查失败

**症状**: 某些服务健康检查失败

**解决方案**:
```bash
# 查看失败服务日志
./scripts/logs.sh <service-name>

# 检查环境变量
cat .env

# 重新部署
./scripts/deploy.sh
```

#### 6. MinIO访问问题

**症状**: 无法访问MinIO控制台或上传文件失败

**解决方案**:
```bash
# 检查MinIO状态
curl http://localhost:9000/minio/health/live

# 查看MinIO日志
docker-compose logs minio

# 重新配置凭证 (在.env中)
MINIO_ACCESS_KEY=admin
MINIO_SECRET_KEY=your_secure_key

# 重启MinIO
docker-compose restart minio
```

#### 7. 备份失败

**症状**: `backup.sh` 执行失败

**解决方案**:
```bash
# 检查磁盘空间
df -h

# 检查容器运行状态
docker-compose ps

# 查看备份目录权限
ls -la backups/

# 手动创建备份目录
mkdir -p backups/{postgres,mongo,minio}
```

### 日志位置

```bash
# 应用日志
docker-compose logs <service-name>

# 备份日志
/var/log/lemon_korean_backup.log

# Nginx日志
docker-compose logs nginx

# 系统日志
journalctl -u docker
```

### 性能优化

#### 数据库优化

```sql
-- PostgreSQL索引优化
CREATE INDEX idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX idx_lessons_level ON lessons(level);

-- 查看慢查询
SELECT * FROM pg_stat_statements ORDER BY mean_exec_time DESC LIMIT 10;
```

#### Redis缓存

```bash
# 查看缓存命中率
docker-compose exec redis redis-cli INFO stats | grep hit

# 清空缓存
docker-compose exec redis redis-cli FLUSHALL
```

#### Nginx缓存

```bash
# 清空Nginx缓存
docker-compose exec nginx rm -rf /var/cache/nginx/*

# 重载配置
docker-compose exec nginx nginx -s reload
```

---

## 🔐 安全建议

1. **生产环境配置**:
   - 使用强密码 (最少16位字符)
   - 定期更换JWT_SECRET
   - 启用HTTPS (使用Let's Encrypt)
   - 配置防火墙规则

2. **数据备份**:
   - 设置定时备份 (cron)
   - 异地备份至云存储
   - 定期测试恢复流程

3. **监控告警**:
   - 配置服务健康监控
   - 磁盘空间告警
   - CPU/内存使用率监控

---

## 📖 详细文档

- **[CLAUDE.md](./CLAUDE.md)** - 详细开发指南
- **[scripts/README.md](./scripts/README.md)** - 运维脚本文档
- **[mobile/lemon_korean/README.md](./mobile/lemon_korean/README.md)** - Flutter应用文档

---

## 🗺️ 开发路线图

- [x] **Phase 1**: 认证服务 + 内容服务
- [x] **Phase 2**: 进度服务 + 同步机制
- [x] **Phase 3**: Flutter基础页面 (登录、注册、首页)
- [x] **Phase 4**: 课程7阶段实现
- [ ] **Phase 5**: 管理员面板
- [ ] **Phase 6**: 数据分析服务
- [ ] **Phase 7**: 生产部署 + CI/CD

---

## 📄 许可证

此项目为个人项目。

---

## 🤝 贡献

欢迎提交Issue和Pull Request。

---

## 📞 联系方式

如有问题或建议，请提交Issue。

---

**Made with ❤️ for Chinese-speaking Korean learners**

---
---

<a name="한국어"></a>

# 📖 프로젝트 소개 (한국어)

**柠檬韩语 (Lemon Korean)** 는 중국어 화자를 위한 한국어 학습 애플리케이션으로, 오프라인 우선 아키텍처를 채택하여 레슨 다운로드 후 네트워크 없이 학습하고, 네트워크 복구 시 자동으로 진도를 동기화합니다.

## ✨ 핵심 기능

- **🔌 오프라인 우선 학습**: 레슨 다운로드 후 인터넷 없이 학습 가능
- **🔄 자동 동기화**: 네트워크 복구 시 학습 진도 자동 백업
- **🇨🇳 중국어 맞춤 설계**: 한자 연결, 발음 유사도 비교
- **📱 몰입형 경험**: 풀스크린 학습 모드
- **🏗️ 마이크로서비스 아키텍처**: 확장 가능한 백엔드
- **🎯 7단계 레슨**: 어휘→문법→연습→대화→퀴즈→복습→요약
- **🎨 현대적 UI**: Material Design 3, 부드러운 애니메이션
- **📊 SRS 복습 시스템**: 지능형 복습 알림

## 🚀 빠른 시작

### 사전 요구사항

- **Docker** 20.x+ & **Docker Compose** 2.x+
- **Node.js** 18+ (개발용)
- **Go** 1.21+ (개발용)
- **Python** 3.11+ (개발용)
- **Flutter** 3.x (모바일 앱 개발)

### 설치 방법

#### 1️⃣ 저장소 클론

```bash
git clone <repository-url>
cd lemonkorean
```

#### 2️⃣ 환경 변수 설정

```bash
cp .env.example .env
```

`.env` 파일을 편집하여 필요한 환경 변수 설정:

```env
# 데이터베이스
DB_PASSWORD=your_secure_password
POSTGRES_DB=lemon_korean
POSTGRES_USER=lemon_user

# JWT
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=7d

# MinIO
MINIO_ACCESS_KEY=admin
MINIO_SECRET_KEY=your_secure_key
```

#### 3️⃣ 서비스 시작

**방법1: 배포 스크립트 사용 (권장)**

```bash
./scripts/deploy.sh
```

이 스크립트는 자동으로 다음을 수행합니다:
- ✅ 환경 변수 검증
- ✅ Docker 이미지 빌드
- ✅ 데이터베이스 마이그레이션
- ✅ 서비스 시작
- ✅ 헬스 체크

**방법2: 수동 시작**

```bash
# 모든 서비스 빌드 및 시작
docker-compose up -d

# 서비스 상태 확인
docker-compose ps

# 로그 확인
./scripts/logs.sh
# 또는
docker-compose logs -f
```

#### 4️⃣ 서비스 확인

다음 주소로 접속하여 서비스 정상 작동 확인:

- **API 게이트웨이**: http://localhost
- **MinIO 콘솔**: http://localhost:9001
- **RabbitMQ 관리 UI**: http://localhost:15672 (계정: guest / guest)

헬스 체크 엔드포인트:
```bash
# Auth Service
curl http://localhost:3001/api/auth/health

# Content Service
curl http://localhost:3002/api/content/health

# Progress Service
curl http://localhost:3003/api/progress/health
```

#### 5️⃣ Flutter 앱 실행

```bash
cd mobile/lemon_korean
flutter pub get
flutter run
```

## 📚 개발 가이드

상세한 개발 가이드는 **[CLAUDE.md](./CLAUDE.md)** 를 참고하세요.

### 로컬 개발

#### 백엔드 서비스 개발

```bash
# Auth Service (Node.js)
cd services/auth
npm install
npm run dev

# Progress Service (Go)
cd services/progress
go mod download
go run main.go

# Analytics Service (Python)
cd services/analytics
pip install -r requirements.txt
uvicorn main:app --reload --port 3005
```

#### Flutter 앱 개발

```bash
cd mobile/lemon_korean
flutter pub get

# iOS 시뮬레이터
flutter run

# Android 에뮬레이터
flutter run

# 프로덕션 빌드
flutter build apk --release
flutter build ios --release
```

## ⚠️ 트러블슈팅

### 일반적인 문제

#### 1. 포트 충돌

```bash
# 포트 사용 확인
sudo lsof -i :5432  # PostgreSQL
sudo lsof -i :3001  # Auth Service

# 서비스 중지 후 재시작
docker-compose down
docker-compose up -d
```

#### 2. Docker 빌드 실패

```bash
# Docker 캐시 정리
docker system prune -a

# 재빌드
docker-compose build --no-cache
docker-compose up -d
```

#### 3. 데이터베이스 연결 실패

```bash
# 컨테이너 상태 확인
docker-compose ps postgres

# 로그 확인
docker-compose logs postgres

# 재시작
docker-compose restart postgres
```

#### 4. Flutter 빌드 오류

```bash
cd mobile/lemon_korean
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

## 📖 추가 문서

- **[CLAUDE.md](./CLAUDE.md)** - 상세 개발 가이드
- **[scripts/README.md](./scripts/README.md)** - 운영 스크립트 문서
- **[mobile/lemon_korean/README.md](./mobile/lemon_korean/README.md)** - Flutter 앱 문서

## 📄 라이선스

이 프로젝트는 개인 프로젝트입니다.

## 📞 문의

문제나 제안사항은 Issue를 등록해주세요.

---

**Made with ❤️ for Chinese-speaking Korean learners**

---
---

<a name="english"></a>

# 📖 Project Overview (English)

**Lemon Korean (柠檬韩语)** is a Korean language learning application designed for Chinese speakers, featuring an offline-first architecture that allows learning downloaded lessons without network connectivity and automatically syncs progress when network is restored.

## ✨ Key Features

- **🔌 Offline-First Learning**: Study downloaded lessons without internet
- **🔄 Auto Sync**: Automatically backup learning progress when network is restored
- **🇨🇳 Chinese-Tailored Design**: Hanja connections, pronunciation similarity comparison
- **📱 Immersive Experience**: Full-screen learning mode
- **🏗️ Microservices Architecture**: Scalable backend system
- **🎯 7-Stage Lessons**: Vocabulary→Grammar→Practice→Dialogue→Quiz→Review→Summary
- **🎨 Modern UI**: Material Design 3, smooth animations
- **📊 SRS Review System**: Intelligent review reminders

## 🚀 Quick Start

### Prerequisites

- **Docker** 20.x+ & **Docker Compose** 2.x+
- **Node.js** 18+ (for development)
- **Go** 1.21+ (for development)
- **Python** 3.11+ (for development)
- **Flutter** 3.x (for mobile app development)

### Installation

#### 1️⃣ Clone Repository

```bash
git clone <repository-url>
cd lemonkorean
```

#### 2️⃣ Environment Configuration

```bash
cp .env.example .env
```

Edit `.env` file with necessary environment variables:

```env
# Database
DB_PASSWORD=your_secure_password
POSTGRES_DB=lemon_korean
POSTGRES_USER=lemon_user

# JWT
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=7d

# MinIO
MINIO_ACCESS_KEY=admin
MINIO_SECRET_KEY=your_secure_key
```

#### 3️⃣ Start Services

**Method 1: Using Deployment Script (Recommended)**

```bash
./scripts/deploy.sh
```

This script automatically:
- ✅ Validates environment variables
- ✅ Builds Docker images
- ✅ Runs database migrations
- ✅ Starts services
- ✅ Performs health checks

**Method 2: Manual Start**

```bash
# Build and start all services
docker-compose up -d

# Check service status
docker-compose ps

# View logs
./scripts/logs.sh
# or
docker-compose logs -f
```

#### 4️⃣ Verify Services

Access these URLs to confirm services are running:

- **API Gateway**: http://localhost
- **MinIO Console**: http://localhost:9001
- **RabbitMQ Management**: http://localhost:15672 (guest/guest)

Health check endpoints:
```bash
# Auth Service
curl http://localhost:3001/api/auth/health

# Content Service
curl http://localhost:3002/api/content/health

# Progress Service
curl http://localhost:3003/api/progress/health
```

#### 5️⃣ Run Flutter App

```bash
cd mobile/lemon_korean
flutter pub get
flutter run
```

## 📚 Development Guide

For detailed development guide, see **[CLAUDE.md](./CLAUDE.md)**.

## ⚠️ Troubleshooting

### Common Issues

#### 1. Port Conflict

```bash
# Check port usage
sudo lsof -i :5432  # PostgreSQL
sudo lsof -i :3001  # Auth Service

# Stop and restart
docker-compose down
docker-compose up -d
```

#### 2. Docker Build Failure

```bash
# Clean Docker cache
docker system prune -a

# Rebuild
docker-compose build --no-cache
docker-compose up -d
```

#### 3. Database Connection Failure

```bash
# Check container status
docker-compose ps postgres

# View logs
docker-compose logs postgres

# Restart
docker-compose restart postgres
```

#### 4. Flutter Build Error

```bash
cd mobile/lemon_korean
flutter clean
flutter pub get
flutter pub upgrade
flutter run
```

## 📖 Additional Documentation

- **[CLAUDE.md](./CLAUDE.md)** - Detailed development guide
- **[scripts/README.md](./scripts/README.md)** - Operations script documentation
- **[mobile/lemon_korean/README.md](./mobile/lemon_korean/README.md)** - Flutter app documentation

## 📄 License

This is a personal project.

## 📞 Contact

For issues or suggestions, please create an Issue.

---

**Made with ❤️ for Chinese-speaking Korean learners**
