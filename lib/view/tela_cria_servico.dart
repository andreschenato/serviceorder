import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/controller/servico_controller.dart';
import 'package:serviceorder/model/servico.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/themes/button_default.dart';
import 'package:serviceorder/themes/form_field_default.dart';
import 'package:serviceorder/widgets/app_drawer.dart';
import 'package:serviceorder/widgets/custom_app_bar.dart';

class TelaCriaServico extends StatefulWidget {
  const TelaCriaServico({super.key});

  @override
  State<TelaCriaServico> createState() => _TelaCriaServicoState();
}

class _TelaCriaServicoState extends State<TelaCriaServico> {
  final _formKey = GlobalKey<FormState>();
  final Servico servico = Servico();
  final nomeServico = TextEditingController();
  final descricao = TextEditingController();
  final preco = TextEditingController();

  @override
  void dispose() {
    nomeServico.dispose();
    descricao.dispose();
    preco.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(txt: 'Serviços'),
      drawer: AppDrawer.appDrawer(context: context, tela: 'Serviços'),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.2,
          ),
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nomeServico,
                  decoration: FormFieldDefault.textFieldStyle(
                      labelTxt: "Nome do serviço",
                      hintTxt: 'Insira um nome para o serviço'),
                  onChanged: (value) {
                    servico.nomeServico = nomeServico.text;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome para o serviço';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: descricao,
                  maxLines: 5,
                  decoration: FormFieldDefault.textFieldStyle(
                      labelTxt: "Descrição do serviço",
                      hintTxt: 'Insira uma descrição do serviço'),
                  onChanged: (value) {
                    servico.descricao = descricao.text;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: preco,
                  decoration: FormFieldDefault.textFieldStyle(
                      labelTxt: "Preço do serviço",
                      hintTxt: 'Insira um preço para o serviço'),
                  onChanged: (value) {
                    servico.preco = double.parse(preco.text);
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um preço para o serviço';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonDefault.buttonStyleCancel(),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar')),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Consumer<UserLogado>(
                      builder: (context, user, _) => Expanded(
                        child: ElevatedButton(
                          style: ButtonDefault.buttonStyle(),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              criaServico(servico, user.id!).then((val) {
                                if (val == true) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      Rotas.servicos,
                                      (Route<dynamic> route) => false);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Erro ao criar serviço'),
                                    ),
                                  );
                                }
                              });
                            }
                          },
                          child: const Text('Salvar'),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
