import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/home_health_screening/data/models/screening_category_model.dart';
import 'package:m2health/utils.dart';

class HomeHealthScreeningRemoteDatasource {
  final Dio dio;

  HomeHealthScreeningRemoteDatasource(this.dio);

  Future<List<ScreeningCategoryModel>> getScreeningServices() async {
    final response = await dio.get(
      '${Const.URL_API}/screening-services',
    );

    return (response.data['data'] as List)
        .map((e) => ScreeningCategoryModel.fromJson(e))
        .toList();
  }

  Future<void> acceptScreeningRequest(int screeningRequestId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      await dio.post(
        '${Const.URL_API}/screening-requests/$screeningRequestId/accept',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      throw Exception('Error accepting screening request: $e');
    }
  }

  Future<void> confirmSampleCollected(int screeningRequestId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      await dio.post(
        '${Const.URL_API}/screening-requests/$screeningRequestId/sample-collected',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      throw Exception('Error confirming sample collection: $e');
    }
  }

  Future<void> markScreeningReportReady(int screeningRequestId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      await dio.post(
        '${Const.URL_API}/screening-requests/$screeningRequestId/report-ready',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      throw Exception('Error marking report ready: $e');
    }
  }
}
