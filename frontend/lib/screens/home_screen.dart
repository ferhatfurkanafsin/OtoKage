import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import 'dart:math' as math;
import '../services/api_service.dart';
import '../services/audio_service.dart';
import '../services/history_service.dart';
import '../models/history_model.dart';
import '../widgets/app_drawer.dart';
import 'history_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final AudioService _audioService = AudioService();
  final HistoryService _historyService = HistoryService();
  bool _isConnected = true; // Optimistic default
  bool _isChecking = false;
  bool _isRecording = false;
  bool _isProcessing = false;
  int _recordingSeconds = 0;
  Timer? _timer;
  Timer? _recognitionTimer;
  bool _foundMatch = false;

  @override
  void initState() {
    super.initState();
    // Check connection asynchronously without blocking UI
    _checkConnectionAsync();
  }

  void _checkConnectionAsync() async {
    try {
      await _checkConnection();
    } catch (e) {
      // Silently fail - user can still try to use the app
      if (mounted) {
        setState(() {
          _isConnected = false;
          _isChecking = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recognitionTimer?.cancel();
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
    // Only start recording if not already recording or processing
    if (!_isRecording && !_isProcessing) {
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
    setState(() {
      _isRecording = true;
      _foundMatch = false;
    });
    _startTimer();

    // Try recognition at 5, 10, and 15 seconds
    // This allows early detection if song is found quickly
    _scheduleProgressiveRecognition();
  }

  void _scheduleProgressiveRecognition() {
    // Try recognition at 5 seconds
    Future.delayed(const Duration(seconds: 5), () async {
      if (_isRecording && !_foundMatch && mounted) {
        await _tryRecognition();
      }
    });

    // Try recognition at 10 seconds if not found yet
    Future.delayed(const Duration(seconds: 10), () async {
      if (_isRecording && !_foundMatch && mounted) {
        await _tryRecognition();
      }
    });

    // Final attempt at 15 seconds - stop regardless
    Future.delayed(const Duration(seconds: 15), () async {
      if (_isRecording && mounted) {
        await _stopRecordingAndRecognize();
      }
    });
  }

  Future<void> _tryRecognition() async {
    if (!_isRecording || _foundMatch) return;

    // Get current audio path without stopping recording
    final path = await _audioService.stopRecording();
    if (path == null) return;

    // Immediately restart recording to continue
    final restartOk = await _audioService.startRecording();
    if (!restartOk) {
      return;
    }

    // Try recognition in background
    setState(() => _isProcessing = true);
    final result = await _apiService.recognizeAudio(path);

    if (!mounted) return;

    // If match found, stop recording and show result
    if (result.success) {
      _foundMatch = true;
      await _audioService.stopRecording();
      setState(() {
        _isRecording = false;
        _isProcessing = false;
      });
      _stopTimer();

      // Save to history
      if (result.song != null) {
        final historyItem = SearchHistory.fromSongModel(result.song);
        await _historyService.saveSearch(historyItem);
      }

      if (!mounted) return;
      Navigator.pushNamed(context, '/result', arguments: result);
    } else {
      // No match yet, keep recording
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _stopRecordingAndRecognize() async {
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

    // Save to history if successful
    if (result.success && result.song != null) {
      final historyItem = SearchHistory.fromSongModel(result.song);
      await _historyService.saveSearch(historyItem);
    }

    // Navigate to result screen
    if (!mounted) return;
    Navigator.pushNamed(context, '/result', arguments: result);
  }

  Future<void> _checkConnection() async {
    if (!mounted) return;
    setState(() => _isChecking = true);
    try {
      final connected = await _apiService.testConnection();
      if (mounted) {
        setState(() {
          _isConnected = connected;
          _isChecking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isConnected = false;
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _ScanlinesOverlay()),
            Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Top Bar with Hamburger Menu, App Name and History Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white70, size: 28),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        tooltip: 'Menu',
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.homeTitleShort,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.history, color: Colors.white70, size: 24),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryScreen(),
                        ),
                      );
                    },
                    tooltip: 'Search History',
                  ),
                ],
              ),
              
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Concentric Circles with Waveform
                    _buildListeningHero(),
                    
                    const SizedBox(height: 60),
                    
                    // Main Text - hide during recording/processing
                    if (!_isRecording && !_isProcessing)
                      Text(
                        AppLocalizations.of(context)!.homeTapToIdentify,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (_isProcessing)
                      Text(
                        AppLocalizations.of(context)!.recognizing,
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00E5FF), // Neon Cyan
                  Color(0xFFFF6B9D), // Sakura Pink
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x6600E5FF), // 40% opacity
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: Color(0x4DFF6B9D), // 30% opacity
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
    const bars = 7;
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
      ..color = const Color(0x05FFFFFF) // 2% opacity
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