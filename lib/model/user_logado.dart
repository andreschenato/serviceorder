import 'package:flutter/material.dart';

class UserLogado extends ChangeNotifier {
  String? _id;
  String? _nome;

  String? get id => _id;
  String? get nome => _nome;

  void userLogado(String idUsuario, String nomeUsuario) {
    _id = idUsuario;
    _nome = nomeUsuario;
    notifyListeners();
  }
}
