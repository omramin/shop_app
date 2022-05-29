/*
this class is establishing a communication channel between him and other widgets/class that are interested
all the listeners will know about all the updates
all the listeners will be rebuild with every data chnaging
*/

import 'package:flutter/material.dart';

import './product.dart';

class Products with ChangeNotifier {
  // storing a list of products here
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  var _showFavoritesOnly = false;

  // when the products change, call a method to tell all the listeners that new data is available
  // when returning the items we take showFavoritesOnly into account to determine which items to return by the [IF]
  List<Product> get items {
    // returning a copy of _items list
    // ignore: sdk_version_ui_as_code
    if (_showFavoritesOnly) {
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    }
    return [..._items];
  }

  // extracting the filtering code from the (product_detail_screen)
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // Adding the logic of filtering our products #2| It's just an alternative getter to get only the FAVORITES
  // we can reach it from our ProductsGrid if showFavs is true !
  List<Product> get faovritesItems {
    // for every prodItem I will return...
    return _items.where((prodITem) => prodITem.isFavorite).toList();
  }

  /* ----> This called application wide filter
  If we have another screen which also shows our products, if choose a filter and then go to that other screen 
  our filter would still be applied there.

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    // to reflect the filtering feature
    notifyListeners();
  }

  // toggling
  void showAll() {
    _showFavoritesOnly = false;
    // to reflect the filtering feature
    notifyListeners();
  }
  */
  void addProducts() {
    // _items.add(value);

    // to tell all (the listeners/ the interested widgets) about new data changings
    notifyListeners();
  }
}
