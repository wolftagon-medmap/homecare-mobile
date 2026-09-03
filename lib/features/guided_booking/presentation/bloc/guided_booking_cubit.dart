import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/guided_booking/domain/entities/guided_booking_draft.dart';
import 'package:m2health/features/guided_booking/domain/usecases/guided_booking_usecases.dart';
import 'package:m2health/core/location/current_location_service.dart';
import 'package:m2health/core/location/visit_location.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_state.dart';

class GuidedBookingCubit extends Cubit<GuidedBookingState> {
  final GetIssueCatalogue getIssueCatalogue;
  final GetBookingProfessionals getProfessionals;
  final GetBookingAvailability getAvailability;
  final GetVisitAddresses getVisitAddresses;
  final SubmitBookingRequest submitRequest;
  final LoadBookingDraft loadDraft;
  final SaveBookingDraft saveDraft;
  final ClearBookingDraft clearDraft;

  static const Duration _saveDebounce = Duration(milliseconds: 400);
  Timer? _saveTimer;
  final String? _entrySubCategory;
  final CurrentLocationService currentLocation;
  final Future<int> Function(VisitLocation) createAddress;

  GuidedBookingCubit({
    required String category,
    String? subCategory,
    required this.getIssueCatalogue,
    required this.getProfessionals,
    required this.getAvailability,
    required this.getVisitAddresses,
    required this.submitRequest,
    required this.loadDraft,
    required this.saveDraft,
    required this.clearDraft,
    required this.currentLocation,
    required this.createAddress,
  })  : _entrySubCategory = subCategory,
        super(GuidedBookingState(
          draft: GuidedBookingDraft(
            category: category,
            subCategory: subCategory,
          ),
        ));

  Future<void> loadCatalogue() async {
    await restoreDraft();
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
      (addresses) async {
        emit(state.copyWith(
          addressStatus: BookingLoadStatus.ready,
          addresses: addresses,
        ));
        if (state.visitLocation != null) {
          loadProfessionals();
          return;
        }

        final defaultAddress =
            addresses.where((a) => a.isDefault).firstOrNull ??
                addresses.firstOrNull;
        if (defaultAddress != null) {
          selectVisitLocation(VisitLocation.fromAddress(defaultAddress));
          return;
        }

        // No saved address: fall back to where the device already says it is.
        // `resolveIfGranted` never prompts, so opening this step cannot raise a
        // permission dialog out of nowhere — the picker asks explicitly.
        final current = await currentLocation.resolveIfGranted();
        if (isClosed) return;
        if (current != null) {
          selectVisitLocation(current);
        }
      },
    );
  }

  Future<void> loadProfessionals({String? name}) async {
    emit(state.copyWith(professionalStatus: BookingLoadStatus.loading));
    final address = state.selectedAddress;
    final result = await getProfessionals(
      category: state.pricingCategory,
      latitude: address?.latitude,
      longitude: address?.longitude,
      name: name,
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
    final result = await getAvailability(
      professionalId,
      category: state.draft.category,
    );
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

  void selectVisitLocation(VisitLocation location) {
    if (location == state.visitLocation) return;
    emit(state.copyWith(
      visitLocation: location,
      draft: state.draft.withAddress(location.addressId),
    ));
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

  Future<void> restoreDraft() async {
    final result = await loadDraft(state.draft.category);
    result.fold(
      (_) {},
      (draft) {
        if (draft == null || isClosed) return;
        // Entering through a named sub-service must win over a saved draft for a
        // different one, or the tap silently lands the user in the other flow.
        if (_entrySubCategory != null &&
            _entrySubCategory != draft.subCategory) {
          return;
        }
        emit(state.copyWith(draft: draft));
      },
    );
  }

  void _persist() {
    _saveTimer?.cancel();
    final draft = state.draft;
    _saveTimer = Timer(_saveDebounce, () => saveDraft(draft));
  }

  @override
  void emit(GuidedBookingState state) {
    final changed = state.draft != this.state.draft;
    super.emit(state);
    if (changed) _persist();
  }

  @override
  Future<void> close() {
    _saveTimer?.cancel();
    return super.close();
  }

  Future<void> submit() async {
    if (state.isSubmitting || !state.draft.isSubmittable) return;

    emit(state.copyWith(isSubmitting: true, clearError: true));

    // A GPS reading or a map pin has no id until now. The booking needs a real
    // address for the professional to navigate to, so it is written here and
    // not while the patient is still browsing.
    var draft = state.draft;
    final location = state.visitLocation;
    if (location != null && !location.isSaved) {
      try {
        final addressId = await createAddress(location);
        if (isClosed) return;
        draft = draft.withAddress(addressId);
        emit(state.copyWith(
          draft: draft,
          visitLocation: VisitLocation.fromAddress(
            Address(
              id: addressId,
              latitude: location.latitude,
              longitude: location.longitude,
              label: location.label,
              formattedAddress: location.formattedAddress,
              googlePlaceId: location.googlePlaceId,
              name: location.name,
            ),
          ),
        ));
      } catch (error) {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: '$error',
        ));
        return;
      }
    }

    final result = await submitRequest(draft);
    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
      (submitted) {
        _saveTimer?.cancel();
        clearDraft(state.draft.category);
        emit(state.copyWith(isSubmitting: false, submitted: submitted));
      },
    );
  }
}
