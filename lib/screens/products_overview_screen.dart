import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
// import '../providers/products.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';

// the enums are just a methodolgy of asigning integers to lables| behind the scenes we have integers but we work with the lables
enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  // we have to access our product provider to filter our products
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // pass it to ProductsGrid() which it displays out products
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false); // coz we're not interested in the data, we just need to access the container to call the methods of toggling
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          // opening a menu as an overlay
          PopupMenuButton(
            // it's value is a FN which gets the selected value
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            // to build the entries| it gets the ctx which we don't need it and retrun a list of widgets
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                // to find out which choice/item was chosen by the user
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                // Instead of [value: 1] we could use an enum
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              // forward the child to badge
              child: ch,
              value: cart.itemCount.toString(),
            ),
            // automatically passed to the above builder as a ch argument | NO NEED TO REBUILD THE ICON_BUTTON
            // again !! this child won't be rebuilt when the cart changes coz it's defined outside the builder function!
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          // the amounts of the items we have in the cart, and we can get it from the cart provider, so, there we added the getter of itemCount
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
