/*
- We want to rebuild this widget whenever the products changed
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  //
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    /* setting up the listener
      It's a generic method, which means you can add <> to let it know which type of data you want to listen to
      and I want to listen in changes in Products.
    */
    final productsData = Provider.of<Products>(context);
    // the copied list =-=-=> items
    // If showFavs is true returning our FAVs | method #2 of Filtering
    final products =
        showFavs ? productsData.faovritesItems : productsData.items;

    return GridView.builder(
      // to add padding around the grid
      padding: const EdgeInsets.all(10.0),
      // how many Grid items to build
      itemCount: products.length,
      // holds the builder FN wich receives the context & the index of the item it's currently building a cell for ==> return the widget that gets built for every grid item
      //how every grid item is built
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // return the value u want to provide
        // (products[i]) will return a single product item as it's stored in the product class and it will do this multiple times coz it's inside of the item builder for all the products u have
        // since I'm providing a single product that means we don't have to receive our product data as arguments in the product item
        // instead use the provider
        // #001
        // we providing this for every ProductItem
        value: products[
            i], // it will do this multiple times coz it's inside of the product builder
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      // how the grid generally should be structured?, how many columns?
      // used when you want AT LEAST A CERTAIN AMOUNT OF GRID ITEMS ON THE SCREEN
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // to be higher/taller than they are wide
        childAspectRatio: 3 / 2,
        // the spacing between the columns
        crossAxisSpacing: 10,
        // the spacing between the rows
        mainAxisSpacing: 10,
      ),
    );
  }
}
