// Showing a list of all the products of the user

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

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
      body: Padding(
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
    );
  }
}
