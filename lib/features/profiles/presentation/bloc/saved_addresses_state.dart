import 'package:equatable/equatable.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';

abstract class SavedAddressesState extends Equatable {
  const SavedAddressesState();

  @override
  List<Object?> get props => [];
}

class SavedAddressesInitial extends SavedAddressesState {}

class SavedAddressesLoading extends SavedAddressesState {}

class SavedAddressesSaving extends SavedAddressesState {}

class SavedAddressesLoaded extends SavedAddressesState {
  final List<Address> addresses;

  const SavedAddressesLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class SavedAddressesSuccess extends SavedAddressesState {
  final String message;

  const SavedAddressesSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SavedAddressesError extends SavedAddressesState {
  final String message;

  const SavedAddressesError(this.message);

  @override
  List<Object?> get props => [message];
}
