import 'package:flutter/material.dart';

class CartItem {
  final String id, title;
  final int quintity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quintity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quintity;
    });
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existCartItem) => CartItem(
            id: existCartItem.id,
            title: existCartItem.title,
            quintity: existCartItem.quintity + 1,
            price: existCartItem.price),
      );
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quintity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quintity > 1) {
      _items.update(
        productId,
        (existCartItem) => CartItem(
            id: existCartItem.id,
            title: existCartItem.title,
            quintity: existCartItem.quintity - 1,
            price: existCartItem.price),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
