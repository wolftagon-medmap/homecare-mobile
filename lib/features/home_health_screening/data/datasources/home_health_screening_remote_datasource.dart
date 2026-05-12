import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/features/booking_appointment/add_on_services/data/model/add_on_service_model.dart';
import 'package:m2health/features/home_health_screening/data/models/screening_category_model.dart';
import 'package:m2health/utils.dart';

class HomeHealthScreeningRemoteDatasource {
  final Dio dio;

  HomeHealthScreeningRemoteDatasource(this.dio);

  // v2: Returns flat list of screening services from unified catalog.
  Future<List<ServiceEntity>> getScreeningServicesV2() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_SERVICES,
      queryParameters: {'category': 'screening', 'is_published': true},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final raw = response.data;
    final list = (raw is Map ? raw['data'] : raw) as List? ?? [];
    return list
        .map((s) => AddOnServiceModel.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  // v2: Advance screening workflow status for an appointment.
  // status: request_accepted | sample_collected | report_ready
  Future<void> updateServiceRequestStatus(
      int appointmentId, String status) async {
    final token = await Utils.getSpString(Const.TOKEN);
    await dio.post(
      '${Const.API_APPOINTMENT}/service-request/status'
          .replaceFirst('/appointments', '/appointments/$appointmentId'),
      data: {'status': status},
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
    );
  }

  // ── Deprecated methods ────────────────────────────────────────────────────

  @Deprecated(
      'Use getScreeningServicesV2() with unified /services?category=screening. TODO: delete.')
  Future<List<ScreeningCategoryModel>> getScreeningServices() async {
    final response = await dio.get(
      '${Const.URL_API}/screening-services',
    );
    return (response.data['data'] as List)
        .map((e) => ScreeningCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @Deprecated(
      'Use updateServiceRequestStatus(appointmentId, "request_accepted"). TODO: delete.')
  Future<void> acceptScreeningRequest(int screeningRequestId) async {
    final token = await Utils.getSpString(Const.TOKEN);
    await dio.post(
      '${Const.URL_API}/screening-requests/$screeningRequestId/accept',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  @Deprecated(
      'Use updateServiceRequestStatus(appointmentId, "sample_collected"). TODO: delete.')
  Future<void> confirmSampleCollected(int screeningRequestId) async {
    final token = await Utils.getSpString(Const.TOKEN);
    await dio.post(
      '${Const.URL_API}/screening-requests/$screeningRequestId/sample-collected',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  @Deprecated(
      'Use updateServiceRequestStatus(appointmentId, "report_ready"). TODO: delete.')
  Future<void> markScreeningReportReady(int screeningRequestId) async {
    final token = await Utils.getSpString(Const.TOKEN);
    await dio.post(
      '${Const.URL_API}/screening-requests/$screeningRequestId/report-ready',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
