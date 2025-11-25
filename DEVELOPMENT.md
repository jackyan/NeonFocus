# NeonFocus - 开发说明

## 项目状态

当前已完成核心功能实现的第一阶段（MVP Phase 1）：

### ✅ 已完成功能

1. **核心UI组件**
   - ✅ 辉光数字组件（GlowDigit）
   - ✅ 动画辉光数字（AnimatedGlowDigit）
   - ✅ 完整时钟显示（GlowClock）
   - ✅ 时钟主屏幕（ClockScreen）

2. **主题系统**
   - ✅ 3种预设主题（赛博蓝、霓虹紫、极简黑）
   - ✅ 主题数据模型
   - ✅ 主题切换功能（双击切换）

3. **番茄钟功能**
   - ✅ 番茄钟数据模型
   - ✅ BLoC状态管理
   - ✅ 虚拟旋钮组件
   - ✅ 番茄钟屏幕UI
   - ✅ 开始/暂停/重置功能

4. **项目结构**
   - ✅ Flutter项目配置
   - ✅ 标准目录结构
   - ✅ 依赖配置

### 🚧 待完成功能

1. **音频系统**（Week 5-6）
   - ⏳ 音效播放器
   - ⏳ 音景播放器
   - ⏳ 音量控制

2. **重力感应**（Week 4）
   - ⏳ 传感器服务
   - ⏳ 扣手机检测
   - ⏳ 重力交互逻辑

3. **手势控制**（Week 4）
   - ⏳ 页面切换手势
   - ⏳ PageView集成
   - ⏳ 手势识别

4. **防烧屏机制**（Week 7）
   - ⏳ 像素偏移
   - ⏳ 旋转保护
   - ⏳ 亮度自适应

5. **系统集成**（Week 7-8）
   - ⏳ 通知系统
   - ⏳ 充电检测
   - ⏳ Widget支持

## 快速开始

### 前置要求

由于当前环境没有Flutter SDK，需要在本地环境运行：

1. **安装Flutter SDK**
   ```bash
   # 下载Flutter
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:`pwd`/flutter/bin"

   # 检查环境
   flutter doctor
   ```

2. **下载字体文件**

   需要手动下载以下字体并放入 `assets/fonts/` 目录：
   - **Orbitron-Bold.ttf** - https://fonts.google.com/specimen/Orbitron
   - **ShareTechMono-Regular.ttf** - https://fonts.google.com/specimen/Share+Tech+Mono

   下载步骤：
   - 访问 Google Fonts 链接
   - 点击 "Download family"
   - 解压后将 TTF 文件复制到 `assets/fonts/`

3. **准备音频资源**

   创建占位符音频文件（或使用临时文件）：
   ```bash
   mkdir -p assets/sounds/effects
   mkdir -p assets/sounds/ambience
   ```

   需要的音频文件：
   - `assets/sounds/effects/ui_click.mp3`
   - `assets/sounds/effects/timer_complete.mp3`
   - `assets/sounds/ambience/rain.mp3`
   - `assets/sounds/ambience/cafe.mp3`
   - `assets/sounds/ambience/white_noise.mp3`

### 运行项目

```bash
# 1. 获取依赖
flutter pub get

# 2. 运行项目
flutter run

# 3. 热重载（开发时）
# 按 'r' 键热重载
# 按 'R' 键热重启
```

### 当前可用功能

1. **时钟显示**
   - 启动后看到实时更新的辉光时钟
   - 双击屏幕切换主题（赛博蓝 → 霓虹紫 → 极简黑）

2. **主题切换**
   - 3种赛博朋克风格主题
   - 平滑的颜色过渡动画

## 代码架构

```
lib/
├── core/
│   ├── constants/
│   │   └── animation_constants.dart    # 动画配置
│   └── themes/
│       └── glow_theme.dart             # 主题定义
│
├── features/
│   ├── clock/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── clock_screen.dart   # 时钟主屏幕
│   │       └── widgets/
│   │           ├── glow_digit.dart     # 辉光数字
│   │           ├── animated_glow_digit.dart  # 动画数字
│   │           └── glow_clock.dart     # 完整时钟
│   │
│   └── pomodoro/
│       ├── domain/
│       │   └── pomodoro_model.dart     # 番茄钟模型
│       └── presentation/
│           ├── bloc/
│           │   ├── pomodoro_bloc.dart  # 状态管理
│           │   ├── pomodoro_event.dart
│           │   └── pomodoro_state.dart
│           ├── screens/
│           │   └── pomodoro_screen.dart  # 番茄钟屏幕
│           └── widgets/
│               └── virtual_knob.dart   # 虚拟旋钮
│
└── main.dart                           # 应用入口
```

## 技术栈

- **Flutter**: 3.2.0+
- **Dart**: 3.2.0+
- **状态管理**: flutter_bloc ^8.1.3
- **本地存储**: hive ^2.2.3
- **音频**: audioplayers ^5.2.0, just_audio ^0.9.36
- **传感器**: sensors_plus ^4.0.0

## 性能优化

已实施的优化：

1. **辉光效果优化**
   - 使用多层模糊实现辉光
   - RepaintBoundary隔离重绘
   - 可配置的辉光强度（低/中/高）

2. **动画优化**
   - TweenSequence实现复杂动画
   - 使用AnimationController控制
   - 及时dispose资源

3. **状态管理**
   - BLoC模式分离业务逻辑
   - Equatable优化状态比较

## 下一步开发

按照12周开发计划，接下来应完成：

### Week 5-6: 音频集成
```bash
# 创建音频服务
touch lib/core/services/audio_service.dart

# 实现音效播放
# 实现音景循环播放
# 集成音量控制
```

### Week 4: 手势和重力
```bash
# 创建传感器服务
touch lib/core/services/sensor_service.dart

# 实现重力感应
# 实现手势识别
# 集成PageView
```

## 常见问题

### Q: 字体显示不正常？
A: 确保已下载字体文件到 `assets/fonts/` 目录，并运行 `flutter clean && flutter pub get`

### Q: 辉光效果不明显？
A: 可以调整 `glow_theme.dart` 中的 `GlowIntensity` 设置

### Q: 如何添加新主题？
A: 在 `glow_theme.dart` 中添加新的 `NeonTheme` 常量

## 贡献指南

1. 遵循Flutter官方代码规范
2. 使用`flutter analyze`检查代码
3. 提交前确保没有警告和错误
4. 重要改动需要添加注释

## 许可证

待定

---

**当前版本**: v0.1.0-alpha
**最后更新**: 2025-11-25
**开发状态**: MVP Phase 1 完成
