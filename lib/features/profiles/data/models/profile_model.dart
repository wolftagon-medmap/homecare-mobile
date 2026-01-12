import 'package:m2health/features/profiles/data/models/address_model.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.userId,
    required super.name,
    super.age,
    super.weight,
    super.height,
    super.phoneNumber,
    super.homeAddress,
    super.gender,
    super.drugAllergy,
    super.avatar,
    super.address,
    super.createdAt,
    super.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      age: json['age'] ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      phoneNumber: json['phone_number'] ?? '',
      name: json['name'] ?? '',
      homeAddress: json['home_address'],
      gender: json['gender'],
      drugAllergy: json['drug_allergy'],
      avatar: json['avatar'],
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
