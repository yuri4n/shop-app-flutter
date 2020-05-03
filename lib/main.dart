import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/products.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/auth.dart';

// import 'helpers/custom_route.dart';

import 'colors/ships_officer.dart';
import 'colors/rich_gardenia.dart';

import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/loading_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders(null, null, []),
            update: (ctx, auth, previousOrder) =>
                Orders(auth.token, auth.userId, previousOrder.orders)),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, null, []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, child) => MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: richGardenia,
            fontFamily: 'Source Sans Pro',
            canvasColor: shipsOfficer,
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
            // pageTransitionsTheme: PageTransitionsTheme(
            //   builders: {
            //     TargetPlatform.android: CustomPageTransitionBuilder(),
            //     TargetPlatform.iOS: CustomPageTransitionBuilder(),
            //   },
            // ),
          ),
          home: authData.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? LoadingScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
