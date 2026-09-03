import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_request.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_slot.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/guided_booking/domain/entities/issue_catalogue.dart';
import 'package:m2health/features/guided_booking/domain/repositories/guided_booking_repository.dart';
import 'package:m2health/features/guided_booking/domain/usecases/guided_booking_usecases.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';

class _InMemoryDraftRepository implements BookingDraftRepository {
  final Map<String, GuidedBookingDraft> store = {};
  int saves = 0;

  @override
  Future<Either<Failure, GuidedBookingDraft?>> load(String category) async =>
      Right(store[category]);

  @override
  Future<Either<Failure, Unit>> save(GuidedBookingDraft draft) async {
    saves++;
    store[draft.category] = draft;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> clear(String category) async {
    store.remove(category);
    return const Right(unit);
  }
}

class _StubCatalogueRepository implements IssueCatalogueRepository {
  @override
  Future<Either<Failure, IssueCatalogue>> getCatalogue(String category) async =>
      Right(IssueCatalogue(
        category: category,
        title: 'Home Nursing',
        pricingModel: 'per_item',
        pricingCategory: category,
        issues: const [],
        subCategories: const [
          IssueSubCategory(
            code: 'primary_nurse',
            label: 'Primary Nursing',
            serviceCode: 'nursing.basic.ngt_feeding',
          ),
          IssueSubCategory(
            code: 'specialized_nurse',
            label: 'Specialized Nursing',
            serviceCode: 'nursing.specialized.stomy_wound_care',
          ),
        ],
      ));
}

class _UnusedProfessionalRepository implements BookingProfessionalRepository {
  @override
  Future<Either<Failure, List<BookingProfessional>>> getProfessionals({
    required String category,
    int? addressId,
  }) async =>
      const Right([]);

  @override
  Future<Either<Failure, List<BookingDay>>> getAvailability(
    int professionalId, {
    required String category,
  }) async =>
      const Right([]);
}

class _UnusedAddressRepository implements BookingAddressRepository {
  @override
  Future<Either<Failure, List<Address>>> getVisitAddresses() async =>
      const Right([]);
}

class _StubSubmissionRepository implements BookingSubmissionRepository {
  GuidedBookingDraft? sent;

  @override
  Future<Either<Failure, SubmittedRequest>> submit(
    GuidedBookingDraft draft,
  ) async {
    sent = draft;
    return Right(SubmittedRequest(
      id: 1,
      status: BookingRequestStatus.pendingApproval,
      submittedAt: DateTime(2026, 9, 3),
    ));
  }

  @override
  Future<Either<Failure, SubmittedRequest>> getRequest(int id) async =>
      throw UnimplementedError();
}

void main() {
  late _InMemoryDraftRepository drafts;
  late _StubSubmissionRepository submissions;

  GuidedBookingCubit build({String? subCategory}) => GuidedBookingCubit(
        category: 'nursing',
        subCategory: subCategory,
        getIssueCatalogue: GetIssueCatalogue(_StubCatalogueRepository()),
        getProfessionals:
            GetBookingProfessionals(_UnusedProfessionalRepository()),
        getAvailability:
            GetBookingAvailability(_UnusedProfessionalRepository()),
        getVisitAddresses: GetVisitAddresses(_UnusedAddressRepository()),
        submitRequest: SubmitBookingRequest(submissions),
        loadDraft: LoadBookingDraft(drafts),
        saveDraft: SaveBookingDraft(drafts),
        clearDraft: ClearBookingDraft(drafts),
      );

  setUp(() {
    drafts = _InMemoryDraftRepository();
    submissions = _StubSubmissionRepository();
  });

  test('a saved draft is restored when the flow is re-entered', () async {
    drafts.store['nursing'] = const GuidedBookingDraft(
      category: 'nursing',
      subCategory: 'primary_nurse',
      issueCodes: ['nurse_wound_care'],
      remarks: 'Dressing change',
      addressId: 10,
      professionalId: 2,
    );

    final cubit = build();
    await cubit.loadCatalogue();

    expect(cubit.state.draft.issueCodes, ['nurse_wound_care']);
    expect(cubit.state.draft.remarks, 'Dressing change');
    expect(cubit.state.draft.addressId, 10);
    await cubit.close();
  });

  test('entering a named sub-service beats a draft for a different one',
      () async {
    drafts.store['nursing'] = const GuidedBookingDraft(
      category: 'nursing',
      subCategory: 'primary_nurse',
      issueCodes: ['nurse_wound_care'],
    );

    final cubit = build(subCategory: 'specialized_nurse');
    await cubit.loadCatalogue();

    expect(cubit.state.draft.subCategory, 'specialized_nurse');
    expect(cubit.state.draft.issueCodes, isEmpty);
    await cubit.close();
  });

  test('a mutation is persisted after the debounce', () async {
    final cubit = build();
    cubit.toggleIssue('nurse_injection');

    await Future<void>.delayed(const Duration(milliseconds: 600));

    expect(drafts.store['nursing']?.issueCodes, ['nurse_injection']);
    await cubit.close();
  });

  test('rapid mutations collapse into a single write', () async {
    final cubit = build();
    cubit.toggleIssue('a');
    cubit.toggleIssue('b');
    cubit.toggleIssue('c');

    await Future<void>.delayed(const Duration(milliseconds: 600));

    expect(drafts.saves, 1);
    expect(drafts.store['nursing']?.issueCodes, ['a', 'b', 'c']);
    await cubit.close();
  });

  test('a successful submit clears the draft', () async {
    final cubit = build();
    cubit.toggleIssue('nurse_wound_care');
    cubit.selectAddress(10);
    cubit.selectProfessional(2);
    cubit.selectSlot(DateTime(2026, 9, 8, 10));

    await cubit.submit();
    await Future<void>.delayed(const Duration(milliseconds: 600));

    expect(cubit.state.submitted, isNotNull);
    expect(drafts.store['nursing'], isNull);
    await cubit.close();
  });

  test('the submitted payload carries every field the server validates',
      () async {
    final cubit = build(subCategory: 'primary_nurse');
    cubit.toggleIssue('nurse_wound_care');
    cubit.setRemarks('Dressing change');
    cubit.selectAddress(10);
    cubit.selectProfessional(2);
    cubit.selectSlot(DateTime(2026, 9, 8, 10));

    await cubit.submit();

    expect(submissions.sent!.toJson(), {
      'category': 'nursing',
      'sub_category': 'primary_nurse',
      'issue_codes': ['nurse_wound_care'],
      'remarks': 'Dressing change',
      'add_on_codes': <String>[],
      'address_id': 10,
      'professional_id': 2,
      'preferred_at': DateTime(2026, 9, 8, 10).toIso8601String(),
    });
    await cubit.close();
  });
}
