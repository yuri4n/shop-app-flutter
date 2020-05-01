import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return [..._items.where((prod) => prod.isFavorite)];
  }

  Product findById(String id) {
    final item = _items.firstWhere((prod) => prod.id == id);
    return item != null ? item : null;
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://shop-app-d85d0.firebaseio.com/products.json';

    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      if (extractData != null) {
        extractData.forEach((key, item) {
          loadedProduct.add(Product(
              id: key,
              title: item['title'],
              description: item['description'],
              price: item['price'],
              isFavorite: item['isFavorite'],
              imageUrl: item['imageUrl']));

          _items = loadedProduct;
          notifyListeners();
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://shop-app-d85d0.firebaseio.com/products.json';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((item) => item.id == id);
    if (productIndex >= 0) {
      final url = 'https://shop-app-d85d0.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  // Optimistic Update pattern
  Future<void> deleteProduct(String id) async {
    final url = 'https://shop-app-d85d0.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    _items.removeWhere((prod) => prod.id == id);
    existingProduct = null;

    notifyListeners();
  }
}
