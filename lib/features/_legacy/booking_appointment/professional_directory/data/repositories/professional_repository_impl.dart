import 'package:m2health/features/_legacy/booking_appointment/professional_directory/data/datasources/professional_remote_datasource.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/domain/repositories/professional_repository.dart';

class ProfessionalRepositoryImpl implements ProfessionalRepository {
  ProfessionalRemoteDatasource remoteDataSource;

  ProfessionalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProfessionalEntity>> getProfessionals({
    String? role,
    String? name,
    List<int>? serviceIds,
    bool? isHomeScreeningAuthorized,
    String? serviceSubCategory,
    double? latitude,
    double? longitude,
  }) async {
    final professionals = await remoteDataSource.getProfessionals(
      role: role,
      name: name,
      serviceIds: serviceIds,
      isHomeScreeningAuthorized: isHomeScreeningAuthorized,
      serviceSubCategory: serviceSubCategory,
      latitude: latitude,
      longitude: longitude,
    );
    return professionals;
  }

  @override
  Future<ProfessionalEntity> getProfessionalDetail(int id) async {
    return await remoteDataSource.getProfessionalDetail(id);
  }

  @override
  Future<void> toggleFavorite(int professionalId, bool isFavorite) async {
    await remoteDataSource.toggleFavorite(professionalId, isFavorite);
  }
}
