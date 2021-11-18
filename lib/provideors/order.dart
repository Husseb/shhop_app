import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/provideors/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  String authToken;
  String userId;

  getData(String authToken, String uId, List<OrderItem> orders) {
    this.authToken = authToken;
    this.userId = uId;
    this._orders = orders;
    notifyListeners();
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shop-flutter-6ea6e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final res = await http.get(url);
      final extractData = json.decode(res.body) as Map<String, dynamic>;
      if (extractData == null) return;

      final List<OrderItem> loaderOrder = [];
      extractData.forEach((orderId, orderDate) {
        loaderOrder.add(
          OrderItem(
            id: orderId,
            amount: orderDate('amount'),
            dateTime: DateTime.parse(orderDate('dateTime')),
            products: (orderDate('products') as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      price: item['price'],
                      quintity: item['quintity'],
                    ))
                .toList(),
          ),
        );
      });
      _orders = loaderOrder.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://shop-flutter-6ea6e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    try {
      final timeStamb = DateTime.now();
      final res = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamb.toIso8601String(),
            'products': cartProduct
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quintity': cp.quintity,
                      'price': cp.price,
                    })
                .toList(),
          }));

      _orders.insert(
        0,
        OrderItem(
            id: json.decode(res.body)['name'],
             amount: total,
            products: cartProduct,
            dateTime: timeStamb),
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
