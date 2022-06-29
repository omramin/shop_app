import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    print('building orders');
    // ToNot live in an infinite loop ()
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        // [dataSnapshot] the data currently returned by the future
        builder: (ctx, dataSnapshot) {
          // It means that we're currently ---> #LOADING
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            // showing the #spinner
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              // Here is the only place we need the
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

/* #The Old OrdersScreen#
class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  // Either we use [initState()] with that Future delayed hack. OR we use [didChangeDependencies]
  @override
  void initState() {
    // Future.delayed() is a constructor that gives us a new future. And we pass a duration that should pass untill this future automatically resolves. And the (Duration = 0) so this will instantly resolved
    Future.delayed(Duration.zero).then((_) async {
      // #async --> #spinner
      // #Spinner# | To update the UI, coz this will run after build was called
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false)
          .fetchAndSetOrders(); // await to fetching orders ---> #spinner
      // after we wait for the above response we have to set this back to false
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
            ),
    );
  }
}
*/
