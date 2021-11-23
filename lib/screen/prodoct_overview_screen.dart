import 'package:flutter/material.dart';
import 'package:flutter_app/provideors/cart.dart';
import 'package:flutter_app/provideors/products.dart';
import 'package:flutter_app/screen/cart_screen.dart';
import 'package:flutter_app/widget/app_drawer.dart';
import 'package:flutter_app/widget/badge.dart';
import 'package:flutter_app/widget/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key key}) : super(key: key);

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var isloadding = false;
  var _showOnlyFavorite = false;
  var _isInit = false;

  @override
  void initState() {
    super.initState();
    isloadding = true;
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct()
        .then((_) => setState(() => isloadding = false))
        .catchError((error) =>isloadding = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorite'),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text(' Show All  '),
                value: FilterOption.All,
              ),
            ],
            onSelected: (FilterOption selectedVal) {
              setState(
                () {
                  if (selectedVal == FilterOption.Favorites) {
                    _showOnlyFavorite = true;
                  } else {
                    _showOnlyFavorite = false;
                  }
                },
              );
            },
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
               child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routName),
              ),
              builder: (_, cart, ch) =>
                  Badge(value: cart.itemCount.toString(), child: ch))
        ],
      ),
      body: isloadding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorite),
      drawer: AppDrawer(),
    );
  }
}
