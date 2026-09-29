import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/chatbot/data/models/assistant_script_model.dart';
import 'package:m2health/features/chatbot/domain/entities/assistant_script.dart';
import 'package:m2health/utils.dart';

abstract class AssistantScriptDataSource {
  Future<AssistantScript> fetch();
}

class AssistantScriptRemoteDataSource implements AssistantScriptDataSource {
  final Dio dio;

  const AssistantScriptRemoteDataSource({required this.dio});

  @override
  Future<AssistantScript> fetch() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await dio.get(
        '${Const.URL_API_V2}/assistant/script',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'];
      return AssistantScriptModel.fromJson(
        data is Map<String, dynamic> ? data : body,
      );
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Could not load the assistant.');
    }
  }
}
