import 'package:flutter/material.dart';
import 'package:my_shop/screens/orders_screen.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*
    Provider ways: The best way in case of providing your data on a [Single List of a Grid]
    return ChangeNotifierProvider.value(
      value: Products(),
      the other way:
    return ChangeNotifierProvider(
      create: (context) => Products(),
      );

    = the build/create method return a new instance of your provided class, which in our case the Products class
    = using create when your are creating a brand new object is always recommended
    */

    // Special type of provider which allows us to group multiple providers togethers
    return MultiProvider(
      // list of providers
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      // the child receive all thee above providers
      child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
          }),
    );
  }
}
