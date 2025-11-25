# 🚀 一键修复脚本

## 方案A：创建必需目录和占位符

在项目根目录运行：

```bash
#!/bin/bash

# 创建所有必需的目录
mkdir -p assets/fonts
mkdir -p assets/sounds/effects
mkdir -p assets/sounds/ambience
mkdir -p assets/images

# 创建占位符文件（避免构建错误）
touch assets/fonts/Orbitron-Bold.ttf
touch assets/fonts/ShareTechMono-Regular.ttf

echo "✅ 目录和占位符已创建"
echo "⚠️  注意：字体文件是空的，需要下载真实字体获得最佳效果"
echo ""
echo "下载字体："
echo "1. 访问 https://fonts.google.com/specimen/Orbitron"
echo "2. 点击 'Download family'"
echo "3. 解压后将 Orbitron-Bold.ttf 复制替换到 assets/fonts/"
echo ""
echo "现在可以运行: flutter run"
```

保存为 `fix_assets.sh`，然后运行：
```bash
chmod +x fix_assets.sh
./fix_assets.sh
```

## 方案B：使用无字体配置（更简单）

### 步骤1：备份并替换 pubspec.yaml

```bash
# 备份原文件
cp pubspec.yaml pubspec.yaml.with_fonts

# 使用无字体版本
cp pubspec_temp.yaml pubspec.yaml

# 重新获取依赖
flutter pub get
```

### 步骤2：创建必需的空目录

```bash
# 即使不声明assets，也需要创建目录避免某些插件报错
mkdir -p assets/sounds/effects
mkdir -p assets/sounds/ambience
mkdir -p assets/images
```

### 步骤3：运行

```bash
flutter run
```

## 方案C：完整设置（最佳体验）

### 1. 下载真实字体

访问 https://fonts.google.com/specimen/Orbitron

- 点击 "Download family"
- 解压 ZIP 文件
- 找到 `Orbitron-Bold.ttf`
- 复制到项目的 `assets/fonts/` 目录

### 2. 创建目录结构

```bash
mkdir -p assets/fonts
mkdir -p assets/sounds/effects
mkdir -p assets/sounds/ambience
mkdir -p assets/images

# 将下载的字体文件放到 assets/fonts/ 目录
# 确保文件名为：Orbitron-Bold.ttf
```

### 3. 验证文件

```bash
ls -la assets/fonts/
# 应该看到：
# Orbitron-Bold.ttf (非空文件，约 50-100KB)
```

### 4. 运行

```bash
flutter clean
flutter pub get
flutter run
```

---

## 快速诊断

如果还有问题，运行：

```bash
# 检查目录是否存在
ls -la assets/

# 检查字体文件
ls -lh assets/fonts/

# 清理并重建
flutter clean
flutter pub get
flutter run
```

---

## 常见错误解决

### 错误：unable to find directory entry
**原因**：目录不存在
**解决**：`mkdir -p assets/sounds/effects assets/sounds/ambience assets/images`

### 错误：unable to locate asset entry
**原因**：字体文件不存在或路径错误
**解决**：下载真实字体，或使用 `pubspec_temp.yaml`（无字体版本）

### 警告：deprecated API
**忽略**：这些是依赖包的警告，不影响运行

---

## 推荐方案

**最快运行**（1分钟）：
```bash
cp pubspec_temp.yaml pubspec.yaml
flutter pub get
flutter run
```

**最佳效果**（5分钟）：
1. 下载 Orbitron 字体
2. 放到 assets/fonts/
3. 创建空目录
4. flutter run
