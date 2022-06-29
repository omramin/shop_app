// A blueprint to create a product object
// ChangeNotifier available in [foundation.dart]
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// to make the widget that are depend on a single product REBUILT whenever that single product changes| ((isFavorite changes))
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  /* Old [toggleFavoriteStatus] FN
  // invert the value of the isFavorite boolean
  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    // like the setState()
    notifyListeners();
  }
  */

  // #4: Roll Back logic
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  // #Updating the Favorite Satus Optimistically: Change the FAV status and roll back if it fails
  Future<void> toggleFavoriteStatus() async {
    // #1: store the old status.
    final oldStatus = isFavorite;
    // #2: Updating the status locally
    isFavorite = !isFavorite;
    notifyListeners();
    // #ID issue?# since this will execute for concrete instances of this class, the ID will be set and therefore we'll target a specific ID and send our request to that ID
    final url = Uri.parse(
        'https://shop-app-708a5-default-rtdb.firebaseio.com/products/$id.json');
    try {
      // #3: Updating the FAV status. | [response.statusCode]
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      // #3: Roll back if an error occured.
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    }
    // #3: Roll back if an error occured.
    catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
