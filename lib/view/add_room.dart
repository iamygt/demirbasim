import 'package:demirbasim/service/room_service.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/widgets/appbars.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demirbasim/models/room_model.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class AddRoomPage extends StatefulWidget {
  const AddRoomPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final roomNameController = TextEditingController();
  late RoomService roomService; // RoomService object defined here

  File? _selectedImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    roomService = Provider.of<RoomService>(context, listen: false); // We are calling the provider here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Demirbas.appbars(context, 'Oda Ekle'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            // Here is the image picker
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                backgroundColor: DemirBasimTheme.of(context).alternate,
              ),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                setState(() {
                  if (image != null) {
                    _selectedImage = File(image.path);
                  }
                });
              },
              child: const Text('Resim Seç'),
            ),
            _selectedImage == null ? Container() : Image.file(_selectedImage!),
            TextFormField(
              controller: roomNameController,
              decoration: const InputDecoration(labelText: 'Oda İsmi'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: DemirBasimTheme.of(context).alternate,
              ),
              child: const Text('Ekle'),
              onPressed: () {
                if (roomNameController.text != '' && _selectedImage != null) {
                  Room newRoom = Room(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: roomNameController.text,
                    imagePath: _selectedImage!.path,
                  );
                  roomService.addRoom(newRoom);
                  Navigator.pop(context, newRoom); // Here we are sending back the new room
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
