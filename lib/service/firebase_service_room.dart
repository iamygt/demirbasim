import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class RoomServiceFirebase with ChangeNotifier {
  final FirebaseFirestore firestore;
  final CollectionReference roomCollection;
  List<RoomModelFireBase> rooms = [];
  String error = '';

  RoomServiceFirebase()
      : firestore = FirebaseFirestore.instance,
        roomCollection = FirebaseFirestore.instance.collection('rooms') {
    firestore.settings = const Settings(persistenceEnabled: true);
  }

  Future<void> addRoom(RoomModelFireBase room, File imageFile) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('room_images/${path.basename(imageFile.path)}');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask;
      String imageUrl = await storageReference.getDownloadURL();
      room.imageUrl = imageUrl;
      await roomCollection.add(room.toMap());
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error in addRoom: $e");
      }
      rethrow;
    }
  }

  Future<void> addRoomWithoutImage(RoomModelFireBase room) async {
    await roomCollection.add(room.toMap());
    notifyListeners();
  }

  Future<List<RoomModelFireBase>> getRooms() async {
    QuerySnapshot snapshot = await roomCollection.get();
    rooms = snapshot.docs.map((doc) => RoomModelFireBase.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    notifyListeners();
    return rooms;
  }

  Future<RoomModelFireBase> getRoom(String id) async {
    DocumentSnapshot snapshot = await roomCollection.doc(id).get();
    if (snapshot.exists) {
      return RoomModelFireBase.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
    }
    return RoomModelFireBase(id: '', imageUrl: '', name: '');
  }

  Future<List<RoomModelFireBase>> fetchRooms() async {
    QuerySnapshot snapshot = await roomCollection.get();
    rooms = snapshot.docs.map((doc) => RoomModelFireBase.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    notifyListeners();
    return rooms;
  }

  Future<void> deleteRoom(String id) async {
    // Odayı sil
    await roomCollection.doc(id).delete();

    // Oda içindeki ürünleri sil
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').where('location', isEqualTo: id).get();
    List<DocumentSnapshot> docs = querySnapshot.docs;
    for (var doc in docs) {
      await doc.reference.delete();
    }

    // Odalar listesinden odayı kaldır
    rooms.removeWhere((room) => room.id == id);

    // Güncellenmiş odaları getir
    await fetchRooms();

    notifyListeners();
  } 
    Stream<List<RoomModelFireBase>> get roomsStream {
    // The implementation should return a stream of list of rooms
    // Here is a mock implementation
    return FirebaseFirestore.instance.collection('rooms')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return RoomModelFireBase.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
  }

  Future<void> updateRoom(RoomModelFireBase room) async {
    await roomCollection.doc(room.id).update(room.toMap());
    notifyListeners();
  }

  Future<List<RoomModelFireBase>> getAllRooms() async {
    QuerySnapshot snapshot = await roomCollection.get();
    rooms = snapshot.docs.map((doc) => RoomModelFireBase.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    notifyListeners();
    return rooms;
  }

  Future<void> removeFirstRoom() async {
    QuerySnapshot snapshot = await roomCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      await deleteRoom(snapshot.docs.first.id);
      notifyListeners();
    } else {
      throw Exception('No products to remove');
    }
  }
}
