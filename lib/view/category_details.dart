import 'package:demirbasim/models/firebase_product_model.dart';
import 'package:demirbasim/service/firebase_service_product.dart';
import 'package:demirbasim/service/firebase_service_room.dart';
import 'package:demirbasim/view/item_details.dart';
import 'package:demirbasim/widgets/appbars.dart';
import 'package:flutter/material.dart';

class CategoryDetailsPage extends StatefulWidget {
  final String category;
  final String roomId;

  const CategoryDetailsPage({Key? key, required this.category, required this.roomId}) : super(key: key);

  @override
  _CategoryDetailsPageState createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  List<ProductModelFireBase> products = [];
  Map<String, List<String>> productsInRooms = {};
  Map<String, String> productRoomNames = {};

  @override
  void initState() {
    super.initState();
    fetchProductsByCategoryAndRoom();
  }

 Future<void> fetchProductsByCategoryAndRoom() async {
    final productService = ProductServiceFirebase();
    final roomService = RoomServiceFirebase();

    final fetchedProducts = await productService.getProductsByCategory(widget.category);

    final fetchedProductRoomNames = {};

    for (final product in fetchedProducts) {
      final room = await roomService.getRoom(product.location);
      fetchedProductRoomNames[product.id] = room.name;
    }

    setState(() {
      products = fetchedProducts;
      productRoomNames = fetchedProductRoomNames.cast<String, String>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Demirbas.appbars(context, '${widget.category} Kategorisi'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Toplam Ürün Sayısı: ${products.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final productName = productRoomNames[product.id] ?? '';
                return ListTile(
                  // ...
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Adet: ${product.piece}'),
                      Text('Odalarda: $productName'), // Change here
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    onPressed: () {
                      final productService = ProductServiceFirebase();
                      productService.deleteProduct(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} ürünü silindi.')),
                      );
                      setState(() {
                        products.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
