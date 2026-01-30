# 认证界面 (Auth Screens)

用户登录和注册界面，使用 Material Design 3 设计规范和 Provider 状态管理。

## 文件结构

```
auth/
├── login_screen.dart       # 登录界面
└── register_screen.dart    # 注册界面
```

---

## LoginScreen (登录界面)

### 功能

- **邮箱/密码登录**
- **实时验证**: 邮箱格式、密码长度
- **密码可见性切换**: 眼睛图标切换显示/隐藏
- **加载状态**: 登录过程显示加载动画
- **错误提示**: 实时显示错误信息
- **导航到注册**: 底部链接跳转到注册界面

### UI 组件

#### 1. Logo 区域
```dart
Container(
  width: 100,
  height: 100,
  decoration: BoxDecoration(
    color: AppConstants.primaryColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
  ),
  child: const Center(
    child: Text('🍋', style: TextStyle(fontSize: 50)),
  ),
),
```

#### 2. 邮箱输入
- **标签**: "邮箱"
- **提示**: "请输入邮箱地址"
- **图标**: 邮件图标 (email_outlined)
- **验证**:
  - 非空检查
  - 正则验证邮箱格式: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
- **背景**: 浅灰色填充 (grey.shade50)

#### 3. 密码输入
- **标签**: "密码"
- **提示**: "请输入密码"
- **图标**: 锁图标 (lock_outlined)
- **可见性切换**: 眼睛图标
- **验证**:
  - 非空检查
  - 最小长度: `AppConstants.minPasswordLength` (默认 6)
- **背景**: 浅灰色填充

#### 4. 登录按钮
- **样式**:
  - 背景色: `AppConstants.primaryColor` (柠檬黄)
  - 前景色: `Colors.black87`
  - 无阴影 (elevation: 0)
- **加载状态**: 显示圆形进度指示器
- **禁用状态**: 加载时禁用点击

#### 5. 错误信息显示
```dart
Container(
  padding: const EdgeInsets.all(AppConstants.paddingMedium),
  decoration: BoxDecoration(
    color: AppConstants.errorColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
    border: Border.all(
      color: AppConstants.errorColor.withOpacity(0.3),
    ),
  ),
  child: Row(
    children: [
      const Icon(Icons.error_outline, color: AppConstants.errorColor),
      const SizedBox(width: AppConstants.paddingSmall),
      Expanded(
        child: Text(errorMessage),
      ),
    ],
  ),
),
```

### 状态管理

使用 `AuthProvider`:

```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return ElevatedButton(
      onPressed: authProvider.isLoading ? null : _handleLogin,
      child: authProvider.isLoading
          ? CircularProgressIndicator()
          : Text('登录'),
    );
  },
)
```

### 验证逻辑

```dart
Future<void> _handleLogin() async {
  // 1. 表单验证
  if (!_formKey.currentState!.validate()) return;

  // 2. 调用 Provider
  final success = await authProvider.login(
    email: _emailController.text.trim(),
    password: _passwordController.text,
  );

  // 3. 导航处理
  if (success) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
  // 错误信息自动显示在 UI
}
```

### 错误清除

用户输入时自动清除错误:

```dart
void initState() {
  super.initState();
  _emailController.addListener(_clearError);
  _passwordController.addListener(_clearError);
}

void _clearError() {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  if (authProvider.error != null) {
    authProvider.clearError();
  }
}
```

---

## RegisterScreen (注册界面)

### 功能

- **用户信息输入**: 用户名、邮箱、密码、确认密码
- **语言选择**: 简体中文 / 繁體中文 (下拉菜单)
- **密码要求提示**: 显示密码规则
- **实时验证**: 完整的表单验证
- **加载状态**: 注册过程显示加载动画
- **错误提示**: 实时显示错误信息
- **导航到登录**: 底部链接返回登录界面

### UI 组件

#### 1. 标题区域
```dart
const Text(
  '创建账号',
  style: TextStyle(
    fontSize: AppConstants.fontSizeXXLarge,
    fontWeight: FontWeight.bold,
  ),
),
const Text(
  '开始你的韩语学习之旅',
  style: TextStyle(
    fontSize: AppConstants.fontSizeMedium,
    color: AppConstants.textSecondary,
  ),
),
```

#### 2. 用户名输入
- **标签**: "用户名"
- **提示**: "请输入用户名"
- **图标**: 人物图标 (person_outline)
- **验证**:
  - 非空检查
  - 最小长度: 2个字符
  - 最大长度: 20个字符

#### 3. 邮箱输入
- 与登录界面相同
- 完整的正则验证

#### 4. 密码输入
- **标签**: "密码"
- **验证**:
  - 非空检查
  - 最小长度检查
  - 必须包含字母和数字: `[a-zA-Z]` 和 `[0-9]`

#### 5. 确认密码输入
- **标签**: "确认密码"
- **提示**: "请再次输入密码"
- **验证**:
  - 非空检查
  - 与密码字段匹配

#### 6. 语言选择
```dart
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.shade400),
    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
    color: Colors.grey.shade50,
  ),
  child: Row(
    children: [
      const Icon(Icons.language, color: Colors.grey),
      const Text('界面语言'),
      const Spacer(),
      DropdownButton<String>(
        value: _selectedLanguage,
        items: const [
          DropdownMenuItem(value: '简体中文', child: Text('简体中文')),
          DropdownMenuItem(value: '繁體中文', child: Text('繁體中文')),
        ],
        onChanged: (value) {
          setState(() => _selectedLanguage = value);
        },
      ),
    ],
  ),
),
```

#### 7. 密码要求提示
```dart
Container(
  padding: const EdgeInsets.all(AppConstants.paddingMedium),
  decoration: BoxDecoration(
    color: AppConstants.primaryColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
  ),
  child: Column(
    children: [
      Row(
        children: const [
          Icon(Icons.info_outline, size: 16),
          SizedBox(width: 8),
          Text('密码要求', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      _buildRequirement('至少6个字符'),
      _buildRequirement('包含字母和数字'),
    ],
  ),
),
```

#### 8. 注册按钮
- 与登录按钮样式相同
- 显示加载状态

#### 9. 登录链接
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text('已有账号？'),
    TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('立即登录'),
    ),
  ],
),
```

### 验证规则

#### 邮箱验证
```dart
final emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);
if (!emailRegex.hasMatch(value)) {
  return '请输入有效的邮箱地址';
}
```

#### 密码验证
```dart
if (value.length < AppConstants.minPasswordLength) {
  return '密码至少需要${AppConstants.minPasswordLength}个字符';
}
if (!RegExp(r'[a-zA-Z]').hasMatch(value) ||
    !RegExp(r'[0-9]').hasMatch(value)) {
  return '密码必须包含字母和数字';
}
```

#### 确认密码验证
```dart
if (value != _passwordController.text) {
  return '两次输入的密码不一致';
}
```

---

## 状态管理 (AuthProvider)

### 状态变量

```dart
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
}
```

### 方法

#### login(email, password)
```dart
Future<bool> login({
  required String email,
  required String password,
}) async {
  _setLoading(true);
  _clearError();

  try {
    final result = await _authRepository.login(email, password);

    if (result.isSuccess) {
      _currentUser = result.user;
      _setLoading(false);
      return true;
    } else {
      _setError(result.error ?? '登录失败');
      _setLoading(false);
      return false;
    }
  } catch (e) {
    _setError(e.toString());
    _setLoading(false);
    return false;
  }
}
```

#### register(email, password, username)
- 与 login 类似
- 额外保存 username

#### logout()
- 清除 tokens
- 清除本地数据
- 重置状态

#### clearError()
- 手动清除错误信息

---

## 使用示例

### 1. 在 main.dart 中配置 Provider

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 2. 导航到登录界面

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const LoginScreen(),
  ),
);
```

### 3. 导航到注册界面

```dart
// 从登录界面
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const RegisterScreen(),
  ),
);
```

### 4. 成功登录后导航

```dart
if (success) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}
```

---

## 样式规范

### 颜色

- **主色调**: `AppConstants.primaryColor` (柠檬黄)
- **文本主色**: `Colors.black87`
- **文本辅色**: `AppConstants.textSecondary` (灰色)
- **错误色**: `AppConstants.errorColor` (红色)
- **输入框背景**: `Colors.grey.shade50`

### 间距

- **Large**: `AppConstants.paddingLarge` (24px)
- **Medium**: `AppConstants.paddingMedium` (16px)
- **Small**: `AppConstants.paddingSmall` (8px)

### 圆角

- **Large**: `AppConstants.radiusLarge` (16px)
- **Medium**: `AppConstants.radiusMedium` (12px)
- **Small**: `AppConstants.radiusSmall` (8px)

### 字体大小

- **XXLarge**: `AppConstants.fontSizeXXLarge` (28px) - 标题
- **Large**: `AppConstants.fontSizeLarge` (18px) - 按钮
- **Medium**: `AppConstants.fontSizeMedium` (16px) - 正文
- **Small**: `AppConstants.fontSizeSmall` (14px) - 辅助文本

---

## Material Design 3 特性

### 1. Filled Text Fields
```dart
TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade50,
  ),
)
```

### 2. Elevated Buttons
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    elevation: 0,  // 无阴影
    backgroundColor: AppConstants.primaryColor,
  ),
)
```

### 3. 错误状态
```dart
Container(
  decoration: BoxDecoration(
    color: errorColor.withOpacity(0.1),
    border: Border.all(color: errorColor.withOpacity(0.3)),
  ),
)
```

---

## 错误处理

### 常见错误信息

| 错误 | 中文提示 |
|------|---------|
| 网络错误 | 网络连接失败，请检查网络设置 |
| 401 | 邮箱或密码错误 |
| 409 | 邮箱已被注册 |
| 超时 | 请求超时，请重试 |
| 其他 | 操作失败，请稍后重试 |

### 错误显示位置

1. **登录界面**: 登录按钮上方
2. **注册界面**: 注册按钮上方
3. **样式**: 浅红色背景 + 错误图标 + 错误文本

---

## 无障碍支持

- 所有输入框都有明确的 `labelText`
- 按钮有语义化的文本
- 错误提示有图标和文字双重提示
- 支持键盘导航

---

## 下一步优化

1. **社交登录**: 添加微信、QQ 登录
2. **忘记密码**: 邮箱重置密码流程
3. **验证码**: 邮箱验证码登录/注册
4. **记住我**: 自动登录功能
5. **生物识别**: 指纹/面容登录
6. **多语言**: 支持更多语言选项
7. **隐私政策**: 注册时显示用户协议

---

## 测试

### 单元测试示例

```dart
testWidgets('Login screen validation', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

  // 找到输入框
  final emailField = find.byType(TextFormField).first;
  final passwordField = find.byType(TextFormField).last;

  // 输入无效邮箱
  await tester.enterText(emailField, 'invalid-email');
  await tester.tap(find.text('登录'));
  await tester.pump();

  // 验证错误提示
  expect(find.text('请输入有效的邮箱地址'), findsOneWidget);
});
```

### 集成测试

```dart
testWidgets('Complete registration flow', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

  // 输入所有字段
  await tester.enterText(find.byType(TextFormField).at(0), 'TestUser');
  await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
  await tester.enterText(find.byType(TextFormField).at(2), 'Test123');
  await tester.enterText(find.byType(TextFormField).at(3), 'Test123');

  // 点击注册
  await tester.tap(find.text('注册'));
  await tester.pumpAndSettle();

  // 验证导航到首页
  expect(find.byType(HomeScreen), findsOneWidget);
});
```
