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
      return externalMetadata['youtube']?['vid'];
    } catch (e) {
      return null;
    }
  }

  String? get spotifyTrackId {
    try {
      return externalMetadata['spotify']?['track']?['id'];
    } catch (e) {
      return null;
    }
  }

  String? get youtubeUrl {
    final vid = youtubeVideoId;
    return vid != null ? 'https://www.youtube.com/watch?v=$vid' : null;
  }

  String? get spotifyUrl {
    final trackId = spotifyTrackId;
    return trackId != null ? 'https://open.spotify.com/track/$trackId' : null;
  }
}
