# 下载管理界面 (Download Manager Screen)

完整的课程下载管理功能，支持实时进度更新、批量管理和存储监控。

## 文件结构

```
download/
├── download_manager_screen.dart  # 下载管理主屏幕
└── README.md                     # 文档
```

**相关文件**:
- `lib/presentation/providers/download_provider.dart` - 下载状态管理
- `lib/core/utils/download_manager.dart` - 下载引擎
- `lib/data/repositories/offline_repository.dart` - 离线数据管理

---

## 功能特性

### 1. 双Tab布局
- **已下载** Tab - 显示已下载课程列表
- **可下载** Tab - 显示可下载课程列表

### 2. 实时下载进度
- 进度条显示（0-100%）
- 状态消息更新
- 取消下载功能

### 3. 存储管理
- 存储空间使用情况
- 存储空间百分比
- 存储详情对话框

### 4. 批量操作
- 清空所有下载
- 批量删除（规划中）

---

## 界面结构

```
┌──────────────────────────────────────┐
│ ← 下载管理        [存储] [清空]      │
├──────────────────────────────────────┤
│ [已下载] [可下载]                    │
├──────────────────────────────────────┤
│ ┌─ 下载中 (2) ───────────────────┐  │
│ │ 课程 1           45%    [x]    │  │
│ │ ████████░░░░                   │  │
│ │ 下载文件 3/10                  │  │
│ │                                 │  │
│ │ 课程 5           12%    [x]    │  │
│ │ ██░░░░░░░░░░                   │  │
│ │ 准备中...                       │  │
│ └─────────────────────────────────┘  │
├──────────────────────────────────────┤
│ 存储空间  156.5 / 500.0 MB          │
│ ████████░░░░░░░░░░░░                │
├──────────────────────────────────────┤
│ [已下载列表]                         │
│ ┌─────────────────────────────────┐ │
│ │ [1] 韩语课程 1         [删除]  │ │
│ │     ✓已下载 • 30分             │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ [2] 韩语课程 2         [删除]  │ │
│ │     ✓已下载 • 35分             │ │
│ └─────────────────────────────────┘ │
└──────────────────────────────────────┘
```

---

## DownloadProvider

### 状态变量

```dart
class DownloadProvider extends ChangeNotifier {
  Map<int, DownloadProgress> _activeDownloads = {};  // 活动下载
  List<LessonModel> _downloadedLessons = [];        // 已下载课程
  List<LessonModel> _availableLessons = [];         // 可下载课程
  OfflineStorageStats? _storageStats;               // 存储统计
  bool _isLoading = false;                          // 加载状态
  String? _error;                                   // 错误信息
}
```

### 核心方法

#### init()
初始化下载管理器。

```dart
Future<void> init() async {
  await _offlineRepository.init();
  await loadData();
  _startProgressMonitoring(); // 启动进度监控
}
```

#### loadData()
加载所有数据。

```dart
Future<void> loadData() async {
  // 1. 加载已下载课程
  _downloadedLessons = await _offlineRepository.getOfflineLessons();

  // 2. 加载所有课程
  final allLessons = await _contentRepository.getLessons();

  // 3. 过滤可下载课程（未下载）
  _availableLessons = allLessons
      .where((lesson) => !_downloadedLessons.any((dl) => dl.id == lesson.id))
      .toList();

  // 4. 加载存储统计
  _storageStats = await _offlineRepository.getStorageStats();
}
```

#### downloadLesson(lesson)
下载课程。

```dart
Future<void> downloadLesson(LessonModel lesson) async {
  await _downloadManager.downloadLesson(
    lesson.id,
    onProgress: (lessonId, progress) {
      _updateDownloadProgress(lessonId, progress);
    },
    onComplete: (lessonId) {
      _onDownloadComplete(lessonId);
    },
  );
}
```

#### deleteLesson(lesson)
删除已下载课程。

```dart
Future<void> deleteLesson(LessonModel lesson) async {
  await _offlineRepository.deleteLesson(lesson.id);

  // 移动到可下载列表
  _downloadedLessons.removeWhere((l) => l.id == lesson.id);
  _availableLessons.add(lesson);

  // 更新存储统计
  _storageStats = await _offlineRepository.getStorageStats();
}
```

---

## 组件详解

### _ActiveDownloadsSection

显示正在下载的课程列表。

**特点**:
- 黄色背景高亮
- 实时进度更新
- 取消按钮

```dart
Container(
  color: AppConstants.primaryColor.withOpacity(0.1),
  child: Column(
    children: [
      // 标题
      '下载中 (2)',

      // 下载项
      _DownloadingItem(
        lessonId: 1,
        progress: progress,
        onCancel: () => provider.cancelDownload(1),
      ),
    ],
  ),
)
```

### _DownloadingItem

单个下载项组件。

**UI元素**:
- 课程标题
- 进度百分比
- 进度条（LinearProgressIndicator）
- 状态消息
- 取消按钮

```dart
Card(
  child: Column(
    children: [
      Row([
        '课程 1',
        '45%',
        [取消按钮],
      ]),
      LinearProgressIndicator(value: 0.45),
      '下载文件 3/10',
    ],
  ),
)
```

### _StorageInfoBar

存储空间信息栏。

**显示内容**:
- 已用空间 / 总空间
- 进度条
- 超过80%时显示红色警告

```dart
Column([
  Row([
    '存储空间',
    '156.5 / 500.0 MB',
  ]),
  LinearProgressIndicator(
    value: 0.31,
    valueColor: percentage > 0.8 ? Colors.red : primaryColor,
  ),
])
```

### _DownloadedTab

已下载课程Tab。

**功能**:
- 显示已下载列表
- 删除按钮
- 下拉刷新
- 空状态提示

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return _DownloadedLessonCard(
      lesson: lessons[index],
      onDelete: () => _showDeleteDialog(context, lesson),
    );
  },
)
```

### _AvailableTab

可下载课程Tab。

**功能**:
- 显示可下载列表
- 下载按钮
- 下拉刷新
- 空状态提示

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return _AvailableLessonCard(
      lesson: lessons[index],
      onDownload: () => provider.downloadLesson(lesson),
    );
  },
)
```

---

## 实时进度更新

### 进度监控机制

使用 `Timer.periodic` 每500ms更新一次：

```dart
void _startProgressMonitoring() {
  _progressTimer = Timer.periodic(
    const Duration(milliseconds: 500),
    (_) {
      _updateActiveDownloads();
    },
  );
}

void _updateActiveDownloads() {
  final newActiveDownloads = _downloadManager.getAllProgress();

  // 只在有变化时更新
  if (!_mapsEqual(_activeDownloads, newActiveDownloads)) {
    _activeDownloads = newActiveDownloads;
    notifyListeners(); // 触发UI更新
  }
}
```

### 下载生命周期

```
开始下载
    ↓
添加到 activeDownloads
    ↓
每500ms更新进度 → notifyListeners()
    ↓
UI自动重建 → 进度条更新
    ↓
下载完成
    ↓
从 activeDownloads 移除
    ↓
移动到 downloadedLessons
    ↓
notifyListeners()
```

---

## 数据流

### 下载流程

```dart
// 1. 用户点击下载按钮
onPressed: () => provider.downloadLesson(lesson)

// 2. Provider调用DownloadManager
await _downloadManager.downloadLesson(
  lesson.id,
  onProgress: (lessonId, progress) {
    _activeDownloads[lessonId] = progress;
    notifyListeners();
  },
)

// 3. DownloadManager下载文件
// - 下载lesson metadata
// - 下载media files
// - 更新进度回调

// 4. 完成后更新列表
_onDownloadComplete(lessonId) {
  _activeDownloads.remove(lessonId);
  loadData(); // 重新加载列表
}
```

### 删除流程

```dart
// 1. 用户点击删除
onDelete: () => provider.deleteLesson(lesson)

// 2. 调用OfflineRepository
await _offlineRepository.deleteLesson(lesson.id)

// 3. 删除本地文件和数据库记录

// 4. 更新列表
_downloadedLessons.remove(lesson);
_availableLessons.add(lesson);
notifyListeners();
```

---

## 存储管理

### 存储统计

```dart
class OfflineStorageStats {
  final int totalLessons;          // 总课程数
  final int downloadedLessons;     // 已下载数
  final int mediaFileCount;        // 媒体文件数
  final int mediaStorageBytes;     // 媒体存储（字节）
  final int totalStorageBytes;     // 总存储（字节）

  double get mediaStorageMB => mediaStorageBytes / 1024 / 1024;
  double get totalStorageMB => totalStorageBytes / 1024 / 1024;
}
```

### 存储信息对话框

```dart
void _showStorageInfo() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('存储信息'),
      content: Column([
        _buildInfoRow('已下载课程', '12'),
        _buildInfoRow('媒体文件数', '156'),
        _buildInfoRow('使用空间', '156.5 MB'),
        _buildInfoRow('缓存空间', '23.2 MB'),
        _buildInfoRow('总计', '179.7 MB'),
      ]),
    ),
  );
}
```

---

## UI交互

### 下载确认

无需确认，直接开始下载。

### 删除确认

```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('删除下载'),
    content: Text('确定要删除"${lesson.titleZh}"吗？'),
    actions: [
      TextButton(child: Text('取消')),
      TextButton(
        child: Text('删除'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
        ),
        onPressed: () {
          provider.deleteLesson(lesson);
        },
      ),
    ],
  ),
);
```

### 清空所有下载

```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('清空下载'),
    content: Text('确定要删除所有 12 个已下载课程吗？'),
    actions: [
      TextButton(child: Text('取消')),
      TextButton(
        child: Text('确定'),
        onPressed: () async {
          await provider.deleteAllDownloads();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('已清空所有下载')),
          );
        },
      ),
    ],
  ),
);
```

---

## 下拉刷新

两个Tab都支持下拉刷新：

```dart
RefreshIndicator(
  onRefresh: () async {
    final provider = Provider.of<DownloadProvider>(
      context,
      listen: false,
    );
    await provider.loadData();
  },
  child: ListView.builder(...),
)
```

---

## 空状态

### 已下载Tab空状态

```
    📥
暂无已下载课程
切换到"可下载"标签开始下载
```

### 可下载Tab空状态

```
    ✓
所有课程已下载
```

---

## 使用示例

### 在main.dart中配置Provider

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 导航到下载管理界面

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const DownloadManagerScreen(),
  ),
);
```

### 在其他界面显示下载状态

```dart
Consumer<DownloadProvider>(
  builder: (context, provider, child) {
    final activeCount = provider.activeDownloads.length;

    if (activeCount > 0) {
      return Badge(
        label: Text('$activeCount'),
        child: Icon(Icons.downloading),
      );
    }

    return Icon(Icons.download_outlined);
  },
)
```

---

## 性能优化

### 1. 进度更新节流

每500ms更新一次，避免过于频繁：

```dart
Timer.periodic(const Duration(milliseconds: 500), ...)
```

### 2. 智能notifyListeners

只在数据真正变化时触发：

```dart
if (!_mapsEqual(_activeDownloads, newActiveDownloads)) {
  _activeDownloads = newActiveDownloads;
  notifyListeners();
}
```

### 3. ListView复用

使用 `ListView.builder` 而不是 `ListView.children`。

---

## 错误处理

### 下载失败

```dart
try {
  await _downloadManager.downloadLesson(...);
} catch (e) {
  _setError('下载错误: $e');
  // UI会自动显示错误消息
}
```

### 删除失败

```dart
try {
  await _offlineRepository.deleteLesson(lesson.id);
} catch (e) {
  _setError('删除失败: $e');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('删除失败: $e')),
  );
}
```

---

## 下一步开发

1. **下载队列**: 限制同时下载数量
2. **断点续传**: 网络中断后继续下载
3. **WiFi限制**: 仅WiFi下载选项
4. **批量下载**: 选择多个课程批量下载
5. **下载优先级**: 调整下载顺序
6. **存储清理**: 自动清理旧文件
7. **下载历史**: 记录下载历史

---

## 测试要点

### Widget测试

```dart
testWidgets('shows active downloads', (tester) async {
  final provider = DownloadProvider();

  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        home: DownloadManagerScreen(),
      ),
    ),
  );

  // 模拟下载
  provider.downloadLesson(testLesson);
  await tester.pump();

  expect(find.text('下载中'), findsOneWidget);
});
```

### Provider测试

```dart
test('downloadLesson updates activeDownloads', () async {
  final provider = DownloadProvider();

  provider.downloadLesson(testLesson);

  expect(provider.activeDownloads, contains(testLesson.id));
});
```
