// To add a new product & editing an existing product
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // to have the transition from one field to another when you click the next btn on the keyboard, we do that with the help of [FocusNode]
  // we assign it to a text input widget
  final _priceFocusNode = FocusNode();
  // to track our focus state <whether that's focused or not>
  final _descriptionFocusNode = FocusNode();
  // you should also dispose it
  final _imageUrlController = TextEditingController();
  // to setup a listener when loses focus
  final _imageUrlFocusNode = FocusNode();
  // To hold our global key | global key is a generic type, which you can specify which data you'll refer to! | in our case [FromState]
  // GlobalKey allows us to interact with the state behind the form widget. by assigning this property to the form to establish that connection
  final _form = GlobalKey<FormState>();
  /* To store the values extracted from the FORM fields  ##[SAVING-FORM]##
    - It's an empty product! an Object. | we use it to update it's values when [_saveForm] is executed
  */
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  // to initialize all the form inputs with some default values
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  // to make sure that I don't run this too often
  var _isInit = true;

/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/

  // setting up our own listener to the [_imageUrlFocusNode], it keeps track of whether that's focused or not
  @override
  void initState() {
    // we point at a FN here that should be executed whenever the focus changes
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  // RUNS BEFORE THE BUILD IS EXECUTED
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      // to check out if we do have a product or not
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    // didChangeDependencies will run multiple times, so we will make [_isInit] false to make sure it will not run again
    // So that for future executions of didChangeDependencies, we don't reinitialize our form.
    _isInit = false;
    super.didChangeDependencies();
  }

  // to Update the UI
  void _updateImageUrl() {
    // if we're not having focus anymore | if we lost focus then we want to update the UI and use the latest state stored  in the [_imageUrlController]
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      // rebuilding the screen to reflect the _imageUrlController updated value
      setState(() {});
    }
  }

  /* Submitting the form:
   - how to interact with the FORM widget from inside this method? how to get a direct access to the form widget?
   - You can use a global key [We use keys when we need to interact with a widget from inside our code]
  */
  void _saveForm() {
    // [_form.currentState.validate()] will erturn TRUE if there is no error. And will return false if at least one validator returns a string and hence it has an error
    final isValid = _form.currentState.validate();
    if (!isValid) {
      // to cancel the FN execution
      return;
    }
    /* save is method provided by the state object of the form widget, and it trigger a method for every form field wich allow you to
      take the value entered into the text from field
    */
    _form.currentState.save();
    // print(_editedProduct.title);
    // print(_editedProduct.description);
    // print(_editedProduct.price);
    // print(_editedProduct.imageUrl);

    /* checking if the _editedProduct has an ID
     * This ID is only set if we loaded a product 
     * If it not equal to null then we updating an existing product
     */
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProducts(_editedProduct);
    }
    Navigator.of(context).pop();

    // _editedProduct contains all the data we're gathering
    Provider.of<Products>(context, listen: false).addProducts(_editedProduct);
  }

  // You have to Dispose FocusNode variables to make sure they won't stick around in memory and could lead to memory leak
  // TO AVOID MEMORY LEAKS !!
  @override
  void dispose() {
    /* We also have to clear that listener when we dispose of that state, otherwise the listener keeps on living in memory 
       even though the page is not presented anymore ==> causes memory leak
    */
    // to remove the listener
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

/*=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=--=- Building the FORM -=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // creating the connection
          key: _form,
          // to build a scrollable list of input elements | ListView is automatically scrollable
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                // gives you a lot of configuration options to change the appearance
                decoration: InputDecoration(
                  // The hint text that shown above the input
                  labelText: 'Title',
                ),
                // To control what the bottom right button in the soft keyboard will show, i.e: checkmark, or a done or a next icon
                // to move to the next input field
                textInputAction: TextInputAction.next,
                // fired whenever the next btn on the keyboard is pressed | we're not interested in the value so we used ' _ '
                onFieldSubmitted: (_) {
                  // using the focusNode to move the focus to the second input field
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  // Creating a product which takes all the old values of the existing added product and overrides the one value for which this text form field was responsible
                  _editedProduct = Product(
                      title: value,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
                /** Validator
                 * Takes the entered value and returns a String.
                 * Executed #1 when you call a specific validate method ---> [the default]
                 *  #2 When you set autovalidate to TRUE, then it will validate on every keystrok
                */
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a title';
                  }
                  // there's no error, the input is correct
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  // -Checking if the user entered a valid number.| -tryParse return a null if it fails
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  // a valid price should be above Zero
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  // then we have a valid number
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                // to make suited for a longer inputs
                maxLines: 3,
                // to make the keyboard gives us an Enter sympol on the bottom right corner of the soft keyboard
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 5) {
                    return 'Should be at least 5 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              //
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // To preview the image
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    // Checking if the imgUrlController is empty ! => to return either the img or an alert
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  // coz the TextFormField takes as much width as it can get
                  Expanded(
                    child: TextFormField(
                      // initialValue: _initValues['imageUrl'],  =====> If you have a controller YOU CAN'T SETUP an INITIAL VALUE
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      // coz we want to access the image URL before the form is submitted
                      controller: _imageUrlController,
                      // we use it when the user unselect it
                      focusNode: _imageUrlFocusNode,
                      // onFieldSubmitted expects a FN that takes a string value
                      // we don't care about the value | Triggered when the done button is pressed on the soft keyboard
                      onFieldSubmitted: (_) {
                        // To execute the FN when the DONE btn is pressed
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: value,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
