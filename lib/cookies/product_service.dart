// import 'dart:io';

// import 'package:demirbasim/models/product_model.dart';
// import 'package:hive/hive.dart';


// class ProductService {
//   final _box = Hive.box<Product>('products');

//   void addProduct(Product product, File file) {
//     _box.put(product.id, product);
//   }

//   void deleteProduct(String id) {
//     _box.delete(id);
//   }

//   Product? getProduct(String id) {
//     return _box.get(id);
//   }

//   List<Product> getAllProducts() {
//     return _box.values.toList();
//   }
// }
