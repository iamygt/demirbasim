import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demirbasim/models/firebase_product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class ProductServiceFirebase {
  final FirebaseFirestore firestore;
  final CollectionReference productCollection;
  List<ProductModelFireBase> products = [];

  ProductServiceFirebase()
      : firestore = FirebaseFirestore.instance,
        productCollection = FirebaseFirestore.instance.collection('products') {
    firestore.settings = const Settings(persistenceEnabled: true);
  }

  Future<void> addProduct(ProductModelFireBase product, File imageFile) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('product_images/${path.basename(imageFile.path)}');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask;
      String imageUrl = await storageReference.getDownloadURL();
      product.imageUrl = imageUrl;
      await productCollection.add(product.toMap());
    } catch (e) {
      if (kDebugMode) {
        print("Error in addProduct: $e");
      }
      rethrow;
    }
  }

  Future<List<ProductModelFireBase>> getProducts() async {
    QuerySnapshot snapshot = await productCollection.get();
    return snapshot.docs
        .map((doc) => ProductModelFireBase.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

 

   Future<List<ProductModelFireBase>> getProductsByPieceRange(double minPiece, double maxPiece) async {
    QuerySnapshot snapshot = await productCollection
        .where('piece', isGreaterThan: minPiece, isLessThan: maxPiece)
        .get();

    return snapshot.docs
        .map((doc) => ProductModelFireBase.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }


  Future<void> deleteProduct(String id) async {
    await productCollection.doc(id).delete();
  }

  Future<void> updateProduct(ProductModelFireBase product) async {
    await productCollection.doc(product.id).update(product.toMap());
  }
 Future<void> addProductWithoutImage(ProductModelFireBase product) async {

    await productCollection.add(product.toMap());
  }



    Future<void> getAllProducts() async {
    QuerySnapshot snapshot = await productCollection.get();
    products = snapshot.docs
        .map((doc) => ProductModelFireBase.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
  
   
    Future<void> removeFirstProduct() async {
    QuerySnapshot snapshot = await productCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      return deleteProduct(snapshot.docs.first.id);
    } else {
      throw Exception('No products to remove');
    }
  } 
  Future<List<ProductModelFireBase>> getProductsByRoom(String roomId) async {
    QuerySnapshot snapshot = await productCollection
        .where('location', isEqualTo: roomId)
        .get();

    return snapshot.docs
        .map((doc) => ProductModelFireBase.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

Future<List<String>> getProductCategories() async {
  QuerySnapshot snapshot = await productCollection.get();
  Set<String> categories = {};
  for (var doc in snapshot.docs) {
    var category = (doc.data() as Map<String, dynamic>)['category'] as String?;
    if (category != null) {
      categories.add(category);
    }
  }
  return categories.toList();
}

Future<List<ProductModelFireBase>> getProductsByCategory(String category) async {
  QuerySnapshot snapshot = await productCollection
      .where('category', isEqualTo: category)
      .get();

  return snapshot.docs
      .map((doc) => ProductModelFireBase.fromMap(doc.data() as Map<String, dynamic>, doc.id))
      .toList();
}


Future<List<ProductModelFireBase>> searchProducts(String query) async {
  QuerySnapshot snapshot = await productCollection
      .where('name', isEqualTo: query)
      .get();

  return snapshot.docs
      .map((doc) => ProductModelFireBase.fromMap(doc.data() as Map<String, dynamic>, doc.id))
      .toList();
}

}
