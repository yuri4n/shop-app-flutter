import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

const String key = 'AIzaSyCM-HIO9g0_jO6XlreQWAnYiMuSDkYO-D4';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  String get userId {
    return this._userId;
  }

  Future<void> signUp(String email, String password) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$key';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> logIn(String email, String password) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$key';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      _autoLogout();

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': this._token,
        'userId': this._userId,
        'expiryDate': this._expiryDate.toIso8601String(),
      });

      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    this._token = null;
    this._userId = null;
    this._expiryDate = null;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    // prefs.clear()
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = this._expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), this.logout);
  }
}
