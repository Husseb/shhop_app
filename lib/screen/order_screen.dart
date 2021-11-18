 import 'package:flutter/material.dart';
import 'package:flutter_app/widget/app_drawer.dart';
class OrderScreen extends StatelessWidget {
  const OrderScreen({Key  key}) : super(key: key);
  static const routName='/order-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('shop'),),
      body: Center(child: Text('shop'),),
      drawer: AppDrawer(),
    );   }
}
