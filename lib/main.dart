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

              // Page indicator
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: _buildPageIndicator(),
                ),
              ),

              // Navigation hint
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
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
                            fontSize: 11,
                            color: _currentTheme.textColor.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          _buildIndicatorDot(0, 'CLOCK'),
          const SizedBox(width: 12),
          _buildIndicatorDot(1, 'TIMER'),
        ],
      ),
    );
  }

  Widget _buildIndicatorDot(int index, String label) {
    final isActive = _currentPage == index;
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
            fontSize: 10,
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
