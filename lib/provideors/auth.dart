import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/http_exptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;

  DateTime _expireDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String get userId => _userId;

  Future<void> _authencation(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDR8r9LnGKjJJjccqReE_xm9TDZuhhOwqs';
    try {
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(res.body);
      if (responseData['error'] != null) {
         throw HttpExptions(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      aotoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      String userData = json.encode({
        'token': _token,
        'userId': userId,
        'expiryDate': _expireDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authencation(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authencation(email, password, 'signInWithPassword');
  }

  Future<bool> tryAotoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('userData')) return false;
    final Map<String, Object> extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (_expireDate.isBefore(DateTime.now())) return false;

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expireDate = expiryDate;
    notifyListeners();
    aotoLogOut();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> aotoLogOut() async {
    if (_authTimer != null) {
      _authTimer.cancel();
     }
    final timeToExpiry = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer= Timer(Duration(seconds: timeToExpiry), logout);
  }
}
