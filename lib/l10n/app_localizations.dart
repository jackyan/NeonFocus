import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'NeonFocus'**
  String get appTitle;

  /// No description provided for @clockTitle.
  ///
  /// In en, this message translates to:
  /// **'CLOCK'**
  String get clockTitle;

  /// No description provided for @timerTitle.
  ///
  /// In en, this message translates to:
  /// **'TIMER'**
  String get timerTitle;

  /// No description provided for @stopwatchTitle.
  ///
  /// In en, this message translates to:
  /// **'STOPWATCH'**
  String get stopwatchTitle;

  /// No description provided for @clockSettings.
  ///
  /// In en, this message translates to:
  /// **'CLOCK SETTINGS'**
  String get clockSettings;

  /// No description provided for @timerSettings.
  ///
  /// In en, this message translates to:
  /// **'TIMER SETTINGS'**
  String get timerSettings;

  /// No description provided for @stopwatchSettings.
  ///
  /// In en, this message translates to:
  /// **'STOPWATCH SETTINGS'**
  String get stopwatchSettings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'THEME'**
  String get theme;

  /// No description provided for @clock.
  ///
  /// In en, this message translates to:
  /// **'CLOCK'**
  String get clock;

  /// No description provided for @pomodoro.
  ///
  /// In en, this message translates to:
  /// **'POMODORO'**
  String get pomodoro;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'SOUND'**
  String get sound;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'SOUND EFFECTS'**
  String get soundEffects;

  /// No description provided for @ambientSound.
  ///
  /// In en, this message translates to:
  /// **'AMBIENT SOUND'**
  String get ambientSound;

  /// No description provided for @effectVolume.
  ///
  /// In en, this message translates to:
  /// **'Effect Volume'**
  String get effectVolume;

  /// No description provided for @ambienceVolume.
  ///
  /// In en, this message translates to:
  /// **'Ambience Volume'**
  String get ambienceVolume;

  /// No description provided for @showDate.
  ///
  /// In en, this message translates to:
  /// **'Show Date'**
  String get showDate;

  /// No description provided for @showWeekday.
  ///
  /// In en, this message translates to:
  /// **'Show Weekday'**
  String get showWeekday;

  /// No description provided for @showBattery.
  ///
  /// In en, this message translates to:
  /// **'Show Battery'**
  String get showBattery;

  /// No description provided for @secondFlipSound.
  ///
  /// In en, this message translates to:
  /// **'Second Flip Sound'**
  String get secondFlipSound;

  /// No description provided for @soundEffectsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get soundEffectsEnabled;

  /// No description provided for @vibrationAlert.
  ///
  /// In en, this message translates to:
  /// **'Vibration Alert'**
  String get vibrationAlert;

  /// No description provided for @gravityInteraction.
  ///
  /// In en, this message translates to:
  /// **'Gravity Interaction'**
  String get gravityInteraction;

  /// No description provided for @gravityInteractionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Flip phone to start/pause'**
  String get gravityInteractionSubtitle;

  /// No description provided for @autoStart.
  ///
  /// In en, this message translates to:
  /// **'Auto Start'**
  String get autoStart;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @lapNumber.
  ///
  /// In en, this message translates to:
  /// **'Lap {number}'**
  String lapNumber(int number);

  /// No description provided for @lapHistory.
  ///
  /// In en, this message translates to:
  /// **'Lap History'**
  String get lapHistory;

  /// No description provided for @noLaps.
  ///
  /// In en, this message translates to:
  /// **'No laps recorded'**
  String get noLaps;

  /// No description provided for @fastest.
  ///
  /// In en, this message translates to:
  /// **'Fastest'**
  String get fastest;

  /// No description provided for @slowest.
  ///
  /// In en, this message translates to:
  /// **'Slowest'**
  String get slowest;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @lap.
  ///
  /// In en, this message translates to:
  /// **'Lap'**
  String get lap;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @rain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get rain;

  /// No description provided for @cafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe'**
  String get cafe;

  /// No description provided for @whiteNoise.
  ///
  /// In en, this message translates to:
  /// **'White Noise'**
  String get whiteNoise;

  /// No description provided for @forest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forest;

  /// No description provided for @ocean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get ocean;

  /// No description provided for @lofi.
  ///
  /// In en, this message translates to:
  /// **'Lo-Fi'**
  String get lofi;

  /// No description provided for @cyberBlue.
  ///
  /// In en, this message translates to:
  /// **'Cyber Blue'**
  String get cyberBlue;

  /// No description provided for @neonPurple.
  ///
  /// In en, this message translates to:
  /// **'Neon Purple'**
  String get neonPurple;

  /// No description provided for @minimalDark.
  ///
  /// In en, this message translates to:
  /// **'Minimal Dark'**
  String get minimalDark;

  /// No description provided for @electricGreen.
  ///
  /// In en, this message translates to:
  /// **'Electric Green'**
  String get electricGreen;

  /// No description provided for @sunsetOrange.
  ///
  /// In en, this message translates to:
  /// **'Sunset Orange'**
  String get sunsetOrange;

  /// No description provided for @iceBlue.
  ///
  /// In en, this message translates to:
  /// **'Ice Blue'**
  String get iceBlue;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
