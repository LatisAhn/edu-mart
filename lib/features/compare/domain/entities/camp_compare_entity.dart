class CampCompareEntity {
  final String campId;
  final String name;
  final String location;
  final String duration;
  final int price;
  final double rating;
  final String thumbnailUrl;
  final String description;
  final int maxParticipants;
  final List<String> includedItems;
  final String startDate;
  final String endDate;
  final String category;

  const CampCompareEntity({
    required this.campId,
    required this.name,
    required this.location,
    required this.duration,
    required this.price,
    required this.rating,
    required this.thumbnailUrl,
    required this.description,
    required this.maxParticipants,
    required this.includedItems,
    required this.startDate,
    required this.endDate,
    required this.category,
  });

  factory CampCompareEntity.fromJson(Map<String, dynamic> json) {
    return CampCompareEntity(
      campId: json['campId'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      duration: json['duration'] as String,
      price: json['price'] as int,
      rating: (json['rating'] as num).toDouble(),
      thumbnailUrl: json['thumbnailUrl'] as String,
      description: json['description'] as String,
      maxParticipants: json['maxParticipants'] as int,
      includedItems: List<String>.from(json['includedItems'] as List),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campId': campId,
      'name': name,
      'location': location,
      'duration': duration,
      'price': price,
      'rating': rating,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'maxParticipants': maxParticipants,
      'includedItems': includedItems,
      'startDate': startDate,
      'endDate': endDate,
      'category': category,
    };
  }
}
