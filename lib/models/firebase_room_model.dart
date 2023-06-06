class RoomModelFireBase {
  final String id;
  final String name;
   String imageUrl;

  RoomModelFireBase({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

 factory RoomModelFireBase.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      return RoomModelFireBase(
        id: documentId,
        name: '',
        imageUrl: '',
      );
    }
    return RoomModelFireBase(
      id: documentId,
      name: data['name'] as String,
      imageUrl: data['imageUrl'] as String,
    );
  }
}