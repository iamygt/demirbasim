// ignore_for_file: use_build_context_synchronously

import 'package:demirbasim/models/firebase_product_model.dart';
import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:demirbasim/service/firebase_service_product.dart';
import 'package:demirbasim/service/firebase_service_room.dart';
import 'package:demirbasim/widgets/appbars.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModelFireBase product;
  final RoomServiceFirebase roomService = RoomServiceFirebase();
  final ProductServiceFirebase productService = ProductServiceFirebase();

  ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  Future<void> _deleteProduct(BuildContext context) async {
    await productService.deleteProduct(product.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} ürünü silindi.')),
    );
    Navigator.pop(context); // Ürün detayları sayfasından çıkış yap
  }

  Future<String?> _getRoomName(String roomId) async {
    final RoomModelFireBase room = await roomService.getRoom(roomId);
    return room.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Demirbas.appbars(context, product.name),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Center(
                // ignore: unnecessary_null_comparison
                child: product.imageUrl == null
                    ? Image.asset(
                        'assets/resimSec.png',
                        height: 150,
                        width: 330,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        product.imageUrl,
                        height: 150,
                        width: 330,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Ürün Adı: ${product.name}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Ürün Açıklama: ${product.description}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder<String?>(
                future: _getRoomName(product.location),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Lokasyon: ${snapshot.data}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () => _deleteProduct(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Ürünü Sil',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
