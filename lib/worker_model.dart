class Worker {
  final String name;
  final String image;
  final String profession;
  final String description;
  final double rating;
  final double price;
  final String timeDuration;
  final String gender;

  Worker({
    required this.name,
    required this.image,
    required this.profession,
    required this.description,
    required this.rating,
    required this.price,
    required this.timeDuration,
    required this.gender,
  });

  // Convert Worker object to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'profession': profession,
      'description': description,
      'rating': rating,
      'price': price,
      'timeDuration': timeDuration,
      'gender': gender,
    };
  }

  // Create Worker object from Firestore Map
  factory Worker.fromMap(Map<String, dynamic> map) {
    return Worker(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      profession: map['profession'] ?? '',
      description: map['description'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      timeDuration: map['timeDuration'] ?? '',
      gender: map['gender'] ?? '',
    );
  }
}
