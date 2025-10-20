// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'VibeQuest: Anime ve Oyun OST';

  @override
  String get homeTitleShort => 'VibeQuest';

  @override
  String get homeTagline => 'Anime • Oyun OST Bulucu';

  @override
  String get homeTapToIdentify => 'OP/ED veya Oyun OST\'sini tanımlamak için dokunun';

  @override
  String get cannotConnect => 'Sunucuya bağlanılamıyor';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get recordHeader => 'OP/OST kaydedin';

  @override
  String get recognizing => 'Tanımlanıyor...';

  @override
  String get recognizingHint => 'Şarkıyı tanımlarken lütfen bekleyin';

  @override
  String get recording => 'Kaydediliyor… 10–15 saniye hedefleyin';

  @override
  String get tapToStart => 'Başlamak için dokunun; OP/ED veya oyun temasını mırıldanın';

  @override
  String get minRecordingHint => 'En az 10 saniye boyunca melodiyi mırıldanın veya söyleyin';

  @override
  String get resultHeader => 'Eşleşme';

  @override
  String get songFound => 'OST bulundu!';

  @override
  String get listenOn => 'Dinle:';

  @override
  String get tryAnotherSong => 'Başka bir şarkı deneyin';

  @override
  String get noMatchFound => 'Eşleşme bulunamadı';

  @override
  String get tipsHeader => 'Daha iyi sonuçlar için ipuçları:';

  @override
  String get tip1 => 'En az 10–15 saniye mırıldanın veya söyleyin';

  @override
  String get tip2 => 'Melodiyi olabildiğince yakından tutturmaya çalışın';

  @override
  String get tip3 => 'Sessiz bir ortamda kaydedin';

  @override
  String get tip4 => 'Popüler bir anime OP/ED veya oyun temasını deneyin';

  @override
  String get tryAgain => 'Tekrar deneyin';
}
