import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/controller/usuario_controller.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/widgets/drawer_button.dart';

class AppDrawer {
  static Drawer appDrawer({
    required BuildContext context,
    String? tela,
  }) {
    return Drawer(
      surfaceTintColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            color: const Color.fromARGB(255, 59, 40, 204),
            child: Center(
              child: Consumer<UserLogado>(
                builder: (context, user, child) => Text(
                  user.nome!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 24),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                CustomButton.botao(
                  selectedItem: tela == 'Ordens',
                  icon: Icons.article_rounded,
                  txt: "Ordens de serviço",
                  action: () {
                    Navigator.pushNamed(context, Rotas.ordens);
                  },
                ),
                CustomButton.botao(
                  selectedItem: tela == 'Clientes',
                  icon: Icons.groups_rounded,
                  txt: "Clientes",
                  action: () {
                    Navigator.pushNamed(context, Rotas.clientes);
                  },
                ),
                CustomButton.botao(
                  selectedItem: tela == 'Servicos',
                  icon: Icons.handyman_rounded,
                  txt: "Serviços",
                  action: () {
                    Navigator.pushNamed(context, Rotas.servicos);
                  },
                ),
                CustomButton.botao(
                  selectedItem: tela == 'Historico',
                  icon: Icons.history_rounded,
                  txt: "Histórico",
                  action: () {},
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomButton.botao(
              icon: Icons.exit_to_app_rounded,
              txt: "Sair",
              action: () {
                fazLogout().then((_) => {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Rotas.login, (Route<dynamic> route) => false)
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
