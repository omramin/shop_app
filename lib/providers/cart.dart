import 'package:flutter/foundation.dart';

// Inside the cart we want to have a couple of cart items
class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  // Mapping every cart item to the id of the product it belongs to
  // all methods won't work if not initalized
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  // To tell us how many items are in there
  int get itemCount {
    // we don't need this solution coz we initialized it above
    //return _items == null ? 0 : _items.length;
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    // for every element in that cart
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    // checking if we already have it in our cart, if so => increase the qnty, else: add it to the cart
    if (_items.containsKey(productId)) {
      // change quantity... | update takes a FN that return the new cart item & it automatically takes the existing value it found for this key
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          // the goal !
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // to add a new entry to the MAP| putIfAbsent takes a FN that create the Value
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // placing an order means we have to clear/remove the cart because we ordered all the elements
  void clear() {
    _items = {};
    notifyListeners();
  }
}
