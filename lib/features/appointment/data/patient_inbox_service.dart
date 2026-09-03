import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/appointment/data/models/patient_care_task_detail.dart';
import 'package:m2health/features/appointment/data/models/patient_inbox_item.dart';
import 'package:m2health/utils.dart';

/// Transport for the patient pending inbox: the unified list of v1 pending
/// appointments + v2 pre-acceptance care tasks. Appointment actions are
/// handled by the existing AppointmentService.
class PatientInboxService {
  final Dio _dio;

  PatientInboxService(this._dio);

  Future<Options> _authOptions() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
  }

  Future<List<PatientInboxItem>> fetchInbox() async {
    final response = await _dio.get(
      '${Const.URL_API_V2}/patient/inbox',
      options: await _authOptions(),
    );
    return (response.data['items'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(PatientInboxItem.fromJson)
        .toList();
  }

  /// Ask again after nobody took the booking. Returns how many professionals
  /// were asked — zero means the new time found nobody either, and the booking
  /// is still there to try again with.
  Future<int> retryAtNewTime(
    int careTaskId, {
    required DateTime start,
  }) async {
    final response = await _dio.post(
      '${Const.URL_API_V2}/care-tasks/$careTaskId/retry',
      data: {
        'preferredDate': DateFormat('yyyy-MM-dd').format(start),
        'preferredTime': DateFormat('HH:mm').format(start),
      },
      options: await _authOptions(),
    );
    return (response.data['asked'] as num?)?.toInt() ?? 0;
  }

  Future<PatientCareTaskDetail> fetchCareTaskDetail(int careTaskId) async {
    final response = await _dio.get(
      '${Const.URL_API_V2}/care-tasks/$careTaskId',
      options: await _authOptions(),
    );
    return PatientCareTaskDetail.fromJson(
        response.data['item'] as Map<String, dynamic>);
  }
}
