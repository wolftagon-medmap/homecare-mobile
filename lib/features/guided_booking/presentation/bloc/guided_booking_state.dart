import 'package:equatable/equatable.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_request.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_slot.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/guided_booking/domain/entities/issue_catalogue.dart';
import 'package:m2health/core/location/visit_location.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';

enum BookingLoadStatus { initial, loading, ready, failure }

class GuidedBookingState extends Equatable {
  final GuidedBookingDraft draft;

  final BookingLoadStatus catalogueStatus;
  final IssueCatalogue? catalogue;

  final BookingLoadStatus addressStatus;
  final List<Address> addresses;

  final VisitLocation? visitLocation;

  final BookingLoadStatus professionalStatus;
  final List<BookingProfessional> professionals;

  final BookingLoadStatus availabilityStatus;
  final List<BookingDay> availability;

  final bool isSubmitting;
  final SubmittedRequest? submitted;
  final String? errorMessage;

  const GuidedBookingState({
    required this.draft,
    this.catalogueStatus = BookingLoadStatus.initial,
    this.catalogue,
    this.addressStatus = BookingLoadStatus.initial,
    this.addresses = const [],
    this.visitLocation,
    this.professionalStatus = BookingLoadStatus.initial,
    this.professionals = const [],
    this.availabilityStatus = BookingLoadStatus.initial,
    this.availability = const [],
    this.isSubmitting = false,
    this.submitted,
    this.errorMessage,
  });

  List<IssueOption> get visibleIssues =>
      catalogue?.issuesFor(draft.subCategory) ?? const [];

  List<String> get selectedIssueLabels => [
        for (final code in draft.issueCodes)
          catalogue?.labelFor(code, draft.subCategory) ?? code,
      ];

  String get pricingCategory => catalogue?.pricingCategory ?? draft.category;

  List<String> get serviceCodes =>
      catalogue?.serviceCodesFor(draft.subCategory) ?? const [];

  bool get hasAddOnPath => catalogue?.hasAddOns ?? false;

  IssueSubCategory? get selectedSubCategory =>
      catalogue?.subCategory(draft.subCategory);

  /// A location the patient picked on the map or took from GPS has no address
  /// id until submit writes it, so readiness is judged on having a location at
  /// all rather than on `draft.addressId`.
  bool get canSubmit =>
      draft.hasIssues &&
      draft.hasProfessional &&
      draft.hasPreferredTime &&
      visitLocation != null;

  String? get visitAddressLabel {
    final location = visitLocation;
    if (location == null) return null;
    final formatted = location.formattedAddress;
    if (formatted != null && formatted.isNotEmpty) return formatted;
    return location.label.isEmpty ? null : location.label;
  }

  BookingProfessional? get selectedProfessional {
    for (final professional in professionals) {
      if (professional.id == draft.professionalId) return professional;
    }
    return null;
  }

  BookingDay? dayFor(DateTime date) {
    for (final day in availability) {
      if (day.date.year == date.year &&
          day.date.month == date.month &&
          day.date.day == date.day) {
        return day;
      }
    }
    return null;
  }

  GuidedBookingState copyWith({
    GuidedBookingDraft? draft,
    BookingLoadStatus? catalogueStatus,
    IssueCatalogue? catalogue,
    BookingLoadStatus? addressStatus,
    List<Address>? addresses,
    VisitLocation? visitLocation,
    BookingLoadStatus? professionalStatus,
    List<BookingProfessional>? professionals,
    BookingLoadStatus? availabilityStatus,
    List<BookingDay>? availability,
    bool? isSubmitting,
    SubmittedRequest? submitted,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GuidedBookingState(
      draft: draft ?? this.draft,
      catalogueStatus: catalogueStatus ?? this.catalogueStatus,
      catalogue: catalogue ?? this.catalogue,
      addressStatus: addressStatus ?? this.addressStatus,
      addresses: addresses ?? this.addresses,
      visitLocation: visitLocation ?? this.visitLocation,
      professionalStatus: professionalStatus ?? this.professionalStatus,
      professionals: professionals ?? this.professionals,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      availability: availability ?? this.availability,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitted: submitted ?? this.submitted,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        draft,
        catalogueStatus,
        catalogue,
        addressStatus,
        addresses,
        visitLocation,
        professionalStatus,
        professionals,
        availabilityStatus,
        availability,
        isSubmitting,
        submitted,
        errorMessage,
      ];
}
