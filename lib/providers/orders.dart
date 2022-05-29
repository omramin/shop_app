import 'package:flutter/foundation.dart';

import './cart.dart';

// defining how the order should look like
class OrderItem {
  final String id;
  final double amount;
  // which products were ordered
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    // add VS insert :--> add: will always add it at the end of the list | insert 0 : add at the begining of the list
    // moving the existing elements of the list one index ahead to the end
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
