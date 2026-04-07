import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';

class AIToolsService {
  final Dio _dio;

  AIToolsService(this._dio);

  /// Transcribes audio file to text using the STT API.
  /// Returns the corrected text if successful.
  Future<String?> transcribeAudio(File audioFile) async {
    try {
      final fileName = audioFile.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: fileName,
        ),
      });

      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.post(
        Const.API_AI_TRANSCRIBE,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          return data['corrected_text'] as String?;
        }
      }
      
      log('STT API returned error: ${response.statusCode} - ${response.data}',
          name: 'AIToolsService.transcribeAudio');
      return null;
    } catch (e, stackTrace) {
      log('STT API request failed',
          name: 'AIToolsService.transcribeAudio',
          error: e,
          stackTrace: stackTrace);
      return null;
    }
  }
}
