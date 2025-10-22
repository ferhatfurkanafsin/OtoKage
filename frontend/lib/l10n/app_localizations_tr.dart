// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'OtoKage: Anime Müzik Bulucu';

  @override
  String get homeTitleShort => 'OtoKage';

  @override
  String get homeTagline => 'Şarkıyı aramak için dokunun';

  @override
  String get homeTapToIdentify => 'Şarkıyı aramak için dokunun';

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

  @override
  String get historyTitle => 'Arama Geçmişi';

  @override
  String get historyEmpty => 'Henüz arama geçmişi yok';

  @override
  String get historyEmptyHint => 'Tanınan şarkılarınız burada görünecek';

  @override
  String get historyClearConfirm => 'Geçmişi temizle?';

  @override
  String get historyClearMessage => 'Bu, tüm arama geçmişinizi silecektir. Bu işlem geri alınamaz.';

  @override
  String get historyCancel => 'İptal';

  @override
  String get historyClear => 'Temizle';

  @override
  String get historyGuestSync => 'Geçmişi tüm cihazlarda kaydetmek için giriş yapın';

  @override
  String get historyGuestLocal => 'Misafir olarak geçmişiniz yalnızca yerel olarak saklanır';

  @override
  String get historyGuestBanner => 'Geçmişinizi tüm cihazlarda senkronize etmek için giriş yapın';

  @override
  String get continueWithGoogle => 'Google ile devam et';

  @override
  String get continueWithEmail => 'E-posta ile devam et';

  @override
  String get continueAsGuest => 'Misafir olarak devam et';

  @override
  String matchScore(int score) {
    return 'Eşleşme: %$score';
  }

  @override
  String get signInFailed => 'Giriş başarısız';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get settings => 'Ayarlar';

  @override
  String get account => 'Hesap';

  @override
  String get profile => 'Profil';

  @override
  String get guestUser => 'Misafir Kullanıcı';

  @override
  String get deleteAccount => 'Hesabı Sil';

  @override
  String get deleteAccountConfirm => 'Hesap Silinsin mi?';

  @override
  String get deleteAccountWarning => 'Bu, hesabınızı ve arama geçmişi dahil tüm ilişkili verileri kalıcı olarak silecektir. Bu işlem geri alınamaz.';

  @override
  String get deleteAccountSuccess => 'Hesap başarıyla silindi';

  @override
  String get deleteAccountFailed => 'Hesap silinemedi. Lütfen tekrar deneyin.';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get termsOfService => 'Hizmet Şartları';

  @override
  String get about => 'Hakkında';

  @override
  String get version => 'Sürüm';

  @override
  String get contactUs => 'Bize Ulaşın';

  @override
  String get accountSettings => 'Hesap Ayarları';

  @override
  String get privacyAndLegal => 'Gizlilik ve Yasal';

  @override
  String get signedInAs => 'Giriş yapıldı:';
}
