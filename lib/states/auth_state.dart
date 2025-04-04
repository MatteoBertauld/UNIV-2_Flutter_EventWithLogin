import 'dart:convert';
import 'dart:io';

import 'package:event_poll/configs.dart';
import 'package:event_poll/models/user.dart';
import 'package:event_poll/result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthState extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  String? _token;
  String? get token => _token;

  Future<Result<User, String>> logIn(String username, String password) async {
    String? error;

    final loginResponse = await http.post(
      Uri.parse('${Configs.baseUrl}/auth/login'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (loginResponse.statusCode == HttpStatus.ok) {
      _token = json.decode(loginResponse.body)['token'];

      final userResponse = await http.get(
        Uri.parse('${Configs.baseUrl}/users/me'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (userResponse.statusCode == HttpStatus.ok) {
        _currentUser = User.fromJson(json.decode(userResponse.body));
        notifyListeners();
        return Result.success(_currentUser!);
      }

      error = 'Une erreur est survenue';
    } else {
      switch (loginResponse.statusCode) {
        case HttpStatus.badRequest || HttpStatus.unauthorized:
          error = 'Identifiant ou mot de passe incorrect';
          break;
        default:
          error = 'Une erreur est survenue';
          break;
      }
    }

    logOut();
    return Result.failure(error);
  }

  Future<bool> signup(String username, String password) async {
    String? error;

    final signupResponse = await http.post(
      Uri.parse('${Configs.baseUrl}/auth/signup'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (signupResponse.statusCode == HttpStatus.conflict) {
      error = "Nom d'utilisateur déjà pris. Veuillez en choisir un autre.";
    }

    if (signupResponse.statusCode == HttpStatus.created) {
      return true;
    }
    return false;
  }

  void logOut() async {
    _currentUser = null;
    _token = null;
    notifyListeners();
    return;
  }
}
