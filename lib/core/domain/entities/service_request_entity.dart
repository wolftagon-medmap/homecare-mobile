import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_request_detail.dart';

class ServiceRequestEntity extends Equatable {
  // request_submitted | request_accepted | sample_collected | report_ready
  final String? status;
  final ServiceRequestDetail? detail;

  const ServiceRequestEntity({this.status, this.detail});

  @override
  List<Object?> get props => [status, detail];
}
