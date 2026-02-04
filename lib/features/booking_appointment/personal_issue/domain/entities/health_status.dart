import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';

class HealthStatus extends Equatable {
  final MobilityStatus? mobilityStatus;
  final String? mobilityStatusDetail;
  final int? relatedHealthRecordId;

  const HealthStatus({
    this.mobilityStatus,
    this.relatedHealthRecordId,
    this.mobilityStatusDetail,
  });

  @override
  List<Object?> get props => [
        mobilityStatus,
        relatedHealthRecordId,
        mobilityStatusDetail,
      ];

  HealthStatus copyWith({
    MobilityStatus? mobilityStatus,
    Option<int>? relatedHealthRecordId,
    Option<String>? mobilityStatusDetail,
  }) {
    return HealthStatus(
      mobilityStatus: mobilityStatus ?? this.mobilityStatus,
      relatedHealthRecordId: relatedHealthRecordId == null
          ? this.relatedHealthRecordId
          : relatedHealthRecordId.fold(
              () => null,
              (value) => value,
            ),
      mobilityStatusDetail: mobilityStatusDetail == null
          ? this.mobilityStatusDetail
          : mobilityStatusDetail.fold(
              () => null,
              (value) => value,
            ),
    );
  }
}
