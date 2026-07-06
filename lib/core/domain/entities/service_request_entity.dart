import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';

class ServiceRequestEntity extends Equatable {
  final int? id;
  // request_submitted | request_accepted | sample_collected | report_ready
  final String? status;
  final ServiceRequestDetail? detail;

  /// The patient's main concern as told to the AI agent (v2 bookings); v1
  /// manual bookings carry personal issues inside [detail] instead.
  final String? chiefComplaint;

  const ServiceRequestEntity({
    this.id,
    this.status,
    this.detail,
    this.chiefComplaint,
  });

  @override
  List<Object?> get props => [id, status, detail, chiefComplaint];
}
