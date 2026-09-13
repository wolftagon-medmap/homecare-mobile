import 'package:equatable/equatable.dart';

class SmokingCessationPlan extends Equatable {
  final DateTime? targetQuitDate;
  final String? medicationName;
  final String? medicationInstructions;
  final String? adviceNote;
  final DateTime? followUpDate;

  const SmokingCessationPlan({
    this.targetQuitDate,
    this.medicationName,
    this.medicationInstructions,
    this.adviceNote,
    this.followUpDate,
  });

  SmokingCessationPlan copyWith({
    DateTime? targetQuitDate,
    String? medicationName,
    String? medicationInstructions,
    String? adviceNote,
    DateTime? followUpDate,
  }) {
    return SmokingCessationPlan(
      targetQuitDate: targetQuitDate ?? this.targetQuitDate,
      medicationName: medicationName ?? this.medicationName,
      medicationInstructions:
          medicationInstructions ?? this.medicationInstructions,
      adviceNote: adviceNote ?? this.adviceNote,
      followUpDate: followUpDate ?? this.followUpDate,
    );
  }

  @override
  List<Object?> get props => [
        targetQuitDate,
        medicationName,
        medicationInstructions,
        adviceNote,
        followUpDate,
      ];
}
