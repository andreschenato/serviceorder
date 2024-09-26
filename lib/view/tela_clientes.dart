import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/controller/cliente_controller.dart';
import 'package:serviceorder/model/cliente.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/widgets/add_button.dart';
import 'package:serviceorder/widgets/app_drawer.dart';
import 'package:serviceorder/widgets/custom_app_bar.dart';

class TelaClientes extends StatefulWidget {
  const TelaClientes({super.key});

  @override
  State<TelaClientes> createState() => _TelaClientesState();
}

class _TelaClientesState extends State<TelaClientes> {
  Future<List<Cliente>>? clientes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(txt: 'Clientes'),
      drawer: AppDrawer.appDrawer(context: context, tela: 'Clientes'),
      body: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Consumer<UserLogado>(
            builder: (context, user, _) {
              if (user.id != null) {
                clientes = carregarClientes(user.id!);
              }
              else {
                clientes = null;
              }
              return FutureBuilder(
                future: clientes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erro ao carregar clientes'));
                  } else if (snapshot.data != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: buildClientes(snapshot.data!),
                    );
                  } else {
                    return const Center(child: Text('Não há clientes'));
                  }
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: AddButton.botao(
              action: () {
                Navigator.pushNamed(context, Rotas.cadastroClientes);
              },
            ),
          ),
        ],
      ),
    );
  }
}
