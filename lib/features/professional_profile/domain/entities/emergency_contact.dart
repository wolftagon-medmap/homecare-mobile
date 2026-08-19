import 'package:equatable/equatable.dart';

class EmergencyContact extends Equatable {
  const EmergencyContact({
    this.name = '',
    this.relationship = '',
    this.phone = '',
  });

  final String name;
  final String relationship;
  final String phone;

  bool get isSet => name.isNotEmpty && phone.isNotEmpty;

  EmergencyContact copyWith({
    String? name,
    String? relationship,
    String? phone,
  }) =>
      EmergencyContact(
        name: name ?? this.name,
        relationship: relationship ?? this.relationship,
        phone: phone ?? this.phone,
      );

  @override
  List<Object?> get props => [name, relationship, phone];
}
