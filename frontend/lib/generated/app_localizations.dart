import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const supported = [Locale('en'), Locale('tr')];

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'VibeQuest: Anime & Game OST',
      'homeTitleShort': 'VibeQuest',
      'homeTagline': 'Anime • Game OST Finder',
      'homeTapToIdentify': 'Tap to identify OP/ED or Game OST',
      'cannotConnect': 'Cannot connect to server',
      'retry': 'Retry',
      'recordHeader': 'Record your OP/OST',
      'recognizing': 'Recognizing...',
      'recognizingHint': 'Please wait while we identify your song',
      'recording': 'Recording… aim for 10–15 seconds',
      'tapToStart': 'Tap to start; hum OP/ED or game theme',
      'minRecordingHint': 'Hum or sing the melody for at least 10 seconds',
      'resultHeader': 'Match',
      'songFound': 'OST Found!',
      'listenOn': 'Listen on:',
      'tryAnotherSong': 'Try Another Song',
      'noMatchFound': 'No Match Found',
      'tipsHeader': 'Tips for better results:',
      'tip1': 'Hum or sing for at least 10–15 seconds',
      'tip2': 'Try to match the melody as closely as possible',
      'tip3': 'Record in a quiet environment',
      'tip4': 'Try a popular anime OP/ED or game theme',
      'tryAgain': 'Try Again',
    },
    'tr': {
      'appTitle': 'VibeQuest: Anime ve Oyun OST',
      'homeTitleShort': 'VibeQuest',
      'homeTagline': 'Anime • Oyun OST Bulucu',
      'homeTapToIdentify': "OP/ED veya Oyun OST'sini tanımlamak için dokunun",
      'cannotConnect': 'Sunucuya bağlanılamıyor',
      'retry': 'Tekrar dene',
      'recordHeader': 'OP/OST kaydedin',
      'recognizing': 'Tanımlanıyor...',
      'recognizingHint': 'Şarkıyı tanımlarken lütfen bekleyin',
      'recording': 'Kaydediliyor… 10–15 saniye hedefleyin',
      'tapToStart': 'Başlamak için dokunun; OP/ED veya oyun temasını mırıldanın',
      'minRecordingHint': 'En az 10 saniye boyunca melodiyi mırıldanın veya söyleyin',
      'resultHeader': 'Eşleşme',
      'songFound': 'OST bulundu!',
      'listenOn': 'Dinle:',
      'tryAnotherSong': 'Başka bir şarkı deneyin',
      'noMatchFound': 'Eşleşme bulunamadı',
      'tipsHeader': 'Daha iyi sonuçlar için ipuçları:',
      'tip1': 'En az 10–15 saniye mırıldanın veya söyleyin',
      'tip2': 'Melodiyi olabildiğince yakından tutturmaya çalışın',
      'tip3': 'Sessiz bir ortamda kaydedin',
      'tip4': 'Popüler bir anime OP/ED veya oyun temasını deneyin',
      'tryAgain': 'Tekrar deneyin',
    },
  };

  String _t(String key) => _localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']![key] ?? key;

  String get appTitle => _t('appTitle');
  String get homeTitleShort => _t('homeTitleShort');
  String get homeTagline => _t('homeTagline');
  String get homeTapToIdentify => _t('homeTapToIdentify');
  String get cannotConnect => _t('cannotConnect');
  String get retry => _t('retry');
  String get recordHeader => _t('recordHeader');
  String get recognizing => _t('recognizing');
  String get recognizingHint => _t('recognizingHint');
  String get recording => _t('recording');
  String get tapToStart => _t('tapToStart');
  String get minRecordingHint => _t('minRecordingHint');
  String get resultHeader => _t('resultHeader');
  String get songFound => _t('songFound');
  String get listenOn => _t('listenOn');
  String get tryAnotherSong => _t('tryAnotherSong');
  String get noMatchFound => _t('noMatchFound');
  String get tipsHeader => _t('tipsHeader');
  String get tip1 => _t('tip1');
  String get tip2 => _t('tip2');
  String get tip3 => _t('tip3');
  String get tip4 => _t('tip4');
  String get tryAgain => _t('tryAgain');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

