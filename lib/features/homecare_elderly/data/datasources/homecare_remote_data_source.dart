import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/data/models/service_model.dart';
import 'package:m2health/utils.dart';

abstract class HomecareRemoteDataSource {
  Future<List<ServiceModel>> getHomecareRates();
  Future<ServiceModel> updateHomecareRate(int id, double price);
}

class HomecareRemoteDataSourceImpl implements HomecareRemoteDataSource {
  final Dio dio;

  HomecareRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ServiceModel>> getHomecareRates() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_SERVICE_TITLES,
      queryParameters: {'service_type': 'homecare'},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data as List;
    return data.map((json) => ServiceModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<ServiceModel> updateHomecareRate(int id, double price) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.put(
      '${Const.API_SERVICE_TITLES}/$id',
      data: {'price': price},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data;
    return ServiceModel.fromJson(data as Map<String, dynamic>);
  }
}
