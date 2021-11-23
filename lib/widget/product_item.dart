import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provideors/auth.dart';
import 'package:flutter_app/provideors/cart.dart';
import 'package:flutter_app/provideors/product.dart';
import 'package:flutter_app/screen/prodoct_detailes_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () =>
              Navigator.of(context)
                  .pushNamed(/*<String, String>{
                'id': product.id,
               },*/
                ProductDetailesScreen.routName, arguments: product.id),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              image: NetworkImage(product.imageUrl),
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added To Cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                    label: 'UNDO!',
                  ),
                ),
              );
            },
            icon: Icon(Icons.shopping_cart),
            color: Theme
                .of(context)
                .colorScheme
                .secondary,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, _) =>
                IconButton(
                  onPressed: () {
                    product.toggeleFavvoritState(
                        authData.token, authData.userId);
                  },
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  icon: Icon(
                      product.isFavorit ? Icons.favorite : Icons
                          .favorite_border),
                ),
          ),
        ),
      ),
    );
  }
}
