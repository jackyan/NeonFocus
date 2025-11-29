# 国际化测试指南

## 支持的语言

NeonFocus 支持以下 4 种语言：
- 🇺🇸 English (en) - 英文
- 🇨🇳 中文 (zh) - 简体中文
- 🇯🇵 日本語 (ja) - 日文
- 🇰🇷 한국어 (ko) - 韩文

---

## 自动语言切换

应用会自动跟随系统语言设置：
- 系统设为中文 → 应用显示中文
- 系统设为日文 → 应用显示日文
- 系统设为韩文 → 应用显示韩文
- 系统设为其他语言 → 应用显示英文（默认）

---

## 测试方法

### iOS 设备测试

#### 方法 1: 通过设置应用（推荐）

1. 打开 **设置 (Settings)** 应用
2. 滚动到 **通用 (General)**
3. 点击 **语言与地区 (Language & Region)**
4. 点击 **添加语言 (Add Language...)**
5. 选择要测试的语言：
   - 中文（简体）
   - 日本語
   - 한국어
6. 系统会询问是否将该语言设为主要语言
7. 选择 **更改为 [语言]** 或 **Change to [Language]**
8. 等待系统切换完成
9. 重新打开 NeonFocus 应用
10. 验证界面语言是否正确切换

#### 方法 2: 通过模拟器命令（仅模拟器）

```bash
# 切换到中文
xcrun simctl spawn booted defaults write "Apple Global Domain" AppleLanguages -array zh-Hans
xcrun simctl spawn booted defaults write "Apple Global Domain" AppleLocale -string zh_CN

# 切换到日文
xcrun simctl spawn booted defaults write "Apple Global Domain" AppleLanguages -array ja
xcrun simctl spawn booted defaults write "Apple Global Domain" AppleLocale -string ja_JP

# 切换到韩文
xcrun simctl spawn booted defaults write "Apple Global Domain" AppleLanguages -array ko
xcrun simctl spawn booted defaults write "Apple Global Domain" AppleLocale -string ko_KR

# 切换回英文
xcrun simctl spawn booted defaults write "Apple Global Domain" AppleLanguages -array en
xcrun simctl spawn booted defaults write "Apple Global Domain" AppleLocale -string en_US

# 重启模拟器以应用更改
# 或者重新运行应用
```

---

### Android 设备测试

#### 方法 1: 通过设置应用（推荐）

1. 打开 **设置 (Settings)** 应用
2. 滚动到 **系统 (System)**
3. 点击 **语言和输入法 (Languages & input)**
4. 点击 **语言 (Languages)**
5. 点击 **添加语言 (Add a language)**
6. 选择要测试的语言：
   - 中文（简体）
   - 日本語
   - 한국어
7. 长按新添加的语言
8. 拖动到列表顶部（设为主要语言）
9. 等待系统切换完成
10. 重新打开 NeonFocus 应用
11. 验证界面语言是否正确切换

#### 方法 2: 通过 ADB 命令（仅模拟器/已连接设备）

```bash
# 切换到中文
adb shell "setprop persist.sys.locale zh-CN; setprop ctl.restart zygote"

# 切换到日文
adb shell "setprop persist.sys.locale ja-JP; setprop ctl.restart zygote"

# 切换到韩文
adb shell "setprop persist.sys.locale ko-KR; setprop ctl.restart zygote"

# 切换回英文
adb shell "setprop persist.sys.locale en-US; setprop ctl.restart zygote"

# 注意：这会重启 Android 系统服务，需要等待几秒钟
```

---

## 验证清单

切换语言后，请验证以下界面的文本是否正确翻译：

### 时钟页面
- [ ] 设置按钮工具提示
- [ ] 时钟设置页面标题
- [ ] "时钟" 部分标题
- [ ] "显示日期" 开关
- [ ] "显示星期" 开关
- [ ] "显示电池" 开关
- [ ] "音效" 部分标题
- [ ] "秒针翻转音效" 开关
- [ ] "音效音量" 标签
- [ ] "主题" 部分标题

### 番茄钟页面
- [ ] 设置按钮工具提示
- [ ] 番茄钟设置页面标题
- [ ] "番茄钟" 部分标题
- [ ] "自动开始" 开关
- [ ] "振动提醒" 开关
- [ ] "重力交互" 开关
- [ ] "翻转手机开始/暂停" 副标题
- [ ] "音效" 部分标题
- [ ] "启用音效" 开关
- [ ] "音效音量" 标签
- [ ] "环境音" 部分标题
- [ ] "环境音音量" 标签
- [ ] "主题" 部分标题

### 秒表页面
- [ ] 设置按钮工具提示
- [ ] 秒表设置页面标题
- [ ] "音效" 部分标题
- [ ] "音效音量" 标签
- [ ] "主题" 部分标题
- [ ] 历史记录按钮工具提示
- [ ] 历史记录页面标题
- [ ] "最快" 统计标签
- [ ] "最慢" 统计标签
- [ ] "平均" 统计标签
- [ ] "总时间" 统计标签
- [ ] "圈速 1", "圈速 2" 等（参数化文本）
- [ ] "暂无圈速记录" 空状态文本

---

## 常见问题

### Q: 切换语言后应用没有变化？
**A**: 请确保：
1. 完全关闭应用（从后台移除）
2. 重新打开应用
3. 如果还是没变化，重启设备

### Q: 某些文本没有翻译？
**A**: 请检查：
1. 该文本是否在 `lib/l10n/app_*.arb` 文件中
2. 是否正确使用 `AppLocalizations.of(context)!.xxx`
3. 是否重新生成了国际化文件（`flutter gen-l10n`）

### Q: 如何添加新的语言？
**A**: 
1. 在 `lib/l10n/` 目录创建新的 `.arb` 文件（如 `app_fr.arb` 法文）
2. 复制 `app_en.arb` 的内容并翻译
3. 在 `lib/main.dart` 的 `supportedLocales` 中添加新语言
4. 运行 `flutter gen-l10n` 生成代码
5. 重新运行应用

### Q: 如何添加新的翻译文本？
**A**:
1. 在 `lib/l10n/app_en.arb` 中添加新的键值对
2. 在其他语言文件中添加对应的翻译
3. 运行 `flutter gen-l10n` 生成代码
4. 在代码中使用 `AppLocalizations.of(context)!.newKey`

---

## 开发提示

### 使用国际化文本

```dart
// 获取 AppLocalizations 实例
final l10n = AppLocalizations.of(context)!;

// 使用简单文本
Text(l10n.clockTitle)

// 使用参数化文本
Text(l10n.lapNumber(lapIndex))
```

### 添加新的翻译键

在 `app_en.arb` 中：
```json
{
  "newKey": "New Text",
  "@newKey": {
    "description": "Description of this text"
  }
}
```

在 `app_zh.arb` 中：
```json
{
  "newKey": "新文本"
}
```

### 参数化文本

在 `app_en.arb` 中：
```json
{
  "lapNumber": "Lap {number}",
  "@lapNumber": {
    "description": "Lap number label",
    "placeholders": {
      "number": {
        "type": "int"
      }
    }
  }
}
```

使用：
```dart
Text(l10n.lapNumber(5))  // 显示 "Lap 5"
```

---

## 测试报告模板

```
测试日期: ____________________
测试人员: ____________________
设备型号: ____________________
系统版本: ____________________

语言测试结果:
[ ] 英文 (en) - 通过/失败
[ ] 中文 (zh) - 通过/失败
[ ] 日文 (ja) - 通过/失败
[ ] 韩文 (ko) - 通过/失败

发现的问题:
1. ________________________________
2. ________________________________
3. ________________________________

备注:
_____________________________________
_____________________________________
```

---

**文档版本**: v1.0  
**最后更新**: 2024-11-29
