import 'package:demirbasim/models/firebase_room_model.dart';
import 'package:demirbasim/service/firebase_service_room.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/utils/draver.dart';
import 'package:demirbasim/view/room_details.dart';
import 'package:demirbasim/widgets/appbars.dart';
import 'package:demirbasim/widgets/bot_nav.dart';
import 'package:demirbasim/widgets/home_widgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DemirBasimHome extends StatefulWidget {
  const DemirBasimHome({Key? key}) : super(key: key);

  @override
  _DemirBasimHomeState createState() => _DemirBasimHomeState();
}

class _DemirBasimHomeState extends State<DemirBasimHome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<RoomModelFireBase> rooms = [];

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    final roomService = Provider.of<RoomServiceFirebase>(context, listen: false);
    final fetchedRooms = await roomService.getRooms();
    setState(() {
      rooms = fetchedRooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BotNavWidget(),
      key: scaffoldKey,
      backgroundColor: DemirBasimTheme.of(context).primaryBackground,
      drawer: const SizedBox(
        width: 200,
        child: CustomDrawer(),
      ),
      appBar: Demirbas.appbars(context, 'Anasayfa'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildLogo(context),
          odalarText(),
          Consumer<RoomServiceFirebase>(
            builder: (context, roomService, child) {
              final rooms = roomService.rooms;

              if (rooms.isEmpty) {
                return const Spacer();
              } else {
                return slider(rooms);
              }
            },
          ),
        ],
      ),
    );
  }

  Expanded slider(List<RoomModelFireBase> rooms) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: rooms.length,
        itemBuilder: (BuildContext context, int index) {
          final room = rooms[index];
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 0, 45),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RoomDetailsPage(room: room)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          // ignore: unnecessary_null_comparison
                          child: room.imageUrl != null
                              ? Image.network(
                                  room.imageUrl,
                                  width: double.infinity,
                                  height: 100,
                                )
                              : const Icon(Icons.image),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                      child: Text(
                        room.name,
                        textAlign: TextAlign.center,
                        style: DemirBasimTheme.of(context).titleMedium.override(
                          fontFamily: 'Outfit',
                          color: const Color(0xFF101213),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
