import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demirbasim/models/firebase_product_model.dart';
import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:demirbasim/service/firebase_service_product.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/view/item_details.dart';
import 'package:demirbasim/view/room_details.dart';
import 'package:demirbasim/widgets/appbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demirbasim/service/firebase_service_room.dart';

class DatabaseTestPage extends StatefulWidget {
  const DatabaseTestPage({Key? key}) : super(key: key);

  @override
  _DatabaseTestPageState createState() => _DatabaseTestPageState();
}

class _DatabaseTestPageState extends State<DatabaseTestPage> {
  bool isRoomMenuOpen = false;
  bool isProductMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: float(context),
      appBar: Demirbas.appbars(context, 'Veritabanı modülü'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final products = snapshot.data?.docs
                .map((doc) => ProductModelFireBase.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                .toList();

            final roomService = Provider.of<RoomServiceFirebase>(context);
            final rooms = roomService.rooms;

            return ListView(
              children: [
                const Text('Ürünler', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                if (products != null)
                  ...products.map(
                    (product) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(product: product),
                          ),
                        );
                      },
                      child: ListTile(
                        // ignore: unnecessary_null_comparison
                        leading: product.imageUrl != null
                            ? Image.network(
                                product.imageUrl!,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return const Icon(Icons.image_not_supported);
                                },
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return const CircularProgressIndicator();
                                },
                              )
                            : const Icon(Icons.image_not_supported),
                        title: Text(product.name),
                        subtitle: Text('Adet: ${product.piece}'),
                      ),
                    ),
                  ),
                if (products?.isEmpty ?? true)
                  const Center(
                    child: Text(
                      "Ürün bulunamadı",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                const Text('Odalar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                StreamBuilder<List<RoomModelFireBase>>(
                   stream: roomService.roomsStream,
                  // RoomServiceFirebase hizmetinin roomsStream'ini dinleyin
                  builder: (BuildContext context, AsyncSnapshot<List<RoomModelFireBase>> roomSnapshot) {
                    if (roomSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final updatedRooms = roomSnapshot.data ?? [];

                    if (updatedRooms.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: updatedRooms.length,
                        itemBuilder: (BuildContext context, int index) {
                          final room = updatedRooms[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RoomDetailsPage(room: room),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                // ignore: unnecessary_null_comparison
                                leading: room.imageUrl != null
                                    ? Image.network(
                                        room.imageUrl!,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return const Icon(Icons.image_not_supported);
                                        },
                                        loadingBuilder:
                                            (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const CircularProgressIndicator();
                                        },
                                      )
                                    : const Icon(
                                        Icons.image_not_supported,
                                      ),
                                title: Text(room.name),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "Oda bulunamadı",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Column float(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          backgroundColor: DemirBasimTheme.of(context).alternate,
          heroTag: "btn1",
          child: const Icon(Icons.hotel),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add Room'),
                    onTap: () async {
                      var addRoomVar = RoomModelFireBase(
                        id: 'Room ${Random().nextInt(1000)}',
                        name: 'Random Room',
                        imageUrl: 'https://picsum.photos/200?random=${Random().nextInt(1000)}',
                      );
                      try {
                        await Provider.of<RoomServiceFirebase>(context, listen: false).addRoomWithoutImage(addRoomVar);
                      } catch (e) {
                        if (kDebugMode) {
                          print('Error adding product: $e');
                        }
                      }
                      // Increase the number of rooms
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.remove),
                    title: const Text('Remove Room'),
                    onTap: () async {
                      try {
                        await Provider.of<RoomServiceFirebase>(context, listen: false).removeFirstRoom();
                      } catch (e) {
                        if (kDebugMode) {
                          print('Error removing product: $e');
                        }
                      }
                    },
                    // Decrease the number of rooms
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          backgroundColor: DemirBasimTheme.of(context).alternate,
          heroTag: "btn2",
          child: const Icon(Icons.apartment),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add Product'),
                    onTap: () async {
                      var product = ProductModelFireBase(
                        id: 'Product ${Random().nextInt(1000)}',
                        name: 'Product ${Random().nextInt(1000)}',
                        description: 'Randomly generated product',
                        piece: (Random().nextDouble() * 100).roundToDouble(),
                        purchaseDate: DateTime.now().toString(),
                        category: '${Random().nextInt(1000000)}',
                        location: 'Random location',
                        imageUrl: 'https://picsum.photos/200?random=${Random().nextInt(1000)}',
                      );

                      try {
                        await Provider.of<ProductServiceFirebase>(context, listen: false)
                            .addProductWithoutImage(product);
                      } catch (e) {
                        if (kDebugMode) {
                          print('Error adding product: $e');
                        }
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.remove),
                    title: const Text('Remove Product'),

                    onTap: () async {
                      try {
                        await Provider.of<ProductServiceFirebase>(context, listen: false).removeFirstProduct();
                      } catch (e) {
                        if (kDebugMode) {
                          print('Error removing product: $e');
                        }
                      }
                    },
                    // Decrease the number of products
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
