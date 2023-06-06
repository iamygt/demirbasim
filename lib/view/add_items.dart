import 'dart:io';

import 'package:demirbasim/models/firebase_product_model.dart';
import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:demirbasim/service/firebase_service_product.dart';
import 'package:demirbasim/service/firebase_service_room.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/widgets/add_items_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddItems extends StatefulWidget {
  final RoomModelFireBase room;

  const AddItems({Key? key, required this.room}) : super(key: key);

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  late RoomServiceFirebase _roomService;
  List<RoomModelFireBase> _rooms = [];
  late ProductServiceFirebase _productService;
  String? _selectedLocation;
  // ignore: unused_field
  String? _selectedRoomName;
  DateTime _purchaseDate = DateTime.now();
  final _productPieceController = TextEditingController();
  final _productCategoryController = TextEditingController();
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final companentSpace = const SizedBox(
    height: 10,
  );
  late TextEditingController _purchaseDateController;

  @override
  void initState() {
    super.initState();
    _productService = Provider.of<ProductServiceFirebase>(context, listen: false);
    _roomService = Provider.of<RoomServiceFirebase>(context, listen: false);
    _purchaseDateController = TextEditingController(text: formatDate(_purchaseDate));
    initializeData();
  }

  void initializeData() async {
    await fetchRooms();
    setState(() {});
  }

  Future<void> fetchRooms() async {
    _rooms = await _roomService.getRooms();
    if (_rooms.isNotEmpty) {
      _selectedLocation = _rooms.first.id;
    }
  }

  void onImagePicked(File? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  void onRoomSelected(String? roomId) {
    setState(() {
      _selectedLocation = roomId;
      _selectedRoomName = _rooms.firstWhere((room) => room.id == roomId).name;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appBarAddItem(context),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ProductImagePicker(onImagePicked: onImagePicked, selectedImage: _selectedImage),
                    companentSpace,
                    _buildProductNameTextField(),
                    companentSpace,
                    _buildProductDescriptionTextField(),
                    companentSpace,
                    _buildProductPieceTextField(),
                    companentSpace,
                    _buildProductPurchaseDateTextField(context),
                    companentSpace,
                    _buildProductCategoryTextField(),
                    companentSpace,
                    RoomDropDown(
                      rooms: _rooms,
                      onRoomSelected: onRoomSelected,
                      selectedRoomId: _selectedLocation,
                    ),
                    _buildAddButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductPurchaseDateTextField(BuildContext context) {
    return TextFormField(
      controller: _purchaseDateController,
      onTap: () => _selectDate(context),
      readOnly: true,
      decoration: DemirbasInputDecoration.addItemInputDec('Satın alma tarihi'),
    );
  }

  Widget _buildProductPieceTextField() {
    return TextFormField(
      controller: _productPieceController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen ürün adetini giriniz';
        }
        if (int.tryParse(value) == null) {
          return 'Lütfen geçerli bir sayı giriniz';
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black, // metin rengi
      ),
      maxLines: 1,
      decoration: DemirbasInputDecoration.addItemInputDec('Ürün adeti'),
    );
  }

  Widget _buildProductNameTextField() {
    return TextFormField(
      controller: _productNameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen ürün adı giriniz';
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black, // metin rengi
      ),
      decoration: DemirbasInputDecoration.addItemInputDec('Ürün Adı'),
    );
  }

  Widget _buildProductDescriptionTextField() {
    return TextField(
      controller: _productDescriptionController,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black, // metin rengi
      ),
      maxLines: 1,
      decoration: DemirbasInputDecoration.addItemInputDec('Ürün Açıklaması'),
    );
  }

  Widget _buildProductCategoryTextField() {
    return TextFormField(
      controller: _productCategoryController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen bir kategori giriniz';
        }
        return null;
      },
      decoration: DemirbasInputDecoration.addItemInputDec('Kategori'),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _addProduct();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: DemirBasimTheme.of(context).alternate, // düğme metin rengi
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      ),
      icon: const Icon(
        Icons.save, // kaydet simgesi
        color: Colors.white,
      ),
      label: const Text(
        'Ekle',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: _purchaseDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != _purchaseDate) {
      setState(() {
        _purchaseDate = picked;
        _purchaseDateController.text = formatDate(_purchaseDate);
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _addProduct() async {
    final messenger = ScaffoldMessenger.of(context);

    if (!_formKey.currentState!.validate()) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
      );
      return;
    }

    if (_productPieceController.text.isEmpty || _productCategoryController.text.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Lütfen fiyat ve kategori alanlarını doldurun!')),
      );
      return;
    }

    int? piece = int.tryParse(_productPieceController.text);
    if (piece == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Geçerli bir ürün fiyatı girin.')),
      );
      return;
    }

    if (_selectedLocation == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Lütfen bir oda seçin.')),
      );
      return;
    }

    final newProduct = ProductModelFireBase(
      id: DateTime.now().toIso8601String(),
      name: _productNameController.text,
      description: _productDescriptionController.text,
      piece: piece,
      purchaseDate: _purchaseDate.toIso8601String(),
      category: _productCategoryController.text,
      location: _selectedLocation!,
      imageUrl: '',
    );

    await _productService.addProduct(newProduct, _selectedImage!);

    messenger.showSnackBar(
      const SnackBar(content: Text('Ürün başarıyla eklendi!')),
    );

    _productNameController.clear();
    _productDescriptionController.clear();
    _productPieceController.clear();
    _productCategoryController.clear();
    _selectedLocation = null;
    _selectedImage = null;
    _purchaseDateController.clear();
  }
}
