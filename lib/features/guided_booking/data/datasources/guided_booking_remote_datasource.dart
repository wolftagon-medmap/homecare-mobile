import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/guided_booking/data/datasources/guided_booking_datasource.dart';
import 'package:m2health/features/guided_booking/data/models/booking_models.dart';
import 'package:m2health/features/guided_booking/data/models/issue_catalogue_model.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/profiles/data/models/address_model.dart';
import 'package:m2health/utils.dart';

class IssueCatalogueRemoteDataSource implements IssueCatalogueDataSource {
  final Dio dio;

  IssueCatalogueRemoteDataSource(this.dio);

  @override
  Future<IssueCatalogueModel> fetchCatalogue(String category) async {
    final response = await dio.get(
      '${Const.URL_API_V2}/services/$category/issues',
      options: Options(headers: await _authHeaders()),
    );
    return IssueCatalogueModel.fromJson(_unwrap(response.data));
  }
}

class BookingProfessionalRemoteDataSource
    implements BookingProfessionalDataSource {
  final Dio dio;

  BookingProfessionalRemoteDataSource(this.dio);

  @override
  Future<List<BookingProfessionalModel>> fetchProfessionals({
    required String category,
    int? addressId,
  }) async {
    final response = await dio.get(
      '${Const.URL_API_V2}/guided-booking/professionals',
      queryParameters: {
        'category': category,
        if (addressId != null) 'address_id': addressId,
      },
      options: Options(headers: await _authHeaders()),
    );
    return _unwrapList(response.data)
        .map(BookingProfessionalModel.fromJson)
        .toList();
  }

  @override
  Future<List<BookingDayModel>> fetchAvailability(int professionalId) async {
    final response = await dio.get(
      '${Const.URL_API_V2}/guided-booking/professionals/$professionalId/availability',
      options: Options(headers: await _authHeaders()),
    );
    return _unwrapList(response.data).map(BookingDayModel.fromJson).toList();
  }
}

class BookingSubmissionRemoteDataSource implements BookingSubmissionDataSource {
  final Dio dio;

  BookingSubmissionRemoteDataSource(this.dio);

  @override
  Future<SubmittedRequestModel> submit(GuidedBookingDraft draft) async {
    final response = await dio.post(
      '${Const.URL_API_V2}/guided-booking/requests',
      data: draft.toJson(),
      options: Options(headers: await _authHeaders()),
    );
    return SubmittedRequestModel.fromJson(_unwrap(response.data));
  }

  @override
  Future<SubmittedRequestModel> fetchRequest(int id) async {
    final response = await dio.get(
      '${Const.URL_API_V2}/guided-booking/requests/$id',
      options: Options(headers: await _authHeaders()),
    );
    return SubmittedRequestModel.fromJson(_unwrap(response.data));
  }
}

class BookingAddressRemoteDataSource implements BookingAddressDataSource {
  final Dio dio;

  BookingAddressRemoteDataSource(this.dio);

  @override
  Future<List<AddressModel>> fetchVisitAddresses() async {
    final response = await dio.get(
      '${Const.URL_API_V2}/addresses',
      options: Options(headers: await _authHeaders()),
    );
    return _unwrapList(response.data).map(AddressModel.fromJson).toList();
  }
}

Future<Map<String, String>> _authHeaders() async {
  final token = await Utils.getSpString(Const.TOKEN);
  return {'Authorization': 'Bearer $token'};
}

Map<String, dynamic> _unwrap(Object? raw) {
  if (raw is Map<String, dynamic>) {
    final data = raw['data'];
    return data is Map<String, dynamic> ? data : raw;
  }
  return const {};
}

List<Map<String, dynamic>> _unwrapList(Object? raw) {
  final list = raw is Map ? raw['data'] : raw;
  return ((list as List?) ?? const []).cast<Map<String, dynamic>>();
}
