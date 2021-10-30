import 'package:flutter/material.dart';
import 'classes.dart';

class OrderPage extends StatefulWidget {
  final Order order;
  const OrderPage(this.order, {Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState(order);
}

class _OrderPageState extends State<OrderPage> {
  final Order order;
  _OrderPageState(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => Navigator.pop(context),
        child: (const Icon(Icons.arrow_back_ios)),
      ),
      body: ListView(
        children: [
          Text(order.title),
          Text(order.description),
        ],
      ),
    );
  }
}
