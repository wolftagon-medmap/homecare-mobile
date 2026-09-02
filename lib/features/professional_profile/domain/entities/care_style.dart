import 'package:equatable/equatable.dart';

/// Claimed, not rated. A self-assigned "Empathy 5/5" carries no signal, so the
/// server stores the trait and nothing else.
class CareStyleTrait extends Equatable {
  const CareStyleTrait({required this.code, required this.label});

  final String code;
  final String label;

  @override
  List<Object?> get props => [code, label];
}
