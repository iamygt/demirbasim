// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference items = FirebaseFirestore.instance.collection('items');

Future<void> addItem(String name, DateTime dateAdded, double price, String serialNumber, String category, String brand,
    String photoUrl) {
  return items
      .add({
        'name': name, // eşya ismi
        'dateAdded': dateAdded, // ekleme tarihi
        'price': price, // fiyatı
        'serialNumber': serialNumber, // seri numarası
        'category': category, // kategorisi
        'brand': brand, // markası
        'photoUrl': photoUrl, // fotoğraf URL
      })
      .then((value) => print("Item Added"))
      .catchError((error) => print("Failed to add item: $error"));
}

Future<QuerySnapshot> getItems() {
  return items.get();
}
