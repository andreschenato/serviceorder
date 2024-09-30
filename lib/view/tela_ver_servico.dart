import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:serviceorder/controller/servico_controller.dart';
import 'package:serviceorder/model/servico.dart';
import 'package:serviceorder/themes/button_default.dart';
import 'package:serviceorder/themes/form_field_default.dart';
import 'package:serviceorder/widgets/app_drawer.dart';
import 'package:serviceorder/widgets/custom_app_bar.dart';

class TelaVerServico extends StatefulWidget {
  final int idServico;
  const TelaVerServico({super.key, required this.idServico});

  @override
  State<TelaVerServico> createState() => _TelaVerServicoState();
}

class _TelaVerServicoState extends State<TelaVerServico> {
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
      drawer: AppDrawer.appDrawer(context: context, tela: 'Servicos'),
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
                preco.text = UtilBrasilFields.obterReal(svc.preco!);
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
                            readOnly: true,
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
                            readOnly: true,
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
                            readOnly: true,
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
                                  style: ButtonDefault.buttonStyle(),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Voltar')),
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
