import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../models/history_model.dart';
import 'auth_service.dart';

class HistoryService {
  static const String _kHistoryKey = 'search_history';
  static const int _maxLocalHistory = 20;
  static const String baseUrl = 'https://otokage-backend.onrender.com/api';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  final AuthService _authService = AuthService();

  /// Save a search to history
  Future<bool> saveSearch(SearchHistory history) async {
    try {
      // Check if user is authenticated (not guest)
      final isAuth = await _authService.isAuthenticated();

      if (isAuth) {
        // Signed-in user: save to backend
        await _saveToBackend(history);
      }

      // Always save locally as well (for offline access)
      await _saveToLocal(history);

      return true;
    } catch (e) {
      // Try to save locally even if backend fails
      try {
        await _saveToLocal(history);
        return true;
      } catch (localError) {
        return false;
      }
    }
  }

  /// Get all search history
  Future<List<SearchHistory>> getHistory() async {
    try {
      // Check if user is authenticated (not guest)
      final isAuth = await _authService.isAuthenticated();

      if (isAuth) {
        // Try to get from backend first
        try {
          final backendHistory = await _getFromBackend();
          if (backendHistory.isNotEmpty) {
            return backendHistory;
          }
        } catch (e) {
          // Fall back to local
        }
      }

      // Get from local storage (for guests or if backend fails)
      return await _getFromLocal();
    } catch (e) {
      return [];
    }
  }

  /// Clear all history
  Future<bool> clearHistory() async {
    try {
      // Check if user is authenticated (not guest)
      final isAuth = await _authService.isAuthenticated();

      if (isAuth) {
        // Clear from backend
        await _clearFromBackend();
      }

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kHistoryKey);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Save to local SharedPreferences
  Future<void> _saveToLocal(SearchHistory history) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing history
    final historyJson = prefs.getString(_kHistoryKey);
    List<SearchHistory> historyList = [];

    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      historyList = decoded.map((json) => SearchHistory.fromJson(json)).toList();
    }

    // Add new history at the beginning
    historyList.insert(0, history);

    // Keep only the last N items
    if (historyList.length > _maxLocalHistory) {
      historyList = historyList.sublist(0, _maxLocalHistory);
    }

    // Save back to SharedPreferences
    final encoded = jsonEncode(historyList.map((h) => h.toJson()).toList());
    await prefs.setString(_kHistoryKey, encoded);
  }

  /// Get from local SharedPreferences
  Future<List<SearchHistory>> _getFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_kHistoryKey);

    if (historyJson == null) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded.map((json) => SearchHistory.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Save to backend
  Future<void> _saveToBackend(SearchHistory history) async {
    final email = await _authService.getUserEmail();
    if (email == null) return;

    await _dio.post(
      '/history',
      data: {
        'user_email': email,
        'history': history.toJson(),
      },
    );
  }

  /// Get from backend
  Future<List<SearchHistory>> _getFromBackend() async {
    final email = await _authService.getUserEmail();
    if (email == null) return [];

    final response = await _dio.get('/history/$email');

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List<dynamic> historyList = response.data['history'];
      return historyList.map((json) => SearchHistory.fromJson(json)).toList();
    }

    return [];
  }

  /// Clear from backend
  Future<void> _clearFromBackend() async {
    final email = await _authService.getUserEmail();
    if (email == null) return;

    await _dio.delete('/history/$email');
  }
}
