import 'dart:convert';

import 'package:serviceorder/database/db_config.dart';
import 'package:serviceorder/model/servicos_ordens.dart';

Future getServicosOrdem(int idOrdem) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  var servicos = await conn
      .execute("SELECT * FROM Vw_ServicosPorOrdem WHERE idOrdem = $idOrdem;");
  var servicoList = servicos.rows.map((row) => row.assoc()).toList();
  await conn.close();
  return jsonEncode(servicoList);
}

Future<List<ServicosOrdens>> carregarServicosOrdens(int idOrdem) async {
  var result = await getServicosOrdem(idOrdem);
  List<dynamic> ordens = jsonDecode(result);
  return ordens.map((e) => ServicosOrdens.fromJson(e)).toList();
}

Future deleteServicoOrdem(int idServicosOrdens) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  await conn.execute("DELETE FROM ServicosOrdem WHERE idServicosOrdem = $idServicosOrdens;");
  await conn.close();
}

Future adicionarServicoOrdem(int idSO, int idOrdem) async {
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  await conn.execute("CALL sp_AdicionarServicoOrdem("
      "'$idOrdem', '$idSO');");
  await conn.close();
  return true;
}
