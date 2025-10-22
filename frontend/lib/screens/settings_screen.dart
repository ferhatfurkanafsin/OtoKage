import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../screens/sign_in_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  bool _isGuest = true;
  String? _userEmail;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final isGuest = await _authService.isGuestMode();
    final email = await _authService.getUserEmail();

    if (mounted) {
      setState(() {
        _isGuest = isGuest;
        _userEmail = email;
      });
    }
  }

  Future<void> _deleteAccount() async {
    final t = AppLocalizations.of(context)!;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D2E),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            const SizedBox(width: 12),
            Text(
              t.deleteAccountConfirm,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          t.deleteAccountWarning,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              t.cancel,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: Text(t.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Perform deletion
    setState(() => _isDeleting = true);

    final success = await _authService.deleteAccount();

    if (!mounted) return;

    setState(() => _isDeleting = false);

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.deleteAccountSuccess),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to sign-in screen
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false,
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.deleteAccountFailed),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.settings,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Settings Section
          _buildSectionHeader(t.accountSettings),
          const SizedBox(height: 8),

          // User info card
          _buildInfoCard(
            icon: Icons.person_outline,
            title: _isGuest ? t.guestUser : _userEmail ?? '',
            subtitle: _isGuest ? t.historyGuestLocal : t.signedInAs,
          ),

          const SizedBox(height: 16),

          // Delete Account Button (only for signed-in users)
          if (!_isGuest)
            _buildDangerButton(
              icon: Icons.delete_forever,
              label: t.deleteAccount,
              onTap: _isDeleting ? null : _deleteAccount,
              isLoading: _isDeleting,
            ),

          const SizedBox(height: 32),

          // Privacy & Legal Section
          _buildSectionHeader(t.privacyAndLegal),
          const SizedBox(height: 8),

          _buildLinkTile(
            icon: Icons.privacy_tip_outlined,
            title: t.privacyPolicy,
            onTap: () => _launchUrl('https://ferhatfurkanafsin.github.io/OtoKage/privacy.html'),
          ),

          _buildLinkTile(
            icon: Icons.description_outlined,
            title: t.termsOfService,
            onTap: () => _launchUrl('https://ferhatfurkanafsin.github.io/OtoKage/terms.html'),
          ),

          const SizedBox(height: 32),

          // About Section
          _buildSectionHeader(t.about),
          const SizedBox(height: 8),

          _buildInfoTile(
            icon: Icons.info_outline,
            title: t.version,
            trailing: '1.3.0',
          ),

          _buildLinkTile(
            icon: Icons.email_outlined,
            title: t.contactUs,
            onTap: () => _launchUrl('mailto:mobex10@gmail.com'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF00E5FF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x1400E5FF),
            Color(0x14FF6B9D),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x3300E5FF), width: 1.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF00E5FF),
            child: Icon(icon, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0x14FF0000),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x4DFF5252), width: 1.5),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.redAccent, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.redAccent,
                    strokeWidth: 2,
                  ),
                )
              else
                const Icon(Icons.arrow_forward_ios, color: Colors.redAccent, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF00E5FF), size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              const Icon(Icons.open_in_new, color: Colors.white38, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00E5FF), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
