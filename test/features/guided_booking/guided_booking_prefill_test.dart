import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/location/current_location_service.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_professional.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_request.dart';
import 'package:m2health/features/guided_booking/domain/entities/booking_slot.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/guided_booking/domain/entities/issue_catalogue.dart';
import 'package:m2health/features/guided_booking/domain/repositories/guided_booking_repository.dart';
import 'package:m2health/features/guided_booking/domain/usecases/guided_booking_usecases.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';
import 'package:m2health/features/user_profiles/domain/entities/address.dart';

class _RecordingDraftRepository implements BookingDraftRepository {
  final Map<String, GuidedBookingDraft> store = {};
  int loads = 0;

  @override
  Future<Either<Failure, GuidedBookingDraft?>> load(String category) async {
    loads++;
    return Right(store[category]);
  }

  @override
  Future<Either<Failure, Unit>> save(GuidedBookingDraft draft) async {
    store[draft.category] = draft;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> clear(String category) async {
    store.remove(category);
    return const Right(unit);
  }
}

class _PharmacyCatalogueRepository implements IssueCatalogueRepository {
  _PharmacyCatalogueRepository({this.subCategoryCount = 2});

  final int subCategoryCount;

  @override
  Future<Either<Failure, IssueCatalogue>> getCatalogue(String category) async =>
      Right(IssueCatalogue(
        category: category,
        title: 'Pharmacist Review',
        pricingModel: 'per_item',
        pricingCategory: category,
        subCategories: [
          const IssueSubCategory(
            code: 'medication_support',
            label: 'Medication Support',
            issues: [
              IssueOption(code: 'med_side_effects', label: 'Side effects'),
              IssueOption(code: 'med_interactions', label: 'Interactions'),
            ],
          ),
          if (subCategoryCount > 1)
            const IssueSubCategory(
              code: 'chronic_care',
              label: 'Chronic care',
              issues: [IssueOption(code: 'chronic_review', label: 'Review')],
            ),
        ],
      ));
}

class _UnusedProfessionalRepository implements BookingProfessionalRepository {
  @override
  Future<Either<Failure, List<BookingProfessional>>> getProfessionals({
    required String category,
    double? latitude,
    double? longitude,
    String? name,
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

class _UnusedSubmissionRepository implements BookingSubmissionRepository {
  @override
  Future<Either<Failure, SubmittedRequest>> submit(
    GuidedBookingDraft draft,
  ) async =>
      throw UnimplementedError();
}

void main() {
  late _RecordingDraftRepository drafts;

  GuidedBookingCubit build({
    String? subCategory,
    List<String> issueCodes = const [],
    String? remarks,
    int subCategoryCount = 2,
  }) =>
      GuidedBookingCubit(
        category: 'pharmacy',
        subCategory: subCategory,
        initialIssueCodes: issueCodes,
        initialRemarks: remarks,
        getIssueCatalogue: GetIssueCatalogue(
          _PharmacyCatalogueRepository(subCategoryCount: subCategoryCount),
        ),
        getProfessionals:
            GetBookingProfessionals(_UnusedProfessionalRepository()),
        getAvailability:
            GetBookingAvailability(_UnusedProfessionalRepository()),
        getVisitAddresses: GetVisitAddresses(_UnusedAddressRepository()),
        submitRequest: SubmitBookingRequest(_UnusedSubmissionRepository()),
        loadDraft: LoadBookingDraft(drafts),
        saveDraft: SaveBookingDraft(drafts),
        clearDraft: ClearBookingDraft(drafts),
        currentLocation: CurrentLocationService(),
        createAddress: (_) async => 1,
      );

  setUp(() => drafts = _RecordingDraftRepository());

  test('prefill keeps valid issue codes and remarks, drops unknown codes',
      () async {
    final cubit = build(
      subCategory: 'medication_support',
      issueCodes: ['med_side_effects', 'not_a_code'],
      remarks: 'x',
    );
    await cubit.loadCatalogue();

    expect(cubit.state.draft.issueCodes, ['med_side_effects']);
    expect(cubit.state.draft.remarks, 'x');
    expect(drafts.loads, 0);
    await cubit.close();
  });

  test('prefill wins over a saved draft for the same category', () async {
    drafts.store['pharmacy'] = const GuidedBookingDraft(
      category: 'pharmacy',
      subCategory: 'medication_support',
      issueCodes: ['med_interactions'],
      remarks: 'old',
    );

    final cubit = build(
      subCategory: 'medication_support',
      issueCodes: ['med_side_effects'],
      remarks: 'new',
    );
    await cubit.loadCatalogue();

    expect(cubit.state.draft.issueCodes, ['med_side_effects']);
    expect(cubit.state.draft.remarks, 'new');
    await cubit.close();
  });

  test('without prefill the saved draft is loaded', () async {
    drafts.store['pharmacy'] = const GuidedBookingDraft(
      category: 'pharmacy',
      subCategory: 'medication_support',
      issueCodes: ['stale_code'],
    );

    final cubit = build();
    await cubit.loadCatalogue();

    expect(drafts.loads, 1);
    expect(cubit.state.draft.issueCodes, ['stale_code']);
    await cubit.close();
  });

  test('remarks longer than the limit are cut', () async {
    final cubit = build(
      subCategory: 'medication_support',
      remarks: 'a' * 400,
    );

    expect(cubit.state.draft.remarks.length, GuidedBookingDraft.remarksLimit);
    await cubit.close();
  });

  test('codes stay unchecked until a sub-category is chosen', () async {
    final cubit = build(issueCodes: ['med_side_effects']);
    await cubit.loadCatalogue();

    expect(cubit.state.draft.subCategory, isNull);
    expect(cubit.state.draft.issueCodes, ['med_side_effects']);
    await cubit.close();
  });

  test('a single sub-category is auto-selected and codes are checked',
      () async {
    final cubit = build(
      issueCodes: ['med_side_effects', 'not_a_code'],
      subCategoryCount: 1,
    );
    await cubit.loadCatalogue();

    expect(cubit.state.draft.subCategory, 'medication_support');
    expect(cubit.state.draft.issueCodes, ['med_side_effects']);
    await cubit.close();
  });
}
