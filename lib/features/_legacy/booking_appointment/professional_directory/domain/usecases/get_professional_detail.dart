import 'package:m2health/features/_legacy/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/_legacy/booking_appointment/professional_directory/domain/repositories/professional_repository.dart';

class GetProfessionalDetail {
  final ProfessionalRepository repository;

  GetProfessionalDetail(this.repository);

  Future<ProfessionalEntity> call(int id) async {
    return await repository.getProfessionalDetail(id);
  }
}
