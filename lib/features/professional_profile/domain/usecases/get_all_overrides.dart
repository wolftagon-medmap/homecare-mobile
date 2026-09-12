import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/professional_profile/domain/entities/provider_availability_override.dart';
import 'package:m2health/features/professional_profile/domain/repositories/schedule_repository.dart';

class GetAllOverrides {
  final ScheduleRepository repository;
  GetAllOverrides(this.repository);

  Future<Either<Failure, List<ProviderAvailabilityOverride>>> call() async {
    return await repository.getAllOverrides();
  }
}
