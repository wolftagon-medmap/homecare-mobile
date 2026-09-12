import 'package:m2health/features/patient_health_profile/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';

class DeletePharmacogenomic {
  final PharmacogenomicsRepository repository;

  DeletePharmacogenomic(this.repository);

  Future<void> call(int id) async {
    await repository.deletePharmacogenomic(id);
  }
}
