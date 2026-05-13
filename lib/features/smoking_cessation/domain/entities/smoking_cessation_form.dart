import 'package:equatable/equatable.dart';

class SmokingCessationForm extends Equatable {
  final bool isSmoking;
  final List<String>? productTypes;
  final int? sticksPerDay;
  final bool hasTriedQuitting;

  const SmokingCessationForm({
    required this.isSmoking,
    this.productTypes,
    this.sticksPerDay,
    required this.hasTriedQuitting,
  });

  @override
  List<Object?> get props => [
        isSmoking,
        productTypes,
        sticksPerDay,
        hasTriedQuitting,
      ];
}
