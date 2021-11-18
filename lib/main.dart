import 'package:flutter/material.dart';
import 'package:flutter_app/provideors/auth.dart';
import 'package:flutter_app/provideors/cart.dart';
import 'package:flutter_app/provideors/order.dart';
import 'package:flutter_app/provideors/product.dart';
import 'package:flutter_app/provideors/products.dart';
import 'package:flutter_app/screen/auth_screen.dart';
import 'package:flutter_app/screen/cart_screen.dart';
import 'package:flutter_app/screen/edit_product_screen.dart';
import 'package:flutter_app/screen/order_screen.dart';
import 'package:flutter_app/screen/splash_screen.dart';
import 'package:flutter_app/screen/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'screen/prodoct_overview_screen.dart';
import 'screen/prodoct_detailes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),

        ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(),
            update: (context, authvalue, previousProduct) => previousProduct
              ..getData(authvalue.token, authvalue.userId,
                  previousProduct == null ? null : previousProduct.items)),

        ChangeNotifierProxyProvider<Auth, Order>(
            create: (_) => Order(),
            update: (context, authvalue, previousOrders) => previousOrders
              ..getData(authvalue.token, authvalue.userId,
                  previousOrders == null ? null : previousOrders.orders)),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: 'Lato',
            textTheme: TextTheme(
              headline6: TextStyle(color: Colors.white),
            ),
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAotoLogin(),
                  builder: ((BuildContext context,
                          AsyncSnapshot authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
                ),
          routes: {
            ProductDetailesScreen.routName: (_) => ProductDetailesScreen(),
            CartScreen.routName: (_) => CartScreen(),
            OrderScreen.routName: (_) => OrderScreen(),
            UserProductScreen.routName: (_) => UserProductScreen(),
            EditProductScreen.routName: (_) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('shop'),
      ),
      body: Center(
        child: Text('shop'),
      ),
    );
  }
}
