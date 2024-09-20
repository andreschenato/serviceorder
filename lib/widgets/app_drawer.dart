import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/widgets/drawer_button.dart';

class AppDrawer {
  static Drawer appDrawer() {
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
                Row(
                  children: [
                    CustomButton.botao(
                      icon: Icons.article_rounded,
                      txt: "Ordens de serviço",
                      action: () {},
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomButton.botao(
                      icon: Icons.groups_rounded,
                      txt: "Clientes",
                      action: () {},
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomButton.botao(
                      icon: Icons.handyman_rounded,
                      txt: "Serviços",
                      action: () {},
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomButton.botao(
                      icon: Icons.history_rounded,
                      txt: "Histórico",
                      action: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomButton.botao(
                  icon: Icons.exit_to_app_rounded,
                  txt: "Sair",
                  action: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
