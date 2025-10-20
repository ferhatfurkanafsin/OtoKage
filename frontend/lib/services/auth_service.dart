import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _kSignedInKey = 'signed_in';
  static const _kDisplayName = 'display_name';

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kSignedInKey) ?? false;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSignedInKey, false);
    await prefs.remove(_kDisplayName);
  }

  Future<bool> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kSignedInKey, true);
      await prefs.setString(_kDisplayName, account.displayName ?? '');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    // Placeholder: accept any non-empty credentials
    if (email.isEmpty || password.isEmpty) return false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSignedInKey, true);
    await prefs.setString(_kDisplayName, email);
    return true;
  }
}


