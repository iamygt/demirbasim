import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:demirbasim/service/firebase_service_room.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/widgets/appbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  late RoomServiceFirebase roomService; // RoomService object defined here

  File? _selectedImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    roomService = Provider.of<RoomServiceFirebase>(context, listen: false); // We are calling the provider here
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
                  RoomModelFireBase newRoom = RoomModelFireBase(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: roomNameController.text,
                    imageUrl: _selectedImage!.path,
                  );
                  roomService.addRoom(newRoom, _selectedImage!).then((value) {
                    roomService.fetchRooms(); // Odaları yeniden getir
                    Navigator.pop(context, newRoom); // Burada yeni odayı geri gönderiyoruz
                  }).catchError((error) {
                    if (kDebugMode) {
                      print("Error adding room: $error");
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
