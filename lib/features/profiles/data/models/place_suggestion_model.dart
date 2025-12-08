import 'package:m2health/features/profiles/domain/entities/place_suggestion.dart';

class PlaceSuggestionModel extends PlaceSuggestion {
  const PlaceSuggestionModel({
    required super.placeId,
    required super.mainText,
    required super.secondaryText,
  });

  factory PlaceSuggestionModel.fromJson(Map<String, dynamic> json) {
    // Parsing Google Places API (New) Response Structure
    final prediction = json['placePrediction'] ?? json;
    final structuredFormat = prediction['structuredFormat'] ?? {};
    
    return PlaceSuggestionModel(
      placeId: prediction['placeId'] ?? prediction['place_id'] ?? '',
      mainText: structuredFormat['mainText']?['text'] ?? '',
      secondaryText: structuredFormat['secondaryText']?['text'] ?? '',
    );
  }
}