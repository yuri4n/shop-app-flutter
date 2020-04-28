import 'package:flutter/material.dart';

class Item {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  Item({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, Item> _items = {};

  Map<String, Item> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmnount {
    double total = 0;

    _items.forEach((key, Item) {
      total += Item.price * Item.quantity;
    });

    return total;
  }

  Item getItemById(String key) {
    return _items.containsKey(key) ? _items[key] : null;
  }

  void addItem(String productId, double price, String title, String imageUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existing) => Item(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          quantity: existing.quantity + 1,
          imageUrl: existing.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
          productId,
          () => Item(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
                imageUrl: imageUrl,
              ));
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
