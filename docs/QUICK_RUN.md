# 🚀 快速运行指南（无需字体文件）

如果你想快速运行项目看效果，而不想先下载字体文件，按以下步骤操作：

## 方法1：临时使用系统字体（推荐）

### 步骤1：生成平台文件
```bash
flutter create . --platforms=ios,android,web
```

### 步骤2：使用临时配置
```bash
# 备份原配置
cp pubspec.yaml pubspec.yaml.backup

# 使用临时配置（无字体依赖）
cp pubspec_temp.yaml pubspec.yaml

# 安装依赖
flutter pub get
```

### 步骤3：修改代码移除字体引用

临时修改以下文件，将 `fontFamily: 'Orbitron'` 改为系统默认字体：

**文件1**: `lib/features/clock/presentation/widgets/glow_digit.dart`
- 第 48-49 行：注释或删除 `fontFamily: 'Orbitron',`
- 第 64-65 行：注释或删除 `fontFamily: 'Orbitron',`

**文件2**: `lib/features/pomodoro/presentation/widgets/virtual_knob.dart`
- 第 139 行：注释或删除 `fontFamily: 'Orbitron',`

**文件3**: `lib/features/pomodoro/presentation/screens/pomodoro_screen.dart`
- 第 81 行：注释或删除 `fontFamily: 'Orbitron',`

**文件4**: `lib/features/clock/presentation/screens/clock_screen.dart`
- 第 100 行：删除或注释 `fontFamily: 'Orbitron',`

### 步骤4：运行
```bash
flutter run
```

## 方法2：直接下载字体（推荐正式开发）

### 1. 下载字体
访问 https://fonts.google.com/specimen/Orbitron
- 点击 "Download family"
- 解压后找到 `Orbitron-Bold.ttf`
- 复制到 `assets/fonts/Orbitron-Bold.ttf`

### 2. 生成平台文件
```bash
flutter create . --platforms=ios,android,web
```

### 3. 安装依赖并运行
```bash
flutter pub get
flutter run
```

## 常见问题

### Q: 运行后报错 "No MaterialLocalizations found"
A: 这是正常的，因为某些依赖需要完整的平台文件。运行 `flutter create .` 后会自动修复。

### Q: 看不到辉光效果？
A: 可能是模拟器性能问题。尝试：
1. 在真机上运行
2. 降低辉光强度（修改 `glow_theme.dart`）

### Q: 双击切换主题没反应？
A: 检查是否在时钟屏幕上双击。主题切换在 `main.dart` 的 `MainScreen` 中。

## 验证清单

运行成功后应该看到：
- ✅ 实时更新的时间显示（每秒刷新）
- ✅ 日期显示
- ✅ 主题名称显示（CYBER BLUE）
- ✅ 双击可以切换主题
- ✅ 底部提示文字 "Double tap to switch theme"

## 推荐运行平台

1. **iOS模拟器** - 最佳视觉效果
   ```bash
   flutter run -d "iPhone 16e"
   ```

2. **Chrome** - 快速测试
   ```bash
   flutter run -d chrome
   ```

3. **macOS** - 原生性能
   ```bash
   flutter run -d macos
   ```

---

**注意**: 使用系统字体只是为了快速测试，正式开发请下载并配置Orbitron字体以获得最佳视觉效果。
