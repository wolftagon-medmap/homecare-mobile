import 'package:equatable/equatable.dart';

abstract class ProfessionalEvent extends Equatable {
  const ProfessionalEvent();

  @override
  List<Object> get props => [];
}

class GetProfessionalsEvent extends ProfessionalEvent {
  final String role;
  final String? name;
  final List<int>? serviceIds;
  final bool? isHomeScreeningAuthorized;
  final String? serviceSubCategory;

  const GetProfessionalsEvent(this.role,
      {this.name,
      this.serviceIds,
      this.isHomeScreeningAuthorized,
      this.serviceSubCategory});

  @override
  List<Object> get props => [
        role,
        name ?? '',
        serviceIds ?? [],
        isHomeScreeningAuthorized ?? false,
        serviceSubCategory ?? '',
      ];
}

class ToggleFavoriteEvent extends ProfessionalEvent {
  final int professionalId;
  final bool isFavorite;

  const ToggleFavoriteEvent(this.professionalId, this.isFavorite);

  @override
  List<Object> get props => [professionalId, isFavorite];
}
