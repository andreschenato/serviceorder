import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:serviceorder/database/db_config.dart';
import 'package:serviceorder/model/ordens.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:intl/intl.dart';
import 'package:serviceorder/view/tela_editar_ordem.dart';

Future getOrdens(String idUser) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  var ordens = await conn
      .execute("SELECT * FROM Vw_OrdensClientes WHERE idUsuario = $idUser;");
  var ordensList = ordens.rows.map((row) => row.assoc()).toList();
  await conn.close();
  return jsonEncode(ordensList);
}

Future<List<Ordens>> carregarOrdens(String idUser) async {
  var result = await getOrdens(idUser);
  List<dynamic> ordens = jsonDecode(result);
  return ordens.map((e) => Ordens.fromJsonView(e)).toList();
}

Future deleteOrdem(int idOrdem) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  await conn.execute("DELETE FROM Ordens WHERE idOrdens = $idOrdem;");
  await conn.close();
}

Future criaOrdem(Ordens ordem, String idUser, int idCliente) async {
  try {
    var conn = await MySqlDBConfiguration().connection;
    await conn.connect();
    await conn.execute(
        "CALL Pc_CriaOrdem('$idUser', '$idCliente', '${ordem.descricao}');");
    await conn.close();
    return true;
  } catch (err) {
    return err;
  }
}

Future<Ordens> getDadosOrdem(int idOrdem) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  var ordem =
      await conn.execute("SELECT * FROM Ordens WHERE idOrdens = $idOrdem;");
  var ordemData = jsonEncode(ordem.rows.map((row) => row.assoc()).toList());
  await conn.close();
  List<dynamic> result = jsonDecode(ordemData);
  Ordens ord = result.map((e) => Ordens.fromJson(e)).single;
  return ord;
}

Future atualizaOrdem(Ordens ordem) async {
  try {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  await conn.execute("CALL Pc_AtualizaOrdem("
      "'${ordem.id}', '${ordem.clienteId}', '${ordem.descricao}', '${ordem.laudo}', '${ordem.status}', '${ordem.diaFinalizado}');");
  await conn.close();
  return true;
  }catch (err) {
    print(err);
    return false;
  }
}

Widget buildOrdens(List<Ordens> ordens) {
  var t = DateFormat("dd/MM/yyyy - HH:mm");
  if (ordens.isEmpty) {
    return const Center(
      child: Text('Não há ordens'),
    );
  }
  return ListView.builder(
    itemCount: ordens.length,
    itemBuilder: (context, index) {
      final ordem = ordens[index];
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
                              TelaEditarOrdem(idOrdem: ordem.id!),
                        ),
                      );
                    },
                    icon: Icons.edit_rounded,
                  ),
                  SlidableAction(
                    backgroundColor: const Color.fromARGB(255, 243, 2, 45),
                    foregroundColor: Colors.white,
                    onPressed: (context) {
                      deleteOrdem(ordem.id!).then((_) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Rotas.ordens, (Route<dynamic> route) => false);
                      });
                    },
                    icon: Icons.delete_rounded,
                  ),
                ],
              ),
              child: ListTile(
                tileColor: const Color.fromARGB(255, 219, 226, 240),
                leading: Text(ordem.id!.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                title: Text(
                  ordem.nomeCliente!.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(t.format(ordem.diaCriado!.toLocal()).toString()),
              ),
            )
          ],
        ),
      );
    },
  );
}
