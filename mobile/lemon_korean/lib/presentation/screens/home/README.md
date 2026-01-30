# 首页界面 (Home Screen)

Material Design 3 风格的首页，包含3个Tab和动画效果。

## 文件结构

```
home/
├── home_screen.dart              # 主屏幕（包含3个Tab）
└── widgets/
    ├── user_header.dart          # 用户头部（问候 + 连续学习天数）
    ├── daily_goal_card.dart      # 今日目标卡片（进度条）
    ├── continue_lesson_card.dart # 继续学习卡片
    └── lesson_grid_item.dart     # 课程网格项
```

---

## 界面结构

### 主屏幕 (HomeScreen)

使用 `IndexedStack` 和 `NavigationBar` 实现3个Tab：

1. **首页** (HomeTab) - 主要学习界面
2. **复习** (ReviewTab) - SRS复习计划
3. **我的** (ProfileTab) - 用户设置和统计

> **注意**: 下载管理功能通过单独的 `DownloadManagerScreen` 访问，不再作为主屏幕Tab。

---

## Tab 详细说明

### 1. 首页 Tab (HomeTab)

使用 `CustomScrollView` + `Sliver` 实现流畅滚动：

**布局顺序**:
```
UserHeader (用户信息 + 连续学习天数)
    ↓
DailyGoalCard (今日目标进度条)
    ↓
ContinueLessonCard (继续学习) [可选，有进行中课程时显示]
    ↓
"所有课程" 标题 + 筛选按钮
    ↓
LessonGridItem (课程网格，2列)
```

**动画效果**:
- UserHeader: `fadeIn` + `slideY` (从上向下)
- DailyGoalCard: `fadeIn` + `slideY` (延迟100ms)
- ContinueLessonCard: `fadeIn` + `slideY` (延迟200ms)
- LessonGridItem: `fadeIn` + `scale` (每个延迟50ms)

**代码示例**:
```dart
UserHeader(user: user, streakDays: _streakDays)
  .animate()
  .fadeIn(duration: 400.ms)
  .slideY(begin: -0.2, end: 0, duration: 400.ms);
```

### 2. 下载 Tab (DownloadsTab)

显示已下载课程列表：

- **SliverAppBar**: 固定标题 "已下载课程"
- **存储管理按钮**: 查看存储空间使用
- **已下载列表**: ListTile格式
- **删除按钮**: 每个课程可单独删除
- **空状态**: 无下载时显示提示

### 3. 复习 Tab (ReviewTab)

SRS复习计划：

- **今日复习卡片**:
  - 显示待复习单词数
  - "开始复习" 按钮（柠檬黄背景）
- **未来复习列表**:
  - 今天、明天、2天后、3天后
  - 每天的复习数量

### 4. 我的 Tab (ProfileTab)

用户设置和统计：

**顶部**:
- 渐变背景（柠檬黄淡化）
- 用户头像（首字母或表情）
- 用户名 + 邮箱
- 会员标签（高级会员/免费用户）

**学习统计**:
- 已完成课程: 12
- 学习天数: 45
- 掌握单词: 230

**设置选项**:
- 通知设置
- 语言设置
- 存储管理

**关于**:
- 帮助中心
- 关于应用

**退出登录**:
- 红色背景卡片
- 确认对话框

---

## 组件详细说明

### UserHeader

**功能**: 显示用户问候和连续学习天数

**属性**:
- `user`: UserModel? - 用户信息
- `streakDays`: int - 连续学习天数

**UI元素**:
- 问候语（早上好/下午好/晚上好）
- 用户名
- 火焰图标 + 连续天数徽章

**样式**:
- 渐变背景（柠檬黄淡化）
- 白色徽章带阴影

---

### DailyGoalCard

**功能**: 显示今日学习目标进度

**属性**:
- `progress`: double (0.0-1.0) - 完成百分比
- `completedLessons`: int - 已完成课程数
- `targetLessons`: int - 目标课程数

**UI元素**:
- 进度百分比
- 进度条（LinearProgressIndicator）
- "X/Y 课完成"
- 完成时显示庆祝消息

**状态**:
- 未完成: 白色背景
- 已完成: 柠檬黄背景 + 庆祝图标

---

### ContinueLessonCard

**功能**: 显示当前正在学习的课程

**属性**:
- `lesson`: LessonModel - 课程信息
- `progress`: ProgressModel - 进度信息
- `onTap`: VoidCallback - 点击回调

**UI元素**:
- 课程等级徽章
- 韩语标题
- 中文标题
- 播放按钮（柠檬黄圆形）
- 进度条
- 学习时长

**样式**:
- Card带elevation
- 圆角边框

---

### LessonGridItem

**功能**: 网格中的课程卡片

**属性**:
- `lesson`: LessonModel - 课程信息
- `progress`: double? - 进度（可选）
- `onTap`: VoidCallback - 点击回调

**UI元素**:

#### 顶部缩略图区域:
- 渐变背景（根据level颜色）
- 课程编号（大号字体）
- Level徽章
- 下载图标（已下载时显示）
- 完成徽章（已完成时显示）

#### 底部信息区域:
- 韩语标题
- 中文标题
- 预计时长图标
- 单词数量图标
- 进度条（已开始时显示）

**Level颜色映射**:
```dart
Level 1 → 绿色
Level 2 → 蓝色
Level 3 → 紫色
Level 4 → 橙色
Level 5 → 红色
Level 6 → 粉色
```

---

## 动画说明

使用 `flutter_animate` 包实现流畅动画：

### FadeIn（淡入）
```dart
.animate().fadeIn(duration: 400.ms)
```

### SlideY（垂直滑动）
```dart
.slideY(
  begin: -0.2,  // 从上方20%开始
  end: 0,       // 到原始位置
  duration: 400.ms,
  curve: Curves.easeOut,
)
```

### Scale（缩放）
```dart
.scale(
  begin: const Offset(0.8, 0.8),  // 从80%开始
  end: const Offset(1, 1),        // 到100%
  duration: 400.ms,
  curve: Curves.easeOut,
)
```

### 延迟动画
```dart
.animate(delay: Duration(milliseconds: 100))
```

---

## Material Design 3 特性

### NavigationBar
```dart
NavigationBar(
  selectedIndex: _selectedIndex,
  destinations: [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: '首页',
    ),
  ],
)
```

### Card
```dart
Card(
  elevation: 0,  // MD3: 无阴影
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: Colors.grey.shade200),
  ),
)
```

### LinearProgressIndicator
```dart
LinearProgressIndicator(
  value: progress,
  minHeight: 8,
  backgroundColor: Colors.grey.shade200,
  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
)
```

---

## 数据流

### Mock数据 (开发阶段)
```dart
void _loadMockData() {
  // 创建12个模拟课程
  for (int i = 1; i <= 12; i++) {
    _lessons.add(LessonModel(...));
  }
}
```

### 未来实现（使用Provider）
```dart
@override
void initState() {
  super.initState();

  // 从Provider加载数据
  final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
  lessonProvider.fetchLessons();

  final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
  progressProvider.fetchProgress();
}
```

---

## 响应式布局

### 网格自适应
```dart
SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,        // 2列
    childAspectRatio: 0.75,   // 宽高比
    crossAxisSpacing: 16,     // 水平间距
    mainAxisSpacing: 16,      // 垂直间距
  ),
)
```

### CustomScrollView优势
- 统一的滚动体验
- Sliver组件高性能
- 支持吸顶、悬浮等效果

---

## 用户交互

### 点击事件
```dart
InkWell(
  onTap: () {
    // 导航到课程详情
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonDetailScreen(lesson: lesson),
      ),
    );
  },
  borderRadius: BorderRadius.circular(12),
  child: ...
)
```

### 确认对话框
```dart
final confirm = await showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('确认退出'),
    content: const Text('确定要退出登录吗？'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context, false), child: Text('取消')),
      TextButton(onPressed: () => Navigator.pop(context, true), child: Text('确定')),
    ],
  ),
);

if (confirm == true) {
  await authProvider.logout();
}
```

---

## 性能优化

### IndexedStack
- 保持所有Tab状态
- 切换Tab时不重建

### const构造函数
```dart
const NavigationDestination(...)
```

### 条件渲染
```dart
if (_currentProgress != null)
  SliverToBoxAdapter(...)
```

---

## 下一步开发

1. **连接Provider**: 替换mock数据为真实数据
2. **课程详情页**: LessonDetailScreen
3. **下载管理**: 实现下载、删除功能
4. **复习功能**: SRS算法集成
5. **统计图表**: 学习进度可视化
6. **搜索功能**: 课程搜索和筛选
7. **通知**: 每日提醒

---

## 测试要点

### Widget测试
```dart
testWidgets('UserHeader displays greeting', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: UserHeader(
        user: testUser,
        streakDays: 7,
      ),
    ),
  );

  expect(find.text('早上好'), findsOneWidget);
  expect(find.text('7'), findsOneWidget);
});
```

### 动画测试
```dart
testWidgets('LessonGridItem animates in', (tester) async {
  await tester.pumpWidget(...);
  await tester.pump(); // 开始动画
  await tester.pump(const Duration(milliseconds: 400)); // 动画完成

  expect(find.byType(LessonGridItem), findsOneWidget);
});
```
