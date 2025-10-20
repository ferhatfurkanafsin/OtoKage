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
  String get homeTagline => 'Identify Anime OPs, EDs & Game OSTs';

  @override
  String get homeTapToIdentify => 'Tap to identify Anime OP/ED or Game OST';

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
}
