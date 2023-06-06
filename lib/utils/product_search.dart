import 'package:demirbasim/models/firebase_product_model.dart';
import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:demirbasim/service/firebase_service_product.dart';


import 'package:flutter/material.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final ProductServiceFirebase productService;
  final List<ProductModelFireBase> allProducts;
  final List<String> allCategories;
  final List<RoomModelFireBase> allRooms;
  List<ProductModelFireBase> searchResults = [];

  ProductSearchDelegate({
    required this.productService,
    required this.allProducts,
    required this.allCategories,
    required this.allRooms,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      return FutureBuilder<List<ProductModelFireBase>>(
        future: productService.getProductsByCategory(query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                return ListTile(
                  title: Text(product.name),
                  // Diğer alanları burada gösterebilirsiniz
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Bir hata oluştu"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
    return const Center(child: Text("Arama yapınız"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<ProductModelFireBase>>(
      future: productService.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var products = snapshot.data!;
          final suggestionList = query.isEmpty
              ? products
              : products
                  .where((product) =>
                      product.name.toLowerCase().startsWith(query.toLowerCase()))
                  .toList();

          return ListView.builder(
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              var product = suggestionList[index];
              return ListTile(
                onTap: () {
                  query = product.name;
                  showResults(context);
                },
                title: Text(product.name),
                // Diğer alanları burada gösterebilirsiniz
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Bir hata oluştu"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}