class Medicine {
  final String id;
  final String name;
  final String category;
  final String imageAsset;
  final double price;

  Medicine({
    required this.id,
    required this.name,
    required this.category,
    required this.imageAsset,
    required this.price,
  });

  // Convert Medicine object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imageAsset': imageAsset,
      'price': price,
    };
  }

  // Convert Map to Medicine object
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      imageAsset: map['imageAsset'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }

  // Create a copy of Medicine with modified fields
  Medicine copyWith({
    String? id,
    String? name,
    String? category,
    String? imageAsset,
    double? price,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imageAsset: imageAsset ?? this.imageAsset,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'Medicine(id: $id, name: $name, category: $category, price: $price)';
  }
}
