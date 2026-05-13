import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/data/models/service_model.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';
import 'package:m2health/utils.dart';

class ServicesRemoteDatasource {
  final Dio dio;

  ServicesRemoteDatasource(this.dio);

  // serviceType is the unified service category (e.g. 'nursing', 'pharmacy', 'screening').
  Future<List<ServiceEntity>> getServices(
      {required String category, String? subCategory}) async {
    final token = await Utils.getSpString(Const.TOKEN);
    log('Fetching services for category=$category, subcategory=$subCategory',
        name: 'ServicesRemoteDatasource');

    final response = await dio.get(
      Const.API_SERVICES,
      queryParameters: {
        'category': category,
        'subcategory': subCategory,
        'is_published': true
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    log('Response data: ${response.data}', name: 'ServicesRemoteDatasource');

    final raw = response.data;
    final list = (raw is Map ? raw['data'] : raw) as List? ?? [];
    return list
        .map((s) => ServiceModel.fromJson(s as Map<String, dynamic>))
        .toList();
  }
}
