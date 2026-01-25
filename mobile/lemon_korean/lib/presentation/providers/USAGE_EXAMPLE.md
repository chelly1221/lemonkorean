# AuthProvider 使用示例

快速上手指南 - 如何在应用中使用 AuthProvider。

---

## 1. 在 main.dart 中配置

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/storage/local_storage.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地存储
  await LocalStorage.init();

  // 创建 AuthProvider 并加载用户
  final authProvider = AuthProvider();
  await authProvider.loadUser(); // 自动登录

  runApp(
    ChangeNotifierProvider.value(
      value: authProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lemon Korean',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      // 根据认证状态显示不同界面
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // 加载中 - 显示启动画面
          if (authProvider.isLoading) {
            return const SplashScreen();
          }

          // 已登录 - 显示首页
          if (authProvider.isLoggedIn) {
            return const HomeScreen();
          }

          // 未登录 - 显示登录界面
          return const LoginScreen();
        },
      ),
    );
  }
}
```

---

## 2. 登录界面 (LoginScreen)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 用户输入时清除错误
    _emailController.addListener(_clearError);
    _passwordController.addListener(_clearError);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearError() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.error != null) {
      authProvider.clearError();
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // 获取 Provider (不监听)
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // 调用登录方法
    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    // 登录成功 - 导航到首页
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
    // 错误信息自动显示在 UI (通过 Consumer)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                const Text(
                  '🍋',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50),
                ),
                const SizedBox(height: 16),
                const Text(
                  '柠檬韩语',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // 邮箱输入
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: '邮箱',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入邮箱';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return '请输入有效的邮箱地址';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 密码输入
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '密码',
                    prefixIcon: Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入密码';
                    }
                    if (value.length < 6) {
                      return '密码至少需要6个字符';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // 错误信息显示 (使用 Consumer 自动更新)
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.error == null) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // 登录按钮 (使用 Consumer 显示加载状态)
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              '登录',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 3. 首页 (HomeScreen) - 显示用户信息和登出

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        actions: [
          // 登出按钮
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );

              // 显示确认对话框
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('确认登出'),
                  content: const Text('确定要退出登录吗？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('确定'),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                // 调用登出
                await authProvider.logout();

                // 导航到登录界面
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          if (user == null) {
            return const Center(child: Text('未登录'));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 头像
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.amber.shade100,
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '👤',
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                const SizedBox(height: 24),

                // 用户名
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // 邮箱
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),

                // 订阅类型
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: user.isPremium
                        ? Colors.amber.shade100
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.isPremium ? '高级会员' : '免费用户',
                    style: TextStyle(
                      color: user.isPremium ? Colors.amber.shade900 : null,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

---

## 4. 启动画面 (SplashScreen) - 加载时显示

```dart
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Logo
            Text(
              '🍋',
              style: TextStyle(fontSize: 80),
            ),
            SizedBox(height: 24),

            // 应用名称
            Text(
              '柠檬韩语',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 40),

            // 加载指示器
            CircularProgressIndicator(
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 5. 常见用法模式

### 模式 1: 获取 Provider 调用方法

```dart
// 在按钮点击等事件处理中
onPressed: () async {
  final authProvider = Provider.of<AuthProvider>(
    context,
    listen: false, // 不监听状态变化
  );

  await authProvider.login(email: email, password: password);
}
```

### 模式 2: 监听状态显示 UI

```dart
// 使用 Consumer 自动更新 UI
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isLoading) {
      return const CircularProgressIndicator();
    }

    if (authProvider.error != null) {
      return Text(authProvider.error!);
    }

    return const Text('就绪');
  },
)
```

### 模式 3: 条件导航

```dart
// 根据登录状态导航
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isLoggedIn) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  },
)
```

### 模式 4: 组合多个状态

```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    // 加载中
    if (authProvider.isLoading) {
      return const LoadingWidget();
    }

    // 有错误
    if (authProvider.error != null) {
      return ErrorWidget(message: authProvider.error!);
    }

    // 已登录
    if (authProvider.isLoggedIn) {
      return WelcomeWidget(user: authProvider.currentUser!);
    }

    // 未登录
    return const LoginPromptWidget();
  },
)
```

---

## 6. 完整的注册流程示例

```dart
Future<void> _handleRegister() async {
  if (!_formKey.currentState!.validate()) return;

  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  final success = await authProvider.register(
    email: _emailController.text.trim(),
    password: _passwordController.text,
    username: _usernameController.text.trim(),
  );

  if (!mounted) return;

  if (success) {
    // 注册成功 - 显示欢迎消息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('欢迎, ${authProvider.currentUser?.username}!'),
        backgroundColor: Colors.green,
      ),
    );

    // 导航到首页
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
  // 错误信息自动显示在 UI
}
```

---

## 7. 调试技巧

### 打印状态变化

```dart
class AuthProvider extends ChangeNotifier {
  void _setLoading(bool value) {
    print('[AuthProvider] Loading: $_isLoading -> $value');
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    print('[AuthProvider] Error: $message');
    _error = message;
    notifyListeners();
  }
}
```

### 监听所有状态变化

```dart
@override
void initState() {
  super.initState();

  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  authProvider.addListener(() {
    print('AuthProvider 状态更新:');
    print('  isLoggedIn: ${authProvider.isLoggedIn}');
    print('  isLoading: ${authProvider.isLoading}');
    print('  error: ${authProvider.error}');
  });
}
```

---

## 总结

**核心概念**:
1. **Provider.of<T>(context, listen: false)** - 调用方法
2. **Consumer<T>** - 监听状态变化
3. **notifyListeners()** - 触发 UI 更新

**最佳实践**:
- ✅ 在方法调用中使用 `listen: false`
- ✅ 在 UI 显示中使用 `Consumer`
- ✅ 统一在 Provider 中处理错误
- ✅ 使用 `loadUser()` 实现自动登录
- ✅ 登出时清除所有本地数据

**注意事项**:
- ⚠️ 异步操作后检查 `mounted` 状态
- ⚠️ 不要在 Consumer 内部调用方法
- ⚠️ 记得在 dispose 中清理控制器
