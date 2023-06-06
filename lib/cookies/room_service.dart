// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:demirbasim/models/room_model.dart';
// import 'package:provider/provider.dart';

// class RoomService with ChangeNotifier {
//   late Box box;
//   Future<List<RoomHive>> fetchRooms() async {
//     await openBox();
//     return rooms;
//   }

//   static final RoomService _singleton = RoomService._internal();

//   factory RoomService() {
//     return _singleton;
//   }

//   RoomService._internal();

//   Future openBox() async {
//     box = await Hive.openBox('rooms');
//   }

//   void addRoom(RoomHive room) {
//     box.put(room.id, room.toJson());
//     // notify listeners after adding a room
//     notifyListeners();
//   }

//   void deleteRoom(String id) {
//     box.delete(id);
//     // notify listeners after deleting a room
//     notifyListeners();
//   }

//   List<RoomHive> get rooms {
//     // ignore: unnecessary_null_comparison
//     return box.values
//         .map((item) => RoomHive.fromJson(Map<String, dynamic>.from(item)))
//         .toList()
//         .where((room) => room.id != null && room.name != null && room.imagePath != null)
//         .toList();
//   }
// }

// // Provider kullanımı için bir widget
// class RoomServiceProvider extends StatelessWidget {
//   final Widget child;

//   const RoomServiceProvider({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<RoomService>(
//       create: (_) => RoomService(),
//       child: child,
//     );
//   }
// }
