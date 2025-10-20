import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../generated/app_localizations.dart';
import 'dart:math' as math;
import '../services/api_service.dart';
import '../services/audio_service.dart';
import '../services/language_service.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final AudioService _audioService = AudioService();
  bool _isConnected = false;
  bool _isChecking = true;
  bool _isRecording = false;
  bool _isProcessing = false;
  int _recordingSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }
  @override
  void dispose() {
    _timer?.cancel();
    _audioService.dispose();
    super.dispose();
  }

  void _startTimer() {
    _recordingSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _recordingSeconds++);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    final ok = await _audioService.startRecording();
    if (!ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to start recording. Please check permissions.')),
        );
      }
      return;
    }
    setState(() => _isRecording = true);
    _startTimer();
  }

  Future<void> _stopRecording() async {
    _stopTimer();
    final path = await _audioService.stopRecording();
    if (path == null) {
      setState(() => _isRecording = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recording failed. Please try again.')),
        );
      }
      return;
    }
    setState(() {
      _isRecording = false;
      _isProcessing = true;
    });
    final result = await _apiService.recognizeAudio(path);
    setState(() => _isProcessing = false);
    if (!mounted) return;
    // Navigate to result screen as before
    Navigator.pushReplacementNamed(context, '/result', arguments: result);
  }

  Future<void> _checkConnection() async {
    setState(() => _isChecking = true);
    final connected = await _apiService.testConnection();
    setState(() {
      _isConnected = connected;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _ScanlinesOverlay()),
            Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Top Bar with App Name and Language Switcher
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.homeTitleShort,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.homeTagline,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  _LanguageSwitcher(),
                ],
              ),
              
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Concentric Circles with Waveform
                    _buildListeningHero(),
                    
                    const SizedBox(height: 60),
                    
                    // Main Text
                    Text(
                      _isProcessing
                          ? AppLocalizations.of(context)!.recognizing
                          : AppLocalizations.of(context)!.homeTapToIdentify,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_isRecording)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          '${(_recordingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_recordingSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Connection Status
              if (_isChecking)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: CircularProgressIndicator(
                    color: Color(0xFF5FBBEF),
                    strokeWidth: 2,
                  ),
                )
              else if (!_isConnected)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.orange,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.cannotConnect,
                        style: GoogleFonts.poppins(
                          color: Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _checkConnection,
                        child: Text(
                          AppLocalizations.of(context)!.retry,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF5FBBEF),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _buildListeningHero() {
    return GestureDetector(
      onTap: _isConnected && !_isProcessing ? _toggleRecording : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outermost circle
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF11202A),
                width: 1,
              ),
            ),
          ),
          
          // Middle circle
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF143140),
                width: 1,
              ),
            ),
          ),
          
          // Inner circle with gradient
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00E5FF), // Neon Cyan
                  Color(0xFFFF6B9D), // Sakura Pink
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: const Color(0xFFFF6B9D).withOpacity(0.3),
                  blurRadius: 60,
                  spreadRadius: 12,
                ),
              ],
            ),
            child: Center(
              child: _AnimatedEqualizer(),
            ),
          ),
          if (_isProcessing)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class _AnimatedEqualizer extends StatefulWidget {
  @override
  State<_AnimatedEqualizer> createState() => _AnimatedEqualizerState();
}

class _AnimatedEqualizerState extends State<_AnimatedEqualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bars = 7;
    return SizedBox(
      width: 100,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(bars, (index) {
          final phase = (index / bars) * 3.1415;
          return AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              final t = _controller.value;
              final h = (0.4 + 0.6 * (0.5 + 0.5 *
                  (math.sin(2 * math.pi * t + phase)))) * 50;
              return Container(
                width: 8,
                height: h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class _ScanlinesOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ScanlinesPainter(),
      ),
    );
  }
}

class _ScanlinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 1;
    const gap = 3.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      y += gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final currentLang = languageService.currentLocale.languageCode;

    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF00E5FF).withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF00E5FF).withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageService.getLanguageFlag(currentLang),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 6),
            Text(
              currentLang.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00E5FF),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF00E5FF),
              size: 18,
            ),
          ],
        ),
      ),
      color: const Color(0xFF1A1F2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: const Color(0xFF00E5FF).withOpacity(0.3),
          width: 1,
        ),
      ),
      itemBuilder: (context) => [
        _buildLanguageMenuItem('en', languageService),
        _buildLanguageMenuItem('tr', languageService),
        _buildLanguageMenuItem('ja', languageService),
      ],
      onSelected: (languageCode) {
        languageService.changeLanguage(languageCode);
      },
    );
  }

  PopupMenuItem<String> _buildLanguageMenuItem(
    String code,
    LanguageService languageService,
  ) {
    final isSelected = languageService.currentLocale.languageCode == code;

    return PopupMenuItem<String>(
      value: code,
      child: Row(
        children: [
          Text(
            languageService.getLanguageFlag(code),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Text(
            languageService.getLanguageName(code),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF00E5FF) : Colors.white,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            const Icon(
              Icons.check,
              color: Color(0xFF00E5FF),
              size: 18,
            ),
          ],
        ],
      ),
    );
  }
}