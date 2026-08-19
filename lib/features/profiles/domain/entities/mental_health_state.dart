class MentalHealthState {
  final int id;
  final int userId;
  final int? overallMood;
  final int? anxietyLevel;
  final int? stressLevel;
  final int? energyLevel;
  final int? focusLevel;
  final int? sleepQuality;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MentalHealthState({
    required this.id,
    required this.userId,
    this.overallMood,
    this.anxietyLevel,
    this.stressLevel,
    this.energyLevel,
    this.focusLevel,
    this.sleepQuality,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  MentalHealthState copyWith({
    int? id,
    int? userId,
    int? overallMood,
    int? anxietyLevel,
    int? stressLevel,
    int? energyLevel,
    int? focusLevel,
    int? sleepQuality,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MentalHealthState(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      overallMood: overallMood ?? this.overallMood,
      anxietyLevel: anxietyLevel ?? this.anxietyLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      energyLevel: energyLevel ?? this.energyLevel,
      focusLevel: focusLevel ?? this.focusLevel,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}