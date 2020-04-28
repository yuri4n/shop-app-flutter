import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../screens/edit_product_screen.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title:
          Text('Your Products', style: Theme
              .of(context)
              .textTheme
              .title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (ctx, i) =>
                Card(margin: EdgeInsets.only(bottom: 20),
                    child: UserProductItem(productsData.items[i].id)),
          ),
        ));
  }
}
