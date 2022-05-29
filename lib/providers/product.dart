// A blueprint to create a product object
// ChangeNotifier available in [foundation.dart]
import 'package:flutter/foundation.dart';
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

  // invert the value of the isFavorite boolean
  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    // like the setState()
    notifyListeners();
  }
}
