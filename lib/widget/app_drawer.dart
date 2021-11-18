import 'package:flutter/material.dart';
import 'package:flutter_app/provideors/auth.dart';
import 'package:flutter_app/screen/order_screen.dart';
import 'package:flutter_app/screen/user_products_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Hello Friend!'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders '),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Mange Product'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(' LogOut'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context , listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
