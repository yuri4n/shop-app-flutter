import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String title;

  ProductDetailScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Center(
        child: Text('Screen'),
      ),
    );
  }
}
