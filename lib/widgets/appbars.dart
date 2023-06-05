import 'package:demirbasim/controllers/search.dart';
import 'package:demirbasim/theme/all_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Demirbas {
  static appbars(BuildContext context, String title) {
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
            var dataSearch = DataSearch([]);
            // Fetch global data
            List<String> globalData = dataSearch.fetchGlobalData(context);
            // Initialize DataSearch with global data
            showSearch(context: context, delegate: DataSearch(globalData));
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
}
