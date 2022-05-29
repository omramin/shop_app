import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// To let dart dart know we're interested only in cart and it won't import the CartItem from the cart.dart file| to avoid the name clash
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
// import '../widgets/cart_item.dart' as ci #002; ---------> coz we have two CartItem classes [cart.dart + cart_item.dart]
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    // To listen to the changes| getting the Cart object to access to it's methods
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  // It takes up all the available spcae and reserves it for itself
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('ORDER NOW'),
                    onPressed: () {
                      // to convert it to a list instead of passing the whole map
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      // to clear the cart
                      cart.clear();
                    },
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              // itemBuilder: (ctx, i) => ci.CartItem(  --------> using a prefix  --> see #002 above
              itemBuilder: (ctx, i) => CartItem(
                // to only work with the concrete values stored in the map
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}
