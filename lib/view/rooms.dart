import 'package:demirbasim/models/room_model.dart';
import 'package:demirbasim/service/room_service.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/view/add_room.dart';
import 'package:demirbasim/view/room_details.dart';
import 'package:demirbasim/widgets/appbars.dart';
import 'package:flutter/material.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  final roomService = RoomService();

  void deleteRoom(Room room) {
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
  
      body: ListView.builder(
        itemCount: roomService.rooms.length,
        itemBuilder: (context, index) {
          final room = roomService.rooms[index];

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
              onPressed: () => deleteRoom(room), // Call the deleteRoom method
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: DemirBasimTheme.of(context).alternate,
        onPressed: () async {
          final Room? newRoom = await Navigator.push(
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
