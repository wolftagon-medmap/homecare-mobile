import 'package:equatable/equatable.dart';
import 'package:m2health/core/domain/entities/service_entity.dart';

class PhysiotherapyRequestData extends Equatable {
  final int id;
  final int appointmentId;
  final int duration;
  final ServiceEntity service;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PhysiotherapyRequestData({
    required this.id,
    required this.appointmentId,
    required this.duration,
    required this.service,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        appointmentId,
        duration,
        service,
        createdAt,
        updatedAt,
      ];
}
