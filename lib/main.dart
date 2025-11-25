import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/themes/glow_theme.dart';
import 'features/clock/presentation/screens/clock_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
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

/// Main screen with theme switcher
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  NeonTheme _currentTheme = NeonTheme.cyberBlue;
  int _currentThemeIndex = 0;

  void _switchTheme() {
    setState(() {
      _currentThemeIndex = (_currentThemeIndex + 1) % NeonTheme.allThemes.length;
      _currentTheme = NeonTheme.allThemes[_currentThemeIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _switchTheme,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        color: _currentTheme.backgroundColor,
        child: Stack(
          children: [
            // Main clock screen
            ClockScreen(theme: _currentTheme),

            // Theme switcher hint
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Double tap to switch theme',
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentTheme.textColor.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
