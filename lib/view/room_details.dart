import 'package:demirbasim/models/firebase_product_model.dart';
import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/view/add_items.dart';
import 'package:demirbasim/view/category_details.dart';
import 'package:demirbasim/view/item_details.dart';
import 'package:demirbasim/widgets/appbars.dart';
import 'package:flutter/material.dart';

import '../service/firebase_service_product.dart';

class RoomDetailsPage extends StatefulWidget {
  final RoomModelFireBase room;
  final ProductServiceFirebase productService;

  RoomDetailsPage({Key? key, required this.room})
      : productService = ProductServiceFirebase(),
        super(key: key);

  @override
  _RoomDetailsPageState createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  num totalProductCount = 0;
  List<String> productCategories = [];

  @override
  void initState() {
    super.initState();
    fetchProductCategories();
    fetchProductCount();
  }

  Future<void> fetchProductCategories() async {
    final categories = await widget.productService.getProductCategories();
    setState(() {
      productCategories = categories;
    });
  }

  Future<void> fetchProductCount() async {
    final products = await widget.productService.getProductsByRoom(widget.room.id);
    num totalCount = 0;
    for (var product in products) {
      totalCount += product.piece;
    }
    setState(() {
      totalProductCount = totalCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModelFireBase>>(
      future: widget.productService.getProductsByRoom(widget.room.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('hata: ${snapshot.error}');
        } else {
          final products = snapshot.data!;
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: DemirBasimTheme.of(context).alternate,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddItems(room: widget.room)),
                );
                if (result != null && result is int) {
                  setState(() {
                    totalProductCount += result;
                  });
                }
              },
              child: const Icon(Icons.add),
            ),
            appBar: Demirbas.appbars(context, widget.room.name),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Toplam ürün: ${products.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Toplam Adet Sayısı: $totalProductCount',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Kategoriler:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: productCategories
                      .map(
                        (category) => GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryDetailsPage(
                                  category: category,
                                  roomId: widget.room.id,
                                ),
                              ),
                            );
                            // Update the category list when returning from the category page
                            fetchProductCategories();
                          },
                          child: Chip(label: Text(category)),
                        ),
                      )
                      .toList(),
                ),
                if (products.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Ürün Eklenmedi.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        child: ListTile(
                          leading:
                              Image.network(product.imageUrl), // Eğer ürün fotoğrafı URL'si varsa burada gösterilebilir
                          title: Text(
                            product.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Adet: ${product.piece}'),
                              Text('Tarih: ${product.purchaseDate}'),
                              Text('Açıkama: ${product.description}'),
                              // Show other properties here
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
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Ürün Silme'),
                                  content: Text('Silmek istediginiz ${product.name}?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('İptal'),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: const Text('Sil'),
                                      onPressed: () {
                                        widget.productService.deleteProduct(product.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('${product.name} siindi.')),
                                        );
                                        setState(() {
                                          products.removeAt(index);
                                          totalProductCount -= product.piece;
                                        });
                                        Navigator.of(context).pop(); // Dialog kapatılıyor
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
