# Providers (状态管理)

使用 Provider 模式管理应用状态。

## 文件列表

```
providers/
└── auth_provider.dart      # 认证状态管理
```

---

## AuthProvider

认证状态管理，使用 `ChangeNotifier` 实现响应式状态更新。

### 依赖

- **AuthRepository**: 处理 API 调用和本地存储
- **FlutterSecureStorage**: 安全存储 JWT 令牌
- **UserModel**: 用户数据模型

### 状态变量

```dart
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;     // 当前用户
  bool _isLoading = false;     // 加载状态
  String? _error;              // 错误信息

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
}
```

---

## 核心方法

### 1. loadUser() - 自动登录

从保存的令牌加载用户信息，实现自动登录功能。

**使用场景**: 应用启动时调用

```dart
Future<void> loadUser() async {
  _setLoading(true);
  _clearError();

  try {
    // 检查是否有保存的用户 ID
    if (_authRepository.isLoggedIn()) {
      final userId = _authRepository.getCurrentUserId();

      if (userId != null) {
        // 创建用户对象（简化版）
        _currentUser = UserModel(
          id: userId,
          email: '',
          username: '',
          createdAt: DateTime.now(),
        );

        _setLoading(false);
        return;
      }
    }

    _currentUser = null;
    _setLoading(false);
  } catch (e) {
    _setError('加载用户信息失败: $e');
    _setLoading(false);
  }
}
```

**流程**:
1. 设置加载状态 → `_isLoading = true`
2. 调用 `AuthRepository.isLoggedIn()` 检查登录状态
3. 获取保存的用户 ID
4. 创建 `UserModel` 对象
5. 更新状态 → `notifyListeners()`

**在 main.dart 中使用**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.loadUser(); // 自动登录

  runApp(
    ChangeNotifierProvider.value(
      value: authProvider,
      child: const MyApp(),
    ),
  );
}
```

---

### 2. login(email, password) - 登录

使用邮箱和密码登录。

```dart
Future<bool> login({
  required String email,
  required String password,
}) async {
  _setLoading(true);
  _clearError();

  try {
    // 调用 AuthRepository 登录
    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    if (result.success && result.user != null) {
      _currentUser = result.user;

      // 保存令牌到安全存储
      if (result.token != null) {
        await _secureStorage.write(
          key: AppConstants.tokenKey,
          value: result.token,
        );
      }

      _setLoading(false);
      return true;
    } else {
      _setError(result.message ?? '登录失败');
      _setLoading(false);
      return false;
    }
  } catch (e) {
    _setError('登录时发生错误: $e');
    _setLoading(false);
    return false;
  }
}
```

**流程**:
1. 设置加载状态
2. 调用 `AuthRepository.login()`
3. 如果成功:
   - 保存 `UserModel` 到 `_currentUser`
   - 保存 JWT 令牌到 `FlutterSecureStorage`
   - 返回 `true`
4. 如果失败:
   - 设置错误信息
   - 返回 `false`

**在界面中使用**:
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

final success = await authProvider.login(
  email: _emailController.text.trim(),
  password: _passwordController.text,
);

if (success) {
  // 导航到首页
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}
// 错误信息自动显示在 UI (通过 Consumer)
```

---

### 3. register(email, password, username) - 注册

注册新用户。

```dart
Future<bool> register({
  required String email,
  required String password,
  required String username,
}) async {
  _setLoading(true);
  _clearError();

  try {
    final result = await _authRepository.register(
      email: email,
      password: password,
      username: username,
    );

    if (result.success && result.user != null) {
      _currentUser = result.user;

      // 保存令牌
      if (result.token != null) {
        await _secureStorage.write(
          key: AppConstants.tokenKey,
          value: result.token,
        );
      }

      _setLoading(false);
      return true;
    } else {
      _setError(result.message ?? '注册失败');
      _setLoading(false);
      return false;
    }
  } catch (e) {
    _setError('注册时发生错误: $e');
    _setLoading(false);
    return false;
  }
}
```

**流程**: 与 login() 类似

**在界面中使用**:
```dart
final success = await authProvider.register(
  email: _emailController.text.trim(),
  password: _passwordController.text,
  username: _usernameController.text.trim(),
);

if (success) {
  // 导航到首页
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}
```

---

### 4. logout() - 登出

登出当前用户，清除所有本地数据。

```dart
Future<void> logout() async {
  _setLoading(true);
  _clearError();

  try {
    // 调用 AuthRepository 登出（清除本地存储）
    await _authRepository.logout();

    // 删除安全存储中的令牌
    await _secureStorage.delete(key: AppConstants.tokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);

    // 清除当前用户
    _currentUser = null;

    _setLoading(false);
  } catch (e) {
    _setError('登出时发生错误: $e');
    _setLoading(false);
  }
}
```

**流程**:
1. 调用 `AuthRepository.logout()` - 清除本地存储
2. 删除 `FlutterSecureStorage` 中的令牌
3. 清除 `_currentUser`
4. 更新状态

**在界面中使用**:
```dart
await authProvider.logout();

// 导航到登录界面
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (context) => const LoginScreen()),
);
```

---

### 5. 辅助方法

#### clearError()
手动清除错误信息。

```dart
void clearError() {
  _error = null;
  notifyListeners();
}
```

**使用**:
```dart
// 用户输入时自动清除错误
_emailController.addListener(() {
  authProvider.clearError();
});
```

#### getToken()
获取保存的 JWT 令牌。

```dart
Future<String?> getToken() async {
  return await _secureStorage.read(key: AppConstants.tokenKey);
}
```

#### hasToken()
检查是否有保存的令牌。

```dart
Future<bool> hasToken() async {
  final token = await getToken();
  return token != null && token.isNotEmpty;
}
```

---

## 在 UI 中使用

### 1. 提供 Provider

在 `main.dart` 中配置:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化
  await LocalStorage.init();

  final authProvider = AuthProvider();
  await authProvider.loadUser(); // 自动登录

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        // 其他 providers...
      ],
      child: const MyApp(),
    ),
  );
}
```

### 2. 访问 Provider (不监听)

用于调用方法:

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

// 调用方法
await authProvider.login(email: email, password: password);
await authProvider.logout();
```

### 3. 监听状态变化 (Consumer)

用于响应式 UI 更新:

```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    // 显示加载状态
    if (authProvider.isLoading) {
      return const CircularProgressIndicator();
    }

    // 显示错误信息
    if (authProvider.error != null) {
      return Text(authProvider.error!);
    }

    // 显示用户信息
    if (authProvider.currentUser != null) {
      return Text('欢迎, ${authProvider.currentUser!.username}');
    }

    return const Text('未登录');
  },
)
```

### 4. 条件渲染

根据登录状态显示不同界面:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // 显示加载界面
          if (authProvider.isLoading) {
            return const SplashScreen();
          }

          // 根据登录状态导航
          if (authProvider.isLoggedIn) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
```

---

## 状态更新流程

### Provider 响应式更新原理

```
用户操作 (登录按钮点击)
    ↓
调用 Provider 方法
    ↓
更新内部状态 (_currentUser, _isLoading, _error)
    ↓
调用 notifyListeners()
    ↓
所有 Consumer<AuthProvider> 自动重建
    ↓
UI 更新
```

### 示例: 登录流程

```dart
// 1. 用户点击登录按钮
onPressed: () async {
  final success = await authProvider.login(
    email: email,
    password: password,
  );
}

// 2. Provider 内部
Future<bool> login(...) async {
  _setLoading(true);        // → notifyListeners()
  // UI 自动显示加载动画

  final result = await _authRepository.login(...);

  if (result.success) {
    _currentUser = result.user;
    _setLoading(false);     // → notifyListeners()
    // UI 自动显示用户信息
    return true;
  } else {
    _setError(result.message);  // → notifyListeners()
    // UI 自动显示错误信息
    return false;
  }
}
```

---

## 错误处理

### 错误类型

| 场景 | 错误信息 |
|------|---------|
| 加载用户失败 | 加载用户信息失败: {error} |
| 登录失败 | 登录时发生错误: {error} |
| 注册失败 | 注册时发生错误: {error} |
| 登出失败 | 登出时发生错误: {error} |
| API 返回错误 | result.message (来自 AuthRepository) |

### 错误显示

使用 Consumer 自动显示错误:

```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.error == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(authProvider.error!)),
        ],
      ),
    );
  },
)
```

---

## 令牌管理

### FlutterSecureStorage

使用 `flutter_secure_storage` 安全存储敏感数据:

```dart
final _secureStorage = const FlutterSecureStorage();

// 保存令牌
await _secureStorage.write(
  key: AppConstants.tokenKey,
  value: token,
);

// 读取令牌
final token = await _secureStorage.read(key: AppConstants.tokenKey);

// 删除令牌
await _secureStorage.delete(key: AppConstants.tokenKey);
```

### 令牌键

在 `AppConstants` 中定义:

```dart
class AppConstants {
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
}
```

### 令牌刷新

TODO: 实现令牌自动刷新逻辑:

```dart
Future<void> refreshToken() async {
  final refreshToken = await _secureStorage.read(
    key: AppConstants.refreshTokenKey,
  );

  if (refreshToken != null) {
    final success = await _authRepository.refreshToken(refreshToken);

    if (success) {
      // 令牌已刷新
    } else {
      // 刷新失败，需要重新登录
      await logout();
    }
  }
}
```

---

## 最佳实践

### 1. 在方法中使用 listen: false

```dart
// ✅ 正确 - 不监听状态变化
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.login(...);

// ❌ 错误 - 会导致不必要的重建
final authProvider = Provider.of<AuthProvider>(context);
await authProvider.login(...);
```

### 2. 使用 Consumer 进行响应式 UI

```dart
// ✅ 正确 - 自动更新
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return Text(authProvider.isLoading ? '加载中...' : '登录');
  },
)

// ❌ 错误 - 不会自动更新
Text(authProvider.isLoading ? '加载中...' : '登录')
```

### 3. 错误处理

```dart
// ✅ 正确 - 统一错误处理
try {
  final success = await authProvider.login(...);
  if (success) {
    // 导航
  }
  // 错误已在 Provider 中处理，UI 自动显示
} catch (e) {
  // 不需要额外处理
}

// ❌ 错误 - 重复错误处理
try {
  final success = await authProvider.login(...);
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.toString())),
  );
}
```

### 4. 清理资源

```dart
// 在 dispose 中不需要手动清理 Provider
// Provider 包会自动管理生命周期
```

---

## 测试

### 单元测试

```dart
test('login sets currentUser on success', () async {
  final authProvider = AuthProvider();

  // Mock AuthRepository
  when(mockAuthRepository.login(
    email: 'test@example.com',
    password: 'password',
  )).thenAnswer((_) async => AuthResult(
    success: true,
    user: testUser,
    token: 'test_token',
  ));

  final success = await authProvider.login(
    email: 'test@example.com',
    password: 'password',
  );

  expect(success, true);
  expect(authProvider.currentUser, isNotNull);
  expect(authProvider.error, isNull);
  expect(authProvider.isLoading, false);
});
```

### Widget 测试

```dart
testWidgets('shows loading indicator while logging in', (tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MaterialApp(home: LoginScreen()),
    ),
  );

  // 输入凭据
  await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
  await tester.enterText(find.byType(TextFormField).last, 'password');

  // 点击登录
  await tester.tap(find.text('登录'));
  await tester.pump(); // 开始异步操作

  // 验证显示加载指示器
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

---

## 扩展功能

### 计划添加的功能

1. **令牌自动刷新**: 在令牌过期前自动刷新
2. **生物识别登录**: 指纹/面容 ID
3. **记住我**: 保存用户偏好
4. **多设备登录**: 管理多个登录会话
5. **社交登录**: 微信、QQ 登录集成

### 实现示例: 令牌自动刷新

```dart
class AuthProvider extends ChangeNotifier {
  Timer? _refreshTimer;

  void _scheduleTokenRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer(const Duration(minutes: 50), () async {
      await refreshToken();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
```
