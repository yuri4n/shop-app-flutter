import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

import '../colors/ships_officer.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Rebuild only the return, not the entire method
    // It can combine both mehtods, for example for set listen false to some methods
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Stack(children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/product_placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                shipsOfficer.withOpacity(0.2),
                shipsOfficer.withOpacity(0.8)
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
            )
          ]),
        ),
        header: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
        ),
        footer: Consumer<Product>(
          builder: (ctx, product, child) => GridTileBar(
            leading: IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                product.toggleFavoriteValue(authData.token, authData.userId);
              },
            ),
            title: Text(''),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.green,
              ),
              onPressed: () {
                cart.addItem(
                    product.id, product.price, product.title, product.imageUrl);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Added item to cart',
                    textAlign: TextAlign.left,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
