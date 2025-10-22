import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/home_screen.dart';
import '../screens/sign_in_screen.dart';

/// AuthGate checks authentication status on app startup
/// and routes to the appropriate screen
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthStatus(),
      builder: (context, snapshot) {
        // Show loading spinner while checking auth status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0B0D14),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00E5FF),
              ),
            ),
          );
        }

        // Check if user is signed in or in guest mode
        final isAuthenticated = snapshot.data ?? false;

        if (isAuthenticated) {
          // User is signed in or guest - go to HomeScreen
          return const HomeScreen();
        } else {
          // User needs to sign in or choose guest mode
          return const SignInScreen();
        }
      },
    );
  }

  Future<bool> _checkAuthStatus() async {
    final authService = AuthService();

    // Check if user is signed in OR in guest mode
    final isSignedIn = await authService.isSignedIn();
    final isGuest = await authService.isGuestMode();

    return isSignedIn || isGuest;
  }
}
