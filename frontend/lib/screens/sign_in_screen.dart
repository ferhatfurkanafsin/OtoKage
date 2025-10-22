import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _loading = false;

  Future<void> _withLoader(Future<bool> Function() action) async {
    setState(() => _loading = true);
    final ok = await action();
    if (mounted) {
      setState(() => _loading = false);
      if (ok) {
        // Navigate to home screen
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        final t = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.signInFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B0D14), Color(0xFF11202A), Color(0xFF143140)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                // App title only (no tagline)
                Text(
                  t.homeTitleShort,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),

                // Email/Password input container
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x1400E5FF), // 8% opacity
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0x3300E5FF), // 20% opacity cyan
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: t.email,
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF00E5FF)),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const Divider(color: Colors.white24, height: 1),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: t.password,
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF00E5FF)),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Continue with Email button
                FilledButton(
                  onPressed: _loading
                      ? null
                      : () => _withLoader(
                            () => _auth.signInWithEmail(
                              _email.text.trim(),
                              _password.text,
                            ),
                          ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: const Color(0xFF0B0D14),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    t.continueWithEmail,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Continue with Google button (icon + text)
                OutlinedButton.icon(
                  onPressed: _loading
                      ? null
                      : () => _withLoader(_auth.signInWithGoogle),
                  icon: const Icon(Icons.account_circle, size: 24),
                  label: Text(t.continueWithGoogle),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Continue as Guest button
                TextButton(
                  onPressed: _loading
                      ? null
                      : () async {
                          final navigator = Navigator.of(context);
                          setState(() => _loading = true);
                          final ok = await _auth.continueAsGuest();
                          if (!mounted) return;
                          setState(() => _loading = false);
                          if (ok) {
                            navigator.pushReplacementNamed('/home');
                          }
                        },
                  child: Text(
                    t.continueAsGuest,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.grey.shade500,
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


