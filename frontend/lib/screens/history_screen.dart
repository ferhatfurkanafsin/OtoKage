import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/history_model.dart';
import '../services/history_service.dart';
import '../services/auth_service.dart';
import '../models/song_model.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  final AuthService _authService = AuthService();
  List<SearchHistory> _history = [];
  bool _loading = true;
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);

    final history = await _historyService.getHistory();
    final isGuest = await _authService.isGuestMode();

    if (mounted) {
      setState(() {
        _history = history;
        _isGuest = isGuest;
        _loading = false;
      });
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: const Text(
          'Clear History?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will delete all your search history. This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _historyService.clearHistory();
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0D14),
        title: Text(
          'Search History',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
              onPressed: _clearHistory,
              tooltip: 'Clear history',
            ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00E5FF),
              ),
            )
          : _history.isEmpty
              ? _buildEmptyState()
              : _buildHistoryList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history,
              size: 80,
              color: Colors.white24,
            ),
            const SizedBox(height: 24),
            Text(
              'No search history yet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your recognized songs will appear here',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (_isGuest) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0x1400E5FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0x3300E5FF),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      color: Color(0xFF00E5FF),
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sign in to save history across devices',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF00E5FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'As a guest, your history is only stored locally',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return Column(
      children: [
        if (_isGuest)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0x1400E5FF),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF00E5FF),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sign in to sync your history across devices',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final item = _history[index];
              return _buildHistoryItem(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(SearchHistory item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0x33FFFFFF),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Create a SongModel from history and navigate to result screen
            final song = _createSongModelFromHistory(item);
            final result = RecognitionResult(
              success: true,
              song: song,
              message: 'From history',
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(result: result),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00E5FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.music_note,
                        color: Color(0xFF0B0D14),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.songTitle,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.artist,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.formattedDuration,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.amber.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.score}%',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.formattedDate,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SongModel _createSongModelFromHistory(SearchHistory item) {
    // Create a minimal SongModel from history item
    return SongModel(
      title: item.songTitle,
      artist: item.artist,
      album: item.album,
      releaseDate: 'Unknown',
      durationMs: item.durationMs,
      score: item.score,
      externalMetadata: {
        'spotify': item.spotifyUrl != null ? {'track': {'id': _extractSpotifyId(item.spotifyUrl!)}} : {},
        'youtube': item.youtubeUrl != null ? {'vid': _extractYoutubeId(item.youtubeUrl!)} : {},
      },
      genres: [],
      label: 'Unknown',
    );
  }

  String? _extractSpotifyId(String url) {
    // Extract ID from https://open.spotify.com/track/ID
    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.length >= 2) {
      return uri.pathSegments.last;
    }
    return null;
  }

  String? _extractYoutubeId(String url) {
    // Extract ID from https://www.youtube.com/watch?v=ID
    final uri = Uri.tryParse(url);
    if (uri != null) {
      return uri.queryParameters['v'];
    }
    return null;
  }
}
