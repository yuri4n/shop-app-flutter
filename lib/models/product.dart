import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteValue(String token) async {
    final oldStatus = this.isFavorite;
    this.isFavorite = !this.isFavorite;
    notifyListeners();

    final String url =
        'https://shop-app-d85d0.firebaseio.com/products/${this.id}.json?auth=$token';

    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': this.isFavorite,
          }));
      if (response.statusCode >= 400) {
        this.isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      this.isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
