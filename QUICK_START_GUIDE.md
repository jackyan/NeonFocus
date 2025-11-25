# NeonFocus - 快速启动指南

**目标**：帮助开发者在30分钟内启动项目并看到第一个可运行的原型

---

## 🚀 快速开始（30分钟）

### Step 1: 克隆项目模板（5分钟）

```bash
# 1. 创建项目
flutter create neonfocus
cd neonfocus

# 2. 初始化Git
git init
git add .
git commit -m "Initial commit"

# 3. 创建分支策略
git checkout -b develop
git checkout -b feature/glow-effect
```

### Step 2: 配置依赖（5分钟）

替换 `pubspec.yaml` 的dependencies部分：

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 核心依赖（MVP必需）
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  audioplayers: ^5.2.0
  sensors_plus: ^4.0.0
  flutter_local_notifications: ^16.2.0
  shared_preferences: ^2.2.2
  
  # UI增强
  flutter_animate: ^4.3.0
  
  # 工具
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.7
  hive_generator: ^2.0.1

flutter:
  uses-material-design: true
  
  assets:
    - assets/fonts/
    - assets/sounds/effects/
    - assets/sounds/ambience/
  
  fonts:
    - family: Orbitron
      fonts:
        - asset: assets/fonts/Orbitron-Bold.ttf
          weight: 700
```

```bash
# 安装依赖
flutter pub get
```

### Step 3: 下载字体（2分钟）

```bash
# 创建字体目录
mkdir -p assets/fonts

# 下载Orbitron字体（Google Fonts）
# 访问：https://fonts.google.com/specimen/Orbitron
# 下载并放入 assets/fonts/Orbitron-Bold.ttf
```

### Step 4: 创建最小原型（15分钟）

创建 `lib/main.dart`：

```dart
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const NeonFocusApp());
}

class NeonFocusApp extends StatelessWidget {
  const NeonFocusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeonFocus',
      theme: ThemeData.dark(),
      home: const ClockScreen(),
    );
  }
}

class ClockScreen extends StatefulWidget {
  const ClockScreen({Key? key}) : super(key: key);

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  DateTime _currentTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),  // 深蓝黑背景
      body: Center(
        child: SimpleGlowClock(time: _currentTime),
      ),
    );
  }
}

/// 简单的辉光时钟（原型版本）
class SimpleGlowClock extends StatelessWidget {
  final DateTime time;

  const SimpleGlowClock({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGlowText(hour),
        _buildGlowText(':'),
        _buildGlowText(minute),
        _buildGlowText(':'),
        _buildGlowText(second),
      ],
    );
  }

  Widget _buildGlowText(String text) {
    const glowColor = Color(0xFF00D9FF);  // 青蓝色
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          // 外层光晕
          Text(
            text,
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 6
                ..color = glowColor.withOpacity(0.3)
                ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 20),
            ),
          ),
          // 中层光晕
          Text(
            text,
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4
                ..color = glowColor.withOpacity(0.5)
                ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10),
            ),
          ),
          // 核心文字
          Text(
            text,
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: glowColor,
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Step 5: 运行原型（3分钟）

```bash
# 启动模拟器或连接真机
flutter devices

# 运行
flutter run
```

**预期效果**：
- 深蓝黑背景
- 青蓝色辉光数字时钟
- 实时更新时间（HH:MM:SS）
- 基本的辉光效果

---

## 📦 第一天开发计划

现在你已经有了一个可运行的原型。接下来按照这个顺序开发：

### 上午（4小时）：完善辉光效果

**目标**：实现生产级别的辉光组件

1. **创建GlowDigit组件**（1小时）
   ```bash
   mkdir -p lib/features/clock/presentation/widgets
   touch lib/features/clock/presentation/widgets/glow_digit.dart
   ```
   - 参考技术文档的 `GlowDigit` 实现
   - 支持多层光晕配置
   - 支持强度调节

2. **添加数字切换动画**（1.5小时）
   ```bash
   touch lib/features/clock/presentation/widgets/animated_glow_digit.dart
   ```
   - 淡入淡出效果
   - 缩放动画
   - 滑动效果

3. **创建完整时钟组件**（1小时）
   ```bash
   touch lib/features/clock/presentation/widgets/glow_clock.dart
   ```
   - 时分秒显示
   - 12/24小时制切换
   - 日期显示

4. **测试与调优**（0.5小时）
   - 性能测试（FPS）
   - 调整动画参数
   - 修复视觉bug

### 下午（4小时）：主题系统

**目标**：实现3种主题切换

1. **定义主题数据结构**（0.5小时）
   ```bash
   mkdir -p lib/core/themes
   touch lib/core/themes/glow_theme.dart
   ```
   - 定义颜色方案
   - 定义辉光配置
   - 预设3种主题

2. **实现主题选择器UI**（1.5小时）
   ```bash
   touch lib/features/clock/presentation/widgets/theme_selector.dart
   ```
   - 网格布局
   - 主题预览
   - 选中状态

3. **集成Bloc状态管理**（1.5小时）
   ```bash
   mkdir -p lib/features/clock/presentation/bloc
   touch lib/features/clock/presentation/bloc/clock_bloc.dart
   touch lib/features/clock/presentation/bloc/clock_event.dart
   touch lib/features/clock/presentation/bloc/clock_state.dart
   ```
   - 主题切换事件
   - 状态持久化（SharedPreferences）

4. **主题切换动画**（0.5小时）
   - 颜色过渡动画
   - 保存用户选择

**检查点**：
- [ ] 3种主题可以流畅切换
- [ ] 主题选择会保存
- [ ] 动画流畅（60fps）
- [ ] 重启App后主题保持

---

## 🎯 第一周里程碑

### Day 1: 核心时钟UI ✅
- 辉光数字组件
- 3种主题
- 主题切换

### Day 2-3: 番茄钟功能
- 倒计时逻辑
- 虚拟旋钮
- 开始/暂停/重置

### Day 4: 手势交互
- 左滑/右滑切换页面
- 上滑打开主题选择
- 点击显示设置

### Day 5: 音频集成
- 3个音景文件
- 音景播放器
- 音量控制

### 周末: 测试与优化
- Bug修复
- 性能优化
- 准备Demo演示

---

## 🔧 常见问题速查

### Q1: 字体显示不正常？

```bash
# 检查字体文件是否存在
ls assets/fonts/

# 检查pubspec.yaml配置
flutter pub get

# 清理重新构建
flutter clean
flutter run
```

### Q2: 辉光效果不明显？

调整参数：
```dart
// 增加模糊半径
blurRadius: 40  // 原来可能是20

// 增加不透明度
opacity: 0.8  // 原来可能是0.4

// 增加层数
layerCount: 3  // 原来可能是1
```

### Q3: 性能卡顿？

```dart
// 添加RepaintBoundary
RepaintBoundary(
  child: GlowClock(),
)

// 降低刷新率
Timer.periodic(Duration(milliseconds: 100), ...) // 10fps
// 而不是
Timer.periodic(Duration(milliseconds: 16), ...) // 60fps
```

### Q4: 热重载不生效？

```bash
# 完全重启
flutter run

# 或者按 'R' 键（热重启）
```

---

## 📚 下一步学习资源

### 官方文档
- [Flutter动画](https://flutter.dev/docs/development/ui/animations)
- [自定义绘制](https://flutter.dev/docs/development/ui/advanced/custom-paint)
- [Bloc模式](https://bloclibrary.dev/)

### 社区资源
- [Flutter Gists](https://gist.github.com/search?q=flutter+glow)
- [CodePen Flutter](https://codepen.io/search/pens?q=flutter)
- [Flutter Awesome](https://flutterawesome.com/)

### 视频教程
- [Flutter动画教程](https://www.youtube.com/results?search_query=flutter+animation+tutorial)
- [自定义Paint教程](https://www.youtube.com/results?search_query=flutter+custom+paint)

---

## ✅ 第一天完成检查清单

### 环境准备
- [ ] Flutter SDK已安装
- [ ] IDE已配置
- [ ] 项目已创建
- [ ] 依赖已安装

### 代码实现
- [ ] main.dart原型已运行
- [ ] 看到辉光时钟效果
- [ ] 时间实时更新
- [ ] 没有明显的性能问题

### 理解程度
- [ ] 理解辉光效果原理（多层模糊）
- [ ] 理解Flutter的StatefulWidget
- [ ] 理解Timer的使用
- [ ] 知道如何调整颜色和效果

### 下一步计划
- [ ] 已阅读技术文档的GlowDigit部分
- [ ] 清楚明天的开发目标
- [ ] 准备好开发环境

---

## 🎉 恭喜！

如果你已经完成了上面的步骤，恭喜你已经：
1. ✅ 建立了开发环境
2. ✅ 运行了第一个原型
3. ✅ 理解了核心概念
4. ✅ 准备好继续开发

**现在你可以**：
- 继续阅读《技术实施方案》中的详细代码
- 开始实现生产级别的组件
- 参考《产品需求文档》了解完整功能
- 加入开发者社区获取帮助

---

**记住**：
- 每天commit代码
- 遇到问题先查文档
- 不要过度优化，先完成再完美
- 保持代码整洁

**联系方式**（示例）：
- GitHub: github.com/neonfocus/app
- Discord: discord.gg/neonfocus
- Email: dev@neonfocus.app

---

*祝开发顺利！🚀*

*最后更新：2024-11-25*
