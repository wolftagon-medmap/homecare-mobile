import 'package:equatable/equatable.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';

class Profile extends Equatable {
  final int id;
  final int userId;
  final String name;
  final int? age;
  final double? weight;
  final double? height;
  final String? phoneNumber;
  final String? homeAddress; // Deprecated, use Address entity instead
  final String? gender;
  final String? drugAllergy;
  final String? avatar;
  final Address? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Profile({
    required this.id,
    required this.userId,
    required this.name,
    this.age,
    this.weight,
    this.height,
    this.phoneNumber,
    this.homeAddress,
    this.gender,
    this.drugAllergy,
    this.avatar,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        age,
        weight,
        height,
        phoneNumber,
        homeAddress,
        gender,
        drugAllergy,
        avatar,
        address,
        createdAt,
        updatedAt,
      ];

  Profile copyWith({
    int? id,
    int? userId,
    String? name,
    int? age,
    double? weight,
    double? height,
    String? phoneNumber,
    String? homeAddress,
    String? gender,
    String? drugAllergy,
    String? avatar,
    Address? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      homeAddress: homeAddress ?? this.homeAddress,
      gender: gender ?? this.gender,
      drugAllergy: drugAllergy ?? this.drugAllergy,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
