// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/view/home_page.dart';
import 'package:demirbasim/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:image_picker/image_picker.dart';

class DemirbasInputDecoration {
  static InputDecoration addItemInputDec(String labelText) {
    return InputDecoration(
      labelText: labelText,
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
    );
  }
}

AppBar appBarAddItem(BuildContext context) {
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

class ProductImagePicker extends StatefulWidget {
  final Function(File?) onImagePicked;
  final File? selectedImage;

  const ProductImagePicker({
    required this.onImagePicked,
    required this.selectedImage,
    Key? key,
  }) : super(key: key);

  @override
  _ProductImagePickerState createState() => _ProductImagePickerState();
}

class _ProductImagePickerState extends State<ProductImagePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          widget.onImagePicked(File(image.path));
        }
      },
      child: Center(
        child: widget.selectedImage == null
            ? Image.asset('assets/resimSec.png', height: 150, width: 330, fit: BoxFit.cover)
            : Image.file(widget.selectedImage!, height: 150, width: 330, fit: BoxFit.cover),
      ),
    );
  }
}

class RoomDropDown extends StatelessWidget {
  final List<RoomModelFireBase> rooms;
  final Function(String?) onRoomSelected;
  final String? selectedRoomId;

  const RoomDropDown({
    required this.rooms,
    required this.onRoomSelected,
    required this.selectedRoomId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return const Text('Lütfen önce oda ekleyiniz...');
    } else {
      return DropdownButton<String>(
        hint: const Text('Lokasyon Seç'),
        value: selectedRoomId, // selectedRoomId should exactly match the value of one DropdownMenuItem
        items: rooms.map<DropdownMenuItem<String>>((RoomModelFireBase room) {
          return DropdownMenuItem<String>(
              value: room.id, // This should be room.id, not room.name
              child: Text(room.name),
              );
        }).toList(),
        onChanged: onRoomSelected,
      );
    }
  }
}
