import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/controller/historico_controller.dart';
import 'package:serviceorder/model/historico.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/widgets/app_drawer.dart';
import 'package:serviceorder/widgets/custom_app_bar.dart';

class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});

  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  Future<List<Historico>>? historico;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(txt: 'Histórico'),
      drawer: AppDrawer.appDrawer(context: context, tela: 'Historico'),
      body: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Consumer<UserLogado>(
            builder: (context, user, _) {
              if (user.id != null) {
                historico = carregarHistorico(user.id!);
              }
              else {
                historico = null;
              }
              return FutureBuilder(
                future: historico,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erro ao carregar históricos'));
                  } else if (snapshot.data != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: buildHistoricos(snapshot.data!),
                    );
                  } else {
                    return const Center(child: Text('Não há históricos'));
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}