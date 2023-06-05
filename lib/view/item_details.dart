import 'dart:io';
import 'package:demirbasim/models/product_model.dart';
import 'package:demirbasim/widgets/appbars.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

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
                child: product.imagePath == null
                    ? Image.asset('assets/resimSec.png', height: 150, width: 330, fit: BoxFit.cover)
                    : Image.file(File(product.imagePath), height: 150, width: 330, fit: BoxFit.cover),
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
              Text(
                'Lokasyon: ${product.location}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
