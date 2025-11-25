# NeonFocus - 技术实施方案

**版本**: v1.0  
**目标**: 提供完整、可执行的开发指南  
**适用对象**: 开发团队  

---

## 目录

1. [技术架构设计](#一技术架构设计)
2. [环境搭建](#二环境搭建)
3. [核心模块实现](#三核心模块实现)
4. [性能优化方案](#四性能优化方案)
5. [测试策略](#五测试策略)
6. [部署与发布](#六部署与发布)
7. [开发检查清单](#七开发检查清单)

---

## 一、技术架构设计

### 1.1 整体架构

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                      │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────┐│
│  │Clock Screen│  │Pomodoro    │  │Stopwatch   │  │Settings││
│  │  Widget    │  │  Screen    │  │  Screen    │  │ Screen ││
│  └──────┬─────┘  └──────┬─────┘  └──────┬─────┘  └───┬────┘│
│         │                │                │             │     │
│         └────────────────┴────────────────┴─────────────┘     │
│                              │                                │
├──────────────────────────────┼────────────────────────────────┤
│                    Business Logic Layer                       │
│         ┌────────────────────┴──────────────────────┐         │
│         │           BLoC / State Management         │         │
│  ┌──────┴─────┐  ┌────────┐  ┌────────┐  ┌────────┴─────┐  │
│  │  ClockBloc │  │Pomodoro│  │Stopwatch│  │SettingsBloc │  │
│  │            │  │  Bloc  │  │  Bloc   │  │             │  │
│  └──────┬─────┘  └────┬───┘  └────┬───┘  └────────┬─────┘  │
│         │             │            │                │         │
├─────────┼─────────────┼────────────┼────────────────┼─────────┤
│         │      Domain Layer (Business Logic)        │         │
│  ┌──────┴──────┐  ┌──┴────────┐  ┌──┴────────┐  ┌─┴──────┐ │
│  │   Clock     │  │  Pomodoro │  │  Stopwatch│  │Settings│ │
│  │   Model     │  │   Model   │  │   Model   │  │ Model  │ │
│  └──────┬──────┘  └─────┬─────┘  └─────┬─────┘  └───┬────┘ │
│         │                │                │            │      │
├─────────┼────────────────┼────────────────┼────────────┼──────┤
│         │        Data Layer (Repository)   │            │      │
│  ┌──────┴────────┐  ┌────┴───────┐  ┌─────┴──────┐  ┌┴────┐│
│  │  Clock Repo   │  │ Timer Repo │  │ Audio Repo │  │Prefs││
│  └───────┬───────┘  └──────┬─────┘  └──────┬─────┘  └┬────┘│
│          │                  │                │          │     │
├──────────┼──────────────────┼────────────────┼──────────┼─────┤
│          │      Infrastructure Layer         │          │     │
│  ┌───────┴────┐  ┌─────┴─────┐  ┌──────┴───┐  ┌──────┴───┐ │
│  │   Hive     │  │  Audio    │  │Notification│ │Sensors   │ │
│  │   DB       │  │  Player   │  │  Service   │ │ Service  │ │
│  └────────────┘  └───────────┘  └────────────┘ └──────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 技术栈详细配置

#### 核心框架
```yaml
# pubspec.yaml - 核心依赖
dependencies:
  flutter:
    sdk: flutter
  
  # 状态管理
  flutter_bloc: ^8.1.3           # BLoC模式
  equatable: ^2.0.5              # 对象比较
  hydrated_bloc: ^9.1.2          # 状态持久化
  
  # UI组件
  flutter_svg: ^2.0.9
  lottie: ^2.7.0                 # 动画文件
  flutter_animate: ^4.3.0        # 动画增强
  
  # 本地存储
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1
  
  # 音频
  audioplayers: ^5.2.0           # 音效播放
  just_audio: ^0.9.36            # 音景播放
  audio_session: ^0.1.16         # 音频会话管理
  
  # 传感器
  sensors_plus: ^4.0.0           # 加速度计
  
  # 通知
  flutter_local_notifications: ^16.2.0
  
  # 系统集成
  wakelock_plus: ^1.1.4          # 保持屏幕常亮
  screen_brightness: ^0.2.2+1    # 亮度控制
  battery_plus: ^5.0.2           # 电池信息
  device_info_plus: ^9.1.1       # 设备信息
  
  # 工具
  intl: ^0.18.1                  # 国际化
  uuid: ^4.2.1                   # UUID生成
  collection: ^1.18.0
  
  # 分析
  firebase_core: ^2.24.2
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # 代码生成
  build_runner: ^2.4.7
  hive_generator: ^2.0.1
  json_serializable: ^6.7.1
  
  # 测试
  bloc_test: ^9.1.5
  mocktail: ^1.0.1
  
  # 代码质量
  flutter_lints: ^3.0.1
  
  # 工具
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.3.5
```

### 1.3 项目目录结构

```
lib/
├── main.dart                          # 应用入口
│
├── core/                              # 核心功能
│   ├── constants/
│   │   ├── app_constants.dart         # 应用常量
│   │   ├── animation_constants.dart   # 动画配置
│   │   └── theme_constants.dart       # 主题常量
│   │
│   ├── themes/
│   │   ├── app_theme.dart             # 主题定义
│   │   ├── glow_theme.dart            # 辉光主题
│   │   └── color_schemes.dart         # 颜色方案
│   │
│   ├── utils/
│   │   ├── time_formatter.dart        # 时间格式化
│   │   ├── haptic_feedback.dart       # 触觉反馈
│   │   └── logger.dart                # 日志工具
│   │
│   ├── errors/
│   │   ├── exceptions.dart            # 异常定义
│   │   └── failures.dart              # 错误处理
│   │
│   └── services/
│       ├── analytics_service.dart     # 分析服务
│       ├── notification_service.dart  # 通知服务
│       ├── audio_service.dart         # 音频服务
│       ├── storage_service.dart       # 存储服务
│       ├── sensor_service.dart        # 传感器服务
│       └── iap_service.dart           # 应用内购买
│
├── features/                          # 功能模块
│   ├── clock/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── clock_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── clock_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── clock_local_datasource.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── clock_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── clock_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_current_time.dart
│   │   │       └── change_theme.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── clock_bloc.dart
│   │       │   ├── clock_event.dart
│   │       │   └── clock_state.dart
│   │       │
│   │       ├── widgets/
│   │       │   ├── glow_digit.dart
│   │       │   ├── glow_clock.dart
│   │       │   ├── theme_selector.dart
│   │       │   └── clock_controls.dart
│   │       │
│   │       └── screens/
│   │           └── clock_screen.dart
│   │
│   ├── pomodoro/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── pomodoro_model.dart
│   │   │   │   └── pomodoro_config_model.dart
│   │   │   └── repositories/
│   │   │       └── pomodoro_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── pomodoro_entity.dart
│   │   │   │   └── pomodoro_config.dart
│   │   │   └── usecases/
│   │   │       ├── start_pomodoro.dart
│   │   │       ├── pause_pomodoro.dart
│   │   │       └── complete_pomodoro.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── pomodoro_bloc.dart
│   │       │   ├── pomodoro_event.dart
│   │       │   └── pomodoro_state.dart
│   │       │
│   │       ├── widgets/
│   │       │   ├── pomodoro_timer.dart
│   │       │   ├── virtual_knob.dart
│   │       │   ├── progress_ring.dart
│   │       │   └── ambience_selector.dart
│   │       │
│   │       └── screens/
│   │           └── pomodoro_screen.dart
│   │
│   ├── stopwatch/
│   │   └── [类似结构]
│   │
│   ├── settings/
│   │   └── [类似结构]
│   │
│   └── stats/
│       └── [类似结构]
│
├── shared/                            # 共享组件
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── bottom_sheet_modal.dart
│   │   └── loading_indicator.dart
│   │
│   └── animations/
│       ├── fade_transition.dart
│       └── slide_transition.dart
│
└── l10n/                              # 国际化
    ├── app_en.arb
    ├── app_zh.arb
    └── app_ja.arb

assets/
├── fonts/
│   ├── Orbitron-Bold.ttf
│   └── ShareTechMono-Regular.ttf
│
├── sounds/
│   ├── effects/
│   │   ├── ui_click.mp3
│   │   ├── ui_swipe.mp3
│   │   ├── timer_start.mp3
│   │   ├── timer_complete.mp3
│   │   └── digit_flip.mp3
│   │
│   └── ambience/
│       ├── rain.mp3
│       ├── cafe.mp3
│       └── white_noise.mp3
│
├── animations/
│   └── digit_morph.json              # Lottie动画
│
└── images/
    └── splash_logo.png

test/
├── unit/
│   ├── bloc/
│   ├── repositories/
│   └── usecases/
│
├── widget/
│   └── widgets/
│
└── integration/
    └── app_test.dart
```

---

## 二、环境搭建

### 2.1 开发环境要求

```
硬件要求：
├─ MacBook Pro（推荐）
│   ├─ CPU: Apple M1/M2或Intel i7+
│   ├─ 内存: 16GB+
│   └─ 存储: 256GB+ SSD
│
├─ Windows PC（可选）
│   ├─ CPU: Intel i7/AMD Ryzen 7+
│   ├─ 内存: 16GB+
│   └─ 存储: 256GB+ SSD
│
└─ 测试设备
    ├─ iPhone（iOS 14+）
    ├─ Android手机（Android 8.0+）
    └─ OLED屏幕设备（防烧屏测试）

软件要求：
├─ Flutter SDK 3.16.0+
├─ Dart SDK 3.2.0+
├─ Android Studio / VS Code
├─ Xcode 15+（macOS）
├─ Git 2.30+
└─ Firebase CLI
```

### 2.2 Flutter环境配置

```bash
# 1. 安装Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# 2. 检查环境
flutter doctor -v

# 3. 配置国内镜像（可选）
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 4. 启用平台支持
flutter config --enable-ios
flutter config --enable-android

# 5. 获取依赖
flutter pub get

# 6. 生成代码
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2.3 Firebase配置

```bash
# 1. 安装Firebase CLI
npm install -g firebase-tools

# 2. 登录
firebase login

# 3. 初始化项目
flutterfire configure

# 4. 生成配置文件
# 会自动生成：
# - android/app/google-services.json
# - ios/Runner/GoogleService-Info.plist
# - lib/firebase_options.dart
```

### 2.4 IDE配置（VS Code）

```json
// .vscode/settings.json
{
  "dart.lineLength": 100,
  "dart.debugExternalPackageLibraries": true,
  "dart.debugSdkLibraries": false,
  "editor.formatOnSave": true,
  "editor.rulers": [80, 100],
  "files.associations": {
    "*.dart": "dart"
  }
}

// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug (Dev)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_dev.dart",
      "args": ["--flavor", "dev"]
    },
    {
      "name": "Release",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "flutterMode": "release"
    }
  ]
}

// .vscode/extensions.json
{
  "recommendations": [
    "dart-code.dart-code",
    "dart-code.flutter",
    "alexisvt.flutter-snippets",
    "nash.awesome-flutter-snippets"
  ]
}
```

---

## 三、核心模块实现

### 3.1 辉光数字组件

#### 基础辉光效果（初级实现）

```dart
// lib/features/clock/presentation/widgets/glow_digit.dart
import 'package:flutter/material.dart';

/// 辉光数字组件 - 使用多层模糊实现辉光效果
class GlowDigit extends StatelessWidget {
  final String digit;
  final Color glowColor;
  final GlowIntensity intensity;
  final double size;

  const GlowDigit({
    Key? key,
    required this.digit,
    required this.glowColor,
    this.intensity = GlowIntensity.medium,
    this.size = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = intensity.config;
    
    return SizedBox(
      width: size,
      height: size * 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 最外层光晕（最大模糊）
          if (config.layerCount >= 3)
            _buildGlowLayer(
              blur: config.blurRadius,
              opacity: config.opacity * 0.3,
            ),
          
          // 中层光晕
          if (config.layerCount >= 2)
            _buildGlowLayer(
              blur: config.blurRadius * 0.6,
              opacity: config.opacity * 0.5,
            ),
          
          // 内层光晕
          _buildGlowLayer(
            blur: config.blurRadius * 0.3,
            opacity: config.opacity * 0.8,
          ),
          
          // 核心数字（最清晰）
          _buildCoreDigit(),
        ],
      ),
    );
  }

  Widget _buildGlowLayer({
    required double blur,
    required double opacity,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(opacity),
            blurRadius: blur,
            spreadRadius: blur * 0.2,
          ),
        ],
      ),
      child: Text(
        digit,
        style: TextStyle(
          fontSize: size,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          color: glowColor,
        ),
      ),
    );
  }

  Widget _buildCoreDigit() {
    return Text(
      digit,
      style: TextStyle(
        fontSize: size,
        fontFamily: 'Orbitron',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: glowColor.withOpacity(0.9),
            blurRadius: 5,
          ),
        ],
      ),
    );
  }
}

/// 辉光强度配置
enum GlowIntensity {
  low(GlowConfig(blurRadius: 15, opacity: 0.4, layerCount: 1)),
  medium(GlowConfig(blurRadius: 25, opacity: 0.6, layerCount: 2)),
  high(GlowConfig(blurRadius: 40, opacity: 0.8, layerCount: 3));

  final GlowConfig config;
  const GlowIntensity(this.config);
}

class GlowConfig {
  final double blurRadius;
  final double opacity;
  final int layerCount;

  const GlowConfig({
    required this.blurRadius,
    required this.opacity,
    required this.layerCount,
  });
}
```

#### 数字切换动画

```dart
// lib/features/clock/presentation/widgets/animated_glow_digit.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 带切换动画的辉光数字
class AnimatedGlowDigit extends StatefulWidget {
  final int value;
  final Color glowColor;
  final double size;

  const AnimatedGlowDigit({
    Key? key,
    required this.value,
    required this.glowColor,
    this.size = 120,
  }) : super(key: key);

  @override
  State<AnimatedGlowDigit> createState() => _AnimatedGlowDigitState();
}

class _AnimatedGlowDigitState extends State<AnimatedGlowDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _previousValue = 0;
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _previousValue = widget.value;
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 60,
      ),
    ]).animate(_controller);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.8),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);

    _slideAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(0, -0.5)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0.5), end: Offset.zero),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(AnimatedGlowDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _currentValue = widget.value;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final displayValue = progress < 0.4 ? _previousValue : _currentValue;
        
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value.dy * widget.size * 0.3),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: GlowDigit(
                digit: displayValue.toString(),
                glowColor: widget.glowColor,
                size: widget.size,
              ),
            ),
          ),
        );
      },
    );
  }
}
```

#### 完整时钟显示

```dart
// lib/features/clock/presentation/widgets/glow_clock.dart
import 'package:flutter/material.dart';

class GlowClock extends StatelessWidget {
  final DateTime time;
  final Color glowColor;
  final bool show24Hour;
  final bool showSeconds;
  final double digitSize;

  const GlowClock({
    Key? key,
    required this.time,
    required this.glowColor,
    this.show24Hour = true,
    this.showSeconds = true,
    this.digitSize = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hour = show24Hour ? time.hour : (time.hour % 12 == 0 ? 12 : time.hour % 12);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 小时
        _buildTimeUnit(hour),
        
        _buildSeparator(),
        
        // 分钟
        _buildTimeUnit(time.minute),
        
        if (showSeconds) ...[
          _buildSeparator(),
          // 秒
          _buildTimeUnit(time.second),
        ],
      ],
    );
  }

  Widget _buildTimeUnit(int value) {
    final tens = value ~/ 10;
    final ones = value % 10;
    
    return Row(
      children: [
        AnimatedGlowDigit(
          value: tens,
          glowColor: glowColor,
          size: digitSize,
        ),
        SizedBox(width: digitSize * 0.1),
        AnimatedGlowDigit(
          value: ones,
          glowColor: glowColor,
          size: digitSize,
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: digitSize * 0.2),
      child: GlowDigit(
        digit: ':',
        glowColor: glowColor,
        size: digitSize * 0.6,
      ),
    );
  }
}
```

### 3.2 虚拟旋钮组件

```dart
// lib/features/pomodoro/presentation/widgets/virtual_knob.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class VirtualKnob extends StatefulWidget {
  final double initialValue;      // 初始值（15-60）
  final double minValue;           // 最小值
  final double maxValue;           // 最大值
  final double step;               // 步长（5分钟）
  final ValueChanged<double> onChanged;
  final Color knobColor;
  final double size;

  const VirtualKnob({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    this.minValue = 15,
    this.maxValue = 60,
    this.step = 5,
    this.knobColor = const Color(0xFF00D9FF),
    this.size = 120,
  }) : super(key: key);

  @override
  State<VirtualKnob> createState() => _VirtualKnobState();
}

class _VirtualKnobState extends State<VirtualKnob> {
  late double _currentValue;
  late double _angle;              // 当前旋转角度（弧度）
  Offset? _startPosition;
  double _lastAngle = 0;

  static const double _minAngle = -math.pi * 0.75;  // -135度
  static const double _maxAngle = math.pi * 0.75;   // 135度
  static const double _totalAngle = _maxAngle - _minAngle;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _angle = _valueToAngle(_currentValue);
  }

  double _valueToAngle(double value) {
    final normalized = (value - widget.minValue) / (widget.maxValue - widget.minValue);
    return _minAngle + (normalized * _totalAngle);
  }

  double _angleToValue(double angle) {
    final normalized = (angle - _minAngle) / _totalAngle;
    final value = widget.minValue + (normalized * (widget.maxValue - widget.minValue));
    return value.clamp(widget.minValue, widget.maxValue);
  }

  double _snapToStep(double value) {
    return (value / widget.step).round() * widget.step;
  }

  void _onPanStart(DragStartDetails details) {
    _startPosition = details.localPosition;
    _lastAngle = _angle;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_startPosition == null) return;

    final center = Offset(widget.size / 2, widget.size / 2);
    final position = details.localPosition - center;
    final newAngle = math.atan2(position.dy, position.dx) + math.pi / 2;
    
    // 计算角度变化
    double deltaAngle = newAngle - _lastAngle;
    
    // 处理角度跨越问题
    if (deltaAngle > math.pi) {
      deltaAngle -= 2 * math.pi;
    } else if (deltaAngle < -math.pi) {
      deltaAngle += 2 * math.pi;
    }
    
    _lastAngle = newAngle;
    
    setState(() {
      _angle = (_angle + deltaAngle).clamp(_minAngle, _maxAngle);
      final newValue = _snapToStep(_angleToValue(_angle));
      
      if (newValue != _currentValue) {
        _currentValue = newValue;
        widget.onChanged(_currentValue);
        
        // 触觉反馈
        HapticFeedback.selectionClick();
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _startPosition = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 背景圆环
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _KnobBackgroundPainter(
                color: widget.knobColor.withOpacity(0.2),
              ),
            ),
            
            // 进度圆环
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _KnobProgressPainter(
                progress: (_angle - _minAngle) / _totalAngle,
                color: widget.knobColor,
              ),
            ),
            
            // 旋钮指示器
            Transform.rotate(
              angle: _angle,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _KnobIndicatorPainter(color: widget.knobColor),
              ),
            ),
            
            // 中心数值显示
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentValue.toInt().toString(),
                  style: TextStyle(
                    fontSize: widget.size * 0.35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Orbitron',
                  ),
                ),
                Text(
                  'MIN',
                  style: TextStyle(
                    fontSize: widget.size * 0.12,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 旋钮背景绘制器
class _KnobBackgroundPainter extends CustomPainter {
  final Color color;

  _KnobBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 绘制背景圆环
    canvas.drawCircle(center, radius, paint);
    
    // 绘制刻度标记
    final tickPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 12; i++) {
      final angle = -math.pi * 0.75 + (i / 11) * math.pi * 1.5;
      final startRadius = radius - 5;
      final endRadius = radius + 5;
      
      final start = Offset(
        center.dx + startRadius * math.cos(angle - math.pi / 2),
        center.dy + startRadius * math.sin(angle - math.pi / 2),
      );
      
      final end = Offset(
        center.dx + endRadius * math.cos(angle - math.pi / 2),
        center.dy + endRadius * math.sin(angle - math.pi / 2),
      );
      
      canvas.drawLine(start, end, tickPaint);
    }
  }

  @override
  bool shouldRepaint(_KnobBackgroundPainter oldDelegate) => false;
}

/// 旋钮进度绘制器
class _KnobProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _KnobProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(0.3),
          color,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final sweepAngle = math.pi * 1.5 * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 1.25,  // 起始角度
      sweepAngle,       // 扫过角度
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_KnobProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// 旋钮指示器绘制器
class _KnobIndicatorPainter extends CustomPainter {
  final Color color;

  _KnobIndicatorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    final indicatorPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 绘制指示器（小圆点）
    final indicatorPos = Offset(
      center.dx,
      center.dy - radius + 5,
    );
    
    canvas.drawCircle(indicatorPos, 6, indicatorPaint);
    
    // 绘制辉光效果
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawCircle(indicatorPos, 10, glowPaint);
  }

  @override
  bool shouldRepaint(_KnobIndicatorPainter oldDelegate) => false;
}
```

### 3.3 重力感应交互

```dart
// lib/core/services/sensor_service.dart
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

enum PhoneOrientation {
  faceUp,      // 屏幕朝上
  faceDown,    // 屏幕朝下
  upright,     // 竖立
  unknown,
}

class SensorService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  
  PhoneOrientation _currentOrientation = PhoneOrientation.unknown;
  DateTime? _orientationChangeTime;
  
  // 配置
  final double threshold;                    // 阈值（m/s²）
  final Duration holdDuration;               // 持续时间要求
  final VoidCallback? onFaceDown;           // 屏幕朝下回调
  final VoidCallback? onFaceUp;             // 屏幕朝上回调
  
  Timer? _holdTimer;

  SensorService({
    this.threshold = 8.0,
    this.holdDuration = const Duration(seconds: 2),
    this.onFaceDown,
    this.onFaceUp,
  });

  /// 启动传感器监听
  void startListening() {
    _accelerometerSubscription = accelerometerEvents.listen(
      _handleAccelerometerEvent,
      onError: (error) {
        print('Accelerometer error: $error');
      },
    );
  }

  /// 停止监听
  void stopListening() {
    _accelerometerSubscription?.cancel();
    _holdTimer?.cancel();
  }

  void _handleAccelerometerEvent(AccelerometerEvent event) {
    final newOrientation = _detectOrientation(event);
    
    if (newOrientation != _currentOrientation) {
      _currentOrientation = newOrientation;
      _orientationChangeTime = DateTime.now();
      _holdTimer?.cancel();
      
      // 启动持续时间计时器
      if (newOrientation == PhoneOrientation.faceDown ||
          newOrientation == PhoneOrientation.faceUp) {
        _holdTimer = Timer(holdDuration, () {
          _triggerOrientationAction(newOrientation);
        });
      }
    }
  }

  PhoneOrientation _detectOrientation(AccelerometerEvent event) {
    // Z轴加速度判断
    if (event.z < -threshold) {
      return PhoneOrientation.faceDown;  // 屏幕朝下
    } else if (event.z > threshold) {
      return PhoneOrientation.faceUp;     // 屏幕朝上
    } else {
      return PhoneOrientation.upright;    // 竖立或其他
    }
  }

  void _triggerOrientationAction(PhoneOrientation orientation) {
    switch (orientation) {
      case PhoneOrientation.faceDown:
        onFaceDown?.call();
        break;
      case PhoneOrientation.faceUp:
        onFaceUp?.call();
        break;
      default:
        break;
    }
  }

  void dispose() {
    stopListening();
  }
}

// 使用示例
class PomodoroScreen extends StatefulWidget {
  // ...
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  late SensorService _sensorService;
  
  @override
  void initState() {
    super.initState();
    
    _sensorService = SensorService(
      onFaceDown: _handleFaceDown,
      onFaceUp: _handleFaceUp,
    );
    
    _sensorService.startListening();
  }

  void _handleFaceDown() {
    // 屏幕朝下 → 开始专注
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('开始专注'),
        content: const Text('检测到手机扣下，即将开始计时'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PomodoroBloc>().add(StartPomodoro());
            },
            child: const Text('确定'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  void _handleFaceUp() {
    // 屏幕朝上 → 暂停
    if (context.read<PomodoroBloc>().state.isRunning) {
      context.read<PomodoroBloc>().add(PausePomodoro());
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('专注已暂停'),
          content: const Text('检测到手机拿起，已暂停计时'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<PomodoroBloc>().add(ResumePomodoro());
              },
              child: const Text('继续'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }
}
```

### 3.4 音频系统

```dart
// lib/core/services/audio_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  // 音效播放器（短音效）
  final AudioPlayer _effectPlayer = AudioPlayer();
  
  // 音景播放器（长音频循环）
  final AudioPlayer _ambiencePlayer = AudioPlayer();
  
  // 当前播放的音景
  String? _currentAmbience;
  
  // 音量
  double _effectVolume = 0.5;
  double _ambienceVolume = 0.7;

  AudioService() {
    _initialize();
  }

  Future<void> _initialize() async {
    // 配置音景播放器为循环模式
    await _ambiencePlayer.setReleaseMode(ReleaseMode.loop);
  }

  /// 播放UI音效
  Future<void> playEffect(AudioEffect effect) async {
    try {
      await _effectPlayer.setVolume(_effectVolume);
      await _effectPlayer.play(
        AssetSource('sounds/effects/${effect.filename}'),
      );
    } catch (e) {
      print('Error playing effect: $e');
    }
  }

  /// 开始播放音景
  Future<void> startAmbience(String ambienceName) async {
    if (_currentAmbience == ambienceName &&
        _ambiencePlayer.state == PlayerState.playing) {
      return; // 已在播放中
    }

    try {
      _currentAmbience = ambienceName;
      
      await _ambiencePlayer.setVolume(_ambienceVolume);
      await _ambiencePlayer.play(
        AssetSource('sounds/ambience/$ambienceName.mp3'),
      );
    } catch (e) {
      print('Error playing ambience: $e');
    }
  }

  /// 停止音景
  Future<void> stopAmbience() async {
    await _ambiencePlayer.stop();
    _currentAmbience = null;
  }

  /// 暂停音景
  Future<void> pauseAmbience() async {
    await _ambiencePlayer.pause();
  }

  /// 恢复音景
  Future<void> resumeAmbience() async {
    await _ambiencePlayer.resume();
  }

  /// 设置音效音量
  Future<void> setEffectVolume(double volume) async {
    _effectVolume = volume.clamp(0.0, 1.0);
    await _effectPlayer.setVolume(_effectVolume);
  }

  /// 设置音景音量
  Future<void> setAmbienceVolume(double volume) async {
    _ambienceVolume = volume.clamp(0.0, 1.0);
    await _ambiencePlayer.setVolume(_ambienceVolume);
  }

  /// 音量淡入淡出
  Future<void> fadeAmbienceVolume({
    required double targetVolume,
    Duration duration = const Duration(seconds: 2),
  }) async {
    final startVolume = _ambienceVolume;
    final steps = 20;
    final stepDuration = duration.inMilliseconds ~/ steps;
    final volumeStep = (targetVolume - startVolume) / steps;

    for (int i = 0; i < steps; i++) {
      await Future.delayed(Duration(milliseconds: stepDuration));
      final newVolume = startVolume + (volumeStep * (i + 1));
      await setAmbienceVolume(newVolume);
    }
  }

  /// 释放资源
  void dispose() {
    _effectPlayer.dispose();
    _ambiencePlayer.dispose();
  }
}

/// 音效枚举
enum AudioEffect {
  uiClick('ui_click.mp3'),
  uiSwipe('ui_swipe.mp3'),
  timerStart('timer_start.mp3'),
  timerComplete('timer_complete.mp3'),
  digitFlip('digit_flip.mp3');

  final String filename;
  const AudioEffect(this.filename);
}

/// 预设音景
enum Ambience {
  rain('rain', 'Rain', '雨声'),
  cafe('cafe', 'Cafe', '咖啡馆'),
  whiteNoise('white_noise', 'White Noise', '白噪音'),
  forest('forest', 'Forest', '森林'),  // 付费
  ocean('ocean', 'Ocean', '海浪'),      // 付费
  lofi('lofi', 'Lo-Fi', 'Lo-Fi音乐');  // 付费

  final String id;
  final String nameEn;
  final String nameZh;
  
  const Ambience(this.id, this.nameEn, this.nameZh);
  
  bool get isPremium => [forest, ocean, lofi].contains(this);
}
```

### 3.5 防烧屏机制

```dart
// lib/core/services/burn_in_protection.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class BurnInProtection {
  Timer? _pixelShiftTimer;
  Timer? _rotationTimer;
  Timer? _brightnessTimer;
  
  // 偏移参数
  Offset _currentOffset = Offset.zero;
  double _currentRotation = 0.0;
  
  // 配置
  final Duration pixelShiftInterval;
  final double maxPixelShift;
  final Duration rotationInterval;
  final double maxRotation;
  
  // 回调
  final ValueChanged<Offset>? onOffsetChanged;
  final ValueChanged<double>? onRotationChanged;
  final ValueChanged<double>? onBrightnessChanged;

  BurnInProtection({
    this.pixelShiftInterval = const Duration(minutes: 5),
    this.maxPixelShift = 10.0,
    this.rotationInterval = const Duration(minutes: 30),
    this.maxRotation = 1.0,  // 度数
    this.onOffsetChanged,
    this.onRotationChanged,
    this.onBrightnessChanged,
  });

  /// 启动防烧屏保护
  void start() {
    _startPixelShift();
    _startRotation();
    _startBrightnessAdjustment();
  }

  /// 停止保护
  void stop() {
    _pixelShiftTimer?.cancel();
    _rotationTimer?.cancel();
    _brightnessTimer?.cancel();
  }

  /// 像素偏移
  void _startPixelShift() {
    _pixelShiftTimer?.cancel();
    
    _pixelShiftTimer = Timer.periodic(pixelShiftInterval, (timer) {
      final random = Random();
      
      // 在±maxPixelShift范围内随机偏移
      _currentOffset = Offset(
        (random.nextDouble() * 2 - 1) * maxPixelShift,
        (random.nextDouble() * 2 - 1) * maxPixelShift,
      );
      
      onOffsetChanged?.call(_currentOffset);
    });
  }

  /// 旋转偏移
  void _startRotation() {
    _rotationTimer?.cancel();
    
    _rotationTimer = Timer.periodic(rotationInterval, (timer) {
      final random = Random();
      
      // 在±maxRotation范围内随机旋转
      _currentRotation = (random.nextDouble() * 2 - 1) * maxRotation * pi / 180;
      
      onRotationChanged?.call(_currentRotation);
    });
  }

  /// 亮度自动调节（根据时间）
  void _startBrightnessAdjustment() {
    _brightnessTimer?.cancel();
    
    _brightnessTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final hour = DateTime.now().hour;
      double brightness;
      
      if (hour >= 23 || hour < 6) {
        // 深夜：极低亮度
        brightness = 0.1;
      } else if (hour >= 6 && hour < 9) {
        // 早晨：渐变提升
        brightness = 0.3 + (hour - 6) * 0.1;
      } else if (hour >= 9 && hour < 21) {
        // 白天：正常亮度
        brightness = 0.7;
      } else {
        // 晚上：中等亮度
        brightness = 0.5;
      }
      
      onBrightnessChanged?.call(brightness);
    });
    
    // 立即执行一次
    _brightnessTimer?.tick = 0;
  }

  void dispose() {
    stop();
  }
}

/// 防烧屏包装Widget
class BurnInProtectionWrapper extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const BurnInProtectionWrapper({
    Key? key,
    required this.child,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<BurnInProtectionWrapper> createState() =>
      _BurnInProtectionWrapperState();
}

class _BurnInProtectionWrapperState extends State<BurnInProtectionWrapper> {
  late BurnInProtection _protection;
  Offset _offset = Offset.zero;
  double _rotation = 0.0;

  @override
  void initState() {
    super.initState();
    
    _protection = BurnInProtection(
      onOffsetChanged: (offset) {
        if (mounted) setState(() => _offset = offset);
      },
      onRotationChanged: (rotation) {
        if (mounted) setState(() => _rotation = rotation);
      },
      onBrightnessChanged: (brightness) {
        // 调用亮度控制服务
        // ScreenBrightness().setScreenBrightness(brightness);
      },
    );
    
    if (widget.enabled) {
      _protection.start();
    }
  }

  @override
  void didUpdateWidget(BurnInProtectionWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _protection.start();
      } else {
        _protection.stop();
        setState(() {
          _offset = Offset.zero;
          _rotation = 0.0;
        });
      }
    }
  }

  @override
  void dispose() {
    _protection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Transform.translate(
      offset: _offset,
      child: Transform.rotate(
        angle: _rotation,
        child: widget.child,
      ),
    );
  }
}
```

---

## 四、性能优化方案

### 4.1 渲染性能优化

```dart
// lib/core/utils/performance_optimizer.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PerformanceOptimizer {
  static final PerformanceOptimizer _instance = PerformanceOptimizer._internal();
  factory PerformanceOptimizer() => _instance;
  PerformanceOptimizer._internal();

  // 帧率监控
  int _frameCount = 0;
  int _droppedFrames = 0;
  DateTime _lastFrameTime = DateTime.now();

  /// 监控帧率
  void startFPSMonitoring() {
    SchedulerBinding.instance.addPersistentFrameCallback(_onFrame);
  }

  void _onFrame(Duration timestamp) {
    _frameCount++;
    final now = DateTime.now();
    final elapsed = now.difference(_lastFrameTime).inMilliseconds;
    
    if (elapsed >= 1000) {
      final fps = _frameCount;
      _droppedFrames = 60 - fps;
      
      if (_droppedFrames > 10) {
        print('Warning: Dropped $_droppedFrames frames in last second');
        _suggestOptimization();
      }
      
      _frameCount = 0;
      _lastFrameTime = now;
    }
  }

  void _suggestOptimization() {
    // 根据掉帧情况建议优化
    // 可以动态降低辉光效果强度等
  }

  /// 根据设备性能自动调整辉光效果
  static GlowIntensity getOptimalGlowIntensity() {
    // 这里可以根据设备型号、RAM等信息判断
    // 简化示例：
    return GlowIntensity.medium;
  }

  /// 缓存复杂Widget
  static Widget cacheComplexWidget(Widget child) {
    return RepaintBoundary(
      child: child,
    );
  }
}

/// 性能分析工具
class PerformanceOverlay extends StatelessWidget {
  final Widget child;
  final bool showFPS;

  const PerformanceOverlay({
    Key? key,
    required this.child,
    this.showFPS = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showFPS) return child;

    return Stack(
      children: [
        child,
        Positioned(
          top: 50,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const FPSIndicator(),
          ),
        ),
      ],
    );
  }
}

class FPSIndicator extends StatefulWidget {
  const FPSIndicator({Key? key}) : super(key: key);

  @override
  State<FPSIndicator> createState() => _FPSIndicatorState();
}

class _FPSIndicatorState extends State<FPSIndicator> {
  int _fps = 60;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    int frameCount = 0;
    DateTime lastTime = DateTime.now();
    
    SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
      frameCount++;
      final now = DateTime.now();
      if (now.difference(lastTime).inMilliseconds >= 1000) {
        if (mounted) {
          setState(() => _fps = frameCount);
        }
        frameCount = 0;
        lastTime = now;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_fps FPS',
      style: TextStyle(
        color: _fps >= 55 ? Colors.green : Colors.red,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
```

### 4.2 内存优化

```dart
// lib/core/utils/memory_manager.dart
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  // 缓存管理
  final Map<String, dynamic> _cache = {};
  final int _maxCacheSize = 50; // MB

  /// 添加到缓存
  void cache(String key, dynamic value) {
    if (_cache.length > 100) {
      // 简单的LRU实现：移除最早的项
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }

  /// 从缓存获取
  T? getFromCache<T>(String key) {
    return _cache[key] as T?;
  }

  /// 清理缓存
  void clearCache() {
    _cache.clear();
  }

  /// 监控内存使用
  void monitorMemory() {
    if (kDebugMode) {
      developer.Timeline.startSync('MemoryMonitoring');
      // 这里可以添加更详细的内存监控逻辑
      developer.Timeline.finishSync();
    }
  }

  /// 图片缓存清理
  void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}
```

### 4.3 电量优化策略

```dart
// lib/core/services/battery_optimizer.dart
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class BatteryOptimizer {
  final Battery _battery = Battery();
  
  BatteryState _batteryState = BatteryState.full;
  int _batteryLevel = 100;
  
  // 回调
  final VoidCallback? onLowBattery;
  final VoidCallback? onCharging;

  BatteryOptimizer({
    this.onLowBattery,
    this.onCharging,
  });

  /// 初始化电池监控
  Future<void> initialize() async {
    _batteryLevel = await _battery.batteryLevel;
    
    _battery.onBatteryStateChanged.listen((state) {
      _batteryState = state;
      
      if (state == BatteryState.charging) {
        onCharging?.call();
      }
    });
  }

  /// 获取推荐的性能配置
  PerformanceConfig getRecommendedConfig() {
    if (_batteryState == BatteryState.charging) {
      // 充电中：全性能
      return PerformanceConfig.high;
    } else if (_batteryLevel < 20) {
      // 低电量：省电模式
      return PerformanceConfig.low;
    } else if (_batteryLevel < 50) {
      // 中等电量：平衡模式
      return PerformanceConfig.medium;
    } else {
      // 高电量：正常模式
      return PerformanceConfig.high;
    }
  }

  /// 应用省电配置
  void applyPowerSavingMode() {
    // 降低辉光效果
    // 降低刷新率
    // 降低音量
    // 关闭粒子动画
  }
}

/// 性能配置
enum PerformanceConfig {
  low(
    glowIntensity: GlowIntensity.low,
    frameRate: 30,
    enableParticles: false,
  ),
  medium(
    glowIntensity: GlowIntensity.medium,
    frameRate: 60,
    enableParticles: false,
  ),
  high(
    glowIntensity: GlowIntensity.high,
    frameRate: 60,
    enableParticles: true,
  );

  final GlowIntensity glowIntensity;
  final int frameRate;
  final bool enableParticles;

  const PerformanceConfig({
    required this.glowIntensity,
    required this.frameRate,
    required this.enableParticles,
  });
}
```

---

## 五、测试策略

### 5.1 单元测试

```dart
// test/features/clock/domain/usecases/change_theme_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClockRepository extends Mock implements ClockRepository {}

void main() {
  late ChangeTheme usecase;
  late MockClockRepository mockRepository;

  setUp(() {
    mockRepository = MockClockRepository();
    usecase = ChangeTheme(mockRepository);
  });

  test('should change theme successfully', () async {
    // arrange
    final theme = GlowTheme.cyberBlue;
    when(() => mockRepository.saveTheme(theme))
        .thenAnswer((_) async => Right(unit));

    // act
    final result = await usecase(theme);

    // assert
    expect(result, Right(unit));
    verify(() => mockRepository.saveTheme(theme)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    final theme = GlowTheme.cyberBlue;
    when(() => mockRepository.saveTheme(theme))
        .thenAnswer((_) async => Left(CacheFailure()));

    // act
    final result = await usecase(theme);

    // assert
    expect(result, Left(CacheFailure()));
    verify(() => mockRepository.saveTheme(theme)).called(1);
  });
}
```

### 5.2 Widget测试

```dart
// test/features/clock/presentation/widgets/glow_clock_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('GlowClock displays time correctly', (tester) async {
    // arrange
    final testTime = DateTime(2024, 1, 1, 14, 30, 45);
    
    // act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlowClock(
            time: testTime,
            glowColor: const Color(0xFF00D9FF),
            show24Hour: true,
            showSeconds: true,
          ),
        ),
      ),
    );

    // assert
    expect(find.text('14'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('45'), findsOneWidget);
    expect(find.text(':'), findsNWidgets(2));
  });

  testWidgets('GlowClock animates on time change', (tester) async {
    // arrange
    var time = DateTime(2024, 1, 1, 14, 30, 59);
    
    // act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlowClock(
            time: time,
            glowColor: const Color(0xFF00D9FF),
          ),
        ),
      ),
    );

    // 时间变化
    time = DateTime(2024, 1, 1, 14, 31, 0);
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlowClock(
            time: time,
            glowColor: const Color(0xFF00D9FF),
          ),
        ),
      ),
    );

    // 等待动画
    await tester.pumpAndSettle();

    // assert
    expect(find.text('31'), findsOneWidget);
  });
}
```

### 5.3 性能测试

```dart
// test/performance/glow_effect_performance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Glow effect maintains 60fps', (tester) async {
    // 性能基准测试
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlowClock(
            time: DateTime.now(),
            glowColor: Color(0xFF00D9FF),
          ),
        ),
      ),
    );

    // 测量渲染时间
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 60; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    stopwatch.stop();

    // 断言：60帧应在1秒内完成
    expect(stopwatch.elapsedMilliseconds, lessThan(1100));
  });
}
```

### 5.4 集成测试

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:neonfocus/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Complete pomodoro flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. 切换到番茄钟页面
      await tester.drag(
        find.byType(GlowClock),
        const Offset(-300, 0),
      );
      await tester.pumpAndSettle();

      // 2. 调节旋钮到25分钟
      final knob = find.byType(VirtualKnob);
      expect(knob, findsOneWidget);

      // 3. 选择音景
      await tester.tap(find.text('Rain'));
      await tester.pumpAndSettle();

      // 4. 开始计时
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pumpAndSettle();

      // 5. 验证状态
      expect(find.text('25:00'), findsOneWidget);
      
      // 6. 暂停
      await tester.tap(find.byIcon(Icons.pause));
      await tester.pumpAndSettle();
    });

    testWidgets('Theme switching works', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. 上滑打开主题选择器
      await tester.drag(
        find.byType(GlowClock),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // 2. 选择新主题
      await tester.tap(find.text('Neon Purple'));
      await tester.pumpAndSettle();

      // 3. 验证主题已更改
      // (通过颜色检查等方式验证)
    });
  });
}
```

---

## 六、部署与发布

### 6.1 Android打包配置

```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.neonfocus.app"
        minSdkVersion 26
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

```bash
# 构建Release版本
flutter build apk --release --split-per-abi
flutter build appbundle --release
```

### 6.2 iOS打包配置

```bash
# 1. 更新版本号
flutter pub run flutter_version --version=1.0.0+1

# 2. 构建iOS
flutter build ios --release

# 3. 打开Xcode归档
open ios/Runner.xcworkspace

# 4. 在Xcode中：
# Product -> Archive
# Window -> Organizer -> Distribute App
```

### 6.3 应用商店元数据

```yaml
# store_listing.yaml

app_name: "NeonFocus - 赛博专注时钟"

short_description: |
  科技美学时钟 + 环境音景 + 专注工具

full_description: |
  NeonFocus 是一款集视觉美学与听觉氛围于一体的专注时钟应用。
  
  ✨ 核心功能：
  • 辉光管风格数字时钟
  • 番茄钟专注计时
  • 环境音景播放
  • 重力感应交互
  
  🎨 视觉设计：
  • 10+种赛博朋克主题
  • 流畅的辉光动画
  • OLED屏幕优化
  • 防烧屏保护
  
  🎵 听觉体验：
  • 50+高品质音景
  • Lo-Fi音乐库
  • 音景混合器
  • 自适应播放
  
  ⚙️ 创新交互：
  • 扣手机开始专注
  • 虚拟旋钮调节
  • 充电自动启动
  • Widget支持

keywords: |
  专注,时钟,番茄钟,辉光管,赛博朋克,白噪音,ASMR,桌面美学

category: Productivity

age_rating: 4+

privacy_policy_url: https://neonfocus.app/privacy

support_url: https://neonfocus.app/support

promotional_text: |
  限时优惠：首月订阅半价！
```

---

## 七、开发检查清单

### Phase 0: 环境准备 ✓

- [ ] Flutter SDK安装配置
- [ ] IDE安装（VS Code/Android Studio）
- [ ] Git仓库初始化
- [ ] Firebase项目创建
- [ ] 设计资源准备（字体、音效、图标）
- [ ] 项目目录结构创建
- [ ] 依赖包安装
- [ ] 代码生成配置

### Phase 1: 核心UI开发（Week 1-2）

#### Week 1
- [ ] 创建基础应用骨架
- [ ] 实现GlowDigit组件
  - [ ] 基础辉光效果
  - [ ] 多层光晕
  - [ ] 性能优化
- [ ] 实现AnimatedGlowDigit
  - [ ] 数字切换动画
  - [ ] 淡入淡出效果
  - [ ] 缩放动画
- [ ] 实现GlowClock组件
  - [ ] 时分秒显示
  - [ ] 分隔符动画
  - [ ] 日期显示

#### Week 2
- [ ] 实现3种主题
  - [ ] 赛博蓝主题
  - [ ] 霓虹紫主题
  - [ ] 极简黑主题
- [ ] 主题切换器
  - [ ] 主题预览
  - [ ] 切换动画
  - [ ] 保存偏好设置
- [ ] 页面切换动画
  - [ ] 左滑/右滑手势
  - [ ] PageView集成
  - [ ] 页面指示器

### Phase 2: 功能开发（Week 3-4）

#### Week 3
- [ ] 番茄钟逻辑
  - [ ] 倒计时核心逻辑
  - [ ] 工作/休息状态管理
  - [ ] 完成次数统计
- [ ] VirtualKnob组件
  - [ ] 旋钮绘制
  - [ ] 拖动交互
  - [ ] 触觉反馈
  - [ ] 数值吸附
- [ ] Pomodoro BLoC
  - [ ] 状态定义
  - [ ] 事件处理
  - [ ] 状态持久化

#### Week 4
- [ ] 重力感应集成
  - [ ] SensorService实现
  - [ ] 扣手机检测
  - [ ] 拿起手机检测
  - [ ] 确认对话框
- [ ] 手势系统
  - [ ] 左滑切换
  - [ ] 右滑切换
  - [ ] 上滑主题
  - [ ] 点击设置
- [ ] 设置页面
  - [ ] 基础设置项
  - [ ] 偏好设置保存
  - [ ] 关于页面

### Phase 3: 音频集成（Week 5-6）

#### Week 5
- [ ] AudioService实现
  - [ ] 音效播放器
  - [ ] 音景播放器
  - [ ] 音量控制
  - [ ] 淡入淡出
- [ ] 音效集成
  - [ ] UI交互音效
  - [ ] 计时器音效
  - [ ] 完成提示音
- [ ] 音景文件准备
  - [ ] 雨声音景
  - [ ] 咖啡馆音景
  - [ ] 白噪音音景

#### Week 6
- [ ] 音景选择器UI
  - [ ] 音景列表
  - [ ] 预览播放
  - [ ] 音量滑块
- [ ] 自动播放逻辑
  - [ ] 番茄钟启动播放
  - [ ] 番茄钟结束停止
  - [ ] 后台播放支持
- [ ] 音频会话管理
  - [ ] 与其他App协调
  - [ ] 蓝牙设备支持

### Phase 4: 系统集成（Week 7-8）

#### Week 7
- [ ] 通知系统
  - [ ] 通知权限请求
  - [ ] 倒计时结束通知
  - [ ] 通知点击处理
- [ ] 防烧屏机制
  - [ ] 像素偏移
  - [ ] 旋转偏移
  - [ ] 亮度自适应
- [ ] 充电检测
  - [ ] 充电状态监听
  - [ ] 自动启动（Android）
  - [ ] 快捷指令（iOS）

#### Week 8
- [ ] 性能优化
  - [ ] FPS监控
  - [ ] 内存优化
  - [ ] 电量优化
  - [ ] 包体积优化
- [ ] 秒表功能
  - [ ] 正向计时
  - [ ] 圈速记录
  - [ ] 暂停/重置
- [ ] Widget支持（可选）
  - [ ] iOS Widget
  - [ ] Android Widget

### Phase 5: 测试与优化（Week 9-10）

#### Week 9
- [ ] 单元测试
  - [ ] BLoC测试
  - [ ] Repository测试
  - [ ] UseCase测试
- [ ] Widget测试
  - [ ] 组件测试
  - [ ] 交互测试
- [ ] 性能测试
  - [ ] 帧率测试
  - [ ] 内存泄漏检测
  - [ ] 电量消耗测试

#### Week 10
- [ ] 集成测试
  - [ ] 完整流程测试
  - [ ] 边界情况测试
- [ ] 多设备测试
  - [ ] iOS测试（14+）
  - [ ] Android测试（8.0+）
  - [ ] OLED设备测试
- [ ] Bug修复
  - [ ] Crash修复
  - [ ] UI问题修复
  - [ ] 性能问题修复

### Phase 6: 上线准备（Week 11-12）

#### Week 11
- [ ] 应用商店准备
  - [ ] 截图制作
  - [ ] 宣传视频
  - [ ] 应用描述
  - [ ] 关键词优化
- [ ] 法律文档
  - [ ] 隐私政策
  - [ ] 用户协议
  - [ ] 开源许可声明
- [ ] 打包配置
  - [ ] 签名配置
  - [ ] ProGuard规则
  - [ ] App图标
  - [ ] 启动页

#### Week 12
- [ ] Beta测试
  - [ ] TestFlight（iOS）
  - [ ] Internal Testing（Android）
  - [ ] 收集反馈
  - [ ] 迭代优化
- [ ] 正式发布
  - [ ] App Store提交
  - [ ] Google Play提交
  - [ ] 审核跟进
- [ ] 发布后
  - [ ] 监控Crash
  - [ ] 收集用户反馈
  - [ ] 规划下一版本

---

## 附录A：常用命令速查

```bash
# Flutter命令
flutter doctor                    # 检查环境
flutter pub get                   # 获取依赖
flutter pub upgrade              # 升级依赖
flutter clean                     # 清理构建
flutter analyze                   # 静态分析
flutter test                      # 运行测试
flutter run --release            # Release模式运行

# 代码生成
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch  # 监听模式

# 构建
flutter build apk --release --split-per-abi    # Android APK
flutter build appbundle --release              # Android AAB
flutter build ios --release                     # iOS

# 分析工具
flutter pub run dart_code_metrics:metrics analyze lib  # 代码指标
flutter pub run dart_code_metrics:metrics check-unused-files lib  # 未使用文件

# Git命令
git checkout -b feature/glow-effect      # 创建功能分支
git add .                                 # 添加更改
git commit -m "feat: add glow effect"   # 提交
git push origin feature/glow-effect      # 推送
```

---

## 附录B：问题排查指南

### 问题1：辉光效果性能差

**症状**：帧率低于40fps，卡顿明显

**排查步骤**：
1. 检查是否使用了过多的模糊层
2. 验证是否使用了RepaintBoundary
3. 检查是否有不必要的Widget重建
4. 使用Flutter DevTools的Performance视图分析

**解决方案**：
```dart
// 错误示例
Widget build(BuildContext context) {
  return BackdropFilter(  // 每帧都重建
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: ExpensiveWidget(),
  );
}

// 正确示例
Widget build(BuildContext context) {
  return RepaintBoundary(  // 隔离重绘
    child: CachedGlowWidget(),
  );
}
```

### 问题2：音频播放失败

**症状**：音景无法播放或中断

**排查步骤**：
1. 检查音频文件路径是否正确
2. 验证assets是否正确配置在pubspec.yaml
3. 检查音频权限是否授予
4. 查看日志输出

**解决方案**：
```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/sounds/ambience/
    - assets/sounds/effects/
```

### 问题3：重力感应不工作

**症状**：扣手机无反应

**排查步骤**：
1. 检查传感器权限
2. 验证阈值设置是否合理
3. 测试在真机而非模拟器
4. 打印传感器数据调试

**解决方案**：
```dart
// 添加调试日志
accelerometerEvents.listen((event) {
  print('Accelerometer: x=${event.x}, y=${event.y}, z=${event.z}');
});
```

---

**文档结束**

*本技术实施方案应与《产品需求文档》配合使用。如有疑问，请联系技术团队。*

*最后更新：2024-11-25*
*版本：v1.0*
