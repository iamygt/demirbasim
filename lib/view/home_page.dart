import 'dart:io';
import 'dart:ui';

import 'package:demirbasim/models/room_model.dart';
import 'package:demirbasim/service/room_service.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/utils/draver.dart';
import 'package:demirbasim/view/room_details.dart';
import 'package:demirbasim/widgets/bot_nav.dart';
import 'package:demirbasim/widgets/icon_button.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DemirBasimHome extends StatefulWidget {
  const DemirBasimHome({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DemirBasimHomeState createState() => _DemirBasimHomeState();
}

class _DemirBasimHomeState extends State<DemirBasimHome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      appBar:  _homeAppBar(context, 'AnaSayfa'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Text(
                  'Odalar',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 20,
                  ),
                ),
              ),
              // Other widgets...
            ],
          ),
          Consumer<RoomService>(
            builder: (context, roomService, child) {
              return FutureBuilder<List<Room>>(
                future: roomService.fetchRooms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final rooms = snapshot.data!;
                    return slider(rooms);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Expanded slider(List<Room> rooms) {
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
                          child: Image.file(
                            File(room.imagePath),
                            width: double.infinity,
                            height: 100,
                          ),
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

  AppBar _homeAppBar(BuildContext context, String? title) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title ?? 'DemirBasim',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: DemirBasimTheme.of(context).primaryBtnText,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: DemirBasimTheme.of(context).primaryBtnText,
            size: 30,
          ),
          onPressed: () {
            if (kDebugMode) {
              print('IconButton pressed ...');
            }
          },
        ),
      ],
      backgroundColor: DemirBasimTheme.of(context).alternate,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Stack(
      children: [
        ClipRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2,
            ),
            child: Container(
              width: double.infinity,
              height: 370,
              decoration: BoxDecoration(
                color: const Color(0xFF262D34),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/blur.jpg',
                  ).image,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
                border: Border.all(
                  color: DemirBasimTheme.of(context).primaryText,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 370,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E2429), Color(0x001E2429)],
              stops: [0, 1],
              begin: AlignmentDirectional(0, 1),
              end: AlignmentDirectional(0, -1),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                child: Image.asset(
                  'assets/beyazuzun.png',
                  width: 300,
                  height: 120,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hoşgeldin!',
                            style: DemirBasimTheme.of(context).displaySmall.override(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'DemirBaşım ile Evini Hatırla!',
                            style: DemirBasimTheme.of(context).headlineMedium.override(
                                  fontFamily: 'Lexend Deca',
                                  color: const Color(0xB3FFFFFF),
                                  fontSize: 26,
                                  fontWeight: FontWeight.w200,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget botNav(BuildContext context) {
  return Stack(
    children: [
      Align(
        alignment: const AlignmentDirectional(0, 2.83),
        child: Row(
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
                    fillColor: DemirBasimTheme.of(context).primary,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
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
                if (kDebugMode) {
                  print('IconButton pressed ...');
                }
              },
            ),
          ],
        ),
      ),
    ],
  );
}
