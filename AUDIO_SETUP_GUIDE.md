# 音频文件设置指南

## 🎵 问题说明

当前应用使用的是**空占位文件**，点击音频相关按钮会出现错误日志。这是正常的，因为空文件无法被音频播放器加载。

要让音频功能正常工作，需要替换为真实的音频文件。

---

## 📋 所需音频文件清单

### 音效文件（Effects）
位置：`assets/sounds/effects/`

| 文件名 | 用途 | 时长建议 | 格式 |
|--------|------|----------|------|
| `ui_click.mp3` | UI点击音效 | 0.1-0.3秒 | MP3 |
| `ui_swipe.mp3` | 滑动切换音效 | 0.2-0.5秒 | MP3 |
| `timer_start.mp3` | 计时器开始 | 0.5-1秒 | MP3 |
| `timer_complete.mp3` | 计时器完成 | 1-2秒 | MP3 |
| `digit_flip.mp3` | 数字翻转音效 | 0.1-0.2秒 | MP3 |

### 音景文件（Ambience）
位置：`assets/sounds/ambience/`

| 文件名 | 用途 | 时长建议 | 格式 |
|--------|------|----------|------|
| `rain.mp3` | 雨声 | 3-10分钟（循环） | MP3 |
| `cafe.mp3` | 咖啡馆环境音 | 3-10分钟（循环） | MP3 |
| `white_noise.mp3` | 白噪音 | 3-10分钟（循环） | MP3 |
| `forest.mp3` | 森林环境音 | 3-10分钟（循环） | MP3 |
| `ocean.mp3` | 海浪声 | 3-10分钟（循环） | MP3 |
| `lofi.mp3` | Lo-Fi音乐 | 3-10分钟（循环） | MP3 |

---

## 🔧 方法一：快速测试（使用在线音频生成）

### 1. 生成简单音效（使用在线工具）

访问：**https://sfxr.me/** 或 **https://sfbgames.itch.io/chiptone**

#### UI音效生成步骤：
```
ui_click.mp3:
1. 选择 "Pickup/Coin" 预设
2. 调整音调到高音
3. 导出为 WAV
4. 使用在线转换器转为 MP3（如 https://cloudconvert.com/wav-to-mp3）

ui_swipe.mp3:
1. 选择 "Powerup" 预设
2. 增加 Attack 时间
3. 导出并转换为 MP3

timer_start.mp3:
1. 选择 "Blip/Select" 预设
2. 调整为中音
3. 导出并转换为 MP3

timer_complete.mp3:
1. 选择 "Powerup" 预设
2. 增加音高和持续时间
3. 导出并转换为 MP3

digit_flip.mp3:
1. 选择 "Hit/Hurt" 预设
2. 降低音量，缩短时长
3. 导出并转换为 MP3
```

### 2. 下载免费音景

#### 雨声（rain.mp3）
访问：**https://freesound.org/**
- 搜索："rain loop"
- 推荐：[Rain Sound Loop](https://freesound.org/people/klankbeeld/sounds/198302/)
- 下载 → 重命名为 `rain.mp3`

#### 咖啡馆（cafe.mp3）
- 搜索："cafe ambience loop"
- 推荐：[Coffee Shop Ambience](https://freesound.org/people/InspectorJ/sounds/415209/)
- 下载 → 重命名为 `cafe.mp3`

#### 白噪音（white_noise.mp3）
- 搜索："white noise"
- 推荐：[White Noise Loop](https://freesound.org/people/Nox_Sound/sounds/562244/)
- 下载 → 重命名为 `white_noise.mp3`

#### 森林（forest.mp3）
- 搜索："forest birds loop"
- 下载 → 重命名为 `forest.mp3`

#### 海浪（ocean.mp3）
- 搜索："ocean waves loop"
- 下载 → 重命名为 `ocean.mp3`

#### Lo-Fi音乐（lofi.mp3）
访问：**YouTube Audio Library** - https://studio.youtube.com/
- 类型：Lo-fi
- 下载免费的 Lo-fi 音乐
- 使用在线转换器转为 MP3

---

## 🎨 方法二：使用专业音频资源（推荐）

### 免费音效库

1. **Freesound.org** （最推荐）
   - 网址：https://freesound.org/
   - 需要注册（免费）
   - 搜索关键词：
     - UI音效："ui click", "button click", "swipe sound"
     - 计时器音效："beep", "timer", "alarm"
   - 下载格式：WAV 或 MP3
   - 许可证：Creative Commons（注意选择允许商业使用的）

2. **Zapsplat**
   - 网址：https://www.zapsplat.com/
   - 免费账户每天可下载5个音效
   - 分类清晰，质量高

3. **Mixkit Sound Effects**
   - 网址：https://mixkit.co/free-sound-effects/
   - 完全免费，无需注册
   - 可商业使用

### 免费音景库

1. **MyNoise.net**
   - 网址：https://mynoise.net/
   - 支持自定义音景并导出
   - 推荐音景：
     - Rain Noise
     - Cafe Restaurant
     - White Noise
     - Japanese Garden（森林）
     - Distant Thunder（海浪）

2. **Ambient-Mixer**
   - 网址：https://www.ambient-mixer.com/
   - 社区上传的免费音景
   - 可在线混合多个音轨

3. **Free Music Archive**
   - 网址：https://freemusicarchive.org/
   - 搜索 "ambient" 或 "lofi"
   - 下载 Lo-Fi 音乐

---

## 📂 详细操作步骤

### 步骤1：创建临时下载文件夹

```bash
mkdir ~/Downloads/neonfocus_audio
cd ~/Downloads/neonfocus_audio
mkdir effects ambience
```

### 步骤2：下载音频文件

根据上面的资源网站，下载所需的音频文件到对应文件夹。

### 步骤3：转换格式（如需要）

如果下载的是 WAV 格式，需要转换为 MP3：

**方法A：使用在线转换器**
- 访问：https://cloudconvert.com/wav-to-mp3
- 上传文件 → 转换 → 下载

**方法B：使用 FFmpeg（如果已安装）**
```bash
# 安装 FFmpeg（macOS）
brew install ffmpeg

# 转换单个文件
ffmpeg -i input.wav -codec:a libmp3lame -qscale:a 2 output.mp3

# 批量转换
for file in *.wav; do
  ffmpeg -i "$file" -codec:a libmp3lame -qscale:a 2 "${file%.wav}.mp3"
done
```

### 步骤4：重命名文件

确保文件名完全匹配（区分大小写）：

**音效文件：**
```
ui_click.mp3
ui_swipe.mp3
timer_start.mp3
timer_complete.mp3
digit_flip.mp3
```

**音景文件：**
```
rain.mp3
cafe.mp3
white_noise.mp3
forest.mp3
ocean.mp3
lofi.mp3
```

### 步骤5：替换占位文件

```bash
# 进入项目目录
cd /path/to/NeonFocus

# 复制音效文件
cp ~/Downloads/neonfocus_audio/effects/*.mp3 assets/sounds/effects/

# 复制音景文件
cp ~/Downloads/neonfocus_audio/ambience/*.mp3 assets/sounds/ambience/
```

### 步骤6：验证文件

检查文件大小，确保不是空文件：

```bash
# 检查音效文件
ls -lh assets/sounds/effects/

# 检查音景文件
ls -lh assets/sounds/ambience/
```

每个文件应该有合理的大小：
- 音效：10KB - 100KB
- 音景：500KB - 5MB

### 步骤7：重新运行应用

```bash
# 清理缓存
flutter clean

# 重新安装依赖
flutter pub get

# 运行应用
flutter run
```

---

## 🎯 最简单的测试方案

如果只是想快速测试音频功能是否正常工作，可以：

### 1. 下载测试音频包

我已经为您准备了一个测试方案：

```bash
# 使用 FFmpeg 生成简单的测试音频
cd assets/sounds/effects/

# 生成 1秒的440Hz正弦波（A音）作为点击音效
ffmpeg -f lavfi -i "sine=frequency=440:duration=0.3" ui_click.mp3

# 生成滑动音效（频率上升）
ffmpeg -f lavfi -i "sine=frequency=330:duration=0.4" ui_swipe.mp3

# 生成计时器开始音效
ffmpeg -f lavfi -i "sine=frequency=523:duration=0.5" timer_start.mp3

# 生成计时器完成音效（和弦）
ffmpeg -f lavfi -i "sine=frequency=659:duration=1" timer_complete.mp3

# 生成数字翻转音效
ffmpeg -f lavfi -i "sine=frequency=880:duration=0.2" digit_flip.mp3

# 进入音景目录
cd ../ambience/

# 生成测试音景（白噪音）
ffmpeg -f lavfi -i "anoisesrc=d=180:c=white:r=48000:a=0.5" white_noise.mp3

# 生成雨声模拟（粉红噪音）
ffmpeg -f lavfi -i "anoisesrc=d=180:c=pink:r=48000:a=0.5" rain.mp3
```

### 2. 或者复制现有音频文件

如果您电脑上已有任何 MP3 文件，可以临时复制并重命名用于测试：

```bash
# 示例：复制系统音效
cp /System/Library/Sounds/Tink.aiff temp.aiff
# 然后转换为 MP3 并重命名
```

---

## ⚠️ 常见问题

### Q1: 点击音频按钮没有声音，也没有错误日志
**A:** 检查设备音量和静音开关。

### Q2: 错误日志：PlatformException(Audio Player)
**A:** 确认文件格式正确（MP3）且不是空文件。

### Q3: 音景播放卡顿
**A:** 文件太大或质量太高，建议：
- 降低比特率：128kbps 即可
- 缩短时长：3-5分钟足够（会循环播放）

### Q4: 如何制作无缝循环的音景？
**A:** 使用 Audacity：
1. 打开音频文件
2. 剪辑到合适长度
3. 效果 → 淡化 → 交叉淡化循环
4. 导出为 MP3

### Q5: 需要购买音频授权吗？
**A:**
- 测试阶段：使用免费资源即可
- 商业发布：确保使用允许商业使用的授权（CC0、CC BY等）
- 保存授权证明到 `AUDIO_LICENSES.txt`

---

## 📜 授权管理

创建 `assets/sounds/AUDIO_LICENSES.txt` 记录音频来源：

```
# NeonFocus Audio Licenses

## Effects (音效)

ui_click.mp3
- Source: Freesound.org
- Author: UserName
- License: CC0 (Public Domain)
- URL: https://freesound.org/...

ui_swipe.mp3
- Source: Generated with SFXR
- License: Free to use

...（其他文件信息）

## Ambience (音景)

rain.mp3
- Source: MyNoise.net
- License: Free for personal use
- URL: https://mynoise.net/...

...（其他文件信息）
```

---

## 🚀 完成后

替换完音频文件后，应用将能够：

✅ 点击按钮时播放音效
✅ 选择音景时开始循环播放
✅ 调节音量滑块
✅ 静音功能正常工作

---

**需要帮助？**

如果在设置音频时遇到问题，请检查：
1. 文件名是否完全匹配（区分大小写）
2. 文件格式是否为 MP3
3. 文件是否为空（检查文件大小）
4. pubspec.yaml 中的资源路径是否正确声明

---

*最后更新: 2025-11-26*
