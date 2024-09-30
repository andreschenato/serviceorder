import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serviceorder/database/db_config.dart';
import 'package:serviceorder/model/historico.dart';

Future getHistoricos(String idUser) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  var historico = await conn
      .execute("SELECT * FROM vw_historicoordens WHERE idUsuarioFK = $idUser;");
  var historicoList = historico.rows.map((row) => row.assoc()).toList();
  await conn.close();
  return jsonEncode(historicoList);
}

Future<List<Historico>> carregarHistorico(String idUser) async {
  var result = await getHistoricos(idUser);
  List<dynamic> historicos = jsonDecode(result);
  return historicos.map((e) => Historico.fromJson(e)).toList();
}

Widget buildHistoricos(List<Historico> historicos) {
  if (historicos.isEmpty) {
    return const Center(
      child: Text('Não há histórico'),
    );
  }
  return ListView.builder(
    itemCount: historicos.length,
    itemBuilder: (context, index) {
      final historico = historicos[index];
      return Card.filled(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          tileColor: const Color.fromARGB(255, 219, 226, 240),
          leading: Text(
            historico.idOrdens.toString(),
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
          title: Text('${historico.statusAnterior} => ${historico.statusNovo}',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Text('${historico.dataModificacao}'),
        ),
      );
    },
  );
}
