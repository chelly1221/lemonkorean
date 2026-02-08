import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/level_constants.dart';

class LevelSelector extends StatefulWidget {
  final int selectedLevel;
  final Set<int> levelsWithProgress;
  final ValueChanged<int> onLevelSelected;

  const LevelSelector({
    super.key,
    required this.selectedLevel,
    required this.levelsWithProgress,
    required this.onLevelSelected,
  });

  @override
  State<LevelSelector> createState() => _LevelSelectorState();
}

class _LevelSelectorState extends State<LevelSelector> {
  late PageController _pageController;
  double _currentPage = 0;

  static const double _viewportFraction = 0.17;
  static const double _maxSize = 80.0;
  static const double _minSize = 32.0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.selectedLevel.toDouble();
    _pageController = PageController(
      initialPage: widget.selectedLevel,
      viewportFraction: _viewportFraction,
    );
    _pageController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(LevelSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedLevel != widget.selectedLevel) {
      _animateToPage(widget.selectedLevel);
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_pageController.page != null) {
      setState(() {
        _currentPage = _pageController.page!;
      });
    }
  }

  void _animateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  double _getIconSize(int index) {
    final distance = (_currentPage - index).abs();
    if (distance >= 3) return _minSize;
    // Smooth interpolation: 0→80, 1→52, 2→40, 3→32
    final t = (distance / 3).clamp(0.0, 1.0);
    return _maxSize - (_maxSize - _minSize) * t;
  }

  double _getBorderWidth(int index) {
    final distance = (_currentPage - index).abs();
    if (distance >= 3) return 1.5;
    final t = (distance / 3).clamp(0.0, 1.0);
    return 3.0 - 1.5 * t;
  }

  @override
  Widget build(BuildContext context) {
    final centerIndex = _currentPage.round();

    return SizedBox(
      height: 110,
      child: PageView.builder(
        controller: _pageController,
        itemCount: LevelConstants.levelCount,
        onPageChanged: (index) {
          widget.onLevelSelected(index);
        },
        itemBuilder: (context, index) {
          final size = _getIconSize(index);
          final borderWidth = _getBorderWidth(index);
          final isCenter = index == centerIndex;
          final color = LevelConstants.getLevelColor(index);

          return GestureDetector(
            onTap: () {
              _animateToPage(index);
              // onPageChanged will trigger onLevelSelected automatically
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: isCenter
                            ? const Color(0xFFFFD54F)
                            : color.withValues(alpha: 0.15),
                        width: borderWidth,
                      ),
                      boxShadow: isCenter
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFFD54F)
                                    .withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: ClipOval(
                      child: Opacity(
                        opacity: isCenter ? 1.0 : 0.4,
                        child: Padding(
                          padding: EdgeInsets.all(size * 0.1),
                          child: SvgPicture.asset(
                            LevelConstants.getSvgPath(index),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCenter
                          ? const Color(0xFFFFD54F)
                          : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
