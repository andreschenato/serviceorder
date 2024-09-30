import 'package:flutter/material.dart';
import 'package:serviceorder/view/tela_cadastro.dart';
import 'package:serviceorder/view/tela_clientes.dart';
import 'package:serviceorder/view/tela_cria_cliente.dart';
import 'package:serviceorder/view/tela_cria_ordem.dart';
import 'package:serviceorder/view/tela_cria_servico.dart';
import 'package:serviceorder/view/tela_historico.dart';
import 'package:serviceorder/view/tela_login.dart';
import 'package:serviceorder/view/tela_ordens.dart';
import 'package:serviceorder/view/tela_servicos.dart';

class Rotas {
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String clientes = '/cliente';
  static const String cadastroClientes = '/cadastroCliente';
  static const String servicos = '/servicos';
  static const String cadastroServicos = '/cadastroServico';
  static const String ordens = '/ordens';
  static const String cadastroOrdens = '/cadastroOrdens';
  static const String historico = '/historico';
}

var rotas = <String, WidgetBuilder> {
  Rotas.login: (ctx) => const TelaLogin(),
  Rotas.cadastro: (ctx) => const TelaCadastro(),
  Rotas.clientes: (ctx) => const TelaClientes(),
  Rotas.cadastroClientes: (ctx) => const TelaCriaCliente(),
  Rotas.servicos: (ctx) => const TelaServicos(),
  Rotas.cadastroServicos: (ctx) => const TelaCriaServico(),
  Rotas.ordens: (ctx) => const TelaOrdens(),
  Rotas.cadastroOrdens: (ctx) => const TelaCriaOrdem(),
  Rotas.historico: (ctx) => const TelaHistorico(),
};