import 'package:dio/dio.dart';
import '../models/song_model.dart';

class ApiService {
  static const String baseUrl = 'https://vgm-music-recognition.onrender.com/api';
  
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📤 REQUEST: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ERROR: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
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
