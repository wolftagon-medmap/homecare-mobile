import 'package:equatable/equatable.dart';
import 'package:m2health/features/profiles/domain/entities/address.dart';

class Profile extends Equatable {
  final int id;
  final int userId;
  final String name;
  final String? countryCode;
  final int? age;

  /// Authoritative over [age], which the backend derives from this.
  final DateTime? dateOfBirth;
  final double? weight;
  final double? height;
  final String? phoneNumber;
  final String? homeAddress; // Deprecated, use Address entity instead
  final String? gender;

  /// How this profile relates to the account holder: 'self' for the account
  /// owner, otherwise a family member ('spouse', 'parent', 'child', ...).
  final String? relation;

  /// The account holder's own profile, created at registration. Exactly one per
  /// account, and it can't be removed.
  final bool isPrimary;
  final String? drugAllergy;
  final String? avatar;
  final Address? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Profile({
    required this.id,
    required this.userId,
    required this.name,
    this.countryCode,
    this.age,
    this.dateOfBirth,
    this.weight,
    this.height,
    this.phoneNumber,
    this.homeAddress,
    this.gender,
    this.relation,
    this.isPrimary = false,
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
        countryCode,
        age,
        dateOfBirth,
        weight,
        height,
        phoneNumber,
        homeAddress,
        gender,
        relation,
        isPrimary,
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
    String? countryCode,
    int? age,
    DateTime? dateOfBirth,
    double? weight,
    double? height,
    String? phoneNumber,
    String? homeAddress,
    String? gender,
    String? relation,
    bool? isPrimary,
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
      countryCode: countryCode ?? this.countryCode,
      age: age ?? this.age,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      homeAddress: homeAddress ?? this.homeAddress,
      gender: gender ?? this.gender,
      relation: relation ?? this.relation,
      isPrimary: isPrimary ?? this.isPrimary,
      drugAllergy: drugAllergy ?? this.drugAllergy,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
