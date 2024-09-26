import 'package:flutter/material.dart';
import 'package:serviceorder/controller/servico_controller.dart';
import 'package:serviceorder/model/servico.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/themes/button_default.dart';
import 'package:serviceorder/themes/form_field_default.dart';
import 'package:serviceorder/widgets/app_drawer.dart';
import 'package:serviceorder/widgets/custom_app_bar.dart';

class TelaEditarServico extends StatefulWidget {
  final int idServico;
  const TelaEditarServico({super.key, required this.idServico});

  @override
  State<TelaEditarServico> createState() => _TelaEditarServicoState();
}

class _TelaEditarServicoState extends State<TelaEditarServico> {
  final _formKey = GlobalKey<FormState>();
  Future<Servico>? servico;
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
  void initState() {
    servico = getDadosServico(widget.idServico);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(txt: 'Serviços'),
      drawer: AppDrawer.appDrawer(context: context, tela: 'Serviços'),
      body: Center(
        child: FutureBuilder(
            future: servico,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar serviços'));
              } else if (snapshot.data != null) {
                var svc = snapshot.data!;
                nomeServico.text = svc.nomeServico!;
                descricao.text = svc.descricao != null ? svc.descricao! : "";
                preco.text = svc.preco.toString();
                return Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                              svc.nomeServico = nomeServico.text;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                              svc.descricao = descricao.text;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                              svc.preco = double.parse(preco.text);
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            Expanded(
                              child: ElevatedButton(
                                  style: ButtonDefault.buttonStyle(),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      atualizaServico(svc).then((val) {
                                        if (val == true) {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  Rotas.servicos,
                                                  (Route<dynamic> route) =>
                                                      false);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Erro ao criar usuário'),
                                            ),
                                          );
                                        }
                                      });
                                    }
                                  },
                                  child: const Text('Salvar')),
                            ),
                          ],
                        )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
              return const Center(child: Text('Não há clientes'));
              }
            }),
      ),
    );
  }
}
