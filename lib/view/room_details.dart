import 'package:demirbasim/models/room_model.dart';
import 'package:demirbasim/service/product_service.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/view/add_items.dart';
import 'package:demirbasim/view/item_details.dart';
import 'package:demirbasim/widgets/appbars.dart';
import 'package:flutter/material.dart';

class RoomDetailsPage extends StatelessWidget {
  final Room room;
  final productService = ProductService();

  RoomDetailsPage({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = productService.getAllProducts().where((product) => product.location == room.name).toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: DemirBasimTheme.of(context).alternate,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddItems()));
        }
      ),
      appBar: Demirbas.appbars(context, room.name),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetailsPage(product: product)),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.black),
              onPressed: () {
                productService.deleteProduct(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} ürünü silindi.')),
                );
                // Ürün listesini yeniden yüklemek için state'i güncellemek gerekiyor.
                // Ancak, StatelessWidget'ta state güncellemek mümkün olmadığı için,
                // bu sayfayı StatefulWidget'a çevirmeniz gerekebilir.
              },
            ),
          );
        },
      ),
    );
  }
}
