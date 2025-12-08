import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/profiles/domain/entities/place_suggestion.dart';
import 'package:m2health/features/profiles/domain/entities/place_detail.dart';
import 'package:m2health/features/profiles/domain/usecases/search_places.dart';
import 'package:m2health/features/profiles/domain/usecases/get_place_details.dart';
import 'package:uuid/uuid.dart';

// States
abstract class AddressSearchState extends Equatable {
  const AddressSearchState();
  @override
  List<Object> get props => [];
}

class AddressSearchInitial extends AddressSearchState {}

class AddressSearchLoading extends AddressSearchState {}

class AddressSearchLoaded extends AddressSearchState {
  final List<PlaceSuggestion> suggestions;
  const AddressSearchLoaded(this.suggestions);
  @override
  List<Object> get props => [suggestions];
}

class PlaceDetailLoading extends AddressSearchState {}

class PlaceDetailLoaded extends AddressSearchState {
  final PlaceDetail detail;
  const PlaceDetailLoaded(this.detail);
  @override
  List<Object> get props => [detail];
}

class AddressSearchError extends AddressSearchState {
  final String message;
  const AddressSearchError(this.message);
  @override
  List<Object> get props => [message];
}

// Cubit
class AddressSearchCubit extends Cubit<AddressSearchState> {
  final SearchPlaces searchPlaces;
  final GetPlaceDetails getPlaceDetails;

  // Manage Session Token internally
  String _sessionToken = const Uuid().v4();
  Timer? _debounce;

  AddressSearchCubit({
    required this.searchPlaces,
    required this.getPlaceDetails,
  }) : super(AddressSearchInitial());

  // Called when text changes
  void onSearchQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 900), () {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        emit(const AddressSearchLoaded([]));
      }
    });
  }

  Future<void> _performSearch(String query) async {
    emit(AddressSearchLoading());
    final result = await searchPlaces(query, _sessionToken);
    result.fold(
      (failure) => emit(AddressSearchError(failure.message)),
      (suggestions) => emit(AddressSearchLoaded(suggestions)),
    );
  }

  // Called when user taps a list item
  Future<void> selectPlace(String placeId, {String? placeName}) async {
    emit(PlaceDetailLoading());
    final result = await getPlaceDetails(placeId, _sessionToken);
    result.fold(
      (failure) => emit(AddressSearchError(failure.message)),
      (detail) {
        emit(PlaceDetailLoaded(detail.copyWith(name: placeName)));
        // Reset session token for next independent search
        _sessionToken = const Uuid().v4();
      },
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
