// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '霓虹专注';

  @override
  String get clockTitle => '时钟';

  @override
  String get timerTitle => '番茄钟';

  @override
  String get stopwatchTitle => '秒表';

  @override
  String get clockSettings => '时钟设置';

  @override
  String get timerSettings => '番茄钟设置';

  @override
  String get stopwatchSettings => '秒表设置';

  @override
  String get settings => '设置';

  @override
  String get theme => '主题';

  @override
  String get clock => '时钟';

  @override
  String get pomodoro => '番茄钟';

  @override
  String get sound => '声音';

  @override
  String get soundEffects => '音效';

  @override
  String get ambientSound => '环境音';

  @override
  String get effectVolume => '音效音量';

  @override
  String get ambienceVolume => '环境音音量';

  @override
  String get showDate => '显示日期';

  @override
  String get showWeekday => '显示星期';

  @override
  String get showBattery => '显示电量';

  @override
  String get secondFlipSound => '秒针翻页声';

  @override
  String get soundEffectsEnabled => '音效开关';

  @override
  String get vibrationAlert => '振动提醒';

  @override
  String get gravityInteraction => '重力交互';

  @override
  String get gravityInteractionSubtitle => '翻转手机开始/暂停';

  @override
  String get autoStart => '自动开始';

  @override
  String get history => '历史记录';

  @override
  String lapNumber(int number) {
    return '第 $number 圈';
  }

  @override
  String get lapHistory => '圈速历史';

  @override
  String get noLaps => '暂无记录';

  @override
  String get fastest => '最快';

  @override
  String get slowest => '最慢';

  @override
  String get average => '平均';

  @override
  String get totalTime => '总时间';

  @override
  String get close => '关闭';

  @override
  String get reset => '重置';

  @override
  String get start => '开始';

  @override
  String get pause => '暂停';

  @override
  String get resume => '继续';

  @override
  String get stop => '停止';

  @override
  String get lap => '圈速';

  @override
  String get none => '无';

  @override
  String get rain => '雨声';

  @override
  String get cafe => '咖啡馆';

  @override
  String get whiteNoise => '白噪音';

  @override
  String get forest => '森林';

  @override
  String get ocean => '海浪';

  @override
  String get lofi => 'Lo-Fi音乐';

  @override
  String get cyberBlue => '赛博蓝';

  @override
  String get neonPurple => '霓虹紫';

  @override
  String get minimalDark => '极简黑';

  @override
  String get electricGreen => '电子绿';

  @override
  String get sunsetOrange => '日落橙';

  @override
  String get iceBlue => '冰蓝';
}
