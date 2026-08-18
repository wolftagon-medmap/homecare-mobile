import 'package:equatable/equatable.dart';

/// A district a professional works in or lives in. The tier differs by country
/// -- planning area in Singapore, daerah in Malaysia, kecamatan in Indonesia --
/// so the server decides which rows are selectable and the app only shows them.
class ServiceArea extends Equatable {
  const ServiceArea({
    required this.code,
    required this.name,
    this.parentName,
  });

  final String code;
  final String name;

  /// The tier above, shown to disambiguate repeated names.
  final String? parentName;

  @override
  List<Object?> get props => [code, name, parentName];
}

/// A selectable area as offered by the catalogue, which also names its country.
class AreaOption extends ServiceArea {
  const AreaOption({
    required this.countryCode,
    required super.code,
    required super.name,
    super.parentName,
  });

  final String countryCode;

  @override
  List<Object?> get props => [countryCode, code, name, parentName];
}
