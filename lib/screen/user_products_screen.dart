import 'package:flutter/material.dart';
import 'package:flutter_app/provideors/products.dart';
import 'package:flutter_app/screen/edit_product_screen.dart';
import 'package:flutter_app/widget/app_drawer.dart';
import 'package:flutter_app/widget/use_product_item.dart';
import 'dart:core';

import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key key}) : super(key: key);
  static const routName = '/user-product-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(filterBYUser: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.pushNamed(context, EditProductScreen.routName),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        initialData: _refreshProducts(context),
        builder: (ctx, AsyncSnapshot<dynamic> snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, prodctData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: prodctData.items.length,
                          itemBuilder: (_, index) => Column(
                            children: [
                              UserProductItem(prodctData.items[index].id,prodctData.items[index].title,prodctData.items[index].imageUrl,),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    )),
      ),
    );
  }
}
