import 'package:equatable/equatable.dart';

class BookingProfessional extends Equatable {
  final int id;
  final String name;
  final String? avatar;
  final String? jobTitle;
  final double rating;
  final int reviewCount;
  final int yearsOfExperience;
  final List<String> categories;
  final List<int> servedAddressIds;

  const BookingProfessional({
    required this.id,
    required this.name,
    this.avatar,
    this.jobTitle,
    required this.rating,
    this.reviewCount = 0,
    required this.yearsOfExperience,
    this.categories = const [],
    this.servedAddressIds = const [],
  });

  bool servesAddress(int? addressId) =>
      addressId == null || servedAddressIds.contains(addressId);

  bool coversCategory(String category) =>
      categories.isEmpty || categories.contains(category);

  @override
  List<Object?> get props => [
        id,
        name,
        avatar,
        jobTitle,
        rating,
        reviewCount,
        yearsOfExperience,
        categories,
        servedAddressIds,
      ];
}
