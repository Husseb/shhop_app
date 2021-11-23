import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provideors/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id, title, productId;
  final int quintity;
  final double price;

  CartItem(this.id, this.title, this.productId, this.quintity, this.price);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(20.0),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('Are You sure!'),
                    content: Text('Do You want to remove item from  the cart?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text('No')),
                      TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: Text('Yes'))
                    ],
                  ));
        },
        onDismissed: (direction){
          Provider.of<Cart>(context,listen: false) .removeItem(productId);
        },
        key: ValueKey(id),
        child: Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(
                      child: Text('\$$price'),
                    ),
                  ),
                ),
                title: Text(title),
                subtitle: Text('Total \$${price * quintity}'),
                trailing: Text('$quintity x'),
              ),
            )));
  }
}
