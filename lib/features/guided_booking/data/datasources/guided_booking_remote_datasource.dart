import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/guided_booking/data/datasources/guided_booking_datasource.dart';
import 'package:m2health/features/guided_booking/data/models/booking_models.dart';
import 'package:m2health/features/guided_booking/data/models/issue_catalogue_model.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/user_profiles/data/models/address_model.dart';
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
    double? latitude,
    double? longitude,
    String? name,
  }) async {
    final response = await dio.get(
      '${Const.URL_API}/professionals',
      queryParameters: {
        'category': category,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
        'limit': 50,
      },
      options: Options(headers: await _authHeaders()),
    );
    return _unwrapList(response.data)
        .map(BookingProfessionalModel.fromDirectoryJson)
        .toList();
  }

  @override
  Future<List<BookingDayModel>> fetchAvailability(
    int professionalId, {
    required String category,
  }) async {
    final response = await dio.get(
      '${Const.URL_API}/schedule/slots/range',
      queryParameters: {
        'provider_id': professionalId,
        'days': 14,
        'timezone': 'Asia/Singapore',
        'service_type': category,
      },
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
}

class BookingAddressRemoteDataSource implements BookingAddressDataSource {
  final Dio dio;

  BookingAddressRemoteDataSource(this.dio);

  @override
  Future<List<AddressModel>> fetchVisitAddresses() async {
    final response = await dio.get(
      '${Const.URL_API}/addresses',
      options: Options(headers: await _authHeaders()),
    );
    return _unwrapList(response.data).map(AddressModel.fromJson).toList();
  }
}

class BookingDraftRemoteDataSource implements BookingDraftDataSource {
  final Dio dio;

  BookingDraftRemoteDataSource(this.dio);

  @override
  Future<GuidedBookingDraft?> load(String category) async {
    final response = await dio.get(
      '${Const.URL_API_V2}/guided-booking/draft',
      queryParameters: {'category': category},
      options: Options(headers: await _authHeaders()),
    );
    final data = (response.data as Map?)?['data'];
    if (data is! Map<String, dynamic>) return null;
    return GuidedBookingDraftModel.fromJson(data);
  }

  @override
  Future<void> save(GuidedBookingDraft draft) async {
    await dio.put(
      '${Const.URL_API_V2}/guided-booking/draft',
      data: draft.toJson(),
      options: Options(headers: await _authHeaders()),
    );
  }

  @override
  Future<void> clear(String category) async {
    await dio.delete(
      '${Const.URL_API_V2}/guided-booking/draft',
      queryParameters: {'category': category},
      options: Options(headers: await _authHeaders()),
    );
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
