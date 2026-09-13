import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/professional_profile/domain/entities/provider_availability.dart';
import 'package:m2health/features/professional_profile/domain/repositories/schedule_repository.dart';

class AddAvailabilitiesBulk {
  final ScheduleRepository repository;
  AddAvailabilitiesBulk(this.repository);

  Future<Either<Failure, List<ProviderAvailability>>> call(
      AddAvailabilitiesBulkParams params) async {
    return await repository.addAvailabilitiesBulk(params);
  }
}

class AddAvailabilitiesBulkParams extends Equatable {
  final List<int> days;
  final String startTime;
  final String endTime;
  final String? timezone;

  const AddAvailabilitiesBulkParams({
    required this.days,
    required this.startTime,
    required this.endTime,
    this.timezone,
  });

  @override
  List<Object?> get props => [days, startTime, endTime, timezone];

  AddAvailabilitiesBulkParams copyWith({
    List<int>? days,
    String? startTime,
    String? endTime,
    String? timezone,
  }) {
    return AddAvailabilitiesBulkParams(
      days: days ?? this.days,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timezone: timezone ?? this.timezone,
    );
  }
}
