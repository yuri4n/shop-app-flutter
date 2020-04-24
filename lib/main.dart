import 'package:flutter/material.dart';

import 'colors/ships_officer.dart';
import 'colors/rich_gardenia.dart';

import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: ThemeData(
          primarySwatch: richGardenia,
          fontFamily: 'Source Sans Pro',
          canvasColor: shipsOfficer,
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.white))),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
      },
    );
  }
}
