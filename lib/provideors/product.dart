import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id, title, description, imageUrl;
  final double price;
  bool isFavorit;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorit = false});

  void _setFavValue(bool newValue) {
    isFavorit = newValue;
    notifyListeners();
  }

  Future<void> toggeleFavvoritState(String token, String userId) async {
    final oldstaties = isFavorit;
    isFavorit = !isFavorit;
    notifyListeners();
    final url =       'https://shop-flutter-6ea6e-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';

    try {
      final res = await http.put(url, body: json.encode(isFavorit));
      if (res.statusCode >= 400) {
        _setFavValue(oldstaties);
      }
    } catch (e) {
      _setFavValue(oldstaties);
    }
  }

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        price = json['price'],
        isFavorit = json['isFavorit'];

  Map<String, dynamic> toJson( ) => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'price': price,
        'isFavorit': isFavorit,
      };
}
