import 'package:demirbasim/models/room_model.dart';
import 'package:demirbasim/service/product_service.dart';
import 'package:demirbasim/service/room_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';

 class DataSearch extends SearchDelegate<String> {
  final List<String> data; // Update this list with global data

  DataSearch(this.data);

  //... Rest of the code
  List<String> fetchGlobalData(BuildContext context) {
  var productService = Provider.of<ProductService>(context, listen: false);
  var roomService = Provider.of<RoomService>(context, listen: false);

  List<Product> allProducts = productService.getAllProducts();
  List<Room> allRooms = roomService.rooms;

  List<String> globalData = [];
  
  globalData.addAll(allProducts.map((product) => product.name).toList());
  globalData.addAll(allRooms.map((room) => room.name).toList());

  return globalData;
}


  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = data.where((item) => item.toLowerCase().startsWith(query.toLowerCase())).toList();
    
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestionList[index]),
        onTap: () {
          close(context, suggestionList[index]);
        },
      ),
      itemCount: suggestionList.length,
    );
  }
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    throw UnimplementedError();
  }
  
  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw UnimplementedError();
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }

  //... Rest of the code
}
