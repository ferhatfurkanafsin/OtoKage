// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'オトカゲ：アニメ音楽ファインダー';

  @override
  String get homeTitleShort => 'OtoKage';

  @override
  String get homeTagline => 'タップして曲を検索';

  @override
  String get homeTapToIdentify => 'タップして曲を検索';

  @override
  String get cannotConnect => 'サーバーに接続できません';

  @override
  String get retry => '再試行';

  @override
  String get recordHeader => 'OP/OSTを録音';

  @override
  String get recognizing => '認識中...';

  @override
  String get recognizingHint => '曲を識別中です、お待ちください';

  @override
  String get recording => '録音中… 10〜15秒を目安に';

  @override
  String get tapToStart => 'タップして開始；OP/EDまたはゲームテーマを歌う';

  @override
  String get minRecordingHint => '少なくとも10秒間メロディーを歌ってください';

  @override
  String get resultHeader => 'マッチ';

  @override
  String get songFound => 'OST発見！';

  @override
  String get listenOn => '聴く：';

  @override
  String get tryAnotherSong => '別の曲を試す';

  @override
  String get noMatchFound => 'マッチが見つかりません';

  @override
  String get tipsHeader => 'より良い結果のためのヒント：';

  @override
  String get tip1 => '少なくとも10〜15秒間歌ってください';

  @override
  String get tip2 => 'メロディーをできるだけ正確に合わせてください';

  @override
  String get tip3 => '静かな環境で録音してください';

  @override
  String get tip4 => '人気のあるアニメOP/EDまたはゲームテーマを試してください';

  @override
  String get tryAgain => '再試行';

  @override
  String get historyTitle => '検索履歴';

  @override
  String get historyEmpty => '検索履歴がまだありません';

  @override
  String get historyEmptyHint => '認識された曲がここに表示されます';

  @override
  String get historyClearConfirm => '履歴をクリア？';

  @override
  String get historyClearMessage => 'すべての検索履歴が削除されます。この操作は元に戻せません。';

  @override
  String get historyCancel => 'キャンセル';

  @override
  String get historyClear => 'クリア';

  @override
  String get historyGuestSync => 'サインインしてすべてのデバイスで履歴を保存';

  @override
  String get historyGuestLocal => 'ゲストとして、履歴はローカルのみに保存されます';

  @override
  String get historyGuestBanner => 'サインインしてすべてのデバイスで履歴を同期';

  @override
  String get continueWithGoogle => 'Googleで続ける';

  @override
  String get continueWithEmail => 'メールで続ける';

  @override
  String get continueAsGuest => 'ゲストとして続ける';

  @override
  String matchScore(int score) {
    return '一致度：$score%';
  }

  @override
  String get signInFailed => 'サインイン失敗';

  @override
  String get email => 'メール';

  @override
  String get password => 'パスワード';

  @override
  String get settings => '設定';

  @override
  String get account => 'アカウント';

  @override
  String get profile => 'プロフィール';

  @override
  String get guestUser => 'ゲストユーザー';

  @override
  String get deleteAccount => 'アカウント削除';

  @override
  String get deleteAccountConfirm => 'アカウントを削除しますか？';

  @override
  String get deleteAccountWarning => 'これにより、アカウントと検索履歴を含むすべての関連データが完全に削除されます。この操作は元に戻せません。';

  @override
  String get deleteAccountSuccess => 'アカウントが正常に削除されました';

  @override
  String get deleteAccountFailed => 'アカウントの削除に失敗しました。もう一度お試しください。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get about => 'について';

  @override
  String get version => 'バージョン';

  @override
  String get contactUs => 'お問い合わせ';

  @override
  String get accountSettings => 'アカウント設定';

  @override
  String get privacyAndLegal => 'プライバシーと法的事項';

  @override
  String get signedInAs => 'サインイン：';
}
