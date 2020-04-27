import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;

  CartItem(this.id);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final item = cart.getItemById(id);

    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: Colors.redAccent,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(id);
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Image.network(item.imageUrl),
            ),
            title: Text(item.title),
            subtitle: Text('Total: \$${item.price * item.quantity}'),
            trailing: Text('${item.quantity} x \$${item.price}'),
          ),
        ),
      ),
    );
  }
}
