// ignore_for_file: use_build_context_synchronously

import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:demirbasim/service/firebase_service_room.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/view/add_items.dart';
import 'package:demirbasim/view/add_room.dart';
import 'package:demirbasim/view/rooms.dart';
import 'package:demirbasim/view/settings.dart';
import 'package:demirbasim/widgets/icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BotNavWidget extends StatelessWidget {
  const BotNavWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomService = Provider.of<RoomServiceFirebase>(context);

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        DemirBasimIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 50,
          icon: const Icon(
            Icons.home_rounded,
            color: Color(0xFF9299A1),
            size: 24,
          ),
          onPressed: () {
            if (kDebugMode) {
              print('IconButton pressed ...');
            }
          },
        ),
        DemirBasimIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 50,
          icon: const Icon(
            Icons.home_work,
            color: Color(0xFF9299A1),
            size: 24,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RoomsPage()),
            );

            if (kDebugMode) {
              print('IconButton pressed ...');
            }
          },
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: DemirBasimIconButton(
                borderColor: Colors.transparent,
                borderRadius: 4,
                borderWidth: 1,
                buttonSize: 60,
                fillColor: DemirBasimTheme.of(context).alternate,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () async {
                  final rooms = await roomService.getRooms();
                  if (rooms.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hiç oda bulunmadığı için oda eklemeye yönlendirildiniz.'),
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddRoomPage()),
                    );
                  } else {
                    RoomModelFireBase room = RoomModelFireBase(name: '', imageUrl: '', id: '');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddItems(room: room)),
                    );
                  }
                  if (kDebugMode) {
                    print('MiddleButton pressed ...');
                  }
                },
              ),
            ),
          ],
        ),
        DemirBasimIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 50,
          icon: const Icon(
            Icons.favorite_rounded,
            color: Color(0xFF9299A1),
            size: 24,
          ),
          onPressed: () {
            if (kDebugMode) {
              print('IconButton pressed ...');
            }
          },
        ),
        DemirBasimIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 50,
          icon: const Icon(
            Icons.settings,
            color: Color(0xFF9299A1),
            size: 24,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
            if (kDebugMode) {
              print('IconButton pressed ...');
            }
          },
        ),
      ],
    );
  }
}
