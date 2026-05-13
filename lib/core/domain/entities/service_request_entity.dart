import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';

class ServiceRequestEntity extends Equatable {
  final int? id;
  // request_submitted | request_accepted | sample_collected | report_ready
  final String? status;
  final ServiceRequestDetail? detail;

  const ServiceRequestEntity({this.id, this.status, this.detail});

  @override
  List<Object?> get props => [id, status, detail];
}
