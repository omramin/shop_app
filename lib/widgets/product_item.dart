/*
  Outsourcing the product into a separate widget
  how each item should look like, how a grid item should look like 
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  /* --------------->>>> after using the provider in the [products_grid] ----->>see #001
  accepting properties to display a product

  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);
  */

  // we need to listen to updates without rebuilding the whole widget, [Provider.of<Product>] VS Consumer is that the consumer only update what you want to update, can also use listen:false

  @override
  Widget build(BuildContext context) {
    // if [Provider.of<Product>(context, listen: false);] there is no rebuild will accure
    print('product item rebuild!');

    /*final prodcut = Provider.of<Product>(context); --------> coz we use the Consumer()*/

    /*-------> setting up the listener for a [single product]    |  and it will now look for the nearest product which is provided
                to listen to the changes in a single product <-------*/
    final product = Provider.of<Product>(context, listen: false);

    // accessing the Cart() container | It gives us the nearest provided object of the type cart, which is there in the main.dart file [ create: (ctx) => Cart() ]
    // listen: false ==?==> to not change the widget if the cart changed!
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      // ClipRRect => ClipRoundedRectangles
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // to make the image tapable, to be navigated to a new screen
        child: GestureDetector(
          // onTap push this new page
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              // passing the data we needed there instead of passing it as an arguments inside of the constructor
              arguments: product.id,
            );
          },
          // the main content of the grid
          child: Image.network(
            product.imageUrl,
            // to take al th available space it can get ==> to make the ims equally sized
            fit: BoxFit.cover,
          ),
        ),
        // to add a bar at the bottom of the grid tile
        footer: GridTileBar(
          // black color with opacity
          backgroundColor: Colors.black87,
          // left| #we need the product changes here, and only here | Using the consumer to rebuild the only nested children
          // Consumer<Product> ==?==> which type of data you want to consume? , and it = to [ Provider.of<Product> ]
          leading: Consumer<Product>(
            // the context, the instance (the nearest instance it found of that data), and a child
            // and then return the widget that depending on our provided data
            builder: (ctx, product, _) => IconButton(
              // reflecting the current fav.state in the icon
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus();
              },
            ),
            // this will never rebuild when the consumer rebuild!, if u don't need it the u use [ _ ]
            // child: Text('The text that\'s NEVER change!'),
          ),
          // to make the text forcfully visible even if it too long
          title: FittedBox(
            child: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              // to hide the current SnackBar
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
