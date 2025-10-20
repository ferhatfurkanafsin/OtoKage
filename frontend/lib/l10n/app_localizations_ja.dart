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
  String get homeTagline => 'アニメOP・ED・ゲームOSTを識別';

  @override
  String get homeTapToIdentify => 'タップしてアニメOP/EDまたはゲームOSTを識別';

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
}
