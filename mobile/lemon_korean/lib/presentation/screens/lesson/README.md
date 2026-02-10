# 课程学习界面 (Lesson Screen)

完整的沉浸式学习体验，包含7个学习阶段，提供系统化的韩语学习流程。

## 文件结构

```
lesson/
├── lesson_screen.dart        # 主学习屏幕（沉浸模式容器）
├── boss_quiz_screen.dart     # Boss Quiz屏幕（每周挑战）
├── stages/
│   ├── stage1_intro.dart     # 第1阶段：课程介绍
│   ├── stage2_vocabulary.dart # 第2阶段：词汇学习（简单版）
│   ├── vocabulary_stage.dart  # 词汇学习（高级版 - 翻转卡片）
│   ├── stage3_grammar.dart    # 第3阶段：语法讲解（简单版）
│   ├── grammar_stage.dart     # 语法讲解（高级版 - 交互练习）
│   ├── stage4_practice.dart   # 第4阶段：练习
│   ├── stage5_dialogue.dart   # 第5阶段：对话练习
│   ├── stage6_quiz.dart       # 第6阶段：测验（简单版）
│   ├── quiz_stage.dart        # 测验（高级版 - 多种题型）
│   └── stage7_summary.dart    # 第7阶段：总结
└── README.md                  # 本文档
```

---

## 核心特性

### 1. 沉浸式全屏模式
- 使用 `SystemChrome.setEnabledSystemUIMode` 隐藏系统UI
- 进入课程自动启用沉浸模式
- 退出课程恢复正常模式

### 2. 7阶段学习流程
```
介绍 → 词汇 → 语法 → 练习 → 对话 → 测验 → 总结
```

### 3. 进度追踪
- 顶部进度条实时显示学习进度
- 显示当前阶段数和完成百分比
- 无法跳过阶段，必须顺序完成

### 4. 平滑过渡
- PageView实现阶段切换
- 禁用手势滑动，只能通过按钮导航
- 300ms过渡动画

### 5. 退出确认
- 点击关闭按钮弹出确认对话框
- 拦截系统返回键（WillPopScope）
- 自动保存进度

---

## lesson_screen.dart

### 状态管理

```dart
class _LessonScreenState extends State<LessonScreen> {
  int _currentStage = 0;           // 当前阶段索引
  final int _totalStages = 7;       // 总阶段数
  final PageController _pageController = PageController();
}
```

### 核心方法

#### _enterImmersiveMode()
进入沉浸模式，隐藏所有系统UI。

```dart
void _enterImmersiveMode() {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );
}
```

#### _exitImmersiveMode()
退出沉浸模式，显示系统UI。

```dart
void _exitImmersiveMode() {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: SystemUiOverlay.values,
  );
}
```

#### _nextStage()
前进到下一阶段或完成课程。

```dart
void _nextStage() {
  if (_currentStage < _totalStages - 1) {
    setState(() {
      _currentStage++;
    });
    _pageController.animateToPage(
      _currentStage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  } else {
    _completeLessonAndExit();
  }
}
```

#### _previousStage()
返回到上一阶段。

```dart
void _previousStage() {
  if (_currentStage > 0) {
    setState(() {
      _currentStage--;
    });
    _pageController.animateToPage(
      _currentStage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
```

#### _showExitDialog()
显示退出确认对话框。

```dart
Future<void> _showExitDialog() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('退出学习'),
      content: const Text('确定要退出当前课程吗？进度将会保存。'),
      actions: [
        TextButton(child: const Text('继续学习')),
        TextButton(
          child: const Text('退出'),
          style: TextButton.styleFrom(
            foregroundColor: AppConstants.errorColor,
          ),
        ),
      ],
    ),
  );

  if (confirm == true && mounted) {
    _saveProgressAndExit();
  }
}
```

### UI布局

```
┌─────────────────────────────────────┐
│ [X] ▓▓▓▓▓▓▓░░░░░░░░ 43%           │ ← 顶部栏
├─────────────────────────────────────┤
│                                     │
│                                     │
│         [Stage Content]             │ ← PageView
│                                     │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

---

## Stage 1: 介绍 (stage1_intro.dart)

### 功能
- 显示课程标题（韩语/中文）
- 显示课程编号徽章
- 显示课程描述
- 显示预计时长和单词数
- 开始学习按钮

### 动画
```dart
// 徽章缩放动画
Container(...)
  .animate()
  .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut);

// 标题渐入动画
Text(lesson.titleKo)
  .animate()
  .fadeIn(delay: 400.ms, duration: 600.ms);

// 按钮滑入动画
ElevatedButton(...)
  .animate()
  .fadeIn(delay: 1200.ms)
  .slideY(begin: 0.3, end: 0, delay: 1200.ms);
```

### UI结构
```
    ┌───────────┐
    │    [1]    │  ← 课程编号徽章（带渐变和阴影）
    └───────────┘

    기본 인사말      ← 韩语标题
    基本问候语        ← 中文标题

    ┌─────────────┐
    │  学习基本的  │  ← 描述卡片
    │  韩语问候语  │
    └─────────────┘

    ⏱ 30分钟  📖 10个单词  ← 信息标签

    ┌─────────────┐
    │  开始学习    │  ← 开始按钮
    └─────────────┘
```

---

## Stage 2: 词汇 (stage2_vocabulary.dart)

### 功能
- 卡片式单词学习
- 显示韩语、汉字、拼音
- 左右导航浏览单词
- 单词计数器

### 数据结构
```dart
{
  'korean': '안녕하세요',
  'chinese': '您好',
  'pinyin': 'nín hǎo'
}
```

### UI结构
```
    词汇学习

    1 / 3              ← 进度计数

    ┌─────────────┐
    │ 안녕하세요   │   ← 韩语（大字）
    │             │
    │   您好       │   ← 中文翻译
    │             │
    │  nín hǎo    │   ← 拼音（斜体）
    └─────────────┘

    [上一个]  [下一个]  ← 导航按钮
```

---

## Vocabulary Stage: 翻转卡片 (vocabulary_stage.dart)

### 功能
- 3D翻转卡片动画
- 前面：图片、韩语、发音按钮
- 背面：中文、拼音、汉字、相似度
- 点击卡片翻转
- 本地/远程图片和音频支持
- AnimationController实现流畅动画

### 数据结构
```dart
{
  'korean': '안녕하세요',
  'pronunciation': 'an-nyeong-ha-se-yo',
  'chinese': '您好',
  'pinyin': 'nín hǎo',
  'hanja': '安寧',           // 汉字词（可选）
  'similarity': 85,          // 相似度 0-100
  'image': 'vocabulary/hello.jpg',
  'audio': 'vocabulary/hello.mp3',
}
```

### 翻转动画实现

#### AnimationController设置
```dart
class _VocabularyStageState extends State<VocabularyStage>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOut,
      ),
    );

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFront = !_isFront;
        });
        _flipController.reset();
      }
    });
  }
}
```

#### 3D翻转变换
```dart
void _flipCard() {
  if (!_flipController.isAnimating) {
    _flipController.forward();
  }
}

AnimatedBuilder(
  animation: _flipAnimation,
  builder: (context, child) {
    final angle = _flipAnimation.value * math.pi;
    final isUnder = angle > math.pi / 2;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)  // 透视效果
        ..rotateY(angle),         // Y轴旋转
      child: isUnder
          ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(math.pi),
              child: _buildBackCard(word),
            )
          : _buildFrontCard(word),
    );
  },
)
```

### 本地/远程媒体加载

#### MediaLoader集成
```dart
// 获取图片路径（优先本地）
FutureBuilder<String>(
  future: MediaLoader.getImagePath(word['image']),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final imagePath = snapshot.data!;
      final isLocal = !imagePath.startsWith('http');

      return isLocal
          ? Image.file(File(imagePath))      // 本地文件
          : Image.network(imagePath);        // 远程URL
    }
    return _buildPlaceholderImage();
  },
)
```

#### 音频播放
```dart
Future<void> _playAudio() async {
  final audioPath = word['audio'];
  // 获取本地或远程路径
  final localPath = await MediaLoader.getAudioPath(audioPath);

  // TODO: 使用 audioplayers 包播放
  // final player = AudioPlayer();
  // await player.play(DeviceFileSource(localPath));
}
```

### 相似度指示器

#### 相似度计算和显示
```dart
Widget _buildSimilarityBar(int similarity) {
  Color barColor;
  if (similarity >= 80) {
    barColor = AppConstants.successColor;     // 绿色
  } else if (similarity >= 60) {
    barColor = AppConstants.primaryColor;     // 黄色
  } else {
    barColor = Colors.orange;                 // 橙色
  }

  return Column([
    Row([
      Text('与中文相似度'),
      Text('$similarity%', style: TextStyle(color: barColor)),
    ]),
    LinearProgressIndicator(value: similarity / 100),
    Text(_getSimilarityHint(similarity)),
  ]);
}

String _getSimilarityHint(int similarity) {
  if (similarity >= 90) return '汉字词，发音相似';
  if (similarity >= 70) return '词源相同，便于记忆';
  if (similarity >= 50) return '有一定联系';
  return '固有词，需要记忆';
}
```

### UI结构

#### 前面（韩语）
```
    词汇学习

    1 / 8          [👆 点击翻转]

    ▓▓▓▓▓░░░░░  63%

    ┌─────────────────┐
    │                 │
    │   [图片区域]    │  ← 单词配图
    │                 │
    ├─────────────────┤
    │  안녕하세요     │  ← 韩语（大字）
    │                 │
    │ an-nyeong-ha-se-yo │ ← 发音
    │                 │
    │   [🔊 发音]     │  ← 音频按钮
    └─────────────────┘

    [上一个]  [下一个]
```

#### 背面（中文）
```
    词汇学习

    1 / 8

    ▓▓▓▓▓░░░░░  63%

    ┌─────────────────┐
    │                 │
    │     您好        │  ← 中文（特大字）
    │                 │
    │   nín hǎo      │  ← 拼音
    │                 │
    ├─────────────────┤
    │   汉字词        │
    │    安寧         │  ← 汉字（如有）
    ├─────────────────┤
    │ 与中文相似度    │
    │ ████████░░ 85% │  ← 相似度条
    │ 汉字词，发音相似│
    └─────────────────┘
           [👆 点击返回]

    [上一个]  [下一个]
```

### 相似度等级

| 相似度 | 颜色 | 说明 |
|--------|------|------|
| 90-100% | 绿色 | 汉字词，发音相似 |
| 70-89% | 黄色 | 词源相同，便于记忆 |
| 50-69% | 橙色 | 有一定联系 |
| 0-49% | 橙色 | 固有词，需要记忆 |

### 翻转动画时序

```
用户点击卡片
    ↓
_flipController.forward()
    ↓
angle: 0 → π (600ms)
    ↓
angle > π/2 ? 显示背面 : 显示前面
    ↓
AnimationStatus.completed
    ↓
_isFront = !_isFront
    ↓
_flipController.reset()
```

### MediaLoader工作流程

```
getImagePath('vocabulary/hello.jpg')
    ↓
查询 DatabaseHelper.getLocalPath()
    ↓
本地存在？
    ├─ Yes → 验证文件存在 → 返回本地路径
    └─ No  → 返回远程URL
```

### 性能优化

#### 1. 图片缓存
```dart
// Flutter自动缓存NetworkImage
Image.network(url)  // 使用内存缓存
```

#### 2. 预加载下一张图片
```dart
// TODO: 在当前卡片显示时预加载下一张
if (_currentCardIndex < _mockWords.length - 1) {
  final nextImage = _mockWords[_currentCardIndex + 1]['image'];
  precacheImage(FileImage(File(nextImage)), context);
}
```

#### 3. 动画性能
```dart
// 使用SingleTickerProviderStateMixin
// 单一AnimationController，减少开销
with SingleTickerProviderStateMixin
```

---

## Stage 3: 语法 (stage3_grammar.dart)

### 功能
- 语法点讲解
- 详细说明和规则
- 例句展示
- 关键词高亮

### 数据结构
```dart
{
  'title': '助词 은/는',
  'titleZh': '主题助词',
  'explanation': '是用于标记句子主题的助词...',
  'examples': [
    {
      'korean': '저는 학생입니다',
      'chinese': '我是学生',
      'highlight': '는'  // 高亮部分
    }
  ]
}
```

### 高亮实现
```dart
List<TextSpan> _buildHighlightedText(String text, String highlight) {
  // 分割文本并高亮指定部分
  return [
    TextSpan(text: '저'),
    TextSpan(
      text: '는',
      style: TextStyle(
        color: primaryColor,
        backgroundColor: Colors.yellow,
      ),
    ),
    TextSpan(text: ' 학생입니다'),
  ];
}
```

### UI结构
```
    语法讲解

    1 / 3

    ┌─────────────────┐
    │ 助词 은/는       │  ← 韩语标题
    │ 主题助词         │  ← 中文标题
    │ ─────────────── │
    │ [解释内容区域]   │  ← 说明文字
    │                 │
    │ 例句             │
    │ 저는 학생입니다  │  ← 例句（는高亮）
    │ 我是学生         │
    │                 │
    │ 책은 재미있어요  │  ← 例句（은高亮）
    │ 书很有趣         │
    └─────────────────┘
```

---

## Grammar Stage: 交互式文法 (grammar_stage.dart)

### 功能
- PageView滑动浏览多个文法点
- 规则讲解 + 中文对比 + 例句 + 练习
- RichText高亮关键词
- 渐进式slideX/slideY动画
- 交互式填空练习
- 即时正误反馈

### 数据结构
```dart
{
  'title_ko': '은/는',
  'title_zh': '主题助词',
  'rule': '是/는 用于标记句子的主题...',
  'chinese_comparison': {
    'title': '与中文对比',
    'korean': '저는 학생입니다',
    'chinese': '我是学生',
    'explanation': '中文"是"表达身份，韩语用"是"+ 은/는 标记主题',
  },
  'examples': [
    {'korean': '저는...', 'highlight': '는', 'explanation': '...'},
  ],
  'exercise': {
    'question': '이것___ 사과예요',
    'options': ['은', '는', '이', '가'],
    'correct': '은',
  },
}
```

### PageView导航
```dart
PageView.builder(
  controller: _pageController,
  onPageChanged: (index) => setState(() => _currentPointIndex = index),
  itemBuilder: (context, index) => _buildGrammarPoint(points[index]),
)
```

### 渐进式动画序列
```dart
// 每个组件按序出现
_buildTitleSection()
  .animate().fadeIn(delay: 100.ms).slideX(begin: -0.2, end: 0)

_buildRuleSection()
  .animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0)

_buildChineseComparisonSection()
  .animate().fadeIn(delay: 300.ms).slideX(begin: -0.2, end: 0)

_buildExamplesSection()
  .animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0)

_buildExerciseSection()
  .animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0)
```

### RichText高亮
```dart
// 例句高亮
RichText(
  children: [
    TextSpan(text: '저'),
    TextSpan(
      text: '는',  // ← 高亮！
      style: TextStyle(
        color: primaryColor,
        backgroundColor: Colors.yellow,  // 黄色背景
      ),
    ),
    TextSpan(text: ' 학생입니다'),
  ],
)

// 填空题虚线
RichText(
  children: [
    TextSpan(text: '이것'),
    TextSpan(
      text: ' ___ ',  // ← 空格
      style: TextStyle(
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.dashed,  // 虚线
      ),
    ),
    TextSpan(text: ' 사과예요'),
  ],
)
```

### 交互式练习
```dart
// 用户选择答案
void _checkAnswer(int pointIndex, String answer) {
  setState(() {
    _userAnswers[pointIndex] = answer;
    _showExerciseFeedback[pointIndex] = true;
  });
}

// 选项颜色
if (showFeedback) {
  if (isCorrectOption) {
    color = successColor;  // 绿色✓
  } else if (isSelected) {
    color = errorColor;    // 红色✗
  }
}
```

### UI结构（单个文法点）
```
    ┌─────────────────┐
    │   은/는          │  ← 标题（黄色渐变）
    │  主题助词        │
    └─────────────────┘
         ↓ slideX

    ┌─────────────────┐
    │ 💡 规则          │  ← 规则（蓝色）
    │ 은/는用于...     │
    │ - 辅音 + 은      │
    │ - 元音 + 는      │
    └─────────────────┘
         ↓ slideX

    ┌─────────────────┐
    │ ⇄ 与中文对比     │  ← 对比（紫色）
    │ 🇰🇷 저는 학생... │
    │ 🇨🇳 我是学生     │
    │ 💡 中文用"是"... │
    └─────────────────┘
         ↓ slideX

    ┌─────────────────┐
    │ 例句             │  ← 例句（白色）
    │ [例1] 저[는]...  │  ← 는高亮
    │ [例2] 책[은]...  │  ← 은高亮
    │ [例3] 선생님[은]..│
    └─────────────────┘
         ↓ slideY

    ┌─────────────────┐
    │ ✏️ 练习          │  ← 练习（绿色）
    │ 이것 ___ 사과예요│  ← 空格虚线
    │ [은✓] [는] [이] [가]│
    │ 🎉 太棒了！      │  ← 反馈
    └─────────────────┘
         ↓ slideY
```

### 文法点列表
1. **은/는** - 主题助词
2. **이/가** - 主格助词
3. **을/를** - 宾格助词
4. **이에요/예요** - 判断句

---

## Stage 4: 练习 (stage4_practice.dart)

### 功能
- 互动练习题
- 多选题形式
- 即时答案反馈
- 正确率统计

### 题目类型
```dart
{
  'type': 'multiple_choice',
  'question': '请选择正确的翻译：안녕하세요',
  'options': ['你好', '谢谢', '再见', '对不起'],
  'correctAnswer': '你好'
}
```

### 答案反馈
```dart
// 正确答案：绿色边框 + 勾选图标
backgroundColor: successColor.withOpacity(0.1);
borderColor: successColor;

// 错误答案：红色边框 + 叉号图标
backgroundColor: errorColor.withOpacity(0.1);
borderColor: errorColor;
```

### UI结构
```
    练习

    1 / 5          ✓ 3    ← 进度 + 正确数

    ┌───────────────────┐
    │ 请选择正确的翻译： │  ← 问题卡片
    │   안녕하세요      │
    └───────────────────┘

    ◉ A  你好  ✓         ← 选项（正确 = 绿色）
    ○ B  谢谢            ← 选项（未选）
    ● C  再见  ✗         ← 选项（错误 = 红色）
    ○ D  对不起          ← 选项（未选）

    ┌───────────────────┐
    │ 🎉 太棒了！答对了！│  ← 反馈消息
    └───────────────────┘

    [上一题]  [下一题]
```

---

## Stage 5: 对话 (stage5_dialogue.dart)

### 功能
- 对话式学习
- 模拟音频播放
- 逐句播放或全部播放
- 对话气泡样式

### 数据结构
```dart
{
  'title': '初次见面',
  'titleZh': '第一次见面',
  'lines': [
    {
      'speaker': 'A',
      'speakerName': '小明',
      'korean': '안녕하세요',
      'chinese': '你好',
      'pinyin': 'nǐ hǎo'
    }
  ]
}
```

### 对话气泡
```dart
// Speaker A（左侧）
Container(
  decoration: BoxDecoration(
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(4),   // 小圆角指向说话者
      bottomRight: Radius.circular(20),
    ),
  ),
)

// Speaker B（右侧）
Container(
  decoration: BoxDecoration(
    color: primaryColor.withOpacity(0.2),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(4),   // 小圆角指向说话者
    ),
  ),
)
```

### 音频播放模拟
```dart
void _playLine(int index) {
  setState(() {
    _playingLineIndex = index;
  });

  // 模拟2秒音频
  Future.delayed(const Duration(seconds: 2), () {
    setState(() {
      _playingLineIndex = null;
    });
  });
}
```

### UI结构
```
    对话练习

    1 / 2

    ┌───────────────┐
    │ 초次 见면     │  ← 对话标题
    │ 第一次见面    │
    └───────────────┘

    [▶ 播放全部]      ← 播放控制

    [A] ┌────────────┐  ← 左侧气泡（A说话者）
        │ 小明       │
        │ 안녕하세요 │🔊
        │ 你好       │
        │ nǐ hǎo    │
        └────────────┘

            ┌────────────┐ [B]  ← 右侧气泡（B说话者）
            │ 小红       │
            │ 안녕하세요 │🔊
            │ 你好       │
            │ nǐ hǎo    │
            └────────────┘
```

---

## Stage 6: 测验 (stage6_quiz.dart)

### 功能
- 综合测验
- 题目类型分类（词汇/语法/对话）
- 提交前可修改答案
- 成绩评估（80分及格）

### 题目数据
```dart
{
  'question': '"안녕하세요"的意思是？',
  'options': ['你好', '谢谢', '再见', '对不起'],
  'correctAnswer': '你好',
  'type': 'vocabulary'  // 或 'grammar', 'dialogue'
}
```

### 成绩计算
```dart
int _calculateScore() {
  int correct = 0;
  for (int i = 0; i < questions.length; i++) {
    if (_userAnswers[i] == questions[i]['correctAnswer']) {
      correct++;
    }
  }
  return correct;
}

double _calculatePercentage() {
  return (_calculateScore() / questions.length) * 100;
}
```

### 题目类型标签
```dart
Color _getQuestionTypeColor(String type) {
  switch (type) {
    case 'vocabulary': return Colors.blue;
    case 'grammar': return Colors.purple;
    case 'dialogue': return Colors.green;
  }
}
```

### UI结构（测验中）
```
    测验

    1 / 8          已答 5/8  ← 进度
    ▓▓▓▓░░░░░░░░         ← 进度条

    [词汇]                 ← 题型标签

    ┌───────────────────┐
    │ "안녕하세요"的    │  ← 问题
    │   意思是？        │
    └───────────────────┘

    ○  你好               ← 选项
    ○  谢谢
    ○  再见
    ○  对不起

    [上一题]  [下一题]
```

### UI结构（结果页）
```
         ┌───┐
         │ 🎉│         ← 结果图标
         └───┘

      太棒了！          ← 结果标题

    得分：7 / 8        ← 分数

       88%             ← 百分比（大字）

    ┌───────────────┐
    │ 你已经很好地  │  ← 评语
    │ 掌握了本课内容│
    └───────────────┘

    [继续]
```

---

## Quiz Stage: 多题型测验 (quiz_stage.dart)

### 功能
- 5种题型：听力、填空、翻译、排序、发音
- 即时反馈 + 动画
- 实时计分
- 可选计时器 (5分钟)
- 最终结果屏幕 (80%及格)

### 题型列表
1. **ListeningQuestion** - 听力题 (🎧 蓝色)
2. **FillInBlankQuestion** - 填空题 (✏️ 绿色)
3. **TranslationQuestion** - 翻译题 (🌐 紫色)
4. **WordOrderQuestion** - 排序题 (🔀 橙色)
5. **PronunciationQuestion** - 发音题 (🗣️ 红色)

### 数据结构
```dart
// 听力题
{
  'type': 'listening',
  'audio': 'quiz/question1.mp3',
  'korean': '안녕하세요',
  'options': ['你好', '谢谢', '再见', '对不起'],
  'correct': '你好',
}

// 填空题
{
  'type': 'fill_in_blank',
  'sentence': '저___ 학생입니다',
  'translation': '我是学生',
  'options': ['은', '는', '이', '가'],
  'correct': '는',
  'explanation': '"저"以元音结尾，使用"는"',
}

// 排序题
{
  'type': 'word_order',
  'translation': '我是学生',
  'words': ['학생', '입니다', '저는'],  // 打乱顺序
  'correct': ['저는', '학생', '입니다'],  // 正确顺序
}
```

### 计时器实现
```dart
QuizStage(
  lesson: lesson,
  enableTimer: true,  // ← 启用计时器
  onNext: _nextStage,
)

// 倒计时
Timer.periodic(Duration(seconds: 1), (timer) {
  if (_remainingSeconds > 0) {
    setState(() => _remainingSeconds--);
  } else {
    _completeQuiz();  // 时间到
  }
});
```

### 动画反馈
```dart
// 答案反馈 (fadeIn + slideY)
_buildFeedback()
  .animate()
  .fadeIn(duration: 300.ms)
  .slideY(begin: -0.2, end: 0, duration: 300.ms);

// 结果屏幕 (scale + shake)
Icon(Icons.celebration)
  .animate()
  .scale(delay: 200.ms, curve: Curves.elasticOut)
  .then()
  .shake(duration: 500.ms);
```

### 答案检查
```dart
void _submitAnswer(dynamic answer) {
  final isCorrect = _checkAnswer(question, answer);

  setState(() {
    _userAnswers[_currentQuestionIndex] = answer;
    _isCorrect[_currentQuestionIndex] = isCorrect;
    if (isCorrect) _score++;
  });
}

bool _checkAnswer(question, answer) {
  switch (question['type']) {
    case 'word_order':
      return question['correct'].toString() == answer.toString();
    default:
      return question['correct'] == answer;
  }
}
```

### 排序题交互
```dart
// 用户拖拽单词排序
List<String> _orderedWords = [];       // 已排序
List<String> _availableWords = [];     // 待排序

void _addWord(String word) {
  setState(() {
    _orderedWords.add(word);
    _availableWords.remove(word);
  });
  // 全部排完自动提交
  if (_availableWords.isEmpty) {
    widget.onAnswer(_orderedWords);
  }
}
```

### UI结构
```
    1 / 5      ⭐ 3      ⏱️ 04:32  ← 进度|分数|计时器
    ████████░░░░░░░░░░  80%      ← 进度条

    [🎧 听力]                     ← 题型标签

    听音频，选择正确的翻译

    ┌─────────────────┐
    │      📊         │          ← 音频播放器
    │  [▶ 播放音频]   │
    └─────────────────┘

    [你好] ✓                     ← 选项 (绿色=正确)
    [谢谢]
    [再见]
    [对不起]

    🎉 太棒了！                  ← 反馈 (动画)
```

### 结果屏幕
```
    ┌───────┐
    │  🎉   │                   ← 图标 (scale+shake动画)
    └───────┘

    太棒了！                    ← 标题

    得分：4 / 5                 ← 分数

    80%                         ← 百分比 (大字)

    ⏱️ 用时: 03:25              ← 耗时

    ┌─────────────────┐
    │ 你已经很好地     │         ← 评语
    │ 掌握了本课内容！ │
    └─────────────────┘

    [继续]
```

### 及格判定
```dart
final percentage = (_score / _questions.length) * 100;
final isPassed = percentage >= 80;  // 80%及格

// 及格 → 绿色 🎉
// 不及格 → 红色 🔁 (重试)
```

---

## Stage 7: 总结 (stage7_summary.dart)

### 功能
- 课程完成庆祝
- 成就展示
- 学习统计
- 下一课预览

### 成就类型
```dart
_buildAchievementCard(
  icon: Icons.check_circle,
  title: '学习完成',
  subtitle: '7个阶段全部通过',
  color: AppConstants.successColor,
);

_buildAchievementCard(
  icon: Icons.military_tech,
  title: '经验值 +${lesson.level * 10}',
  subtitle: '继续保持学习热情',
  color: AppConstants.primaryColor,
);

_buildAchievementCard(
  icon: Icons.local_fire_department,
  title: '学习连续天数 +1',
  subtitle: '已连续学习 7 天',
  color: Colors.orange,
);
```

### 学习统计
```dart
Row([
  _buildStatItem(icon: Icons.translate, label: '单词', value: '10'),
  _buildStatItem(icon: Icons.menu_book, label: '语法点', value: '3'),
  _buildStatItem(icon: Icons.chat_bubble_outline, label: '对话', value: '2'),
])
```

### 动画序列
```dart
// 1. 庆祝图标（200ms）
Icon(Icons.celebration)
  .animate()
  .scale(delay: 200.ms, curve: Curves.elasticOut)
  .then()
  .shake();

// 2. 标题（400ms）
Text('课程完成！')
  .animate()
  .fadeIn(delay: 400.ms);

// 3. 成就卡片（800ms, 1000ms, 1200ms）
_buildAchievementCard(...)
  .animate()
  .fadeIn(delay: 800.ms)
  .slideX(begin: -0.2, end: 0);

// 4. 统计（1400ms）
Container(...)
  .animate()
  .fadeIn(delay: 1400.ms);

// 5. 完成按钮（1800ms）
ElevatedButton(...)
  .animate()
  .fadeIn(delay: 1800.ms)
  .slideY(begin: 0.3, end: 0);
```

### UI结构
```
         ┌───┐
         │ 🎉│         ← 庆祝图标
         └───┘

      课程完成！        ← 标题
      基本问候语        ← 课程名称

    ┌────────────────┐
    │ ✓ 学习完成     │  ← 成就1
    │ 7个阶段全部通过│
    └────────────────┘

    ┌────────────────┐
    │ 🏅 经验值 +10  │  ← 成就2
    │ 继续保持学习热情│
    └────────────────┘

    ┌────────────────┐
    │ 🔥 学习连续天数+1│ ← 成就3
    │ 已连续学习 7 天 │
    └────────────────┘

    ┌────────────────┐
    │ 本课学习内容   │  ← 统计
    │ 📖10  📚3  💬2 │
    └────────────────┘

    ┌────────────────┐
    │ [2] 下一课 →   │  ← 下一课预览
    └────────────────┘

    [完成]
```

---

## 数据流

### 课程启动
```dart
// 1. 从课程列表点击
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => LessonScreen(lesson: selectedLesson),
  ),
);

// 2. 进入沉浸模式
_enterImmersiveMode();

// 3. 显示Stage 1
PageView(
  children: [
    Stage1Intro(lesson: lesson, onNext: _nextStage),
    // ...
  ],
)
```

### 阶段导航
```dart
// 用户点击"继续"按钮
Stage1Intro(
  onNext: _nextStage,  // 回调函数
)

// lesson_screen.dart 收到回调
void _nextStage() {
  _currentStage++;  // 0 → 1
  _pageController.animateToPage(1);  // 切换到Stage 2
}
```

### 退出流程
```dart
// 1. 用户点击关闭按钮或按返回键
WillPopScope(
  onWillPop: () async {
    await _showExitDialog();
    return false;  // 阻止默认返回
  },
)

// 2. 显示确认对话框
showDialog(
  builder: (context) => AlertDialog(
    title: Text('退出学习'),
    content: Text('确定要退出当前课程吗？进度将会保存。'),
  ),
)

// 3. 用户确认退出
_saveProgressAndExit() {
  // TODO: 保存进度到 ProgressProvider
  Navigator.pop(context);
}

// 4. 退出沉浸模式
_exitImmersiveMode();
```

### 完成流程
```dart
// 1. Stage 7 完成
Stage7Summary(
  onComplete: _completeLessonAndExit,
)

// 2. 标记课程完成
_completeLessonAndExit() {
  // TODO: 标记课程完成（ProgressProvider）
  // TODO: 更新连续学习天数
  // TODO: 添加经验值
  Navigator.pop(context);
}
```

---

## 性能优化

### 1. PageView优化
```dart
PageView(
  controller: _pageController,
  physics: NeverScrollableScrollPhysics(),  // 禁用滑动，节省性能
  children: [...],
)
```

### 2. 懒加载
所有Stage都是StatefulWidget，只有显示时才构建Widget树。

### 3. 动画优化
```dart
// 使用 flutter_animate 库而不是自定义AnimationController
// 自动管理动画生命周期
Text('...')
  .animate()
  .fadeIn(delay: 400.ms, duration: 600.ms);
```

### 4. 资源管理
```dart
@override
void dispose() {
  _exitImmersiveMode();      // 恢复系统UI
  _pageController.dispose(); // 释放PageController
  super.dispose();
}
```

---

## 错误处理

### 网络错误
```dart
// 所有Stage使用mock数据，不依赖网络
// 真实数据从 lesson.content 字段获取（已下载）
final words = lesson.content['stage2_vocabulary']['words'] ?? _mockWords;
```

### 状态错误
```dart
// 使用 mounted 检查避免已销毁Widget的setState
Future.delayed(const Duration(seconds: 2), () {
  if (mounted) {
    setState(() {
      _playingLineIndex = null;
    });
  }
});
```

---

## 使用示例

### 从课程列表启动
```dart
// home_screen.dart
LessonGridItem(
  lesson: lesson,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonScreen(lesson: lesson),
      ),
    );
  },
)
```

### 从"继续学习"卡片启动
```dart
// continue_lesson_card.dart
ContinueLessonCard(
  lesson: currentLesson,
  progress: 0.43,  // 43% 完成
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonScreen(lesson: currentLesson),
      ),
    );
  },
)
```

---

## 未来增强

### 1. 真实数据集成
```dart
// 使用 lesson.content 而不是 mock 数据
final vocabularyData = lesson.content['stage2_vocabulary'];
final words = vocabularyData['words'];
```

### 2. 进度保存
```dart
// 使用 ProgressProvider 保存进度
void _saveProgress() {
  final provider = Provider.of<ProgressProvider>(context, listen: false);
  provider.updateProgress(
    lessonId: widget.lesson.id,
    stage: _currentStage,
    timestamp: DateTime.now(),
  );
}
```

### 3. 音频播放
```dart
// 使用 audioplayers 包播放真实音频
import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();
await player.play(UrlSource(audioUrl));
```

### 4. 语音识别
```dart
// 添加语音识别练习（Stage 4或5）
import 'package:speech_to_text/speech_to_text.dart';

final speech = SpeechToText();
speech.listen(
  onResult: (result) {
    // 比对用户发音和正确答案
    _checkPronunciation(result.recognizedWords);
  },
);
```

### 5. 错题回顾
```dart
// Stage 6 测验结束后
if (percentage < 80) {
  // 显示错题列表
  _showWrongAnswers();
}
```

---

## 测试要点

### Widget测试
```dart
testWidgets('lesson screen shows all stages', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LessonScreen(lesson: testLesson),
    ),
  );

  // 验证Stage 1显示
  expect(find.text('开始学习'), findsOneWidget);

  // 点击"继续"
  await tester.tap(find.text('开始学习'));
  await tester.pumpAndSettle();

  // 验证Stage 2显示
  expect(find.text('词汇学习'), findsOneWidget);
});
```

### 集成测试
```dart
testWidgets('complete full lesson flow', (tester) async {
  // 测试从Stage 1到Stage 7的完整流程
  for (int i = 0; i < 7; i++) {
    // 完成当前阶段
    // 验证下一阶段
  }
});
```

---

## 注意事项

1. **沉浸模式**: 必须在dispose时调用 `_exitImmersiveMode()`
2. **导航限制**: 不能跳过阶段，必须顺序完成
3. **进度保存**: 退出时必须保存当前进度
4. **Mock数据**: 当前使用mock数据，需要替换为 `lesson.content`
5. **音频播放**: 当前为模拟播放，需要集成真实音频播放器
