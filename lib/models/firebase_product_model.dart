class ProductModelFireBase {
  String id;
  String name;
  String description;
  num piece;
  String purchaseDate;
  String category;
  String location;
  String imageUrl;

  ProductModelFireBase({
    required this.id,
    required this.name,
    required this.description,
    required this.piece,
    required this.purchaseDate,
    required this.category,
    required this.location,
    required this.imageUrl,
  });

  factory ProductModelFireBase.fromMap(Map<String, dynamic> map, String id) {
    return ProductModelFireBase(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String,
      piece: map['piece'] as num,
      purchaseDate: map['purchaseDate'] as String,
      category: map['category'] as String,
      location: map['location'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'piece': piece,
      'purchaseDate': purchaseDate,
      'category': category,
      'location': location,
      'imageUrl': imageUrl,
    };
  }
}
