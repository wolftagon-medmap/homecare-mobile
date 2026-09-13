import 'package:m2health/features/_legacy/booking_appointment/professional_directory/domain/entities/professional_entity.dart';

abstract class ProfessionalRepository {
  Future<List<ProfessionalEntity>> getProfessionals({
    String? role,
    String? name,
    List<int>? serviceIds,
    bool? isHomeScreeningAuthorized,
    String? serviceSubCategory,
    double? latitude,
    double? longitude,
  });
  Future<ProfessionalEntity> getProfessionalDetail(int id);
  Future<void> toggleFavorite(int professionalId, bool isFavorite);
}
