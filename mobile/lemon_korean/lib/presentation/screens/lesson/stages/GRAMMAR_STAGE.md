# GrammarStage - 交互式语法学习

高级语法学习组件，采用PageView滑动浏览，包含规则讲解、中文对比、例句展示和交互练习。

---

## 核心特性

### 1. PageView滑动浏览
- 多个文法点横向滑动
- 400ms平滑过渡动画
- 点状导航指示器
- 支持手势滑动和按钮导航

### 2. 分段式内容展示
每个文法点包含5个部分：
1. **标题区** - 韩语/中文标题
2. **规则区** - 详细规则说明
3. **对比区** - 韩中语法对比
4. **例句区** - 3个实例例句
5. **练习区** - 交互式填空题

### 3. 渐进式动画
```
标题 (100ms) → 规则 (200ms) → 对比 (300ms) → 例句 (400ms) → 练习 (500ms)
```

### 4. RichText高亮
- 例句中的关键助词高亮（黄色背景）
- 填空题的空格虚线下划线
- 选项的动态颜色（选中/正确/错误）

### 5. 即时反馈
- 选择答案后立即显示正误
- 绿色✓正确 / 红色✗错误
- 详细解释说明

---

## 技术实现

### PageView控制器

```dart
class _GrammarStageState extends State<GrammarStage> {
  final PageController _pageController = PageController();
  int _currentPointIndex = 0;
  final Map<int, String?> _userAnswers = {};
  final Map<int, bool> _showExerciseFeedback = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
```

### 页面导航

```dart
void _nextPoint() {
  if (_currentPointIndex < _mockGrammarPoints.length - 1) {
    _pageController.animateToPage(
      _currentPointIndex + 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  } else {
    widget.onNext();  // 进入下一阶段
  }
}

void _onPageChanged(int index) {
  setState(() {
    _currentPointIndex = index;
  });
}
```

### PageView构建

```dart
PageView.builder(
  controller: _pageController,
  onPageChanged: _onPageChanged,
  itemCount: _mockGrammarPoints.length,
  itemBuilder: (context, index) {
    return _buildGrammarPoint(
      _mockGrammarPoints[index],
      index,
    );
  },
)
```

---

## 数据结构

### 文法点对象
```dart
{
  // 标题
  'title_ko': '은/는',
  'title_zh': '主题助词',

  // 规则说明
  'rule': '은/는 用于标记句子的主题。\n- 前一个字以辅音结尾时使用 은\n- 前一个字以元音结尾时使用 는',

  // 中文对比
  'chinese_comparison': {
    'title': '与中文对比',
    'korean': '저는 학생입니다',
    'chinese': '我是学生',
    'explanation': '中文"是"表达身份，韩语用"是"+ 은/는 标记主题',
  },

  // 例句列表
  'examples': [
    {
      'korean': '저는 학생입니다',
      'chinese': '我是学生',
      'highlight': '는',              // 高亮部分
      'explanation': '"저"以元音结尾，使用"는"',
    },
    // ...
  ],

  // 练习题
  'exercise': {
    'question': '이것___ 사과예요',      // 填空题
    'question_zh': '这是苹果',
    'blank_word': '이것',               // 前面的词
    'options': ['은', '는', '이', '가'],  // 选项
    'correct': '은',                    // 正确答案
    'explanation': '"이것"以辅音 ㅅ 结尾，使用"은"',
  },
}
```

---

## UI组件详解

### 1. 标题区 (_buildTitleSection)

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        primaryColor.withOpacity(0.2),
        primaryColor.withOpacity(0.1),
      ],
    ),
  ),
  child: Column([
    Text('은/는', fontSize: 36, color: primaryColor),  // 韩语
    Text('主题助词', fontSize: 20),                    // 中文
  ]),
)
  .animate()
  .fadeIn(delay: 100.ms, duration: 500.ms)
  .slideX(begin: -0.2, end: 0, delay: 100.ms);
```

### 2. 规则区 (_buildRuleSection)

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.blue.shade50,
    border: Border.all(color: Colors.blue.shade200, width: 2),
  ),
  child: Column([
    Row([
      Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
      Text('规则', color: Colors.blue.shade700),
    ]),
    Text(point['rule'], height: 1.6),  // 多行规则说明
  ]),
)
  .animate()
  .fadeIn(delay: 200.ms)
  .slideX(begin: -0.2, end: 0);
```

### 3. 中文对比区 (_buildChineseComparisonSection)

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.purple.shade50,
    border: Border.all(color: Colors.purple.shade200),
  ),
  child: Column([
    Row([
      Icon(Icons.compare_arrows),
      Text('与中文对比'),
    ]),

    // 韩语示例
    Container(
      color: Colors.white,
      child: Column([
        Text('🇰🇷 韩语'),
        Text('저는 학생입니다', fontSize: 20, bold),
      ]),
    ),

    // 中文对照
    Container(
      color: Colors.white,
      child: Column([
        Text('🇨🇳 中文'),
        Text('我是学生', fontSize: 20, bold),
      ]),
    ),

    // 对比说明
    Text('💡 中文"是"表达身份，韩语用"是"+ 은/는 标记主题'),
  ]),
)
  .animate()
  .fadeIn(delay: 300.ms)
  .slideX(begin: -0.2, end: 0);
```

### 4. 例句区 (_buildExamplesSection)

```dart
Column([
  Text('例句', fontSize: large, bold),

  // 例句卡片1
  _buildExampleCard({
    'korean': '저는 학생입니다',
    'chinese': '我是学生',
    'highlight': '는',
    'explanation': '"저"以元音结尾，使用"는"',
  }, 0),

  // 例句卡片2
  _buildExampleCard(..., 1),
  // ...
])
  .animate()
  .fadeIn(delay: 400.ms)
  .slideY(begin: 0.2, end: 0);
```

#### 单个例句卡片
```dart
Widget _buildExampleCard(Map<String, dynamic> example, int index) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [Shadow(...)],
    ),
    child: Column([
      // 例句编号
      Container([
        Text('例 ${index + 1}', color: primaryColor),
      ]),

      // 韩语（高亮）
      RichText(
        text: TextSpan(
          children: _buildHighlightedText('저는 학생입니다', '는'),
        ),
      ),

      // 中文翻译
      Text('我是学生', color: secondary),

      // 解释
      Container([
        Text('📌 "저"以元音结尾，使用"는"', italic),
      ]),
    ]),
  );
}
```

### 5. 练习区 (_buildExerciseSection)

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient([
      Colors.green.shade50,
      Colors.green.shade100,
    ]),
    border: Border.all(color: Colors.green.shade300),
  ),
  child: Column([
    Row([
      Icon(Icons.edit_note, color: Colors.green.shade700),
      Text('练习'),
    ]),

    // 填空题
    Text('填空：'),
    RichText(
      text: TextSpan(
        children: _buildQuestionText('이것___ 사과예요'),
      ),
    ),
    Text('这是苹果', color: secondary),

    // 选项
    Wrap([
      _buildOption('은'),
      _buildOption('는'),
      _buildOption('이'),
      _buildOption('가'),
    ]),

    // 反馈（选择后显示）
    if (showFeedback)
      Container([
        Icon(isCorrect ? Icons.celebration : Icons.info_outline),
        Text(isCorrect ? '太棒了！' : '正确答案是: 은'),
        Text('"이것"以辅音 ㅅ 结尾，使用"은"'),
      ]),
  ]),
)
  .animate()
  .fadeIn(delay: 500.ms)
  .slideY(begin: 0.2, end: 0);
```

---

## RichText高亮实现

### 例句高亮

#### 功能
将韩语句子中的关键助词用黄色背景高亮显示。

#### 实现
```dart
List<TextSpan> _buildHighlightedText(String text, String highlight) {
  // 分割文本
  final parts = text.split(highlight);
  final spans = <TextSpan>[];

  for (int i = 0; i < parts.length; i++) {
    // 普通文本
    if (parts[i].isNotEmpty) {
      spans.add(TextSpan(text: parts[i]));
    }

    // 高亮部分
    if (i < parts.length - 1) {
      spans.add(
        TextSpan(
          text: highlight,
          style: const TextStyle(
            color: AppConstants.primaryColor,      // 黄色文字
            fontWeight: FontWeight.bold,            // 加粗
            backgroundColor: Color(0xFFFFEB3B),     // 黄色背景
          ),
        ),
      );
    }
  }

  return spans;
}
```

#### 使用示例
```dart
// 输入
text: '저는 학생입니다'
highlight: '는'

// 输出
RichText(
  children: [
    TextSpan(text: '저'),
    TextSpan(
      text: '는',
      style: TextStyle(
        color: primaryColor,
        backgroundColor: yellow,  // ← 高亮！
      ),
    ),
    TextSpan(text: ' 학생입니다'),
  ],
)

// 显示效果
저[는] 학생입니다
  ^^^ 黄色背景高亮
```

### 填空题空格

#### 功能
将填空题的"___"用虚线下划线标记。

#### 实现
```dart
List<TextSpan> _buildQuestionText(String question) {
  // 分割 "이것___ 사과예요"
  final parts = question.split('___');
  final spans = <TextSpan>[];

  for (int i = 0; i < parts.length; i++) {
    // 普通文本
    if (parts[i].isNotEmpty) {
      spans.add(TextSpan(text: parts[i]));
    }

    // 空格部分
    if (i < parts.length - 1) {
      spans.add(
        TextSpan(
          text: ' ___ ',
          style: TextStyle(
            color: Colors.green.shade700,           // 绿色
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,   // 下划线
            decorationStyle: TextDecorationStyle.dashed,  // 虚线
          ),
        ),
      );
    }
  }

  return spans;
}
```

#### 显示效果
```
이것 ___ 사과예요
    ^^^^^ 绿色虚线下划线
```

---

## 动画系统

### flutter_animate集成

#### 渐进式出场
```dart
Widget _buildGrammarPoint(point, index) {
  return SingleChildScrollView(
    child: Column([
      // 1. 标题 (100ms延迟)
      _buildTitleSection(point)
        .animate()
        .fadeIn(delay: 100.ms, duration: 500.ms)
        .slideX(begin: -0.2, end: 0, delay: 100.ms),

      // 2. 规则 (200ms延迟)
      _buildRuleSection(point)
        .animate()
        .fadeIn(delay: 200.ms)
        .slideX(begin: -0.2, end: 0, delay: 200.ms),

      // 3. 对比 (300ms延迟)
      _buildChineseComparisonSection(point)
        .animate()
        .fadeIn(delay: 300.ms)
        .slideX(begin: -0.2, end: 0, delay: 300.ms),

      // 4. 例句 (400ms延迟)
      _buildExamplesSection(point)
        .animate()
        .fadeIn(delay: 400.ms)
        .slideY(begin: 0.2, end: 0, delay: 400.ms),

      // 5. 练习 (500ms延迟)
      _buildExerciseSection(point, index)
        .animate()
        .fadeIn(delay: 500.ms)
        .slideY(begin: 0.2, end: 0, delay: 500.ms),
    ]),
  );
}
```

#### 动画效果

| 组件 | 延迟 | 动画 | 效果 |
|------|------|------|------|
| 标题 | 100ms | fadeIn + slideX(-0.2) | 从左滑入 + 渐显 |
| 规则 | 200ms | fadeIn + slideX(-0.2) | 从左滑入 + 渐显 |
| 对比 | 300ms | fadeIn + slideX(-0.2) | 从左滑入 + 渐显 |
| 例句 | 400ms | fadeIn + slideY(0.2) | 从下滑入 + 渐显 |
| 练习 | 500ms | fadeIn + slideY(0.2) | 从下滑入 + 渐显 |

### PageView滑动动画

```dart
_pageController.animateToPage(
  nextIndex,
  duration: const Duration(milliseconds: 400),
  curve: Curves.easeInOut,
);
```

**注意**: PageView自带滑动动画，无需AnimationController。

---

## 交互式练习

### 练习流程

```
1. 显示填空题
    ↓
2. 显示选项（Wrap布局）
    ↓
3. 用户点击选项
    ↓
4. _checkAnswer() → 保存答案
    ↓
5. 显示反馈（正确/错误）
    ↓
6. 选项变色（绿色✓ / 红色✗）
    ↓
7. 显示解释说明
```

### 答案检查

```dart
void _checkAnswer(int pointIndex, String answer) {
  setState(() {
    _userAnswers[pointIndex] = answer;          // 保存用户答案
    _showExerciseFeedback[pointIndex] = true;   // 显示反馈
  });
}
```

### 选项状态

```dart
final userAnswer = _userAnswers[pointIndex];
final showFeedback = _showExerciseFeedback[pointIndex] ?? false;
final isCorrect = userAnswer == exercise['correct'];

// 为每个选项计算颜色
for (option in options) {
  final isSelected = userAnswer == option;
  final isCorrectOption = option == exercise['correct'];

  if (showFeedback) {
    if (isCorrectOption) {
      backgroundColor = successColor.withOpacity(0.2);  // 浅绿色
      borderColor = successColor;                       // 绿边框
      textColor = successColor;                         // 绿文字
    } else if (isSelected && !isCorrectOption) {
      backgroundColor = errorColor.withOpacity(0.2);    // 浅红色
      borderColor = errorColor;                         // 红边框
      textColor = errorColor;                           // 红文字
    }
  } else if (isSelected) {
    backgroundColor = primaryColor.withOpacity(0.2);
    borderColor = primaryColor;
    textColor = primaryColor;
  }
}
```

### 反馈显示

```dart
if (showFeedback) {
  Container(
    decoration: BoxDecoration(
      color: isCorrect
          ? successColor.withOpacity(0.1)
          : errorColor.withOpacity(0.1),
    ),
    child: Column([
      // 反馈标题
      Row([
        Icon(isCorrect ? Icons.celebration : Icons.info_outline),
        Text(isCorrect ? '太棒了！' : '正确答案是: 은'),
      ]),

      // 解释
      Text(exercise['explanation']),
    ]),
  );
}
```

---

## UI结构

### 完整布局
```
    语法讲解

    1 / 4          ●○○○          ← 进度 + 导航点

    ┌─────────────────────────┐
    │        은/는             │  ← 标题区（渐变背景）
    │      主题助词            │
    └─────────────────────────┘
           ↑ slideX动画

    ┌─────────────────────────┐
    │ 💡 规则                 │  ← 规则区（蓝色）
    │ 은/는 用于标记句子的主题 │
    │ - 辅音结尾使用 은        │
    │ - 元音结尾使用 는        │
    └─────────────────────────┘
           ↑ slideX动画

    ┌─────────────────────────┐
    │ ⇄ 与中文对比             │  ← 对比区（紫色）
    │ ┌─────────────────────┐ │
    │ │ 🇰🇷 韩语             │ │
    │ │ 저는 학생입니다       │ │
    │ └─────────────────────┘ │
    │ ┌─────────────────────┐ │
    │ │ 🇨🇳 中文             │ │
    │ │ 我是学生             │ │
    │ └─────────────────────┘ │
    │ 💡 中文用"是"...        │
    └─────────────────────────┘
           ↑ slideX动画

    ┌─────────────────────────┐
    │ 例句                     │  ← 例句区（白色）
    │ ┌─────────────────────┐ │
    │ │ [例 1]               │ │
    │ │ 저[는] 학생입니다    │ │  ← 는高亮
    │ │ 我是学生             │ │
    │ │ 📌 "저"以元音结尾... │ │
    │ └─────────────────────┘ │
    │ ┌─────────────────────┐ │
    │ │ [例 2]               │ │
    │ │ 책[은] 재미있어요    │ │  ← 은高亮
    │ │ 书很有趣             │ │
    │ │ 📌 "책"以辅音结尾... │ │
    │ └─────────────────────┘ │
    └─────────────────────────┘
           ↑ slideY动画

    ┌─────────────────────────┐
    │ ✏️ 练习                 │  ← 练习区（绿色）
    │ 填空：                   │
    │ 이것 ___ 사과예요        │  ← 空格虚线
    │ 这是苹果                 │
    │                          │
    │ [은] [는] [이] [가]      │  ← 选项
    │  ✓               （选中）│
    │                          │
    │ ┌─────────────────────┐ │
    │ │ 🎉 太棒了！          │ │  ← 反馈（正确=绿色）
    │ │ "이것"以辅音结尾...  │ │
    │ └─────────────────────┘ │
    └─────────────────────────┘
           ↑ slideY动画

    [上一个]      [下一个]
```

---

## 颜色方案

### 区块配色
```dart
// 标题区 - 黄色渐变
gradient: [
  primaryColor.withOpacity(0.2),  // #FFD54F20
  primaryColor.withOpacity(0.1),  // #FFD54F10
]

// 规则区 - 蓝色
background: Colors.blue.shade50,    // #E3F2FD
border: Colors.blue.shade200,       // #90CAF9
icon/text: Colors.blue.shade700,   // #1976D2

// 对比区 - 紫色
background: Colors.purple.shade50,  // #F3E5F5
border: Colors.purple.shade200,     // #CE93D8
icon/text: Colors.purple.shade700, // #7B1FA2

// 练习区 - 绿色
gradient: [
  Colors.green.shade50,             // #E8F5E9
  Colors.green.shade100,            // #C8E6C9
]
border: Colors.green.shade300,      // #81C784
icon/text: Colors.green.shade700,  // #388E3C
```

### 答案反馈配色
```dart
// 正确答案
background: successColor.withOpacity(0.2),  // #4CAF5020
border: successColor,                       // #4CAF50
text: successColor,                         // #4CAF50
icon: Icons.check_circle

// 错误答案
background: errorColor.withOpacity(0.2),    // #F4433620
border: errorColor,                         // #F44336
text: errorColor,                           // #F44336
icon: Icons.cancel

// 未选中
background: Colors.white,
border: Colors.grey.shade300,
text: Colors.black87
```

---

## 交互式练习详解

### 选项布局

#### Wrap组件
```dart
Wrap(
  spacing: 8,       // 横向间距
  runSpacing: 8,    // 换行间距
  children: [
    _buildOptionChip('은'),
    _buildOptionChip('는'),
    _buildOptionChip('이'),
    _buildOptionChip('가'),
  ],
)
```

**优点**:
- 自动换行
- 响应式布局
- 适应不同选项长度

#### 选项芯片
```dart
GestureDetector(
  onTap: showFeedback ? null : () => _checkAnswer(pointIndex, option),
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radiusMedium),
      border: Border.all(color: borderColor, width: 2),
    ),
    child: Row([
      Text(option, fontSize: 20, bold, color: textColor),
      if (showFeedback && isCorrectOption)
        Icon(Icons.check_circle, color: successColor),
      if (showFeedback && isSelected && !isCorrectOption)
        Icon(Icons.cancel, color: errorColor),
    ]),
  ),
)
```

### 状态管理

```dart
// 每个文法点独立状态
final Map<int, String?> _userAnswers = {
  0: '는',   // 第1题答案
  1: null,   // 第2题未答
  2: '를',   // 第3题答案
  3: null,   // 第4题未答
};

final Map<int, bool> _showExerciseFeedback = {
  0: true,   // 第1题显示反馈
  1: false,  // 第2题不显示
  2: true,   // 第3题显示反馈
  3: false,  // 第4题不显示
};
```

**优点**: 切换页面时保留答题状态。

---

## 中文对比详解

### 对比结构

#### 韩中并列显示
```dart
Column([
  // 韩语示例
  Container(
    color: Colors.white,
    child: Column([
      Text('🇰🇷 韩语', fontSize: small, color: secondary),
      Text('저는 학생입니다', fontSize: 20, bold),
    ]),
  ),

  SizedBox(height: 12),

  // 中文对照
  Container(
    color: Colors.white,
    child: Column([
      Text('🇨🇳 中文', fontSize: small, color: secondary),
      Text('我是学生', fontSize: 20, bold),
    ]),
  ),

  SizedBox(height: 12),

  // 对比说明
  Text(
    '💡 中文"是"表达身份，韩语用"是"+ 은/는 标记主题',
    fontStyle: italic,
    color: purple,
  ),
])
```

### 对比主题示例

#### 1. 은/는 vs 中文"是"
```
🇰🇷 저는 학생입니다
🇨🇳 我是学生

💡 中文"是"表达身份，韩语用"是"+ 은/는 标记主题
```

#### 2. 이/가 vs 疑问句
```
🇰🇷 누가 왔어요? - 민수가 왔어요
🇨🇳 谁来了？ - 民秀来了

💡 回答疑问词时用 이/가，强调新信息
```

#### 3. 을/를 vs 语序
```
🇰🇷 저는 한국어를 공부해요
🇨🇳 我学习韩语

💡 中文靠语序表达宾语，韩语用 을/를 标记
```

#### 4. 이에요/예요 vs "是"
```
🇰🇷 저는 학생이에요
🇨🇳 我是学生

💡 中文用"是"连接，韩语用 이에요/예요
```

---

## 文法点内容

### 1. 은/는 (主题助词)

**规则**:
- 辅音结尾 + 은: 책은, 학생은, 이것은
- 元音结尾 + 는: 저는, 사과는, 누나는

**例句**:
```
저는 학생입니다         我是学生
책은 재미있어요         书很有趣
선생님은 친절해요       老师很亲切
```

**练习**:
```
이것___ 사과예요 (这是苹果)
答案: 은（이것 辅音ㅅ结尾）
```

### 2. 이/가 (主格助词)

**规则**:
- 辅音结尾 + 이: 꽃이, 책이, 학생이
- 元音结尾 + 가: 비가, 누가, 사과가

**例句**:
```
비가 와요              下雨了
꽃이 예뻐요            花很漂亮
누가 왔어요?           谁来了？
```

**练习**:
```
사과___ 맛있어요 (苹果很好吃)
答案: 가（사과 元音结尾）
```

### 3. 을/를 (宾格助词)

**规则**:
- 辅音结尾 + 을: 밥을, 책을, 물을
- 元音结尾 + 를: 커피를, 사과를, 우유를

**例句**:
```
커피를 마셔요          喝咖啡
밥을 먹어요            吃饭
책을 읽어요            看书
```

**练习**:
```
친구___ 만났어요 (见了朋友)
答案: 를（친구 元音结尾）
```

### 4. 이에요/예요 (判断句)

**规则**:
- 辅音结尾 + 이에요: 학생이에요, 물이에요
- 元音结尾 + 예요: 사과예요, 커피예요

**例句**:
```
이것은 사과예요        这是苹果
저는 학생이에요        我是学生
오늘은 월요일이에요    今天是星期一
```

**练习**:
```
이것은 물___ (这是水)
答案: 이에요（물 辅音结尾）
```

---

## 性能优化

### 1. PageView优化
```dart
// 使用PageController
// Flutter自动管理页面缓存
PageView.builder(
  controller: _pageController,
  itemCount: points.length,
  // 默认缓存前后各1页
)
```

### 2. 动画优化
```dart
// 使用flutter_animate而不是AnimationController
// 自动管理动画生命周期，无需dispose

_buildTitleSection()
  .animate()
  .fadeIn(delay: 100.ms);  // 自动清理
```

### 3. 状态保留
```dart
// 使用Map保存所有页面的答题状态
// 切换页面时不会丢失已答题目

final Map<int, String?> _userAnswers = {};
final Map<int, bool> _showExerciseFeedback = {};
```

### 4. 懒加载
```dart
// PageView.builder只构建可见页面
// 不会一次性构建所有4个文法点
PageView.builder(
  itemBuilder: (context, index) {
    return _buildGrammarPoint(points[index], index);
  },
)
```

---

## 使用示例

### 在lesson_screen.dart中集成

```dart
import 'stages/grammar_stage.dart';

PageView(
  children: [
    Stage1Intro(...),
    VocabularyStage(...),

    // 使用高级交互版本
    GrammarStage(
      lesson: lesson,
      onNext: _nextStage,
      onPrevious: _previousStage,
    ),

    // 或使用简单版本
    // Stage3Grammar(...),

    Stage4Practice(...),
    // ...
  ],
)
```

### 真实数据替换

```dart
@override
void initState() {
  super.initState();

  // 从lesson.content加载
  final grammarData = widget.lesson.content['stage3_grammar'];
  _mockGrammarPoints = (grammarData['points'] as List)
      .map((p) => p as Map<String, dynamic>)
      .toList();
}
```

---

## 与stage3_grammar.dart的区别

| 特性 | stage3_grammar.dart | grammar_stage.dart |
|------|---------------------|-------------------|
| 导航 | 按钮 | PageView滑动 + 按钮 |
| 动画 | 无 | 渐进式slideX/slideY |
| 中文对比 | 无 | 独立对比区块 |
| 练习 | 无 | 交互式填空题 |
| 反馈 | 无 | 即时正误反馈 |
| 布局 | 单一滚动 | 分页滚动 |
| 复杂度 | 简单 | 高级 |
| 适用场景 | 快速浏览 | 深度学习 |

**建议**: 初级课程用stage3，中高级课程用grammar_stage。

---

## 下一步开发

### 1. 添加更多练习类型

#### 选择题
```dart
'exercise': {
  'type': 'multiple_choice',
  'question': '下列哪个句子使用了正确的助词？',
  'options': [
    '저은 학생입니다',
    '저는 학생입니다',  // 正确
    '저가 학생입니다',
    '저를 학생입니다',
  ],
  'correct': 1,  // 索引
}
```

#### 拖拽排序
```dart
'exercise': {
  'type': 'reorder',
  'question': '按正确顺序排列',
  'items': ['저는', '학생', '입니다'],
  'correct': ['저는', '학생', '입니다'],
}
```

### 2. 添加音频示例

```dart
// 每个例句添加音频按钮
IconButton(
  icon: Icon(Icons.volume_up),
  onPressed: () async {
    final audioPath = await MediaLoader.getAudioPath(
      'grammar/${point['title_ko']}/example_${index}.mp3',
    );
    // Play audio
  },
)
```

### 3. 添加文法笔记

```dart
// 添加"记笔记"功能
IconButton(
  icon: Icon(Icons.note_add),
  onPressed: _showNoteDialog,
)

void _showNoteDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('添加笔记'),
      content: TextField(
        decoration: InputDecoration(hintText: '记录你的理解...'),
      ),
      actions: [
        TextButton(child: Text('保存')),
      ],
    ),
  );
}
```

### 4. 语法表格

```dart
// 助词对比表格
Table(
  border: TableBorder.all(),
  children: [
    TableRow(children: [
      Text('结尾'),
      Text('主题'),
      Text('主格'),
      Text('宾格'),
    ]),
    TableRow(children: [
      Text('辅音'),
      Text('은'),
      Text('이'),
      Text('을'),
    ]),
    TableRow(children: [
      Text('元音'),
      Text('는'),
      Text('가'),
      Text('를'),
    ]),
  ],
)
```

---

## 测试要点

### Widget测试
```dart
testWidgets('swipe to next grammar point', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: GrammarStage(
        lesson: testLesson,
        onNext: () {},
        onPrevious: () {},
      ),
    ),
  );

  // 验证第1个文法点
  expect(find.text('은/는'), findsOneWidget);

  // 滑动到下一页
  await tester.drag(
    find.byType(PageView),
    const Offset(-400, 0),
  );
  await tester.pumpAndSettle();

  // 验证第2个文法点
  expect(find.text('이/가'), findsOneWidget);
});
```

### 交互测试
```dart
testWidgets('exercise shows feedback on answer', (tester) async {
  await tester.pumpWidget(...);

  // 点击选项
  await tester.tap(find.text('은'));
  await tester.pump();

  // 验证反馈显示
  expect(find.byIcon(Icons.celebration), findsOneWidget);
  expect(find.text('太棒了！'), findsOneWidget);
});
```

### 状态测试
```dart
test('preserves answers when changing pages', () async {
  final state = _GrammarStageState();

  // 第1页答题
  state._checkAnswer(0, '는');
  expect(state._userAnswers[0], '는');

  // 切换到第2页
  state._currentPointIndex = 1;

  // 第2页答题
  state._checkAnswer(1, '가');
  expect(state._userAnswers[1], '가');

  // 返回第1页，答案保留
  expect(state._userAnswers[0], '는');
});
```

---

## 故障排除

### 动画不显示
```dart
// 确保导入flutter_animate
import 'package:flutter_animate/flutter_animate.dart';

// 确保pubspec.yaml中添加
dependencies:
  flutter_animate: ^4.0.0
```

### PageView滑动卡顿
```dart
// 减少每页内容复杂度
// 使用const widget
const Text('...')
const SizedBox(...)

// 或禁用滑动，只用按钮
PageView(
  physics: NeverScrollableScrollPhysics(),
)
```

### RichText不高亮
```dart
// 检查split逻辑
final parts = text.split(highlight);
print('Parts: $parts');  // 应该分割成多个部分

// 检查高亮文本存在
if (text.contains(highlight)) {
  // 正常
} else {
  // highlight文本不在text中
}
```

### 反馈不显示
```dart
// 检查状态更新
void _checkAnswer(int pointIndex, String answer) {
  setState(() {  // ← 必须使用setState
    _userAnswers[pointIndex] = answer;
    _showExerciseFeedback[pointIndex] = true;
  });
}
```

---

## 设计原则

### 1. 视觉层次
```
标题（渐变背景）← 最突出
    ↓
规则（蓝色）← 重要
    ↓
对比（紫色）← 辅助理解
    ↓
例句（白色）← 实例
    ↓
练习（绿色）← 应用
```

### 2. 颜色语义
- 蓝色 = 规则/理论
- 紫色 = 对比/分析
- 白色 = 例句/中性
- 绿色 = 练习/互动
- 黄色 = 主题色/高亮

### 3. 交互反馈
- 选项点击 → 立即变色
- 正确答案 → 绿色 + ✓
- 错误答案 → 红色 + ✗
- 正确选项 → 始终显示绿色

### 4. 渐进式学习
```
1. 先看标题（知道学什么）
2. 读规则（理解规则）
3. 看对比（联系中文）
4. 读例句（看实例）
5. 做练习（检验理解）
```

---

## 注意事项

1. **PageController**: 必须在dispose中释放
2. **状态保留**: 使用Map保存各页答题状态
3. **RichText**: highlight文本必须存在于原文中
4. **动画延迟**: 保持100ms递增，避免同时出现
5. **反馈时机**: 选择后立即显示，不可修改答案

---

## Mock数据总结

### 包含的文法点
1. **은/는** - 主题助词
2. **이/가** - 主格助词
3. **을/를** - 宾格助词
4. **이에요/예요** - 判断句结尾

### 每个文法点包含
- 标题（韩/中）
- 规则说明（3行）
- 中文对比（1个示例 + 说明）
- 例句（3个，带高亮和解释）
- 练习（1个填空题，4个选项）

**总计**: 4个文法点 × 3个例句 × 1个练习 = 12个例句 + 4个练习

---

## 依赖包

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_animate: ^4.0.0    # 动画库

  # 未来依赖
  # audioplayers: ^5.0.0     # 音频示例（可选）
```
