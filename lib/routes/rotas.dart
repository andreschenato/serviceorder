import 'package:flutter/material.dart';
import 'package:serviceorder/view/tela_cadastro.dart';
import 'package:serviceorder/view/tela_clientes.dart';
import 'package:serviceorder/view/tela_cria_cliente.dart';
import 'package:serviceorder/view/tela_login.dart';

class Rotas {
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String clientes = '/cliente';
  static const String cadastroClientes = '/cadastroCliente';
}

var rotas = <String, WidgetBuilder> {
  Rotas.login: (ctx) => const TelaLogin(),
  Rotas.cadastro: (ctx) => const TelaCadastro(),
  Rotas.clientes: (ctx) => const TelaClientes(),
  Rotas.cadastroClientes: (ctx) => const TelaCriaCliente(),
};