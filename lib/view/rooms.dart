import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:demirbasim/service/firebase_service_room.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/view/add_room.dart';
import 'package:demirbasim/view/room_details.dart';
import 'package:demirbasim/widgets/appbars.dart';
import 'package:flutter/material.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  RoomsPageState createState() => RoomsPageState();
}

class RoomsPageState extends State<RoomsPage> {
  final RoomServiceFirebase roomService = RoomServiceFirebase();

  void deleteRoom(RoomModelFireBase room) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Room'),
        content: Text('Are you sure you want to delete ${room.name}?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              roomService.deleteRoom(room.id);
              Navigator.of(context).pop();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Demirbas.appbars(context, 'Odalar'),
      body: FutureBuilder<List<RoomModelFireBase>>(
        future: roomService.getRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final rooms = snapshot.data!;
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                return ListTile(
                  title: Text(room.name, style: const TextStyle(fontSize: 22)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoomDetailsPage(room: room)),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    onPressed: () => deleteRoom(room),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DemirBasimTheme.of(context).alternate,
        onPressed: () async {
          final RoomModelFireBase? newRoom = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRoomPage()),
          );
          if (newRoom != null) {
            setState(() {});
          }
        },
        tooltip: 'Add Room',
        child: const Icon(Icons.add),
      ),
    );
  }
}
