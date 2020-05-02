import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<Item> products;
  final DateTime date;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.date,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final String url =
        'https://shop-app-d85d0.firebaseio.com/orders.json?auth=${this.authToken}';

    final List<OrderItem> loadedOrders = [];
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) return;

    extractedData.forEach((orderId, order) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: order['amount'],
        date: DateTime.parse(order['date']),
        products: (order['products'] as List<dynamic>)
            .map((item) => Item(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                  imageUrl: item['imageUrl'],
                ))
            .toList(),
      ));
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<Item> cartProducts, double total) async {
    final String url =
        'https://shop-app-d85d0.firebaseio.com/orders.json?auth=${this.authToken}';
    final DateTime timeStamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'date': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                    'imageUrl': cp.imageUrl
                  })
              .toList(),
        }));

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        date: timeStamp,
        products: cartProducts,
      ),
    );

    notifyListeners();
  }
}
