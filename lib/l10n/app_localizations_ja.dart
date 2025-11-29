// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ネオンフォーカス';

  @override
  String get clockTitle => '時計';

  @override
  String get timerTitle => 'タイマー';

  @override
  String get stopwatchTitle => 'ストップウォッチ';

  @override
  String get clockSettings => '時計設定';

  @override
  String get timerSettings => 'タイマー設定';

  @override
  String get stopwatchSettings => 'ストップウォッチ設定';

  @override
  String get settings => '設定';

  @override
  String get theme => 'テーマ';

  @override
  String get clock => '時計';

  @override
  String get pomodoro => 'ポモドーロ';

  @override
  String get sound => 'サウンド';

  @override
  String get soundEffects => 'サウンドエフェクト';

  @override
  String get ambientSound => 'アンビエントサウンド';

  @override
  String get effectVolume => 'エフェクト音量';

  @override
  String get ambienceVolume => 'アンビエンス音量';

  @override
  String get showDate => '日付を表示';

  @override
  String get showWeekday => '曜日を表示';

  @override
  String get showBattery => 'バッテリーを表示';

  @override
  String get secondFlipSound => '秒針フリップ音';

  @override
  String get soundEffectsEnabled => 'サウンドエフェクト';

  @override
  String get vibrationAlert => '振動アラート';

  @override
  String get gravityInteraction => '重力インタラクション';

  @override
  String get gravityInteractionSubtitle => '電話を裏返して開始/一時停止';

  @override
  String get autoStart => '自動開始';

  @override
  String get history => '履歴';

  @override
  String lapNumber(int number) {
    return 'ラップ $number';
  }

  @override
  String get lapHistory => 'ラップ履歴';

  @override
  String get noLaps => '記録なし';

  @override
  String get fastest => '最速';

  @override
  String get slowest => '最遅';

  @override
  String get average => '平均';

  @override
  String get totalTime => '合計時間';

  @override
  String get close => '閉じる';

  @override
  String get reset => 'リセット';

  @override
  String get start => '開始';

  @override
  String get pause => '一時停止';

  @override
  String get resume => '再開';

  @override
  String get stop => '停止';

  @override
  String get lap => 'ラップ';

  @override
  String get none => 'なし';

  @override
  String get rain => '雨';

  @override
  String get cafe => 'カフェ';

  @override
  String get whiteNoise => 'ホワイトノイズ';

  @override
  String get forest => '森';

  @override
  String get ocean => '海';

  @override
  String get lofi => 'Lo-Fi';

  @override
  String get cyberBlue => 'サイバーブルー';

  @override
  String get neonPurple => 'ネオンパープル';

  @override
  String get minimalDark => 'ミニマルダーク';

  @override
  String get electricGreen => 'エレクトリックグリーン';

  @override
  String get sunsetOrange => 'サンセットオレンジ';

  @override
  String get iceBlue => 'アイスブルー';
}
