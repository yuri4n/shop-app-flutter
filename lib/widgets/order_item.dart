import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  AnimationController _controller;
  Animation<double> _dropAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                '\$${widget.order.amount}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 120, 200)
                  : 0,
              curve: Curves.fastOutSlowIn,
              child: Container(
                padding: EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: widget.order.products.length,
                  itemBuilder: (ctx, i) {
                    return Card(
                      color: Theme.of(context).canvasColor,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              widget.order.products[i].title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${widget.order.products[i].price}x${widget.order.products[i].quantity}',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
