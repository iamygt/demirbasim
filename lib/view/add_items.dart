import 'dart:io';
import 'package:demirbasim/models/product_model.dart';
import 'package:demirbasim/models/room_model.dart';
import 'package:demirbasim/service/product_service.dart';
import 'package:demirbasim/service/room_service.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/view/home_page.dart';
import 'package:demirbasim/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddItems extends StatefulWidget {
  const AddItems({Key? key}) : super(key: key);

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  late RoomService _roomService;
  late ProductService _productService;
  String? _selectedLocation;

  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();

    @override
  void initState() {
    super.initState();
    _roomService = Provider.of<RoomService>(context, listen: false);
    _productService = Provider.of<ProductService>(context, listen: false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarAddItem(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                _buildImagePicker(),
                const SizedBox(
                  height: 24,
                ),
                _buildProductNameTextField(),
                const SizedBox(
                  height: 16,
                ),
                _buildProductDescriptionTextField(),
                const SizedBox(
                  height: 16,
                ),
                _buildLocationSelectButton(),
                const SizedBox(
                  height: 10,
                ),
                _buildAddButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);

        setState(() {
          if (image != null) {
            _selectedImage = File(image.path);
          }
        });
      },
      child: Center(
        child: _selectedImage == null
            ? Image.asset('assets/resimSec.png', height: 150, width: 330, fit: BoxFit.cover)
            : Image.file(_selectedImage!, height: 150, width: 330, fit: BoxFit.cover),
      ),
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
      decoration: InputDecoration(
        labelText: 'Ürün Adı',
        labelStyle: const TextStyle(
          color: Colors.grey, // etiket rengi
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.grey, // kenarlık rengi
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.grey, // kenarlık rengi
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.blue, // odaklanan kenarlık rengi
          ),
        ),
      ),
    );
  }

  Widget _buildProductDescriptionTextField() {
    return TextField(
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black, // metin rengi
      ),
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Ürün Açıklama',
        labelStyle: const TextStyle(
          color: Colors.grey, // etiket rengi
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.grey, // kenarlık rengi
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.grey, // kenarlık rengi
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.blue, // odaklanan kenarlık rengi
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSelectButton() {
    return DropdownButton<String>(
      hint: const Text('Lokasyon Seç'),
      value: _selectedLocation,
      items: _roomService.rooms.map<DropdownMenuItem<String>>((Room room) {
        return DropdownMenuItem<String>(
          value: room.name,
          child: Text(room.name),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedLocation = newValue;
        });
      },
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _addProduct();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: DemirBasimTheme.of(context).alternate, // düğme metin rengi
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

  AppBar _appBarAddItem(BuildContext context) {
    return AppBar(
      backgroundColor: DemirBasimTheme.of(context).secondaryBackground,
      automaticallyImplyLeading: false,
      title: Text(
        'Ürün Ekleme',
        style: DemirBasimTheme.of(context).headlineMedium,
      ),
      actions: _actionButton(context),
      centerTitle: false,
      elevation: 0,
    );
  }

  List<Widget> _actionButton(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
        child: DemirBasimIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          buttonSize: 48,
          icon: Icon(
            Icons.close_rounded,
            color: DemirBasimTheme.of(context).secondaryText,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DemirBasimHome()),
            );
          },
        ),
      ),
    ];
  }

  void _addProduct() {
    if (_productNameController.text.isEmpty || _selectedImage == null || _selectedLocation == null) {
      // Veri eksik, uyarı ver
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
      );
      return;
    }

    final newProduct = Product()
      ..id = DateTime.now().toIso8601String() // Unique id
      ..name = _productNameController.text
      ..description = _productDescriptionController.text
      ..imagePath = _selectedImage!.path
      ..location = _selectedLocation!;

    _productService.addProduct(newProduct);

    // Veri eklendi, başarı mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ürün başarıyla eklendi!')),
    );

    _productNameController.clear();
    _productDescriptionController.clear();
    _selectedLocation = null;
    _selectedImage = null;
  }
}
