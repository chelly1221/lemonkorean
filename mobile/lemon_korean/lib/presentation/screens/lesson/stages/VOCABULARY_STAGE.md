# VocabularyStage - 翻转卡片词汇学习

高级词汇学习组件，采用3D翻转卡片动画，支持本地/远程媒体加载。

---

## 核心特性

### 1. 3D翻转卡片动画
- AnimationController驱动的流畅翻转
- 600ms动画时长
- Curves.easeInOut缓动曲线
- 点击卡片触发翻转

### 2. 双面卡片设计

**前面（韩语）**:
- 单词配图（本地优先）
- 韩语单词（大字体）
- 罗马音标注
- 发音按钮（播放音频）

**背面（中文）**:
- 中文翻译（特大字体）
- 拼音标注
- 汉字词显示（如果是汉字词）
- 中韩相似度指示器

### 3. 媒体加载策略
- 优先使用本地下载的文件
- 本地不存在时使用远程URL
- 图片加载失败显示占位符
- 音频播放前检查本地可用性

---

## 技术实现

### AnimationController

```dart
class _VocabularyStageState extends State<VocabularyStage>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();

    // 创建动画控制器
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // 创建动画（0 → 1）
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOut,
      ),
    );

    // 监听动画完成
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFront = !_isFront;  // 切换状态
        });
        _flipController.reset();  // 重置动画
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();  // 释放资源
    super.dispose();
  }
}
```

### 3D变换矩阵

```dart
void _flipCard() {
  if (!_flipController.isAnimating) {
    _flipController.forward();
  }
}

AnimatedBuilder(
  animation: _flipAnimation,
  builder: (context, child) {
    // 计算旋转角度（0 → π）
    final angle = _flipAnimation.value * math.pi;

    // 判断是否已翻转过半
    final isUnder = angle > math.pi / 2;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)  // 透视效果（重要！）
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

**关键点**:
- `setEntry(3, 2, 0.001)` - 添加透视效果，使翻转更真实
- `rotateY(angle)` - Y轴旋转（水平翻转）
- `isUnder = angle > π/2` - 超过90度显示背面
- 背面需要额外旋转180度（rotateY(π)）以正确显示

---

## 前面卡片 (_buildFrontCard)

### 布局结构
```dart
Column([
  Expanded(
    flex: 3,
    child: FutureBuilder<String>(
      future: MediaLoader.getImagePath(word['image']),
      builder: (context, snapshot) {
        // 加载图片
      },
    ),
  ),

  Expanded(
    flex: 2,
    child: Column([
      Text(word['korean'], fontSize: 48),      // 韩语
      Text(word['pronunciation']),              // 发音
      ElevatedButton.icon(                      // 音频按钮
        icon: Icon(Icons.volume_up),
        label: Text('发音'),
        onPressed: _playAudio,
      ),
    ]),
  ),
])
```

### 图片加载逻辑
```dart
FutureBuilder<String>(
  future: MediaLoader.getImagePath(word['image']),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return _buildPlaceholderImage();  // 加载中
    }

    final imagePath = snapshot.data!;
    final isLocal = !imagePath.startsWith('http');

    if (isLocal) {
      // 本地文件
      return Image.file(
        File(imagePath),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else {
      // 远程URL
      return Image.network(
        imagePath,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          // 显示加载进度
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    }
  },
)
```

### 占位符图片
```dart
Widget _buildPlaceholderImage() {
  return Container(
    decoration: BoxDecoration(
      color: AppConstants.primaryColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
    ),
    child: const Center(
      child: Icon(
        Icons.image_outlined,
        size: 80,
        color: AppConstants.textHint,
      ),
    ),
  );
}
```

---

## 背面卡片 (_buildBackCard)

### 布局结构
```dart
Column([
  // 中文翻译
  Text(word['chinese'], fontSize: 56),

  // 拼音
  Text(word['pinyin'], fontSize: 24, fontStyle: italic),

  // 汉字词（可选）
  if (word['hanja'] != null)
    Container([
      Text('汉字词'),
      Text(word['hanja'], fontSize: 32),
    ]),

  // 相似度指示器
  _buildSimilarityBar(word['similarity']),

  // 返回提示
  Container([
    Icon(Icons.touch_app),
    Text('点击返回'),
  ]),
])
```

### 汉字词显示
```dart
if (word['hanja'] != null) ...[
  Container(
    padding: EdgeInsets.all(AppConstants.paddingMedium),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column([
      Text('汉字词', fontSize: small, color: secondary),
      SizedBox(height: 8),
      Text(
        word['hanja'],  // '安寧', '感謝', etc.
        fontSize: 32,
        fontWeight: bold,
        color: primaryColor,
      ),
    ]),
  ),
  SizedBox(height: 20),
]
```

---

## 相似度指示器

### 颜色映射
```dart
Color barColor;
if (similarity >= 80) {
  barColor = AppConstants.successColor;    // 绿色 - 高相似度
} else if (similarity >= 60) {
  barColor = AppConstants.primaryColor;    // 黄色 - 中等相似度
} else {
  barColor = Colors.orange;                // 橙色 - 低相似度
}
```

### 提示文本
```dart
String _getSimilarityHint(int similarity) {
  if (similarity >= 90) {
    return '汉字词，发音相似';     // 例：학교 (學校) = xuéxiào
  } else if (similarity >= 70) {
    return '词源相同，便于记忆';   // 例：안녕 (安寧) ≈ ānníng
  } else if (similarity >= 50) {
    return '有一定联系';           // 例：감사 (感謝) ~ gǎnxiè
  } else {
    return '固有词，需要记忆';     // 例：밥 (饭) ≠ fàn
  }
}
```

### UI组件
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey.shade300),
  ),
  child: Column([
    // 标题和百分比
    Row([
      Text('与中文相似度'),
      Text('$similarity%', color: barColor),
    ]),

    // 进度条
    LinearProgressIndicator(
      value: similarity / 100,
      valueColor: AlwaysStoppedAnimation(barColor),
    ),

    // 提示文本
    Text(_getSimilarityHint(similarity), color: barColor),
  ]),
)
```

---

## 音频播放

### 当前实现（占位符）
```dart
Future<void> _playAudio() async {
  final word = _mockWords[_currentCardIndex];
  final audioPath = word['audio'] as String?;

  if (audioPath != null) {
    // 获取本地路径（如果已下载）
    final localPath = await MediaLoader.getAudioPath(audioPath);

    // TODO: 集成 audioplayers 包
    // final player = AudioPlayer();
    // await player.play(DeviceFileSource(localPath));

    // 临时反馈
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('播放: $localPath'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
```

### 未来实现（audioplayers）
```dart
import 'package:audioplayers/audioplayers.dart';

class _VocabularyStageState extends State<VocabularyStage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playAudio() async {
    final word = _mockWords[_currentCardIndex];
    final audioPath = word['audio'] as String?;

    if (audioPath != null) {
      final localPath = await MediaLoader.getAudioPath(audioPath);
      final isLocal = !localPath.startsWith('http');

      if (isLocal) {
        await _audioPlayer.play(DeviceFileSource(localPath));
      } else {
        await _audioPlayer.play(UrlSource(localPath));
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _flipController.dispose();
    super.dispose();
  }
}
```

---

## MediaLoader集成

### 工作流程

```
1. 用户查看单词卡片
    ↓
2. FutureBuilder调用 MediaLoader.getImagePath()
    ↓
3. MediaLoader查询数据库
    ↓
4. 本地存在？
    ├─ Yes → 返回本地文件路径 → Image.file()
    └─ No  → 返回远程URL → Image.network()
    ↓
5. 用户点击发音按钮
    ↓
6. MediaLoader.getAudioPath()
    ↓
7. 播放本地或远程音频
```

### DatabaseHelper映射表

```sql
CREATE TABLE media_files (
  remote_key TEXT,      -- 'vocabulary/hello.jpg'
  local_path TEXT,      -- '/data/.../media/images/vocabulary_hello.jpg'
  file_type TEXT,       -- 'image' or 'audio'
  file_size INTEGER,
  lesson_id INTEGER,
  downloaded_at INTEGER,
  last_accessed INTEGER
);
```

### 示例查询
```dart
// 获取本地路径
final path = await DatabaseHelper.instance.getLocalPath('vocabulary/hello.jpg');
// 返回: '/data/user/0/.../media/images/vocabulary_hello.jpg'

// 如果不存在
// 返回: null → 使用远程URL
```

---

## 数据结构

### 单词对象
```dart
{
  // 韩语信息
  'korean': '안녕하세요',
  'pronunciation': 'an-nyeong-ha-se-yo',

  // 中文信息
  'chinese': '您好',
  'pinyin': 'nín hǎo',
  'hanja': '安寧',              // 汉字词（可选，固有词为null）

  // 学习辅助
  'similarity': 85,             // 0-100，中韩相似度

  // 媒体文件
  'image': 'vocabulary/hello.jpg',
  'audio': 'vocabulary/hello.mp3',
}
```

### 相似度分类

| 范围 | 类型 | 示例 | 说明 |
|------|------|------|------|
| 90-100 | 汉字词高度相似 | 학교(學校) = xuéxiào | 发音几乎一致 |
| 70-89 | 汉字词中度相似 | 감사(感謝) ≈ gǎnxiè | 发音相近 |
| 50-69 | 词源相关 | 사랑 ← 思量 | 有历史联系 |
| 0-49 | 固有词 | 밥 ≠ fàn | 完全不同 |

---

## 状态管理

### 状态变量
```dart
int _currentCardIndex = 0;      // 当前卡片索引
bool _isFront = true;            // 当前显示面（true=前面）
int? _playingLineIndex;          // 正在播放的行索引（未使用）
```

### 卡片切换
```dart
void _nextCard() {
  if (_currentCardIndex < _mockWords.length - 1) {
    setState(() {
      _currentCardIndex++;
      _isFront = true;  // 重置为前面
    });
  } else {
    widget.onNext();    // 进入下一阶段
  }
}

void _previousCard() {
  if (_currentCardIndex > 0) {
    setState(() {
      _currentCardIndex--;
      _isFront = true;  // 重置为前面
    });
  }
}
```

### 翻转逻辑
```dart
void _flipCard() {
  if (!_flipController.isAnimating) {
    _flipController.forward();
  }
}

// 动画完成时
_flipController.addStatusListener((status) {
  if (status == AnimationStatus.completed) {
    setState(() {
      _isFront = !_isFront;  // true → false 或 false → true
    });
    _flipController.reset();
  }
});
```

---

## UI组件详解

### 进度指示器
```dart
Row([
  // 卡片计数
  Text('${_currentCardIndex + 1} / ${_mockWords.length}'),

  // 翻转提示（仅前面显示）
  if (_isFront)
    Container([
      Icon(Icons.touch_app),
      Text('点击翻转'),
    ]),
])

// 进度条
LinearProgressIndicator(
  value: (_currentCardIndex + 1) / _mockWords.length,
)
```

### 前面卡片样式
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.white,
        primaryColor.withOpacity(0.1),
      ],
    ),
    borderRadius: BorderRadius.circular(radiusLarge),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  ),
)
```

### 背面卡片样式
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        primaryColor.withOpacity(0.1),
        Colors.white,
      ],
    ),
    borderRadius: BorderRadius.circular(radiusLarge),
    boxShadow: [...],
  ),
)
```

**区别**: 渐变方向相反，视觉上区分正反面。

---

## 相似度指示器详解

### 完整实现
```dart
Widget _buildSimilarityBar(int similarity) {
  // 根据相似度选择颜色
  Color barColor;
  if (similarity >= 80) {
    barColor = AppConstants.successColor;
  } else if (similarity >= 60) {
    barColor = AppConstants.primaryColor;
  } else {
    barColor = Colors.orange;
  }

  return Container(
    padding: EdgeInsets.all(AppConstants.paddingMedium),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column([
      // 标题行
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('与中文相似度'),
          Text('$similarity%', style: TextStyle(color: barColor)),
        ],
      ),

      SizedBox(height: 8),

      // 进度条
      LinearProgressIndicator(
        value: similarity / 100,
        backgroundColor: Colors.grey.shade200,
        valueColor: AlwaysStoppedAnimation(barColor),
      ),

      SizedBox(height: 8),

      // 提示文本
      Text(
        _getSimilarityHint(similarity),
        style: TextStyle(color: barColor, fontStyle: italic),
      ),
    ]),
  );
}
```

### 相似度示例

**100% 相似 - 학교 (學校)**:
```
韩语: 학교 (hak-gyo)
中文: 学校 (xué xiào)
汉字: 學校
相似度: 100% ████████████ 绿色
提示: 汉字词，发音相似
```

**85% 相似 - 안녕 (安寧)**:
```
韩语: 안녕하세요 (an-nyeong-ha-se-yo)
中文: 您好 (nín hǎo)
汉字: 安寧
相似度: 85% ██████████░░ 绿色
提示: 汉字词，发音相似
```

**40% 相似 - 밥 (固有词)**:
```
韩语: 밥 (bap)
中文: 饭 (fàn)
汉字: null
相似度: 40% █████░░░░░░░ 橙色
提示: 固有词，需要记忆
```

---

## 使用示例

### 在lesson_screen.dart中集成
```dart
import 'stages/vocabulary_stage.dart';

PageView(
  children: [
    Stage1Intro(lesson: lesson, onNext: _nextStage),

    // 使用高级翻转卡片版本
    VocabularyStage(
      lesson: lesson,
      onNext: _nextStage,
      onPrevious: _previousStage,
    ),

    // 或使用简单版本
    // Stage2Vocabulary(...),

    Stage3Grammar(...),
    // ...
  ],
)
```

### Mock数据示例
```dart
final List<Map<String, dynamic>> _mockWords = [
  {
    'korean': '안녕하세요',
    'pronunciation': 'an-nyeong-ha-se-yo',
    'chinese': '您好',
    'pinyin': 'nín hǎo',
    'hanja': '安寧',
    'similarity': 85,
    'image': 'vocabulary/hello.jpg',
    'audio': 'vocabulary/hello.mp3',
  },
  // ...
];
```

### 真实数据替换
```dart
@override
void initState() {
  super.initState();

  // 从lesson content加载
  final vocabularyData = widget.lesson.content['stage2_vocabulary'];
  _mockWords = (vocabularyData['words'] as List)
      .map((w) => w as Map<String, dynamic>)
      .toList();

  _flipController = AnimationController(...);
}
```

---

## 性能优化

### 1. 图片预加载
```dart
// 预加载下一张图片
void _preloadNextImage() {
  if (_currentCardIndex < _mockWords.length - 1) {
    final nextWord = _mockWords[_currentCardIndex + 1];
    MediaLoader.getImagePath(nextWord['image']).then((path) {
      if (path.startsWith('http')) {
        precacheImage(NetworkImage(path), context);
      } else {
        precacheImage(FileImage(File(path)), context);
      }
    });
  }
}

// 在_nextCard()中调用
void _nextCard() {
  setState(() {
    _currentCardIndex++;
    _isFront = true;
  });
  _preloadNextImage();  // 预加载
}
```

### 2. 动画优化
```dart
// 使用SingleTickerProviderStateMixin
// 只创建一个Ticker，减少开销
with SingleTickerProviderStateMixin

// 防止重复触发
void _flipCard() {
  if (!_flipController.isAnimating) {  // 检查是否正在动画
    _flipController.forward();
  }
}
```

### 3. 内存管理
```dart
@override
void dispose() {
  _flipController.dispose();  // 释放动画控制器
  // TODO: _audioPlayer.dispose();
  super.dispose();
}
```

---

## 错误处理

### 图片加载失败
```dart
Image.file(
  File(imagePath),
  errorBuilder: (context, error, stackTrace) {
    return _buildPlaceholderImage();  // 显示占位符
  },
)

Image.network(
  imagePath,
  errorBuilder: (context, error, stackTrace) {
    return _buildPlaceholderImage();  // 显示占位符
  },
)
```

### 音频播放失败
```dart
try {
  await _audioPlayer.play(DeviceFileSource(localPath));
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('播放失败: $e')),
  );
}
```

### 媒体文件不存在
```dart
// MediaLoader自动处理
// 本地不存在 → 返回远程URL
// 远程也失败 → errorBuilder显示占位符
```

---

## 与stage2_vocabulary.dart的区别

| 特性 | stage2_vocabulary.dart | vocabulary_stage.dart |
|------|------------------------|----------------------|
| 动画 | 无 | 3D翻转动画 |
| 卡片面数 | 单面 | 双面（前/后） |
| 图片 | 无 | 支持本地/远程图片 |
| 音频 | 无 | 支持音频播放 |
| 汉字词 | 无 | 显示汉字 |
| 相似度 | 无 | 相似度指示器 |
| 复杂度 | 简单 | 高级 |
| 适用场景 | 快速浏览 | 深度学习 |

**建议**: 根据课程难度选择使用哪个版本。初级课程用stage2，高级课程用vocabulary_stage。

---

## 下一步开发

### 1. 音频播放集成
```bash
flutter pub add audioplayers
```

```dart
import 'package:audioplayers/audioplayers.dart';

final _audioPlayer = AudioPlayer();
await _audioPlayer.play(DeviceFileSource(localPath));
```

### 2. 图片预加载
```dart
// 在initState或_nextCard时预加载下一张
precacheImage(FileImage(File(nextImagePath)), context);
```

### 3. 语音识别（可选）
```bash
flutter pub add speech_to_text
```

```dart
// 添加"跟读"按钮
final speech = SpeechToText();
await speech.listen(
  onResult: (result) {
    _checkPronunciation(result.recognizedWords);
  },
);
```

### 4. 收藏功能
```dart
// 添加"收藏"按钮
IconButton(
  icon: Icon(
    _isFavorite ? Icons.favorite : Icons.favorite_border,
    color: Colors.red,
  ),
  onPressed: _toggleFavorite,
)
```

### 5. 自动翻转
```dart
// 3秒后自动翻转到背面
Timer(Duration(seconds: 3), () {
  if (_isFront) {
    _flipCard();
  }
});
```

---

## 测试要点

### Widget测试
```dart
testWidgets('card flips on tap', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: VocabularyStage(
        lesson: testLesson,
        onNext: () {},
        onPrevious: () {},
      ),
    ),
  );

  // 初始显示前面
  expect(find.text('안녕하세요'), findsOneWidget);
  expect(find.text('您好'), findsNothing);

  // 点击卡片
  await tester.tap(find.byType(GestureDetector).first);
  await tester.pumpAndSettle();

  // 显示背面
  expect(find.text('안녕하세요'), findsNothing);
  expect(find.text('您好'), findsOneWidget);
});
```

### 动画测试
```dart
testWidgets('flip animation completes', (tester) async {
  await tester.pumpWidget(...);

  final state = tester.state<_VocabularyStageState>(
    find.byType(VocabularyStage),
  );

  // 触发翻转
  state._flipCard();

  // 验证动画进行中
  expect(state._flipController.isAnimating, true);

  // 等待动画完成
  await tester.pumpAndSettle();

  // 验证状态切换
  expect(state._isFront, false);
});
```

### MediaLoader测试
```dart
test('loads local image when available', () async {
  // Mock本地文件存在
  when(DatabaseHelper.instance.getLocalPath('vocabulary/hello.jpg'))
      .thenAnswer((_) async => '/local/path/hello.jpg');

  final path = await MediaLoader.getImagePath('vocabulary/hello.jpg');

  expect(path, '/local/path/hello.jpg');
});

test('fallback to remote URL when local not available', () async {
  // Mock本地文件不存在
  when(DatabaseHelper.instance.getLocalPath('vocabulary/hello.jpg'))
      .thenAnswer((_) async => null);

  final path = await MediaLoader.getImagePath('vocabulary/hello.jpg');

  expect(path, contains('http'));
});
```

---

## 故障排除

### 图片不显示
```dart
// 1. 检查本地文件存在
final isLocal = await MediaLoader.isMediaAvailableLocally('vocabulary/hello.jpg');
print('Local available: $isLocal');

// 2. 检查数据库记录
final mediaFile = await DatabaseHelper.instance.getMediaFile('vocabulary/hello.jpg');
print('Media file: $mediaFile');

// 3. 检查文件权限
final file = File(localPath);
print('File exists: ${await file.exists()}');
```

### 翻转动画卡顿
```dart
// 确保使用SingleTickerProviderStateMixin
with SingleTickerProviderStateMixin

// 减少卡片内容复杂度
// 使用const widget
const Text('...')
```

### 音频播放无声音
```dart
// 检查音频文件路径
print('Audio path: $audioPath');

// 检查本地文件
final file = File(audioPath);
print('Audio file exists: ${await file.exists()}');

// 检查audioplayers配置
await _audioPlayer.setVolume(1.0);
```

---

## 注意事项

1. **动画冲突**: 切换卡片时重置翻转状态（`_isFront = true`）
2. **内存泄漏**: 必须在dispose中释放AnimationController
3. **图片缓存**: NetworkImage自动缓存，本地图片无需缓存
4. **音频资源**: AudioPlayer需要手动释放
5. **透视效果**: `setEntry(3, 2, 0.001)` 必须设置，否则翻转效果不自然

---

## 技术依赖

```yaml
dependencies:
  flutter:
    sdk: flutter
  path_provider: ^2.0.0      # 本地路径
  sqflite: ^2.0.0            # SQLite数据库

  # 未来依赖
  # audioplayers: ^5.0.0     # 音频播放
  # speech_to_text: ^6.0.0   # 语音识别（可选）
```
