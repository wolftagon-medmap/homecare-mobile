import 'package:m2health/core/domain/entities/service_request_entity.dart';
import 'package:m2health/features/booking_appointment/nursing/data/models/nursing_personal_case.dart';
import 'package:m2health/features/booking_appointment/pharmacy/data/models/pharmacy_personal_case.dart';
import 'package:m2health/features/homecare_elderly/data/model/homecare_request_data_model.dart';
import 'package:m2health/features/physiotherapy/data/models/physiotherapy_request_data_model.dart';
import 'package:m2health/features/second_opinion_imaging/data/models/second_opinion_imaging_request_data_model.dart';

class ServiceRequestModel extends ServiceRequestEntity {
  const ServiceRequestModel({
    required super.status,
    super.detail,
    super.nursingDetail,
    super.pharmacyDetail,
    super.physiotherapyDetail,
    super.secondOpinionDetail,
    super.homecareDetail,
  });

  // appointmentType is used to parse the typed accessor from detail.
  factory ServiceRequestModel.fromJson(
      Map<String, dynamic> json, String appointmentType) {
    final detail = json['detail'] as Map<String, dynamic>?;
    final status = json['status'] as String? ?? 'request_submitted';

    return ServiceRequestModel(
      status: status,
      detail: detail,
      nursingDetail: _tryParseNursing(detail, appointmentType),
      pharmacyDetail: _tryParsePharmacy(detail, appointmentType),
      physiotherapyDetail: _tryParsePhysiotherapy(detail, appointmentType),
      secondOpinionDetail: _tryParseSecondOpinion(detail, appointmentType),
      homecareDetail: _tryParseHomecare(detail, appointmentType),
    );
  }

  static NursingPersonalCaseModel? _tryParseNursing(
      Map<String, dynamic>? detail, String type) {
    if (type != 'nursing' || detail == null) return null;
    try {
      return NursingPersonalCaseModel.fromJson(detail);
    } catch (_) {
      return null;
    }
  }

  static PharmacyPersonalCaseModel? _tryParsePharmacy(
      Map<String, dynamic>? detail, String type) {
    if (type != 'pharmacy' || detail == null) return null;
    try {
      return PharmacyPersonalCaseModel.fromJson(detail);
    } catch (_) {
      return null;
    }
  }

  static PhysiotherapyRequestDataModel? _tryParsePhysiotherapy(
      Map<String, dynamic>? detail, String type) {
    if (type != 'physiotherapy' || detail == null) return null;
    try {
      return PhysiotherapyRequestDataModel.fromJson(detail);
    } catch (_) {
      return null;
    }
  }

  static SecondOpinionImagingRequestDataModel? _tryParseSecondOpinion(
      Map<String, dynamic>? detail, String type) {
    if (type != 'second_opinion_imaging' || detail == null) return null;
    try {
      return SecondOpinionImagingRequestDataModel.fromJson(detail);
    } catch (_) {
      return null;
    }
  }

  static HomecareRequestDataModel? _tryParseHomecare(
      Map<String, dynamic>? detail, String type) {
    if (type != 'homecare' || detail == null) return null;
    try {
      return HomecareRequestDataModel.fromJson(detail);
    } catch (_) {
      return null;
    }
  }
}
