// Showing a list of all the products of the user

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  // #Pull-To-Refresh# 2#: add a FN  | first it was like this [_refreshProducts ()] and that gave us an error coz we're not in a state class here and we don't get the context so we needed to get as an input in our [_refreshProducts (here)]
  Future<void> _refreshProducts(BuildContext context) async {
    // #await: we'll await for this to finish, Therefore this overall method will only be done once this is done and lastly the above future will be resolved
    // #FALSE : Coz we don't want to listen in updates in products. We only want to trigger the method,
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            // To navigate to add a new product screen
            onPressed: () {
              // we used pushNamed coz we want to push the new page on the stack of pages so that we also can go back to this page from the new page
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      // coz we want a padding around the list
      // #Pull-To-Refresh# 1#:
      body: RefreshIndicator(
        // #cant: [onRefresh: _refreshProducts] | since we need the context there, we need to pass it here, and therefore we need t wrap it in anonymous FN
        // and inside the anonymous FN we can pass the context that we getting here in the above build method
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          // to have the possible performance improvement
          child: ListView.builder(
            // the [items] is the the list of the products
            itemCount: productsData.items.length,
            // we don't need the ctx here | how should a single product look like
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(
                  productsData.items[i].id,
                  productsData.items[i].title,
                  productsData.items[i].imageUrl,
                ),
                // to have a Divider after every user product item
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
