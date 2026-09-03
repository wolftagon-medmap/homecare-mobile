import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';

void main() {
  GuidedBookingDraft full() => const GuidedBookingDraft(
        category: 'pharmacy',
        subCategory: 'medication_support',
        issueCodes: ['med_questions', 'med_side_effects'],
        remarks: 'Twice daily',
        addOnCodes: ['addon_a'],
        addressId: 1,
        professionalId: 103,
      ).withPreferredAt(DateTime(2026, 9, 8, 9));

  group('back and edit', () {
    test('going back and re-toggling keeps everything else', () {
      final edited = full().toggleIssue('med_questions');

      expect(edited.issueCodes, ['med_side_effects']);
      expect(edited.remarks, 'Twice daily');
      expect(edited.addressId, 1);
      expect(edited.professionalId, 103);
      expect(edited.preferredAt, isNotNull);
    });

    test('toggling an issue twice restores the original draft', () {
      final draft = full();
      expect(draft.toggleIssue('new_code').toggleIssue('new_code'), draft);
    });

    test('changing the address clears the professional and the slot', () {
      final edited = full().withAddress(2);

      expect(edited.addressId, 2);
      expect(edited.professionalId, isNull);
      expect(edited.preferredAt, isNull);
      expect(edited.issueCodes, hasLength(2));
    });

    test('changing the professional clears only the slot', () {
      final edited = full().withProfessional(101);

      expect(edited.professionalId, 101);
      expect(edited.preferredAt, isNull);
      expect(edited.addressId, 1);
      expect(edited.issueCodes, hasLength(2));
    });

    test('re-picking the same value is a no-op', () {
      final draft = full();

      expect(draft.withAddress(1), draft);
      expect(draft.withProfessional(103), draft);
      expect(
        draft.withSubCategory('medication_support', sharesIssueList: false),
        draft,
      );
    });

    test('a sub-service with its own list clears the ticks', () {
      final edited =
          full().withSubCategory('quit_smoking', sharesIssueList: false);

      expect(edited.issueCodes, isEmpty);
      expect(edited.addOnCodes, isEmpty);
      expect(edited.remarks, 'Twice daily');
      expect(edited.professionalId, 103);
    });

    test('an inheriting sub-service keeps the ticks', () {
      final edited =
          full().withSubCategory('specialized_nurse', sharesIssueList: true);

      expect(edited.issueCodes, hasLength(2));
      expect(edited.addOnCodes, ['addon_a']);
    });
  });

  group('rules', () {
    test('remarks are hard-capped at the limit', () {
      final draft = full().withRemarks('x' * 500);
      expect(draft.remarks.length, GuidedBookingDraft.remarksLimit);
    });

    test('issue order follows tap order', () {
      final draft = const GuidedBookingDraft(category: 'nursing')
          .toggleIssue('b')
          .toggleIssue('a')
          .toggleIssue('c');
      expect(draft.issueCodes, ['b', 'a', 'c']);
    });

    test('submittable needs all four of issues, address, pro and time', () {
      expect(full().isSubmittable, isTrue);
      expect(full().withAddress(2).isSubmittable, isFalse);
      expect(full().withPreferredAt(null).isSubmittable, isFalse);
      expect(
        full()
            .toggleIssue('med_questions')
            .toggleIssue('med_side_effects')
            .isSubmittable,
        isFalse,
      );
    });

    test('saving a one-off pick keeps the professional and the time', () {
      // A map pin or a GPS fix carries no address id while the patient picks a
      // professional and a slot; submit fills it in afterwards.
      final picked = const GuidedBookingDraft(
        category: 'pharmacy',
        subCategory: 'medication_support',
        issueCodes: ['med_questions'],
        professionalId: 103,
      ).withPreferredAt(DateTime(2026, 9, 8, 9));

      final draft = picked.withSavedAddressId(77);

      expect(draft.addressId, 77);
      expect(draft.professionalId, 103);
      expect(draft.preferredAt, DateTime(2026, 9, 8, 9));
      expect(draft.isSubmittable, isTrue);
    });

    test('toJson carries the wire shape', () {
      expect(full().toJson(), {
        'category': 'pharmacy',
        'sub_category': 'medication_support',
        'issue_codes': ['med_questions', 'med_side_effects'],
        'remarks': 'Twice daily',
        'add_on_codes': ['addon_a'],
        'address_id': 1,
        'professional_id': 103,
        'preferred_at': DateTime(2026, 9, 8, 9).toIso8601String(),
      });
    });
  });
}
