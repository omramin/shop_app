import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../providers/products.dart';

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
  var isInit = true;
  // #spinner#1# : add the property to identify the loading process
  var _isLoading = true;

  @override
  void initState() {
    // #HACK#
    /* #fetch datat #1# : all these kinds of context doesn't work here in [initState()]. Coz simply the widget isn't fully wired up with everything here
    - Provider.of<Products>(context).fetchAndSetProducts(); */

    /* #fetch data #2# : #Method #2: add future with delay | This will execute immediately coz we have zero duration until this code runs 
    --> COD-TRNSLT:--> [.delayed(Duration.zero)] is a helper construcor wich creates a future wich executes [then] after the duration passed
    ======= this could work but technically still registered as a to-do action, it will run after the initialization the class & the widget before it comes to this hack
    - Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context).fetchAndSetProducts();
    });

    */

    super.initState();
  }

  /* #fetch datat #3# : Using [ didChangeDependencies() ] with a helper var and making sure we use it only one time !  */
  // the [didChangeDependencies()] Will run after the widget has been fully initialized BUT before build ran for the first time. And we always use it with another helper variale
  @override
  void didChangeDependencies() {
    if (isInit) {
      // #spinner#2#: change the property to load the spinner
      setState(() {
        _isLoading = true;
      });
      // #spinner#3#: add [then] part | after load the spinner make the loading controller (_isLoading) false X
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        // coz here we're done with fetching the products| The fetching process is done coz the [.fetchAndSetProducts()] returns a future once it's done
        setState(() {
          _isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
