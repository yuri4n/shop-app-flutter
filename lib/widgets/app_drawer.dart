import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu', style: Theme.of(context).textTheme.title),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop, color: Colors.white),
            title: Text('Shop',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment, color: Colors.white),
            title: Text('Orders',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit, color: Colors.white),
            title: Text('Manage Products',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
