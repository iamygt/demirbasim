class Room {
  final String id;
  final String name;
  final String imagePath;

  Room({
    required this.id,
    required this.name,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
    );
  }
}
