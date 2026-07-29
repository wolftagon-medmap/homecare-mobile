import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';
import 'package:m2health/features/profiles/presentation/bloc/saved_addresses_state.dart';

class SavedAddressesCubit extends Cubit<SavedAddressesState> {
  final GetAddresses getAddressesUseCase;
  final CreateAddress createAddressUseCase;
  final UpdateAddress updateAddressUseCase;
  final DeleteAddress deleteAddressUseCase;
  final SetDefaultAddress setDefaultAddressUseCase;

  SavedAddressesCubit({
    required this.getAddressesUseCase,
    required this.createAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
    required this.setDefaultAddressUseCase,
  }) : super(SavedAddressesInitial());

  Future<void> loadAddresses() async {
    emit(SavedAddressesLoading());
    final result = await getAddressesUseCase();
    result.fold(
      (failure) {
        log('Failed to load addresses: ${failure.message}',
            name: 'SavedAddressesCubit');
        emit(SavedAddressesError(failure.message));
      },
      (addresses) => emit(SavedAddressesLoaded(addresses)),
    );
  }

  Future<void> createAddress(CreateAddressParams params) async {
    emit(SavedAddressesSaving());
    final result = await createAddressUseCase(params);
    result.fold(
      (failure) => emit(SavedAddressesError(failure.message)),
      (_) {
        emit(const SavedAddressesSuccess('Address added successfully!'));
        loadAddresses();
      },
    );
  }

  Future<void> updateAddress(UpdateAddressParams params) async {
    emit(SavedAddressesSaving());
    final result = await updateAddressUseCase(params);
    result.fold(
      (failure) => emit(SavedAddressesError(failure.message)),
      (_) {
        emit(const SavedAddressesSuccess('Address updated successfully!'));
        loadAddresses();
      },
    );
  }

  Future<void> deleteAddress(int id) async {
    emit(SavedAddressesSaving());
    final result = await deleteAddressUseCase(id);
    result.fold(
      (failure) => emit(SavedAddressesError(failure.message)),
      (_) {
        emit(const SavedAddressesSuccess('Address removed successfully!'));
        loadAddresses();
      },
    );
  }

  Future<void> setDefaultAddress(int id) async {
    emit(SavedAddressesSaving());
    final result = await setDefaultAddressUseCase(id);
    result.fold(
      (failure) => emit(SavedAddressesError(failure.message)),
      (_) => loadAddresses(),
    );
  }
}
