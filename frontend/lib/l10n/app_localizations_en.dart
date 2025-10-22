// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'OtoKage: Anime Music Finder';

  @override
  String get homeTitleShort => 'OtoKage';

  @override
  String get homeTagline => 'Tap to search the song';

  @override
  String get homeTapToIdentify => 'Tap to search the song';

  @override
  String get cannotConnect => 'Cannot connect to server';

  @override
  String get retry => 'Retry';

  @override
  String get recordHeader => 'Record your OP/OST';

  @override
  String get recognizing => 'Recognizing...';

  @override
  String get recognizingHint => 'Please wait while we identify your song';

  @override
  String get recording => 'Recording… aim for 10–15 seconds';

  @override
  String get tapToStart => 'Tap to start; hum OP/ED or game theme';

  @override
  String get minRecordingHint => 'Hum or sing the melody for at least 10 seconds';

  @override
  String get resultHeader => 'Match';

  @override
  String get songFound => 'OST Found!';

  @override
  String get listenOn => 'Listen on:';

  @override
  String get tryAnotherSong => 'Try Another Song';

  @override
  String get noMatchFound => 'No Match Found';

  @override
  String get tipsHeader => 'Tips for better results:';

  @override
  String get tip1 => 'Hum or sing for at least 10–15 seconds';

  @override
  String get tip2 => 'Try to match the melody as closely as possible';

  @override
  String get tip3 => 'Record in a quiet environment';

  @override
  String get tip4 => 'Try a popular anime OP/ED or game theme';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get historyTitle => 'Search History';

  @override
  String get historyEmpty => 'No search history yet';

  @override
  String get historyEmptyHint => 'Your recognized songs will appear here';

  @override
  String get historyClearConfirm => 'Clear History?';

  @override
  String get historyClearMessage => 'This will delete all your search history. This action cannot be undone.';

  @override
  String get historyCancel => 'Cancel';

  @override
  String get historyClear => 'Clear';

  @override
  String get historyGuestSync => 'Sign in to save history across devices';

  @override
  String get historyGuestLocal => 'As a guest, your history is only stored locally';

  @override
  String get historyGuestBanner => 'Sign in to sync your history across devices';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithEmail => 'Continue with Email';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String matchScore(int score) {
    return 'Match: $score%';
  }

  @override
  String get signInFailed => 'Sign-in failed';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get profile => 'Profile';

  @override
  String get guestUser => 'Guest User';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirm => 'Delete Account?';

  @override
  String get deleteAccountWarning => 'This will permanently delete your account and all associated data including search history. This action cannot be undone.';

  @override
  String get deleteAccountSuccess => 'Account deleted successfully';

  @override
  String get deleteAccountFailed => 'Failed to delete account. Please try again.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get privacyAndLegal => 'Privacy & Legal';

  @override
  String get signedInAs => 'Signed in as';
}
