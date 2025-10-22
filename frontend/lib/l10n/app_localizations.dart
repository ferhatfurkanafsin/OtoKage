import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_tr.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'OtoKage: Anime Music Finder'**
  String get appTitle;

  /// No description provided for @homeTitleShort.
  ///
  /// In en, this message translates to:
  /// **'OtoKage'**
  String get homeTitleShort;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Tap to search the song'**
  String get homeTagline;

  /// No description provided for @homeTapToIdentify.
  ///
  /// In en, this message translates to:
  /// **'Tap to search the song'**
  String get homeTapToIdentify;

  /// No description provided for @cannotConnect.
  ///
  /// In en, this message translates to:
  /// **'Cannot connect to server'**
  String get cannotConnect;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @recordHeader.
  ///
  /// In en, this message translates to:
  /// **'Record your OP/OST'**
  String get recordHeader;

  /// No description provided for @recognizing.
  ///
  /// In en, this message translates to:
  /// **'Recognizing...'**
  String get recognizing;

  /// No description provided for @recognizingHint.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we identify your song'**
  String get recognizingHint;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording… aim for 10–15 seconds'**
  String get recording;

  /// No description provided for @tapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to start; hum OP/ED or game theme'**
  String get tapToStart;

  /// No description provided for @minRecordingHint.
  ///
  /// In en, this message translates to:
  /// **'Hum or sing the melody for at least 10 seconds'**
  String get minRecordingHint;

  /// No description provided for @resultHeader.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get resultHeader;

  /// No description provided for @songFound.
  ///
  /// In en, this message translates to:
  /// **'OST Found!'**
  String get songFound;

  /// No description provided for @listenOn.
  ///
  /// In en, this message translates to:
  /// **'Listen on:'**
  String get listenOn;

  /// No description provided for @tryAnotherSong.
  ///
  /// In en, this message translates to:
  /// **'Try Another Song'**
  String get tryAnotherSong;

  /// No description provided for @noMatchFound.
  ///
  /// In en, this message translates to:
  /// **'No Match Found'**
  String get noMatchFound;

  /// No description provided for @tipsHeader.
  ///
  /// In en, this message translates to:
  /// **'Tips for better results:'**
  String get tipsHeader;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'Hum or sing for at least 10–15 seconds'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'Try to match the melody as closely as possible'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'Record in a quiet environment'**
  String get tip3;

  /// No description provided for @tip4.
  ///
  /// In en, this message translates to:
  /// **'Try a popular anime OP/ED or game theme'**
  String get tip4;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No search history yet'**
  String get historyEmpty;

  /// No description provided for @historyEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Your recognized songs will appear here'**
  String get historyEmptyHint;

  /// No description provided for @historyClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear History?'**
  String get historyClearConfirm;

  /// No description provided for @historyClearMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all your search history. This action cannot be undone.'**
  String get historyClearMessage;

  /// No description provided for @historyCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get historyCancel;

  /// No description provided for @historyClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get historyClear;

  /// No description provided for @historyGuestSync.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save history across devices'**
  String get historyGuestSync;

  /// No description provided for @historyGuestLocal.
  ///
  /// In en, this message translates to:
  /// **'As a guest, your history is only stored locally'**
  String get historyGuestLocal;

  /// No description provided for @historyGuestBanner.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your history across devices'**
  String get historyGuestBanner;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get continueWithEmail;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @matchScore.
  ///
  /// In en, this message translates to:
  /// **'Match: {score}%'**
  String matchScore(int score);

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get signInFailed;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all associated data including search history. This action cannot be undone.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get deleteAccountSuccess;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get deleteAccountFailed;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @privacyAndLegal.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Legal'**
  String get privacyAndLegal;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get signedInAs;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
