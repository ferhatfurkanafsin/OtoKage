import 'package:dio/dio.dart';
import '../models/song_model.dart';

class ApiService {
  static const String baseUrl = 'https://otokage-backend.onrender.com/api';
  
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<RecognitionResult> recognizeAudio(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(
          filePath,
          filename: 'recording.m4a',
        ),
      });

      final response = await _dio.post(
        '/recognize',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true) {
          return RecognitionResult(
            success: true,
            song: SongModel.fromJson(data['song']),
            message: data['message'],
          );
        } else {
          return RecognitionResult(
            success: false,
            message: data['message'] ?? 'No matching song found',
          );
        }
      } else {
        return RecognitionResult(
          success: false,
          message: 'Server error: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return RecognitionResult(
          success: false,
          message: e.response?.data['message'] ?? 'No matching song found',
        );
      }
      
      return RecognitionResult(
        success: false,
        message: 'Network error: ${e.message}',
      );
    } catch (e) {
      return RecognitionResult(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  Future<bool> deleteAccount(String email) async {
    try {
      final response = await _dio.delete('/account/$email');
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}

class RecognitionResult {
  final bool success;
  final SongModel? song;
  final String message;

  RecognitionResult({
    required this.success,
    this.song,
    required this.message,
  });
}
