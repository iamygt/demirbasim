import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demirbasim/service/firebase_service_product.dart';
import 'package:demirbasim/service/firebase_service_room.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:demirbasim/utils/search_page.dart';
import 'package:flutter/material.dart';

class Demirbas {
  static final firestore = FirebaseFirestore.instance;

  static AppBar appbars(BuildContext context, String title) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
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
  showSearch(
    context: context,
    delegate: SearchPage(
      productService: ProductServiceFirebase(),
      roomService: RoomServiceFirebase(), allRooms: [],
    ),
  );
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
}