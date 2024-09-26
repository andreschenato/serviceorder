import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:serviceorder/database/db_config.dart';
import 'package:serviceorder/model/servico.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/view/tela_editar_servico.dart';

Future getServicos(String idUser) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  var servicos =
      await conn.execute("SELECT * FROM Servico WHERE idUsuarioFK = $idUser;");
  var servicoList = servicos.rows.map((row) => row.assoc()).toList();
  await conn.close();
  return jsonEncode(servicoList);
}

Future<List<Servico>> carregarServicos(String idUser) async {
  var result = await getServicos(idUser);
  List<dynamic> servicos = jsonDecode(result);
  return servicos.map((e) => Servico.fromJson(e)).toList();
}

Future deleteServico(int id) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  await conn.execute("DELETE FROM Servico WHERE idServico = $id;");
  await conn.close();
}

Future<Servico> getDadosServico(int idServico) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  var servico =
      await conn.execute("SELECT * FROM Servico WHERE idServico = $idServico;");
  var servicoData = jsonEncode(servico.rows.map((row) => row.assoc()).toList());
  List<dynamic> result = jsonDecode(servicoData);
  Servico svc = result.map((e) => Servico.fromJson(e)).single;
  return svc;
}

Future criaServico(Servico servico, String idUsuario) async {
   var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  await conn.execute("CALL Pc_CriaServico("
      "'$idUsuario', '${servico.nomeServico}', '${servico.descricao}', '${servico.preco}');");
  await conn.close();
  return true;
}

Future atualizaServico(Servico servico) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  await conn.execute("CALL Pc_AtualizaServico("
      "'${servico.idServico}', '${servico.nomeServico}', '${servico.descricao}', '${servico.preco}');");
  await conn.close();
  return true;
}

Widget buildServicos(List<Servico> servicos) {
  if (servicos.isEmpty) {
    return const Center(
      child: Text('Não há serviços'),
    );
  }
  return ListView.builder(
    itemCount: servicos.length,
    itemBuilder: (context, index) {
      final servico = servicos[index];
      return Card.filled(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slidable(
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: const Color.fromARGB(255, 34, 182, 1),
                    foregroundColor: Colors.white,
                    onPressed: (context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TelaEditarServico(idServico: servico.idServico!),
                        ),
                      );
                    },
                    icon: Icons.edit_rounded,
                  ),
                  SlidableAction(
                    backgroundColor: const Color.fromARGB(255, 243, 2, 45),
                    foregroundColor: Colors.white,
                    onPressed: (context) {
                      deleteServico(servico.idServico!).then((_) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Rotas.servicos, (Route<dynamic> route) => false);
                      });
                    },
                    icon: Icons.delete_rounded,
                  ),
                ],
              ),
              child: ListTile(
                tileColor: const Color.fromARGB(255, 219, 226, 240),
                title: Text(
                  servico.nomeServico!,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text('R\$ ${servico.preco!.toString()}'),
              ),
            )
          ],
        ),
      );
  });
}
