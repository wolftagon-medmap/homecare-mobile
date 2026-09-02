import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'dart:io';

abstract class FileUploadRemoteDataSource {
  Future<int> uploadFile(String filePath);
}

class FileUploadRemoteDataSourceImpl implements FileUploadRemoteDataSource {
  final Dio dio;

  FileUploadRemoteDataSourceImpl({required this.dio});

  @override
  Future<int> uploadFile(String filePath) async {
    // Backend validator: max 10MB
    const maxSizeBytes = 10 * 1024 * 1024;  
    final f = File(filePath);
    if (!await f.exists()) {
      throw Exception('Upload failed: file not found at path: $filePath');
    }
    final length = await f.length();
    if (length > maxSizeBytes) {
      throw Exception(
        'Upload failed: file is too large (${(length / (1024 * 1024)).toStringAsFixed(2)}MB). Max is 10MB.',
      );
    }

    final token = await Utils.getSpString(Const.TOKEN);

  // Use `print` (not `log`) so it consistently appears in `flutter run` output.
  print('[FileUpload] tokenPresent=${token != null && token.isNotEmpty}');

    final file = await MultipartFile.fromFile(
      filePath,
      filename: filePath.split('/').last,
    );

    final formData = FormData.fromMap({'file': file});

  print(
    '[FileUpload] POST ${Const.API_FILE_UPLOADS} size=$length path=$filePath');

    final response = await dio.post(
      Const.API_FILE_UPLOADS,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
        // Don't throw on 4xx so we can read the response body (useful for 422 validation errors).
        validateStatus: (status) {
          return true;
        },
      ),
    );

  print(
    '[FileUpload] response status=${response.statusCode} contentType=${response.headers.value('content-type')} data=${response.data}');

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300) {
      throw Exception(
        'Upload failed (status: $status, body: ${response.data})',
      );
    }

    final dynamic data = response.data;
    int? id;

    // Accept both common shapes:
    // 1) { data: { id: 123, ... } }
    // 2) { id: 123, ... }
    if (data is Map<String, dynamic>) {
      final direct = data['id'];
      if (direct is int) {
        id = direct;
      } else {
        final inner = data['data'];
        if (inner is Map<String, dynamic>) {
          final v = inner['id'];
          if (v is int) id = v;
        }
      }
    }

    if (id == null) {
      throw Exception(
        'Failed to upload file: missing id (status: ${response.statusCode}, body: ${response.data})',
      );
    }

    return id;
  }
}
