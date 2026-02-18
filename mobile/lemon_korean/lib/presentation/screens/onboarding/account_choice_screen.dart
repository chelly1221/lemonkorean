import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';

/// Screen 4: Account Choice
class AccountChoiceScreen extends StatelessWidget {
  const AccountChoiceScreen({super.key});

  Future<void> _navigateToAuth(
    BuildContext context,
    SettingsProvider settingsProvider, {
    required bool toLogin,
  }) async {
    await settingsProvider.completeOnboarding();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            toLogin ? const LoginScreen() : const RegisterScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          );
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final hMargin = screenWidth * 0.055;

    return Scaffold(
      backgroundColor: const Color(0xFFFEFFF4),
      body: Stack(
        clipBehavior: Clip.none,
        children: [

          // ── 배경 타원 (화면 정중앙) ───────────────────────────
          Center(
            child: OverflowBox(
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: Transform.translate(
                offset: Offset(0, -screenHeight * 0.005),
                child: Transform.scale(
                  scaleY: 0.65,
                  child: Container(
                    width: screenWidth * 1.2,
                    height: screenWidth * 1.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFFFEF7E).withOpacity(0.5),
                          const Color(0xFFFFEF7E).withOpacity(0.0),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── UI 레이어 ─────────────────────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: screenHeight * 0.17),

                // ── Title ──────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hMargin),
                  child: Text(
                    '어서와요! 모니와 함께\n공부 루틴을 만들어볼까요?',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: screenWidth * 0.063,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      color: const Color(0xFF43240D),
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),
                ),

                SizedBox(height: screenHeight * 0.012),

                // ── Subtitle ───────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hMargin),
                  child: Text(
                    '상큼하게 시작하고, 실력은 내가 꽉 잡아줄게!',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: screenWidth * 0.036,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF7B7B7B),
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 150.ms, duration: 400.ms)
                      .slideY(begin: 0.2, end: 0, delay: 150.ms, duration: 400.ms, curve: Curves.easeOut),
                ),

                // ── 마스코트 ────────────────────────────────────
                Expanded(
                  child: Align(
                    alignment: const Alignment(0, -0.55),
                    child: SvgPicture.asset(
                      'assets/images/login_mascot.svg',
                      height: screenHeight * 0.25,
                    )
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.easeOutBack)
                        .fadeIn(delay: 200.ms, duration: 400.ms),
                  ),
                ),

                // ── 로그인하기 (텍스트만) ───────────────────────
                GestureDetector(
                  onTap: () => _navigateToAuth(context, settingsProvider, toLogin: true),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.016),
                    alignment: Alignment.center,
                    child: Text(
                      '로그인하기',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: screenWidth * 0.042,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF43240D),
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 400.ms),

                SizedBox(height: screenHeight * 0.008),

                // ── 이메일로 시작하기 ────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hMargin),
                  child: _EmailButton(
                    onPressed: () =>
                        _navigateToAuth(context, settingsProvider, toLogin: false),
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 400.ms)
                    .slideY(begin: 0.2, end: 0, delay: 500.ms, duration: 400.ms, curve: Curves.easeOut),

                SizedBox(height: screenHeight * 0.035),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class _EmailButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double screenWidth;
  final double screenHeight;

  const _EmailButton({
    required this.onPressed,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<_EmailButton> createState() => _EmailButtonState();
}

class _EmailButtonState extends State<_EmailButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.mediumImpact();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: widget.screenHeight * 0.058,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEC6D),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/mail.svg',
                width: widget.screenWidth * 0.05,
                height: widget.screenWidth * 0.05,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF43240D),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: widget.screenWidth * 0.02),
              Text(
                '이메일로 시작하기',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: widget.screenWidth * 0.042,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF43240D),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
