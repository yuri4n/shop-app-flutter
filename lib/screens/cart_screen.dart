import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static final String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$${cart.totalAmnount}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton(
              child: Text(
                'Order Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              onPressed: () {},
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, i) => CartItem(cart.items.keys.toList()[i])),
          ),
        ],
      ),
    );
  }
}
