import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provideors/products.dart';
import 'package:provider/provider.dart';

class ProductDetailesScreen extends StatelessWidget {
  const ProductDetailesScreen({Key key}) : super(key: key);
  static const routName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    final loadeProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Product Detail Screen'),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadeProduct.title),
              background: Hero(
                tag: loadeProduct.id,
                child: Image.network(
                  loadeProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  '\$${loadeProduct.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),                SizedBox(
                height: 10,
              ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadeProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
