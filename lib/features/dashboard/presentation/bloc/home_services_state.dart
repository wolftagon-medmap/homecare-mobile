part of 'home_services_cubit.dart';

class HomeServicesState extends Equatable {
  final HomeServicesLayout layout;

  const HomeServicesState({this.layout = HomeServicesLayout.grid});

  @override
  List<Object?> get props => [layout];
}
