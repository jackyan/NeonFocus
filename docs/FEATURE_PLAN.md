# 功能优化与国际化实施计划

## 分支信息
- **分支名**: `feature/settings-optimization-and-i18n`
- **基于**: `claude/review-implementation-gaps-019upbPkMiHY5HJ5TvqwDdiN`
- **创建时间**: 2024-11-29

---

## 需求概述

### 一、公共设置优化（3个页面统一）
1. 抽取主题设置为公共元素
2. 抽取声效大小设置为公共元素

### 二、时分秒设置页面问题
- 开关状态未持久化

### 三、番茄时钟设置页面问题
- 添加翻页声音开关
- 声效开关关闭时，音量控件置灰

### 四、Stop Watch页面问题
1. 历史记录按钮始终显示
2. 历史记录弹出独立页面

### 五、国际化支持
- 添加中文、日文、韩文支持

---

## 实施计划

### Phase 1: 公共组件抽取 (2-3小时)

#### 1.1 创建公共设置组件
```
lib/shared/widgets/settings/
├── theme_selector_widget.dart      # 主题选择器
├── volume_control_widget.dart      # 音量控制
└── settings_toggle_widget.dart     # 开关组件
```

#### 1.2 创建设置数据持久化服务
```
lib/core/services/
└── settings_service.dart           # 设置持久化服务
```

**功能**:
- 使用 SharedPreferences 保存设置
- 提供统一的设置读写接口
- 支持默认值

---

### Phase 2: 时钟设置页面优化 (1小时)

#### 2.1 添加设置持久化
```dart
class ClockSettings {
  bool showDate;
  bool showWeekday;
  bool showBattery;
  bool secondFlipSound;
}
```

#### 2.2 修改文件
- `lib/features/clock/presentation/screens/clock_screen_new.dart`
- `lib/features/clock/presentation/screens/clock_settings_screen.dart`

---

### Phase 3: 番茄钟设置页面优化 (1-2小时)

#### 3.1 添加音效开关
```dart
class PomodoroSettings {
  bool soundEffectsEnabled;  // 新增
  double effectVolume;
  double ambienceVolume;
  // ...
}
```

#### 3.2 音量控件置灰逻辑
```dart
Slider(
  value: _effectVolume,
  onChanged: _soundEffectsEnabled ? (value) {...} : null,  // 禁用时为 null
  // ...
)
```

#### 3.3 修改文件
- `lib/features/pomodoro/presentation/screens/pomodoro_screen_new.dart`
- `lib/features/pomodoro/presentation/screens/pomodoro_settings_screen.dart`

---

### Phase 4: 秒表页面优化 (2小时)

#### 4.1 历史记录按钮始终显示
```dart
// 修改前
if (hasLaps) _buildHistoryButton()

// 修改后
_buildHistoryButton(enabled: hasLaps)
```

#### 4.2 创建历史记录弹出页面
```
lib/features/stopwatch/presentation/screens/
└── lap_history_screen.dart         # 圈速历史页面
```

**设计**:
- 使用 `showModalBottomSheet` 或 `showDialog`
- 全屏或半屏显示
- 列表展示所有圈速
- 支持滚动
- 显示统计信息（最快、最慢、平均）

#### 4.3 修改文件
- `lib/features/stopwatch/presentation/screens/stopwatch_screen.dart`

---

### Phase 5: 国际化支持 (3-4小时)

#### 5.1 添加依赖
```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1
```

#### 5.2 创建国际化文件结构
```
lib/l10n/
├── app_en.arb      # 英文
├── app_zh.arb      # 中文
├── app_ja.arb      # 日文
└── app_ko.arb      # 韩文
```

#### 5.3 配置国际化
```yaml
# pubspec.yaml
flutter:
  generate: true
```

```yaml
# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

#### 5.4 翻译内容清单
- 页面标题（CLOCK, TIMER, STOPWATCH）
- 设置项标签
- 按钮文字
- 提示信息
- 主题名称
- 音景名称

---

## 详细实施步骤

### Step 1: 创建公共组件

#### 1.1 主题选择器组件
```dart
// lib/shared/widgets/settings/theme_selector_widget.dart
class ThemeSelectorWidget extends StatelessWidget {
  final NeonTheme currentTheme;
  final Function(NeonTheme) onThemeChanged;
  
  // 统一的主题选择器UI
  // 可被3个设置页面复用
}
```

#### 1.2 音量控制组件
```dart
// lib/shared/widgets/settings/volume_control_widget.dart
class VolumeControlWidget extends StatelessWidget {
  final String label;
  final double value;
  final Function(double) onChanged;
  final bool enabled;  // 支持禁用状态
  final NeonTheme theme;
  
  // 统一的音量控制UI
  // 支持禁用状态（置灰）
}
```

#### 1.3 设置开关组件
```dart
// lib/shared/widgets/settings/settings_toggle_widget.dart
class SettingsToggleWidget extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final Function(bool) onChanged;
  final NeonTheme theme;
  
  // 统一的开关UI
}
```

---

### Step 2: 创建设置服务

```dart
// lib/core/services/settings_service.dart
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  
  late SharedPreferences _prefs;
  
  // 时钟设置
  Future<void> saveClockSettings(ClockSettings settings) async {...}
  ClockSettings getClockSettings() {...}
  
  // 番茄钟设置
  Future<void> savePomodoroSettings(PomodoroSettings settings) async {...}
  PomodoroSettings getPomodoroSettings() {...}
  
  // 秒表设置
  Future<void> saveStopwatchSettings(StopwatchSettings settings) async {...}
  StopwatchSettings getStopwatchSettings() {...}
  
  // 通用设置
  Future<void> saveTheme(String themeId) async {...}
  String getTheme() {...}
}
```

---

### Step 3: 国际化实施

#### 3.1 创建 ARB 文件

**app_en.arb** (英文):
```json
{
  "@@locale": "en",
  "appTitle": "NeonFocus",
  "clockTitle": "CLOCK",
  "timerTitle": "TIMER",
  "stopwatchTitle": "STOPWATCH",
  "settings": "Settings",
  "theme": "Theme",
  "soundEffects": "Sound Effects",
  "effectVolume": "Effect Volume",
  "ambienceVolume": "Ambience Volume",
  "showDate": "Show Date",
  "showWeekday": "Show Weekday",
  "showBattery": "Show Battery",
  "secondFlipSound": "Second Flip Sound",
  "soundEffectsEnabled": "Sound Effects Enabled",
  "vibrationAlert": "Vibration Alert",
  "gravityInteraction": "Gravity Interaction",
  "gravityInteractionSubtitle": "Flip phone to start/pause",
  "autoStart": "Auto Start",
  "history": "History",
  "lapNumber": "Lap {number}",
  "@lapNumber": {
    "placeholders": {
      "number": {
        "type": "int"
      }
    }
  }
}
```

**app_zh.arb** (中文):
```json
{
  "@@locale": "zh",
  "appTitle": "霓虹专注",
  "clockTitle": "时钟",
  "timerTitle": "番茄钟",
  "stopwatchTitle": "秒表",
  "settings": "设置",
  "theme": "主题",
  "soundEffects": "音效",
  "effectVolume": "音效音量",
  "ambienceVolume": "环境音音量",
  "showDate": "显示日期",
  "showWeekday": "显示星期",
  "showBattery": "显示电量",
  "secondFlipSound": "秒针翻页声",
  "soundEffectsEnabled": "启用音效",
  "vibrationAlert": "振动提醒",
  "gravityInteraction": "重力交互",
  "gravityInteractionSubtitle": "翻转手机开始/暂停",
  "autoStart": "自动开始",
  "history": "历史记录",
  "lapNumber": "第 {number} 圈"
}
```

**app_ja.arb** (日文):
```json
{
  "@@locale": "ja",
  "appTitle": "ネオンフォーカス",
  "clockTitle": "時計",
  "timerTitle": "タイマー",
  "stopwatchTitle": "ストップウォッチ",
  "settings": "設定",
  "theme": "テーマ",
  "soundEffects": "サウンドエフェクト",
  "effectVolume": "エフェクト音量",
  "ambienceVolume": "アンビエンス音量",
  "showDate": "日付を表示",
  "showWeekday": "曜日を表示",
  "showBattery": "バッテリーを表示",
  "secondFlipSound": "秒針フリップ音",
  "soundEffectsEnabled": "サウンドエフェクトを有効にする",
  "vibrationAlert": "振動アラート",
  "gravityInteraction": "重力インタラクション",
  "gravityInteractionSubtitle": "電話を裏返して開始/一時停止",
  "autoStart": "自動開始",
  "history": "履歴",
  "lapNumber": "ラップ {number}"
}
```

**app_ko.arb** (韩文):
```json
{
  "@@locale": "ko",
  "appTitle": "네온포커스",
  "clockTitle": "시계",
  "timerTitle": "타이머",
  "stopwatchTitle": "스톱워치",
  "settings": "설정",
  "theme": "테마",
  "soundEffects": "사운드 효과",
  "effectVolume": "효과음 볼륨",
  "ambienceVolume": "앰비언스 볼륨",
  "showDate": "날짜 표시",
  "showWeekday": "요일 표시",
  "showBattery": "배터리 표시",
  "secondFlipSound": "초침 플립 사운드",
  "soundEffectsEnabled": "사운드 효과 활성화",
  "vibrationAlert": "진동 알림",
  "gravityInteraction": "중력 상호작용",
  "gravityInteractionSubtitle": "전화를 뒤집어 시작/일시정지",
  "autoStart": "자동 시작",
  "history": "기록",
  "lapNumber": "랩 {number}"
}
```

#### 3.2 使用国际化

```dart
// 在 Widget 中使用
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Text(AppLocalizations.of(context)!.clockTitle)
```

---

## 文件修改清单

### 新增文件
1. `lib/shared/widgets/settings/theme_selector_widget.dart`
2. `lib/shared/widgets/settings/volume_control_widget.dart`
3. `lib/shared/widgets/settings/settings_toggle_widget.dart`
4. `lib/core/services/settings_service.dart`
5. `lib/features/stopwatch/presentation/screens/lap_history_screen.dart`
6. `lib/l10n/app_en.arb`
7. `lib/l10n/app_zh.arb`
8. `lib/l10n/app_ja.arb`
9. `lib/l10n/app_ko.arb`
10. `l10n.yaml`

### 修改文件
1. `pubspec.yaml` - 添加国际化依赖和配置
2. `lib/main.dart` - 配置国际化支持
3. `lib/features/clock/presentation/screens/clock_screen_new.dart`
4. `lib/features/clock/presentation/screens/clock_settings_screen.dart`
5. `lib/features/pomodoro/presentation/screens/pomodoro_screen_new.dart`
6. `lib/features/pomodoro/presentation/screens/pomodoro_settings_screen.dart`
7. `lib/features/stopwatch/presentation/screens/stopwatch_screen.dart`
8. `lib/features/stopwatch/presentation/screens/stopwatch_settings_screen.dart`

---

## 测试计划

### 功能测试
- [ ] 主题选择在3个页面保持同步
- [ ] 音量设置在3个页面保持同步
- [ ] 时钟设置开关状态持久化
- [ ] 番茄钟音效开关控制音量控件状态
- [ ] 秒表历史按钮始终显示
- [ ] 秒表历史记录弹出页面正常
- [ ] 4种语言切换正常

### 兼容性测试
- [ ] iOS 模拟器
- [ ] iOS 真机
- [ ] Android 模拟器
- [ ] Android 真机

---

## 预计时间

- Phase 1: 公共组件抽取 - 2-3小时
- Phase 2: 时钟设置优化 - 1小时
- Phase 3: 番茄钟设置优化 - 1-2小时
- Phase 4: 秒表页面优化 - 2小时
- Phase 5: 国际化支持 - 3-4小时

**总计**: 9-12小时

---

## 开始实施

准备好后，按照以下顺序实施：

1. ✅ 创建新分支
2. ⏳ Phase 1: 公共组件
3. ⏳ Phase 2: 时钟优化
4. ⏳ Phase 3: 番茄钟优化
5. ⏳ Phase 4: 秒表优化
6. ⏳ Phase 5: 国际化
7. ⏳ 测试验证
8. ⏳ 提交代码

---

**创建时间**: 2024-11-29  
**状态**: 准备开始实施
