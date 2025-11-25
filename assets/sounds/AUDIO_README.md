# 音频资源

## 需要的音频文件

### 音效文件 (effects/)

放置在 `assets/sounds/effects/` 目录：

1. **ui_click.mp3**
   - 用途：按钮点击音效
   - 时长：~50ms
   - 建议音量：-20dB

2. **ui_swipe.mp3**
   - 用途：页面切换音效
   - 时长：~200ms
   - 建议音量：-25dB

3. **timer_start.mp3**
   - 用途：计时器启动音效
   - 时长：~800ms
   - 建议音量：-15dB

4. **timer_complete.mp3**
   - 用途：计时器完成提示
   - 时长：~2000ms
   - 建议音量：-10dB

5. **digit_flip.mp3**
   - 用途：数字翻转音效（可选）
   - 时长：~300ms
   - 建议音量：-30dB

### 音景文件 (ambience/)

放置在 `assets/sounds/ambience/` 目录：

1. **rain.mp3**
   - 用途：雨声背景音
   - 时长：10分钟循环
   - 格式：192kbps MP3

2. **cafe.mp3**
   - 用途：咖啡馆环境音
   - 时长：15分钟循环
   - 格式：192kbps MP3

3. **white_noise.mp3**
   - 用途：白噪音
   - 时长：连续或10分钟循环
   - 格式：192kbps MP3

## 获取音频资源

### 免费资源网站

1. **Freesound.org**
   - 链接: https://freesound.org
   - 许可：CC0 或 CC-BY
   - 搜索关键词：rain, cafe ambience, white noise

2. **Zapsplat.com**
   - 链接: https://www.zapsplat.com
   - 许可：免费用于商业项目
   - 搜索关键词：UI sounds, timer sounds

3. **Mixkit.co**
   - 链接: https://mixkit.co/free-sound-effects/
   - 许可：免费商用
   - 分类：Sound Effects

### 临时占位符

开发时可以使用任何音频文件作为占位符，只要文件名匹配即可：

```bash
# 创建目录
mkdir -p assets/sounds/effects
mkdir -p assets/sounds/ambience

# 使用任何 MP3 文件作为占位符
# 注意：实际使用时需要替换为合适的音频
```

## 目录结构

```
assets/sounds/
├── effects/
│   ├── ui_click.mp3          # 请准备
│   ├── ui_swipe.mp3          # 请准备
│   ├── timer_start.mp3       # 请准备
│   ├── timer_complete.mp3    # 请准备
│   └── digit_flip.mp3        # 可选
│
├── ambience/
│   ├── rain.mp3              # 请准备
│   ├── cafe.mp3              # 请准备
│   └── white_noise.mp3       # 请准备
│
└── AUDIO_README.md           # 本文件
```

## 音频规格建议

### 音效文件
- **格式**: MP3
- **采样率**: 44.1kHz
- **比特率**: 128kbps
- **声道**: 单声道(Mono)
- **音量**: 标准化到 -3dB

### 音景文件
- **格式**: MP3
- **采样率**: 44.1kHz
- **比特率**: 192kbps
- **声道**: 立体声(Stereo)
- **时长**: 10-15分钟循环
- **音量**: 标准化到 -6dB

## 许可注意事项

使用音频资源时请注意：

1. **免费使用**：确认许可证允许商业使用
2. **署名要求**：如需要，请在应用关于页面添加署名
3. **修改权限**：确认是否允许修改音频
4. **重新分发**：了解是否允许重新分发

## 版权合规

建议的署名格式（如需要）：

```
音频资源:
- 雨声: 来自 Freesound.org 用户 [username]
- 咖啡馆: 来自 Zapsplat.com
- UI音效: 自制 / 来自 [source]
```

## 测试

完成后测试音频：

```bash
# 运行应用
flutter run

# 测试项目：
# ✅ UI点击音效播放
# ✅ 计时器音效播放
# ✅ 音景循环播放
# ✅ 音量控制正常
# ✅ 没有爆音或失真
```

## 备选方案

如果暂时没有音频文件，可以：

1. **注释掉音频代码**
   ```dart
   // 临时禁用音频
   // await audioService.playEffect(...);
   ```

2. **使用空文件**
   ```bash
   # 创建空文件避免错误
   touch assets/sounds/effects/ui_click.mp3
   ```

3. **下载音频包**
   - 在GitHub或资源网站搜索 "flutter sound pack"
   - 下载现成的音频包

---

**注意**: 正式发布前必须使用正版授权的音频资源！
