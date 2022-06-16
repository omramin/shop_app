import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  // The information that we want to get here in this widget
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    // Defining how a single item should look like
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        // the image that shown inside the avatar,
        // backgroundImage doesn't take a widget, but an image provider
        backgroundImage: NetworkImage(imageUrl),
      ),
      // we useed the container to fix the sizing problem of the ROW!. the row takes as much space as it can get, so we restrict that size by using the container
      trailing: Container(
        width: 100,
        // we did the above solution[container with fixed width] coz the row takes as much space as it can get, and the trailing of the ListTile doesn't restrict that size
        child: Row(
          children: <Widget>[
            // Editing the product
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // To let this screen know about which product I want to edit
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            // Deleting the product
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                //
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
