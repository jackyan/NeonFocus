import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/themes/glow_theme.dart';
import 'core/services/audio_service.dart';
import 'features/clock/presentation/screens/clock_screen.dart';
import 'features/pomodoro/presentation/screens/pomodoro_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  // Use semi-transparent status bar on Android to avoid content overlap
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.black.withOpacity(0.3), // Semi-transparent instead of fully transparent
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations (support both portrait and landscape)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const NeonFocusApp());
}

/// Main application widget
class NeonFocusApp extends StatelessWidget {
  const NeonFocusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeonFocus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: NeonTheme.cyberBlue.backgroundColor,
        primaryColor: NeonTheme.cyberBlue.primaryColor,
      ),
      home: const MainScreen(),
    );
  }
}

/// Main screen with theme switcher and page navigation
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AudioService _audioService = AudioService();
  final PageController _pageController = PageController();

  NeonTheme _currentTheme = NeonTheme.cyberBlue;
  int _currentThemeIndex = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _audioService.initialize();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _switchTheme() {
    setState(() {
      _currentThemeIndex = (_currentThemeIndex + 1) % NeonTheme.allThemes.length;
      _currentTheme = NeonTheme.allThemes[_currentThemeIndex];
    });
    _audioService.playEffect(AudioEffect.uiClick);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    HapticFeedback.selectionClick();
    _audioService.playEffect(AudioEffect.uiSwipe);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    // Responsive positioning
    final indicatorTop = isLandscape ? 10.0 : 60.0;
    final hintBottom = isLandscape ? 10.0 : 40.0;
    final hintFontSize = isLandscape ? 9.0 : 11.0;

    return GestureDetector(
      onDoubleTap: _switchTheme,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        color: _currentTheme.backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Page view for screen navigation
              PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  // Clock screen
                  ClockScreen(theme: _currentTheme),

                  // Pomodoro screen
                  PomodoroScreen(theme: _currentTheme),
                ],
              ),

              // Page indicator - with SafeArea to avoid notch
              Positioned(
                top: indicatorTop,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Center(
                    child: _buildPageIndicator(isLandscape: isLandscape),
                  ),
                ),
              ),

              // Navigation hint
              Positioned(
                bottom: hintBottom,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLandscape ? 12 : 16,
                        vertical: isLandscape ? 6 : 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentPage == 0
                            ? 'Swipe left for Timer  •  Double tap to switch theme'
                            : 'Swipe right for Clock  •  Double tap to switch theme',
                        style: TextStyle(
                          fontSize: hintFontSize,
                          color: _currentTheme.textColor.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator({bool isLandscape = false}) {
    final padding = isLandscape ? 8.0 : 12.0;
    final spacing = isLandscape ? 8.0 : 12.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.67),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _currentTheme.glowColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIndicatorDot(0, 'CLOCK', isLandscape: isLandscape),
          SizedBox(width: spacing),
          _buildIndicatorDot(1, 'TIMER', isLandscape: isLandscape),
        ],
      ),
    );
  }

  Widget _buildIndicatorDot(int index, String label, {bool isLandscape = false}) {
    final isActive = _currentPage == index;
    final fontSize = isLandscape ? 8.0 : 10.0;
    final horizontalPadding = isLandscape ? 8.0 : 12.0;
    final verticalPadding = isLandscape ? 3.0 : 4.0;

    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? _currentTheme.glowColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? _currentTheme.glowColor
                : _currentTheme.glowColor.withOpacity(0.2),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive
                ? _currentTheme.glowColor
                : _currentTheme.glowColor.withOpacity(0.5),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
