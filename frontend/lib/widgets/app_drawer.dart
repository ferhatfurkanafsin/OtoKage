import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';
import '../screens/settings_screen.dart';
import '../screens/history_screen.dart';
import '../screens/sign_in_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final authService = AuthService();

    return Drawer(
      backgroundColor: const Color(0xFF0B0D14), // Deep Space
      child: FutureBuilder<Map<String, dynamic>>(
        future: _getUserInfo(authService),
        builder: (context, snapshot) {
          final userInfo = snapshot.data ?? {'isGuest': true, 'email': null, 'name': null};
          final isGuest = userInfo['isGuest'] as bool;
          final email = userInfo['email'] as String?;
          final displayName = userInfo['name'] as String?;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header with user info
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00E5FF), // Neon Cyan
                      Color(0xFFFF6B9D), // Sakura Pink
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isGuest ? t.guestUser : displayName ?? email ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isGuest && email != null)
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Settings
              ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFF00E5FF)),
                title: Text(
                  t.settings,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),

              // History
              ListTile(
                leading: const Icon(Icons.history, color: Color(0xFF00E5FF)),
                title: Text(
                  t.historyTitle,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                },
              ),

              // Divider
              const Divider(color: Colors.white24, height: 32),

              // Language Switcher
              _LanguageSwitcherTile(),

              // Divider
              const Divider(color: Colors.white24, height: 32),

              // Sign Out (only for signed-in users)
              if (!isGuest)
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    await authService.signOut();
                    if (!context.mounted) return;
                    navigator.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                      (route) => false,
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserInfo(AuthService authService) async {
    final isGuest = await authService.isGuestMode();
    final email = await authService.getUserEmail();
    final displayName = await authService.getDisplayName();

    return {
      'isGuest': isGuest,
      'email': email,
      'name': displayName,
    };
  }
}

class _LanguageSwitcherTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final currentLang = languageService.currentLocale.languageCode;

    return ListTile(
      leading: const Icon(Icons.language, color: Color(0xFF00E5FF)),
      title: const Text(
        'Language',
        style: TextStyle(color: Colors.white),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0x1400E5FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF00E5FF), width: 1),
        ),
        child: Text(
          currentLang.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF00E5FF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1D2E),
            title: const Text(
              'Select Language',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _languageOption(context, 'English', 'en', languageService),
                _languageOption(context, 'Türkçe', 'tr', languageService),
                _languageOption(context, '日本語', 'ja', languageService),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _languageOption(BuildContext context, String label, String code, LanguageService service) {
    final isSelected = service.currentLocale.languageCode == code;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF00E5FF) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF00E5FF))
          : null,
      onTap: () {
        service.changeLanguage(code);
        Navigator.pop(context);
      },
    );
  }
}
