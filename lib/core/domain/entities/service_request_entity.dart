import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/entities/pharmacy_case.dart';
import 'package:m2health/features/homecare_elderly/domain/entities/homecare_request_data.dart';
import 'package:m2health/features/physiotherapy/domain/entities/physiotherapy_request_data.dart';
import 'package:m2health/features/second_opinion_imaging/domain/entities/second_opinion_imaging_request_data.dart';

// Unified service request that replaces per-type *_request_data fields.
// Accessors parse detail on-demand using existing typed entities.
class ServiceRequestEntity extends Equatable {
  // request_submitted | request_accepted | sample_collected | report_ready
  final String status;
  final Map<String, dynamic>? detail;

  // Pre-parsed typed entities (populated by AppointmentModel.fromJson based on type)
  final NursingCase? _nursingDetail;
  final PharmacyCase? _pharmacyDetail;
  final PhysiotherapyRequestData? _physiotherapyDetail;
  final SecondOpinionImagingRequestData? _secondOpinionDetail;
  final HomecareRequestData? _homecareDetail;

  const ServiceRequestEntity({
    required this.status,
    this.detail,
    NursingCase? nursingDetail,
    PharmacyCase? pharmacyDetail,
    PhysiotherapyRequestData? physiotherapyDetail,
    SecondOpinionImagingRequestData? secondOpinionDetail,
    HomecareRequestData? homecareDetail,
  })  : _nursingDetail = nursingDetail,
        _pharmacyDetail = pharmacyDetail,
        _physiotherapyDetail = physiotherapyDetail,
        _secondOpinionDetail = secondOpinionDetail,
        _homecareDetail = homecareDetail;

  NursingCase? asNursingDetail() => _nursingDetail;
  PharmacyCase? asPharmacyDetail() => _pharmacyDetail;
  PhysiotherapyRequestData? asPhysiotherapyDetail() => _physiotherapyDetail;
  SecondOpinionImagingRequestData? asSecondOpinionDetail() =>
      _secondOpinionDetail;
  HomecareRequestData? asHomecareDetail() => _homecareDetail;

  @override
  List<Object?> get props => [
        status,
        detail,
        _nursingDetail,
        _pharmacyDetail,
        _physiotherapyDetail,
        _secondOpinionDetail,
        _homecareDetail,
      ];
}
