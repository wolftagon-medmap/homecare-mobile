import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/guided_booking/domain/usecases/guided_booking_usecases.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';

class GuidedBookingCubit extends Cubit<GuidedBookingState> {
  final GetIssueCatalogue getIssueCatalogue;
  final GetBookingProfessionals getProfessionals;
  final GetBookingAvailability getAvailability;
  final GetVisitAddresses getVisitAddresses;
  final SubmitBookingRequest submitRequest;

  GuidedBookingCubit({
    required String category,
    String? subCategory,
    required this.getIssueCatalogue,
    required this.getProfessionals,
    required this.getAvailability,
    required this.getVisitAddresses,
    required this.submitRequest,
  }) : super(GuidedBookingState(
          draft: GuidedBookingDraft(
            category: category,
            subCategory: subCategory,
          ),
        ));

  Future<void> loadCatalogue() async {
    emit(state.copyWith(
      catalogueStatus: BookingLoadStatus.loading,
      clearError: true,
    ));

    final result = await getIssueCatalogue(state.draft.category);
    result.fold(
      (failure) => emit(state.copyWith(
        catalogueStatus: BookingLoadStatus.failure,
        errorMessage: failure.message,
      )),
      (catalogue) {
        final autoSelected = catalogue.subCategories.length == 1
            ? catalogue.subCategories.first.code
            : state.draft.subCategory;

        emit(state.copyWith(
          catalogueStatus: BookingLoadStatus.ready,
          catalogue: catalogue,
          draft: autoSelected == state.draft.subCategory
              ? state.draft
              : state.draft
                  .withSubCategory(autoSelected, sharesIssueList: true),
        ));
      },
    );
  }

  Future<void> loadAddresses() async {
    if (state.addressStatus == BookingLoadStatus.loading) return;

    emit(state.copyWith(addressStatus: BookingLoadStatus.loading));
    final result = await getVisitAddresses();
    result.fold(
      (failure) => emit(state.copyWith(
        addressStatus: BookingLoadStatus.failure,
        errorMessage: failure.message,
      )),
      (addresses) {
        emit(state.copyWith(
          addressStatus: BookingLoadStatus.ready,
          addresses: addresses,
        ));
        if (state.draft.addressId == null && addresses.isNotEmpty) {
          final fallback = addresses.first;
          final preselected = addresses.firstWhere(
            (address) => address.isDefault,
            orElse: () => fallback,
          );
          selectAddress(preselected.id);
        } else {
          loadProfessionals();
        }
      },
    );
  }

  Future<void> loadProfessionals() async {
    emit(state.copyWith(professionalStatus: BookingLoadStatus.loading));
    final result = await getProfessionals(
      category: state.draft.category,
      addressId: state.draft.addressId,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        professionalStatus: BookingLoadStatus.failure,
        errorMessage: failure.message,
      )),
      (professionals) => emit(state.copyWith(
        professionalStatus: BookingLoadStatus.ready,
        professionals: professionals,
      )),
    );
  }

  Future<void> loadAvailability() async {
    final professionalId = state.draft.professionalId;
    if (professionalId == null) return;

    emit(state.copyWith(availabilityStatus: BookingLoadStatus.loading));
    final result = await getAvailability(professionalId);
    result.fold(
      (failure) => emit(state.copyWith(
        availabilityStatus: BookingLoadStatus.failure,
        errorMessage: failure.message,
      )),
      (availability) => emit(state.copyWith(
        availabilityStatus: BookingLoadStatus.ready,
        availability: availability,
      )),
    );
  }

  void selectSubCategory(String code) {
    final sub = state.catalogue?.subCategory(code);
    emit(state.copyWith(
      draft: state.draft.withSubCategory(
        code,
        sharesIssueList: sub?.inheritsIssues ?? true,
      ),
    ));
  }

  void toggleIssue(String code) =>
      emit(state.copyWith(draft: state.draft.toggleIssue(code)));

  void toggleAddOn(String code) =>
      emit(state.copyWith(draft: state.draft.toggleAddOn(code)));

  void setRemarks(String value) =>
      emit(state.copyWith(draft: state.draft.withRemarks(value)));

  void selectAddress(int? id) {
    if (id == state.draft.addressId) return;
    emit(state.copyWith(draft: state.draft.withAddress(id)));
    loadProfessionals();
  }

  void selectProfessional(int id) {
    if (id == state.draft.professionalId) return;
    emit(state.copyWith(
      draft: state.draft.withProfessional(id),
      availability: const [],
      availabilityStatus: BookingLoadStatus.initial,
    ));
  }

  void selectSlot(DateTime? startTime) =>
      emit(state.copyWith(draft: state.draft.withPreferredAt(startTime)));

  Future<void> submit() async {
    if (state.isSubmitting || !state.draft.isSubmittable) return;

    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await submitRequest(state.draft);
    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
      (submitted) => emit(state.copyWith(
        isSubmitting: false,
        submitted: submitted,
      )),
    );
  }
}
