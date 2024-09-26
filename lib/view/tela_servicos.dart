import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/controller/servico_controller.dart';
import 'package:serviceorder/model/servico.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/widgets/add_button.dart';
import 'package:serviceorder/widgets/app_drawer.dart';
import 'package:serviceorder/widgets/custom_app_bar.dart';

class TelaServicos extends StatefulWidget {
  const TelaServicos({super.key});

  @override
  State<TelaServicos> createState() => _TelaServicosState();
}

class _TelaServicosState extends State<TelaServicos> {
  Future<List<Servico>>? servicos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(txt: 'Serviços'),
      drawer: AppDrawer.appDrawer(context: context, tela: 'Serviços'),
      body: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Consumer<UserLogado>(
            builder: (context, user, _) {
              if (user.id != null) {
                servicos = carregarServicos(user.id!);
              }
              else {
                servicos = null;
              }
              return FutureBuilder(
                future: servicos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(
                        child: Text('Erro ao carregar serviços'));
                  } else if (snapshot.data != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: buildServicos(snapshot.data!),
                    );
                  } else {
                    return const Center(child: Text('Não há serviços'));
                  }
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: AddButton.botao(
              action: () {
                Navigator.pushNamed(context, Rotas.cadastroServicos);
              },
            ),
          ),
        ],
      ),
    );
  }
}