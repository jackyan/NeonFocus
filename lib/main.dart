import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'core/themes/glow_theme.dart';
import 'core/services/notification_service.dart';
import 'features/clock/presentation/screens/clock_screen_new.dart';
import 'features/pomodoro/presentation/screens/pomodoro_screen_new.dart';
import 'features/stopwatch/presentation/screens/stopwatch_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for data persistence
  await Hive.initFlutter();

  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  // Initialize notification service
  await NotificationService().initialize();
  await NotificationService().requestPermissions();

  // Set system UI to immersive mode (fullscreen, hide status bar)
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [], // Hide all system overlays
  );

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
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
  final PageController _pageController = PageController();
  NeonTheme _currentTheme = NeonTheme.cyberBlue;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changeTheme(NeonTheme newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      color: _currentTheme.backgroundColor,
      child: PageView(
        controller: _pageController,
        children: [
          // Clock screen
          ClockScreen(
            theme: _currentTheme,
            onThemeChanged: _changeTheme,
          ),

          // Pomodoro screen
          PomodoroScreen(
            theme: _currentTheme,
            onThemeChanged: _changeTheme,
          ),

          // Stopwatch screen
          StopwatchScreen(
            theme: _currentTheme,
            onThemeChanged: _changeTheme,
          ),
        ],
      ),
    );
  }
}
