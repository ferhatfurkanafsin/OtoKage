import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static const _kSignedInKey = 'signed_in';
  static const _kDisplayName = 'display_name';
  static const _kGuestModeKey = 'guest_mode';
  static const _kUserEmailKey = 'user_email';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<bool> isSignedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kSignedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kSignedInKey, false);
      await prefs.setBool(_kGuestModeKey, false);
      await prefs.remove(_kDisplayName);
      await prefs.remove(_kUserEmailKey);
    } catch (e) {
      // Silently fail
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kSignedInKey, true);
      await prefs.setBool(_kGuestModeKey, false);
      await prefs.setString(_kDisplayName, account.displayName ?? '');
      await prefs.setString(_kUserEmailKey, account.email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      // Simple validation - accept any non-empty credentials
      if (email.isEmpty || password.isEmpty) return false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kSignedInKey, true);
      await prefs.setBool(_kGuestModeKey, false);
      await prefs.setString(_kDisplayName, email);
      await prefs.setString(_kUserEmailKey, email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getDisplayName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_kDisplayName);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is in guest mode
  Future<bool> isGuestMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_kGuestModeKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Continue as guest without signing in
  Future<bool> continueAsGuest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kGuestModeKey, true);
      await prefs.setBool(_kSignedInKey, false);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get user email (for history sync)
  Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_kUserEmailKey);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated (signed in, not guest)
  Future<bool> isAuthenticated() async {
    final signedIn = await isSignedIn();
    final guest = await isGuestMode();
    return signedIn && !guest;
  }

  /// Delete account and all associated data
  Future<bool> deleteAccount() async {
    try {
      final email = await getUserEmail();
      if (email == null) return false;

      // Call backend to delete user data
      final apiService = ApiService();
      final deleted = await apiService.deleteAccount(email);

      if (deleted) {
        // Clear all local data
        await _googleSignIn.signOut();
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}


