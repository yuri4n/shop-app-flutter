import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        this._editedProduct =
            Provider.of<Products>(context).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();

    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);

      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error ocurred!'),
            content: Text('Somethig went wrong'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Product',
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: double.parse(value),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a description';
                        }
                        if (value.length < 10) {
                          return 'Please enter a description a least 10 characters long';
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
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text(
                                  'Enter an url',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide an url';
                              }
                              if (!value.startsWith('http')) {
                                return 'Please enter an url';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('jpeg')) {
                                return 'Please enter an image url';
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
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
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
