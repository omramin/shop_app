/*
this class is establishing a communication channel between him and other widgets/class that are interested
all the listeners will know about all the updates
all the listeners will be rebuild with every data chnaging
*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // to avoid name clashes

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  // storing a list of products here
  List<Product> _items = [
    //   Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
  ];

  var _showFavoritesOnly = false;

  // when the products change, call a method to tell all the listeners that new data is available
  // when returning the items we take showFavoritesOnly into account to determine which items to return by the [IF]
  List<Product> get items {
    // returning a copy of _items list
    // ignore: sdk_version_ui_as_code
    if (_showFavoritesOnly) {
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    }
    return [..._items];
  }

  // extracting the filtering code from the (product_detail_screen)
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // Adding the logic of filtering our products #2| It's just an alternative getter to get only the FAVORITES
  // we can reach it from our ProductsGrid if showFavs is true !
  List<Product> get faovritesItems {
    // for every prodItem I will return...
    return _items.where((prodITem) => prodITem.isFavorite).toList();
  }

  /* ----> This called application wide filter
  If we have another screen which also shows our products, if choose a filter and then go to that other screen 
  our filter would still be applied there.

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    // to reflect the filtering feature
    notifyListeners();
  }

  // toggling
  void showAll() {
    _showFavoritesOnly = false;
    // to reflect the filtering feature
    notifyListeners();
  }
  */

  Future<void> fetchAndSetProducts() async {
    // reaching out the same url we've used to post/save our products
    final url = Uri.parse(
        'https://shop-app-708a5-default-rtdb.firebaseio.com/products.json');
    // coz this might fail !!
    try {
      // the [response] will contain the data
      final response = await http.get(url);
      // even though we it's a map inside a map we simply cant do <String, Map> it will give us an error
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // To make sure that this code won't run if extractedDate is null (has no oders)
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      /**for each value in the key which is an ID. The value is a MAP
       * It will execute for every entry in that map, in the outer map
      */
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imgUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = loadedProducts;
      // to update all the places in the app tat are interested in the products
      notifyListeners();
    } catch (error) {
      // to handle it in or widget if we want to do that there
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    // [products] at the end of the URL: to create a folder/collection in the database | firebase request a [.json] when it parses the incomming request
    final url = Uri.parse(
        'https://shop-app-708a5-default-rtdb.firebaseio.com/products.json');
    /*Future gives us a [then] method, that allows us to wait for a certain action to finish.
    It allows us to define a FN that should execute in the future once this action is done
    
    - #1#spinner# : Return the hole block of [http.post] as a FUTURE object (bcoz [post] returns a FUTURE), to accept it when we call [addProducts] from [edit_product_screen.dart]
    - 
    */
    // #async2# : #REMOVE: [return http] coz the future will be be returned automatically
    // #async3# : #ADD: await keyword | it tells dart that we want to await for this operation to finish before we move on to the next line of our code
    // #async6# : store the result in a variable |
    // #try catch1# : to handle the error that could happen, we wrap the code that might fail  [when there's too many factors beyond your control]
    try {
      final response = await http.post(
        url,
        // body: allows us to define the request body which is the data attached to the request
        // convert the product object to a json, by creating a map
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imgUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        // to have a unique ID for now
        // id: DateTime.now().toString(),
        id: json.decode(response.body)['name'],
      );
      // add it to our _items
      _items.add(newProduct);
      // Alternatively: to add it at the beginning of the list
      // _items.insert(0, newProduct); // at the start of the list

      // to tell all (the listeners/the interested widgets) about new data changes
      notifyListeners();
    } catch (error) {
      // Here we put the code that should run when the above [try] throw an error
      print(error);
      throw error;
    }
  }

  /* -----------------------------
  We put these lines of code inside the [then] FN to make the addition after the POST return a response
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      // to have a unique ID for now
      id: DateTime.now().toString(),
      // id: json.decode(response.body),
    );
    // add it to our _items
    _items.add(newProduct);
    // Alternatively: to add it at the beginning of the list
    // _items.insert(0, newProduct); // at the start of the list

    // to tell all (the listeners/the interested widgets) about new data changes
    notifyListeners();
  } -----------------------------
  */

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shop-app-708a5-default-rtdb.firebaseio.com/products/$id.json');
      // #patch : To merg the data which is incoming with the existing data | We'll encode a map that reflect my [newProduct]
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imgUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  // Removing a product
  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-app-708a5-default-rtdb.firebaseio.com/products/$id.json');
    // #Optimistic Updating# 1#: Getting the index of the product we want to remove
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    // #Optimistic Updating# 2#: Storing a reference/a pointer to the product which is about to be deleted in [existingProduct]
    var existingProduct = _items[existingProductIndex];
    // #Optimistic Updating# 3#: Deleting the item from the list, but it still a live in memory coz we have a reference in the above [existingProduct]
    _items.removeAt(existingProductIndex);
    notifyListeners();
    // #Optimistic Updating# 4#: Sending the delete request & We also want o handle the error if it occured by using the [catchError] ===> #replaced with async-await + storing the response in a variable [final response]
    final response = await http.delete(url);
    // #Status Code: 1# : Handling the error by it's status code. | We want to throw our own ERROR !
    if (response.statusCode >= 400) {
      // reinsert it if we hade an ERROR
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      // It's recommanded to use your own exception based on the Exception() class to handle such an HTTP-Delete error
      throw HttpException('Could not delete the product!');
    }
    // #Optimistic Updating# 6#: To clear up the reference and remove the object that live in memory
    existingProduct = null;
    /* =====> #replaced with async await. | So we removed the catchError method
      #Optimistic Updating# 5#: [ .catchError((_) {} ] => We're not interesting in the error itself, so we pass [ _ ],
      - Here we just want to roll back the deletion if something went wrong. ($adding the product again$).
      - [existingProduct] holding a reference to the same old prodcut. | And this will reinsert the product into the list IF WE FAILD HERE [http.delete(url)].
      
      }).catchError((_) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
      });

    */

    /*---------------> OLDDDDD CODDDDE
    execute a FN on every product there
    and if it return true, it's a product that should be removed.
    and we will return true if the ID of the product we're looking at in our list of products is equal to the ID we're getting here as an argument
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    */

    /** Summerizing FN :-
     * The Above FN Steps in summery :-
     * 1. First, we immediately delete the product
     * 2. then we wait for the response
     * 3. the we check the response and possibly roll back and throw an error if it is an error response 
     * 4. finally, reset the existing product we cached
     */
  }
}
