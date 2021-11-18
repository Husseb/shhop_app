import 'package:flutter/material.dart';
import 'package:flutter_app/widget/app_drawer.dart';
class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key  key}) : super(key: key);

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('shop'),),
      body: Center(child: Text('shop'),),
      drawer: AppDrawer(),
    );  }
}
