import 'package:demirbasim/models/firebase_product_model.dart';
import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:demirbasim/service/firebase_service_product.dart';
import 'package:demirbasim/service/firebase_service_room.dart';
import 'package:demirbasim/view/item_details.dart';
import 'package:flutter/material.dart';

class SearchPage extends SearchDelegate<String> {
  final ProductServiceFirebase productService;
  final RoomServiceFirebase roomService;
  final List<RoomModelFireBase> allRooms;

  SearchPage({
    required this.productService,
    required this.roomService,
     required this.allRooms
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
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      return FutureBuilder<List<ProductModelFireBase>>(
        future: productService.searchProducts(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Bir hata oluştu"));
          }
          final products = snapshot.data;
          if (products == null || products.isEmpty) {
            return const Center(child: Text("Sonuç bulunamadı"));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product.imageUrl.isNotEmpty
                    ? Image.network(product.imageUrl)
                    : const Icon(Icons.image),
                title: Text(product.name),
                subtitle: Text(product.category),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(product: product),
                    ),
                  );
                },
              );
            },
          );
        },
      );
    }
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      final filteredRooms = allRooms.where((room) =>
          room.name.toLowerCase().contains(query.toLowerCase())).toList();

      return ListView.builder(
        itemCount: filteredRooms.length,
        itemBuilder: (context, index) {
          final room = filteredRooms[index];
          return ListTile(
            title: Text(room.name),
            onTap: () {
              // Odanın detaylarına yönlendirme işlemleri burada yapılabilir
            },
          );
        },
      );
    }
    return Container();
  }
}

class SearchPageWidget extends StatefulWidget {
  final ProductServiceFirebase productService;
  final RoomServiceFirebase roomService;
  final List<RoomModelFireBase> allRooms; // Add this line

  const SearchPageWidget({
    Key? key,
    required this.productService,
    required this.roomService,
    required this.allRooms, // Add this line
  }) : super(key: key);

  @override
  _SearchPageWidgetState createState() => _SearchPageWidgetState();
}

class _SearchPageWidgetState extends State<SearchPageWidget> {
  List<ProductModelFireBase> allProducts = [];
  List<String> allCategories = [];
  List<RoomModelFireBase> allRooms = [];

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    final products = await widget.productService.getProducts();
    final categories = await widget.productService.getProductCategories();
    final rooms = await widget.roomService.getRooms();

    setState(() {
      allProducts = products;
      allCategories = categories;
      allRooms = rooms;
    });
    // Odaları isme göre sıralayın
    allRooms.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürün Ara"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPage(
                  productService: widget.productService,
                  roomService: widget.roomService,
                  allRooms: widget.allRooms,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tüm Ürünler",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: allProducts.length,
                itemBuilder: (context, index) {
                  final product = allProducts[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text("Kategori: ${product.category}"),
                    // Diğer alanları da burada gösterebilirsiniz
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                "Tüm Kategoriler",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: allCategories.length,
                itemBuilder: (context, index) {
                  final category = allCategories[index];
                  return ListTile(
                    title: Text(category),
                    // Diğer alanları da burada gösterebilirsiniz
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                "Tüm Odalar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: allRooms.length,
                itemBuilder: (context, index) {
                  final room = allRooms[index];
                  return ListTile(
                    title: Text(room.name),
                    // Diğer alanları da burada gösterebilirsiniz
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
