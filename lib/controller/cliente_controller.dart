import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serviceorder/database/db_config.dart';
import 'package:serviceorder/model/cliente.dart';

Future getClientes() async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  var clientes = await conn.execute("SELECT * FROM Cliente");
  var clienteList = clientes.rows.map((row) => row.assoc()).toList();
  return jsonEncode(clienteList);
}

Future<List<Cliente>> carregarClientes() async {
  var result = await getClientes();
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
            ListTile(
              
              tileColor: const Color.fromARGB(255, 219, 226, 240),
              title: Text(cliente.nome!),
              subtitle: Text(cliente.telefonePrincipal!),
            )
            
          ],
        ),
      );
    },
  );
}
