import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  /*
  final String title;
  final double price;

  ProductDetailScreen(this.title, this.price);
    ====> Instead of getting the above as an arguments we extracted the data from the routing arguments
  */

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    // we use (ModalRoute)to extract the data passed by the [argument] of the (PushedNamed => 'argument')
    // VIA the id u cant get all the product data for that ID
    final productId = ModalRoute.of(context).settings.arguments
        as String; // this will in the end give us the ID !

    // By using the Provider pkg, you can tap into your provided data --> we want all the product data
    // #Method_2: making the search in the [providers/products.dart] to make this class a bit leaner
    final loadedProduct = Provider.of<Products>(
      context, // the ctx is the communication channel
      // when you are not interesting with the products updates, no need to listen
      // to make the widget not rebuild if [notifyListener] is called, making the listener inactive, we just need the data 1one1 time!, we are not interesting in updates.
      listen: false, // to avoid the rebuilding of the widget
    ).findById(productId);

    /* #Method_1:  -- [Provider.of<Products>(context)] ===> gives us access to the whole products object
    final loadedProduct = Provider.of<Products>(context)
        .items
        .firstWhere((prod) => prod.id == productId);*/

    /* --->method #1 & method #2 are the same, it's just about mmaking the code a bit leaner<--- */

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
