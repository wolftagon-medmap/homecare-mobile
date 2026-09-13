import 'package:m2health/features/_legacy/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/domain/repositories/professional_repository.dart';

class GetProfessionals {
  final ProfessionalRepository repository;

  GetProfessionals(this.repository);

  Future<List<ProfessionalEntity>> call(
      {String? role,
      String? name,
      List<int>? serviceIds,
      bool? isHomeScreeningAuthorized,
      String? serviceSubCategory,
      double? latitude,
      double? longitude}) async {
    return await repository.getProfessionals(
      role: role,
      name: name,
      serviceIds: serviceIds,
      isHomeScreeningAuthorized: isHomeScreeningAuthorized,
      serviceSubCategory: serviceSubCategory,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
