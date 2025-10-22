class SearchHistory {
  final String songTitle;
  final String artist;
  final String album;
  final DateTime searchedAt;
  final String? spotifyUrl;
  final String? youtubeUrl;
  final int score;
  final int durationMs;

  SearchHistory({
    required this.songTitle,
    required this.artist,
    required this.album,
    required this.searchedAt,
    this.spotifyUrl,
    this.youtubeUrl,
    required this.score,
    required this.durationMs,
  });

  /// Convert from JSON
  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      songTitle: json['songTitle'] ?? 'Unknown',
      artist: json['artist'] ?? 'Unknown',
      album: json['album'] ?? 'Unknown',
      searchedAt: DateTime.parse(json['searchedAt']),
      spotifyUrl: json['spotifyUrl'],
      youtubeUrl: json['youtubeUrl'],
      score: json['score'] ?? 0,
      durationMs: json['durationMs'] ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'songTitle': songTitle,
      'artist': artist,
      'album': album,
      'searchedAt': searchedAt.toIso8601String(),
      'spotifyUrl': spotifyUrl,
      'youtubeUrl': youtubeUrl,
      'score': score,
      'durationMs': durationMs,
    };
  }

  /// Create from SongModel (from recognition result)
  factory SearchHistory.fromSongModel(dynamic song) {
    return SearchHistory(
      songTitle: song.title ?? 'Unknown',
      artist: song.artist ?? 'Unknown',
      album: song.album ?? 'Unknown',
      searchedAt: DateTime.now(),
      spotifyUrl: song.spotifyUrl,
      youtubeUrl: song.youtubeUrl,
      score: song.score ?? 0,
      durationMs: song.durationMs ?? 0,
    );
  }

  /// Format duration for display
  String get formattedDuration {
    int seconds = (durationMs / 1000).round();
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Format date for display
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(searchedAt);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${searchedAt.day}/${searchedAt.month}/${searchedAt.year}';
    }
  }
}
