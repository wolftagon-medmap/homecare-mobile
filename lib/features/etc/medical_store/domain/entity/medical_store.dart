class MedicalStoreProduct {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final bool isLocalImage;
  final double? price;

  MedicalStoreProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.isLocalImage = false,
    this.price,
  });

  factory MedicalStoreProduct.fromJson(Map<String, dynamic> json) {
    return MedicalStoreProduct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['thumbnail']['url'],
      isLocalImage: false,
      price: json['price'],
    );
  }
}

enum MedicalStoreProductCategory {
  consumables,
  poct;
}
