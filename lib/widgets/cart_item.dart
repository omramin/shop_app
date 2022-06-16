import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      // to restrict the direction of the deletion | Right --to--> Left
      direction: DismissDirection.endToStart,
      // it returns a Future
      confirmDismiss: (direction) {
        // show dialog return a Future after the dialog is closed
        return showDialog(
          // the ctx on the right refers to context of the build method
          context: context,
          // the builder gives you it's own context as all builders do
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
              'Do you want to remove the item from the cart?',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                // Here we can control what the Futuure resolves to, by calling Navigator.pop  ===> hover on showDialog to see more tips(just before: "State Restoration in Dialogs")
                onPressed: () {
                  // use the context that the above builder that gives us
                  /*  this will close the dialog, and we also can forward a vzalue, [that's optionall],
                      but we want to do that becuse we want to yield a value with our future in the end.
                      - If the user chose NO we don't want to dismiss, So we don't want to confirm the Dismissable
                      - See the Yes button down there!
                      */
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  // Here the opposite is true
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      // to define what whould happen based on the direction you getting here as an argument
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                // to fit the text inside the CircleAvatar
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
