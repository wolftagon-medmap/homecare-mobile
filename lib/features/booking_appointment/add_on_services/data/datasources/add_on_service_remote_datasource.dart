import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/booking_appointment/add_on_services/data/model/add_on_service_model.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/utils.dart';

class AddOnServiceRemoteDatasource {
  final Dio dio;

  AddOnServiceRemoteDatasource(this.dio);

  // serviceType is now the unified service category (e.g. 'nursing', 'pharmacy', 'screening').
  Future<List<AddOnService>> getAddOnServices(String serviceType) async {
    final token = await Utils.getSpString(Const.TOKEN);
    log('Fetching services for category=$serviceType',
        name: 'AddOnServiceRemoteDatasource');

    final response = await dio.get(
      Const.API_SERVICES,
      queryParameters: {'category': serviceType, 'is_published': true},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    log('Response data: ${response.data}',
        name: 'AddOnServiceRemoteDatasource');

    final raw = response.data;
    final list = (raw is Map ? raw['data'] : raw) as List? ?? [];
    return list
        .map((s) => AddOnServiceModel.fromJson(s as Map<String, dynamic>))
        .toList();
  }
}
