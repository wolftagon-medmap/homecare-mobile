import 'package:equatable/equatable.dart';

class BookingSlot extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  const BookingSlot({
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [startTime, endTime, isAvailable];
}

class BookingDay extends Equatable {
  final DateTime date;
  final List<BookingSlot> slots;

  const BookingDay({required this.date, required this.slots});

  bool get hasAvailability => slots.any((slot) => slot.isAvailable);

  @override
  List<Object?> get props => [date, slots];
}
