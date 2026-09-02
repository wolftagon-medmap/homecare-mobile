import 'package:equatable/equatable.dart';

class GuidedBookingDraft extends Equatable {
  static const int remarksLimit = 300;

  final String category;
  final String? subCategory;
  final List<String> issueCodes;
  final String remarks;
  final List<String> addOnCodes;
  final int? addressId;
  final int? professionalId;
  final DateTime? preferredAt;

  const GuidedBookingDraft({
    required this.category,
    this.subCategory,
    this.issueCodes = const [],
    this.remarks = '',
    this.addOnCodes = const [],
    this.addressId,
    this.professionalId,
    this.preferredAt,
  });

  bool get hasIssues => issueCodes.isNotEmpty;
  bool get hasLocation => addressId != null;
  bool get hasProfessional => professionalId != null;
  bool get hasPreferredTime => preferredAt != null;

  bool get isSubmittable =>
      hasIssues && hasLocation && hasProfessional && hasPreferredTime;

  GuidedBookingDraft toggleIssue(String code) {
    final next = List<String>.from(issueCodes);
    next.contains(code) ? next.remove(code) : next.add(code);
    return _copyWith(issueCodes: next);
  }

  GuidedBookingDraft toggleAddOn(String code) {
    final next = List<String>.from(addOnCodes);
    next.contains(code) ? next.remove(code) : next.add(code);
    return _copyWith(addOnCodes: next);
  }

  GuidedBookingDraft withRemarks(String value) => _copyWith(
        remarks: value.length > remarksLimit
            ? value.substring(0, remarksLimit)
            : value,
      );

  GuidedBookingDraft withSubCategory(
    String? code, {
    required bool sharesIssueList,
  }) {
    if (code == subCategory) return this;
    return GuidedBookingDraft(
      category: category,
      subCategory: code,
      issueCodes: sharesIssueList ? issueCodes : const [],
      remarks: remarks,
      addOnCodes: sharesIssueList ? addOnCodes : const [],
      addressId: addressId,
      professionalId: professionalId,
      preferredAt: preferredAt,
    );
  }

  GuidedBookingDraft withAddress(int? id) {
    if (id == addressId) return this;
    return GuidedBookingDraft(
      category: category,
      subCategory: subCategory,
      issueCodes: issueCodes,
      remarks: remarks,
      addOnCodes: addOnCodes,
      addressId: id,
      professionalId: null,
      preferredAt: null,
    );
  }

  GuidedBookingDraft withProfessional(int? id) {
    if (id == professionalId) return this;
    return GuidedBookingDraft(
      category: category,
      subCategory: subCategory,
      issueCodes: issueCodes,
      remarks: remarks,
      addOnCodes: addOnCodes,
      addressId: addressId,
      professionalId: id,
      preferredAt: null,
    );
  }

  GuidedBookingDraft withPreferredAt(DateTime? value) =>
      _copyWith(preferredAt: value, clearPreferredAt: value == null);

  GuidedBookingDraft _copyWith({
    List<String>? issueCodes,
    String? remarks,
    List<String>? addOnCodes,
    DateTime? preferredAt,
    bool clearPreferredAt = false,
  }) {
    return GuidedBookingDraft(
      category: category,
      subCategory: subCategory,
      issueCodes: issueCodes ?? this.issueCodes,
      remarks: remarks ?? this.remarks,
      addOnCodes: addOnCodes ?? this.addOnCodes,
      addressId: addressId,
      professionalId: professionalId,
      preferredAt: clearPreferredAt ? null : (preferredAt ?? this.preferredAt),
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'sub_category': subCategory,
        'issue_codes': issueCodes,
        'remarks': remarks,
        'add_on_codes': addOnCodes,
        'address_id': addressId,
        'professional_id': professionalId,
        'preferred_at': preferredAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        category,
        subCategory,
        issueCodes,
        remarks,
        addOnCodes,
        addressId,
        professionalId,
        preferredAt,
      ];
}
