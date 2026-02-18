import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  InputDecoration _inputDecoration(
    String hint,
    double screenWidth,
    double screenHeight, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: const Color(0xFFB0A9A4),
        fontSize: screenWidth * 0.036,
        fontWeight: FontWeight.w500,
        fontFamily: 'Pretendard',
      ),
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.041,
        vertical: screenHeight * 0.016,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Color(0xFFE9E9E9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Color(0xFFE9E9E9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Color(0xFFFFD600), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppConstants.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: AppConstants.errorColor, width: 1.5),
      ),
      filled: true,
      fillColor: const Color(0xFFFEFFF4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final hMargin = screenWidth * 0.061;

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFF4),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── 백버튼 ─────────────────────────────────────────
              SizedBox(
                height: screenHeight * 0.047,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.only(left: hMargin),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: screenWidth * 0.051,
                      color: Colors.black87,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),

              // ── 스크롤 가능한 폼 영역 ──────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    hMargin,
                    screenHeight * 0.169,
                    hMargin,
                    screenHeight * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── 메인 아이콘 ──────────────────────────────
                      SvgPicture.asset(
                        'assets/images/login_icon.svg',
                        height: screenHeight * 0.115,
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // 제목
                      Text(
                        '레몬 한국어',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: screenWidth * 0.046,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF43240D),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.010),

                      // 부제목
                      Text(
                        '레몬처럼 상큼하게, 실력은 탄탄하게!',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: screenWidth * 0.036,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7B7B7B),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.029),

                      // ── 이메일 입력칸 ────────────────────────────
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: screenWidth * 0.036,
                        ),
                        decoration: _inputDecoration(
                          '이메일을 입력해주세요',
                          screenWidth,
                          screenHeight,
                        ),
                        validator: Validators.emailValidator,
                      ),
                      SizedBox(height: screenHeight * 0.017),

                      // ── 비밀번호 입력칸 ──────────────────────────
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: screenWidth * 0.036,
                        ),
                        decoration: _inputDecoration(
                          '문자와 숫자를 포함한 8자 이상을 입력해주세요',
                          screenWidth,
                          screenHeight,
                          suffixIcon: IconButton(
                            icon: SvgPicture.asset(
                              _isPasswordVisible
                                  ? 'assets/images/icon_eye_off.svg'
                                  : 'assets/images/icon_eye_open.svg',
                              width: screenWidth * 0.040,
                              height: screenWidth * 0.040,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF43240D),
                                BlendMode.srcIn,
                              ),
                            ),
                            onPressed: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible),
                          ),
                        ),
                        validator: Validators.passwordBasicValidator,
                      ),
                      SizedBox(height: screenHeight * 0.025),

                      // ── 아이디찾기 / 비밀번호 재설정 ──────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              '아이디찾기',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: screenWidth * 0.036,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF43240D),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: screenHeight * 0.015,
                            color: const Color(0xFFE4E3E3),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              '비밀번호 재설정',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: screenWidth * 0.036,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF43240D),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ── 에러 메시지 ────────────────────────────────
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          if (authProvider.error == null) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.02),
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.041),
                              decoration: BoxDecoration(
                                color: AppConstants.errorColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppConstants.errorColor
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: AppConstants.errorColor,
                                      size: screenWidth * 0.051),
                                  SizedBox(width: screenWidth * 0.02),
                                  Expanded(
                                    child: Text(
                                      authProvider.error!,
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        color: AppConstants.errorColor,
                                        fontSize: screenWidth * 0.036,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // ── 하단 고정: 로그인 버튼 + 회원가입 링크 ───────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  hMargin,
                  screenHeight * 0.01,
                  hMargin,
                  screenHeight * 0.03,
                ),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: screenHeight * 0.05,
                          child: ElevatedButton(
                            onPressed:
                                authProvider.isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFEC6D),
                              foregroundColor: const Color(0xFF43240D),
                              disabledBackgroundColor:
                                  const Color(0xFFFFEC6D).withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero,
                              elevation: 0,
                            ),
                            child: authProvider.isLoading
                                ? SizedBox(
                                    height: screenWidth * 0.051,
                                    width: screenWidth * 0.051,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF43240D)),
                                    ),
                                  )
                                : Text(
                                    '로그인',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: screenWidth * 0.043,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.2,
                                      color: const Color(0xFF43240D),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '계정이 없으신가요?',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: screenWidth * 0.036,
                                color: const Color(0xFF888888),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.015),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                '회원가입하기',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: screenWidth * 0.036,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFFA323),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
