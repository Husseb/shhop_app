import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/http_exptions.dart';
import 'package:flutter_app/provideors/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
  ];

  String authToken;
  String userId;

  getData(String authToken, String uId, List<Product> product) {
    this.authToken = authToken;
    this.userId = uId;
    this._items = product;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesItems {
    return _items.where((prodItem) => prodItem.isFavorit).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prodItem) => prodItem.isFavorit);
  }

  Future<void> fetchAndSetProduct({bool filterBYUser = false}) async {
    final flilterString =
        filterBYUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shop-flutter-6ea6e-default-rtdb.firebaseio.com/products.json?auth=$authToken&$flilterString';
    try {
      final res = await http.get(url);
      final extractData = json.decode(res.body) as Map<String, dynamic>;
      if (extractData == null) return;
      url =
          'https://shop-flutter-6ea6e-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favRes = await http.get(url);
      final favData = json.decode(favRes.body) as Map<String, dynamic>;

      final List<Product> loaderProdactes = [];
      extractData.forEach((prodId, prodData) {
        loaderProdactes.add(
          Product(
            id: prodId,
            title: prodData('title'),
            description: prodData('description'),
            imageUrl: prodData('imageUrl'),
            price: prodData('price'),
            isFavorit: favData == null ? false : favData[prodId] ?? false,
          ),
        );
      });
      _items = loaderProdactes;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-flutter-6ea6e-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final res = await http.post(url,
          body: json.encode({
            'creatorId': userId,
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        id: json.decode(res.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(Product newProduct, String id) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-flutter-6ea6e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('......');
    }
  }

  Future<void> deleteProduct(String id) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-flutter-6ea6e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      var product = _items[prodIndex];
      _items.removeAt(prodIndex);
      ;
      notifyListeners();
      final res = await http.delete(url);
      if (res.statusCode >= 400) {
        _items.insert(prodIndex, product);
        notifyListeners();
        throw HttpExptions('Coul not delete prodoct');
      } else {
        print('......');
      }
      product = null;
    }
  }
}
