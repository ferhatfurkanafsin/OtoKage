class SongModel {
  final String title;
  final String artist;
  final String album;
  final String releaseDate;
  final int durationMs;
  final int score;
  final Map<String, dynamic> externalMetadata;
  final List<dynamic> genres;
  final String label;

  SongModel({
    required this.title,
    required this.artist,
    required this.album,
    required this.releaseDate,
    required this.durationMs,
    required this.score,
    required this.externalMetadata,
    required this.genres,
    required this.label,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      title: json['title'] ?? 'Unknown',
      artist: json['artist'] ?? 'Unknown',
      album: json['album'] ?? 'Unknown',
      releaseDate: json['release_date'] ?? 'Unknown',
      durationMs: json['duration_ms'] ?? 0,
      score: json['score'] ?? 0,
      externalMetadata: json['external_metadata'] ?? {},
      genres: json['genres'] ?? [],
      label: json['label'] ?? 'Unknown',
    );
  }

  String get formattedDuration {
    int seconds = (durationMs / 1000).round();
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String? get youtubeVideoId {
    try {
      final vid = externalMetadata['youtube']?['vid'];
      if (vid == null || vid.toString().isEmpty) {
        return null;
      }
      return vid.toString();
    } catch (e) {
      return null;
    }
  }

  String? get spotifyTrackId {
    try {
      final trackId = externalMetadata['spotify']?['track']?['id'];
      if (trackId == null || trackId.toString().isEmpty) {
        return null;
      }
      return trackId.toString();
    } catch (e) {
      return null;
    }
  }

  String? get youtubeUrl {
    final vid = youtubeVideoId;
    if (vid == null || vid.isEmpty) {
      return null;
    }
    final url = 'https://www.youtube.com/watch?v=$vid';
    return url;
  }

  String? get spotifyUrl {
    final trackId = spotifyTrackId;
    if (trackId == null || trackId.isEmpty) {
      return null;
    }
    final url = 'https://open.spotify.com/track/$trackId';
    return url;
  }
}
