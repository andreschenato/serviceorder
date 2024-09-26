import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/database/db_config.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/model/usuario.dart';

const FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true));

Future<void> storeLogin(Usuario user) async {
  await storage.write(key: 'userName', value: user.nome);
  await storage.write(key: 'email', value: user.email);
  await storage.write(key: 'senha', value: user.senha);
}

Future<void> fazLogout() async {
  await storage.delete(key: 'userName');
  await storage.delete(key: 'email');
  await storage.delete(key: 'senha');
}

Future criaUser(Usuario user, bool keepLogin) async {
  try {
    var conn = await MySqlDBConfiguration().connection;
    await conn.connect();
    var senhaBytes = utf8.encode(user.senha as String);
    var senhaHash = sha256.convert(senhaBytes);
    await conn
        .execute(
            "CALL Pc_CriaUser('${user.nome}', '${user.email}', '$senhaHash');")
        .then((_) => {
              fazLogin(user, keepLogin),
            });
    await conn.close();
    return true;
  } catch (err) {
    return err;
  }
}

Future fazLogin(Usuario user, bool keepLogin) async {
  try {
    var conn = await MySqlDBConfiguration().connection;
    await conn.connect();
    var senhaBytes = utf8.encode(user.senha as String);
    var senhaHash = sha256.convert(senhaBytes);
    bool isValid = false;
    var val = await conn
        .execute("SELECT fc_ValidaLogin('${user.email}', '$senhaHash');");
    if (val.rows.first.assoc().values.first == '1') {
      isValid = true;
    } else {
      isValid = false;
    }
    await conn.close();
    if (isValid == true && keepLogin == true) {
      storeLogin(user);
      return true;
    } else if (isValid == true && keepLogin == false) {
      return true;
    } else {
      return false;
    }
  } catch (err) {
    String errMsg = 'Erro ao fazer login!';
    return errMsg;
  }
}

Future notifyLogin(BuildContext context, Usuario user) async {
  UserLogado login = Provider.of<UserLogado>(context, listen: false);
  var conn = await MySqlDBConfiguration().connection;
  await conn.connect();
  var val = await conn
      .execute("SELECT * FROM Usuario WHERE emailUsuario = '${user.email}';");
  var userLocal = val.rows.map((row) => row.assoc()).toList();
  var userName = userLocal.first['nomeUsuario'];
  var userId = userLocal.first['idUsuario'];
  await conn.close();
  login.userLogado(userId!, userName!);
}

Future<bool> tentaLoginAutomatico() async {
  String? email = await storage.read(key: 'email');
  String? senha = await storage.read(key: 'senha');
  if (email != null && senha != null) {
    Usuario user = Usuario(email: email, senha: senha);
    bool isLoggedIn = await fazLogin(user, true);
    if (isLoggedIn) {
      return isLoggedIn;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
