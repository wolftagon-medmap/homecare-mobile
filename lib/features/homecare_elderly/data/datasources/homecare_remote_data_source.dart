import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/features/booking_appointment/add_on_services/data/model/add_on_service_model.dart';

abstract class HomecareRemoteDataSource {
  Future<List<AddOnServiceModel>> getHomecareRates();
  Future<AddOnServiceModel> updateHomecareRate(int id, double price);
}

class HomecareRemoteDataSourceImpl implements HomecareRemoteDataSource {
  final Dio dio;

  HomecareRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AddOnServiceModel>> getHomecareRates() async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.get(
      Const.API_SERVICE_TITLES,
      queryParameters: {'service_type': 'homecare'},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data as List;
    return data.map((json) => AddOnServiceModel.fromJson(json)).toList();
  }

  @override
  Future<AddOnServiceModel> updateHomecareRate(int id, double price) async {
    final token = await Utils.getSpString(Const.TOKEN);
    final response = await dio.put(
      '${Const.API_SERVICE_TITLES}/$id',
      data: {'price': price},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data;
    return AddOnServiceModel.fromJson(data);
  }
}
