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
    // to fix the not showing of the snackBar coz we do it there inside the future and [.of(context)] can't be resolved anymore due how the flutter work internally
    // It's already updating the widget tree at this point of time and therefore it's not sure whether a context still refers to the same context it did before
    final scaffold = Scaffold.of(context);
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
              // turning it to a async FN so that it can work with this future behind the scenes
              onPressed: () async {
                // #See the Delete method in [products.dart file]. ---> Handling the error Gracefully
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting Failed !',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
