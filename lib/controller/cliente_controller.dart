import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:serviceorder/database/db_config.dart';
import 'package:serviceorder/model/cliente.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/view/tela_editar_cliente.dart';

Future getClientes(String idUser) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  var clientes = await conn.execute("SELECT * FROM Cliente");
  var clienteList = clientes.rows.map((row) => row.assoc()).toList();
  await conn.close();
  return jsonEncode(clienteList);
}

Future criaCliente(Cliente cliente, String idUsuario) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  await conn.execute("CALL Pc_CriaCliente("
      "'$idUsuario', '${cliente.nome}', "
      "'${cliente.telefonePrincipal}', '${cliente.telefoneSecundario}', '${cliente.email}', "
      "'${cliente.endereco}', '${cliente.numEndereco}', '${cliente.bairro}', '${cliente.complemento}');");
  await conn.close();
  return true;
}

Future atualizaCliente(Cliente cliente) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  await conn.execute("CALL Pc_AtualizaCliente("
      "'${cliente.id}', '${cliente.nome}', "
      "'${cliente.telefonePrincipal}', '${cliente.telefoneSecundario}', '${cliente.email}', "
      "'${cliente.endereco}', '${cliente.numEndereco}', '${cliente.bairro}', '${cliente.complemento}');");
  await conn.close();
  return true;
}

Future<Cliente> getDadosCliente(int idCliente) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  var cliente =
      await conn.execute("SELECT * FROM Cliente WHERE idCliente = $idCliente;");
  var clienteData = jsonEncode(cliente.rows.map((row) => row.assoc()).toList());
  List<dynamic> result = jsonDecode(clienteData);
  Cliente cli = result.map((e) => Cliente.fromJson(e)).single;
  return cli;
}

Future deleteCliente(int id) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  await conn.execute("DELETE FROM Cliente WHERE idCliente = $id;");
  await conn.close();
}

Future<List<Cliente>> carregarClientes(String idUser) async {
  var result = await getClientes(idUser);
  List<dynamic> clientes = jsonDecode(result);
  return clientes.map((e) => Cliente.fromJson(e)).toList();
}

Widget buildClientes(List<Cliente> clientes) {
  return ListView.builder(
    itemCount: clientes.length,
    itemBuilder: (context, index) {
      final cliente = clientes[index];
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
                              TelaEditarCliente(idCliente: cliente.id!),
                        ),
                      );
                    },
                    icon: Icons.edit_rounded,
                  ),
                  SlidableAction(
                    backgroundColor: const Color.fromARGB(255, 243, 2, 45),
                    foregroundColor: Colors.white,
                    onPressed: (context) {
                      deleteCliente(cliente.id!).then((_) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Rotas.clientes, (Route<dynamic> route) => false);
                      });
                    },
                    icon: Icons.delete_rounded,
                  ),
                ],
              ),
              child: ListTile(
                tileColor: const Color.fromARGB(255, 219, 226, 240),
                title: Text(
                  cliente.nome!,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(cliente.telefonePrincipal!),
              ),
            )
          ],
        ),
      );
    },
  );
}
