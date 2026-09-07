import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_request.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_slot.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';

class BookingProfessionalModel extends BookingProfessional {
  const BookingProfessionalModel({
    required super.id,
    required super.name,
    super.avatar,
    super.jobTitle,
    required super.rating,
    super.reviewCount,
    required super.yearsOfExperience,
    super.categories,
    super.servedAddressIds,
  });

  factory BookingProfessionalModel.fromDirectoryJson(
      Map<String, dynamic> json) {
    return BookingProfessionalModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] as String?,
      jobTitle:
          (json['job_title'] ?? json['jobTitle'] ?? json['role']) as String?,
      rating: _toDouble(json['rating']) ?? 0,
      reviewCount:
          ((json['rating_count'] ?? json['ratingCount']) as num?)?.toInt() ?? 0,
      yearsOfExperience: (json['experience'] as num?)?.toInt() ?? 0,
    );
  }

  factory BookingProfessionalModel.fromJson(Map<String, dynamic> json) {
    return BookingProfessionalModel(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      jobTitle: json['job_title'] as String?,
      rating: _toDouble(json['rating']) ?? 0,
      reviewCount: json['review_count'] as int? ?? 0,
      yearsOfExperience: json['years_of_experience'] as int? ?? 0,
      categories: ((json['categories'] as List?) ?? const []).cast<String>(),
      servedAddressIds:
          ((json['served_address_ids'] as List?) ?? const []).cast<int>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'job_title': jobTitle,
        'rating': rating,
        'review_count': reviewCount,
        'years_of_experience': yearsOfExperience,
        'categories': categories,
        'served_address_ids': servedAddressIds,
      };
}

class BookingSlotModel extends BookingSlot {
  const BookingSlotModel({
    required super.startTime,
    required super.endTime,
    super.isAvailable,
  });

  factory BookingSlotModel.fromJson(Map<String, dynamic> json) {
    return BookingSlotModel(
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'is_available': isAvailable,
      };
}

class BookingDayModel extends BookingDay {
  const BookingDayModel({required super.date, required super.slots});

  factory BookingDayModel.fromJson(Map<String, dynamic> json) {
    final slots = (json['slots'] as List?) ?? const [];
    return BookingDayModel(
      date: DateTime.parse(json['date'] as String),
      slots: slots
          .map(
              (slot) => BookingSlotModel.fromJson(slot as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String().split('T').first,
        'slots': slots
            .map((slot) => BookingSlotModel(
                  startTime: slot.startTime,
                  endTime: slot.endTime,
                  isAvailable: slot.isAvailable,
                ).toJson())
            .toList(),
      };
}

class SubmittedRequestModel extends SubmittedRequest {
  const SubmittedRequestModel({
    required super.id,
    required super.status,
    required super.submittedAt,
    super.professionalName,
    super.preferredAt,
    super.proposedAt,
  });

  factory SubmittedRequestModel.fromJson(Map<String, dynamic> json) {
    return SubmittedRequestModel(
      id: json['id'] as int,
      status: BookingRequestStatus.fromWire(json['status'] as String?),
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      professionalName: json['professional_name'] as String?,
      preferredAt: _toDate(json['preferred_at']),
      proposedAt: _toDate(json['proposed_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': _statusToWire(status),
        'submitted_at': submittedAt.toIso8601String(),
        'professional_name': professionalName,
        'preferred_at': preferredAt?.toIso8601String(),
        'proposed_at': proposedAt?.toIso8601String(),
      };
}

String _statusToWire(BookingRequestStatus status) => switch (status) {
      BookingRequestStatus.pendingApproval => 'pending',
      BookingRequestStatus.confirmed => 'accepted',
      BookingRequestStatus.alternativeProposed => 'time_proposed',
      BookingRequestStatus.cancelled => 'cancelled',
    };

double? _toDouble(Object? value) => switch (value) {
      null => null,
      final num n => n.toDouble(),
      final String s => double.tryParse(s),
      _ => null,
    };

DateTime? _toDate(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

class GuidedBookingDraftModel {
  const GuidedBookingDraftModel._();

  // Returns the entity, not a subclass: Equatable compares runtimeType, so a
  // model instance would never equal an otherwise identical draft.
  static GuidedBookingDraft fromJson(Map<String, dynamic> json) {
    final preferredAt = json['preferred_at'] as String?;
    return GuidedBookingDraft(
      category: json['category'] as String,
      subCategory: json['sub_category'] as String?,
      issueCodes: ((json['issue_codes'] as List?) ?? const []).cast<String>(),
      remarks: json['remarks'] as String? ?? '',
      addOnCodes: ((json['add_on_codes'] as List?) ?? const []).cast<String>(),
      addressId: json['address_id'] as int?,
      professionalId: json['professional_id'] as int?,
      preferredAt: preferredAt == null ? null : DateTime.tryParse(preferredAt),
    );
  }
}
