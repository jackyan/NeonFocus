# 字体资源

## 需要的字体文件

请下载以下字体并放置到此目录：

### 1. Orbitron
- **文件名**: `Orbitron-Bold.ttf`
- **下载链接**: https://fonts.google.com/specimen/Orbitron
- **用途**: 主要数字显示字体
- **许可**: SIL Open Font License (免费商用)
- **权重**: Bold (700)

### 2. Share Tech Mono
- **文件名**: `ShareTechMono-Regular.ttf`
- **下载链接**: https://fonts.google.com/specimen/Share+Tech+Mono
- **用途**: 备用等宽字体
- **许可**: SIL Open Font License (免费商用)
- **权重**: Regular (400)

## 下载步骤

1. 访问上述 Google Fonts 链接
2. 点击右侧的 "Download family" 按钮
3. 解压下载的 ZIP 文件
4. 找到对应的 TTF 文件
5. 复制到此目录 (`assets/fonts/`)

## 目录结构

```
assets/fonts/
├── Orbitron-Bold.ttf           # 请下载并放置
├── ShareTechMono-Regular.ttf   # 请下载并放置
└── FONTS_README.md             # 本文件
```

## 验证

完成后，运行以下命令验证：

```bash
ls -la assets/fonts/
# 应该看到两个 .ttf 文件
```

然后运行项目：

```bash
flutter pub get
flutter run
```

如果字体正确安装，你应该能看到：
- ✅ 时钟数字使用 Orbitron 字体
- ✅ 辉光效果正常显示
- ✅ 无字体相关警告

## 问题排查

如果字体不显示：

1. 检查文件名是否完全匹配
2. 运行 `flutter clean`
3. 重新 `flutter pub get`
4. 重启应用

## 许可信息

两个字体都使用 SIL Open Font License，可以：
- ✅ 免费用于商业项目
- ✅ 修改和分发
- ✅ 嵌入到应用中

详细许可信息请参考字体包中的 LICENSE 文件。
