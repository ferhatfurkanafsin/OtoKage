import 'dart:async';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _recordingPath;

  bool get isRecording => _isRecording;
  String? get recordingPath => _recordingPath;

  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> hasPermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  Future<bool> startRecording() async {
    try {
      if (!await hasPermission()) {
        final granted = await requestPermission();
        if (!granted) {
          return false;
        }
      }

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _recordingPath = '${directory.path}/recording_$timestamp.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _recordingPath!,
      );

      _isRecording = true;
      return true;
    } catch (e) {
      _isRecording = false;
      return false;
    }
  }

  Future<String?> stopRecording() async {
    try {
      if (!_isRecording) {
        return null;
      }

      final path = await _recorder.stop();
      _isRecording = false;

      if (path != null) {
        return path;
      } else {
        return null;
      }
    } catch (e) {
      _isRecording = false;
      return null;
    }
  }

  Future<void> cancelRecording() async {
    try {
      if (_isRecording) {
        await _recorder.stop();
        _isRecording = false;
        _recordingPath = null;
      }
    } catch (e) {
      // Silent fail
    }
  }

  void dispose() {
    _recorder.dispose();
  }
}
