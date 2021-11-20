import 'package:flutter/material.dart';
import 'package:flutter_app/provideors/products.dart';
import 'package:flutter_app/widget/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  bool showFav;

  ProductsGrid(this.showFav);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products =showFav?productData.favoritesItems:productData.items;
    return GridView.builder(
      itemCount: products.length,
      itemBuilder: (BuildContext context, int i) => ChangeNotifierProvider .value(value: products[i],child: ProductItem(),),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,childAspectRatio: 3/2, crossAxisSpacing: 10,mainAxisExtent: 10,
      ),
    );
  }
}
