import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/controller/ordem_controller.dart';
import 'package:serviceorder/model/ordens.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/widgets/add_button.dart';
import 'package:serviceorder/widgets/app_drawer.dart';
import 'package:serviceorder/widgets/custom_app_bar.dart';

class TelaOrdens extends StatefulWidget {
  const TelaOrdens({super.key});

  @override
  State<TelaOrdens> createState() => _TelaOrdensState();
}

class _TelaOrdensState extends State<TelaOrdens> {
  Future<List<Ordens>>? ordens;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(txt: 'Ordens de Serviço'),
      drawer: AppDrawer.appDrawer(context: context, tela: 'Ordens'),
      body: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Consumer<UserLogado>(
            builder: (context, user, _) {
              if (user.id != null) {
                ordens = carregarOrdens(user.id!);
              } else {
                ordens = null;
              }
              return FutureBuilder(
                future: ordens,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(
                      child: Text('Erro ao carregar ordens'),
                    );
                  } else if (snapshot.data != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: buildOrdens(snapshot.data!),
                    );
                  } else {
                    return const Center(
                      child: Text('Não há ordens'),
                    );
                  }
                },
              );
            },
          ), 
          Padding(
            padding: const EdgeInsets.all(25),
            child: AddButton.botao(
              action: () {
                Navigator.pushNamed(context, Rotas.cadastroOrdens);
              },
            ),
          ),
        ],
      ),
    );
  }
}
