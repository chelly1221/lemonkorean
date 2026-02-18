import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearError);
    _passwordController.addListener(_clearError);
    _confirmPasswordController.addListener(_clearError);
    _usernameController.addListener(_clearError);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _clearError() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.error != null) {
      authProvider.clearError();
    }
  }

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
        vertical: screenHeight * 0.017,
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
              // ── 백버튼 ────────────────────────────────────────
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
                    screenHeight * 0.048,
                    hMargin,
                    screenHeight * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목
                      Text(
                        '상큼한 한국어 여행, 지금 출발!',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: screenWidth * 0.046,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF43240D),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.004),

                      // 부제목
                      Text(
                        '가볍게 출발해도 괜찮아! 내가 꽉 잡아줄게',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: screenWidth * 0.036,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7B7B7B),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.023),

                      // ── 별명 ────────────────────────────────────
                      Text(
                        '별명',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: screenWidth * 0.036,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF43240D),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.009),
                      TextFormField(
                        controller: _usernameController,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: screenWidth * 0.036,
                        ),
                        decoration: _inputDecoration(
                          '15자 이내로 문자,숫자,밑줄로 입력해주세요',
                          screenWidth,
                          screenHeight,
                        ),
                        validator: Validators.usernameValidator,
                      ),
                      SizedBox(height: screenHeight * 0.013),

                      // ── 이메일 ──────────────────────────────────
                      Text(
                        '이메일',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: screenWidth * 0.036,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF43240D),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.009),
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
                      SizedBox(height: screenHeight * 0.022),

                      // ── 비밀번호 ─────────────────────────────────
                      Text(
                        '비밀번호',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: screenWidth * 0.036,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF43240D),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.009),
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
                        validator: Validators.passwordStrictValidator,
                      ),
                      SizedBox(height: screenHeight * 0.007),

                      // ── 비밀번호 확인 ─────────────────────────────
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: screenWidth * 0.036,
                        ),
                        decoration: _inputDecoration(
                          '비밀번호를 한 번 더 입력해주세요',
                          screenWidth,
                          screenHeight,
                          suffixIcon: IconButton(
                            icon: SvgPicture.asset(
                              _isConfirmPasswordVisible
                                  ? 'assets/images/icon_eye_off.svg'
                                  : 'assets/images/icon_eye_open.svg',
                              width: screenWidth * 0.040,
                              height: screenWidth * 0.040,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF43240D),
                                BlendMode.srcIn,
                              ),
                            ),
                            onPressed: () => setState(() =>
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible),
                          ),
                        ),
                        validator: Validators.confirmPasswordValidator(
                          () => _passwordController.text,
                        ),
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

              // ── 하단 고정: 버튼 + 로그인 링크 ────────────────────
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
                                authProvider.isLoading ? null : _handleRegister,
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
                                    '회원가입',
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
                              '이미 계정이 있으신가요?',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: screenWidth * 0.036,
                                color: const Color(0xFF888888),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.015),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                '로그인하기',
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
