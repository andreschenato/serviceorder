import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/controller/cliente_controller.dart';
import 'package:serviceorder/controller/ordem_controller.dart';
import 'package:serviceorder/model/cliente.dart';
import 'package:serviceorder/model/ordens.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/themes/button_default.dart';
import 'package:serviceorder/themes/form_field_default.dart';
import 'package:serviceorder/widgets/app_drawer.dart';
import 'package:serviceorder/widgets/custom_app_bar.dart';

class TelaCriaOrdem extends StatefulWidget {
  const TelaCriaOrdem({super.key});

  @override
  State<TelaCriaOrdem> createState() => _TelaCriaOrdemState();
}

class _TelaCriaOrdemState extends State<TelaCriaOrdem> {
  final _formKey = GlobalKey<FormState>();
  final Ordens ordem = Ordens();
  final descricao = TextEditingController();
  int? idCliente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(txt: 'Ordens de Serviço'),
      drawer: AppDrawer.appDrawer(context: context, tela: 'Ordens'),
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
                Consumer<UserLogado>(
                  builder: (_, user, __) => FutureBuilder<List<Cliente>>(
                    future: carregarClientes(user.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Erro ao carregar clientes'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Nenhum cliente disponível'),
                        );
                      }

                      List<Cliente> clientes = snapshot.data!;
                      var cli = snapshot.data!.where((val) => val.id == idCliente);

                      return DropdownSearch<Cliente>(
                        selectedItem: cli.isNotEmpty ?cli.single : null,
                        items: (c, lp) => clientes,
                        itemAsString: (Cliente cliente) =>
                            '${cliente.id} - ${cliente.nome}',
                        onChanged: (Cliente? cliente) {
                          idCliente = cliente?.id;
                        },
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          fit: FlexFit.loose,
                          disabledItemFn: (item) => item.id == idCliente,
                          showSelectedItems:
                              true,
                        ),
                        compareFn: (Cliente c1, Cliente c2) => c1 == c2,
                        dropdownBuilder: (context, cliente) {
                          return Text(cliente != null
                              ? '${cliente.id} - ${cliente.nome}'
                              : 'Selecione um cliente');
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: descricao,
                  maxLines: 10,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: FormFieldDefault.textFieldStyle(
                      labelTxt: "Descrição da ordem de serviço",
                      hintTxt: 'Insira uma descrição da ordem'),
                  onChanged: (value) {
                    ordem.descricao = descricao.text;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma descrição para a ordem de serviço!';
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
                              criaOrdem(ordem, user.id!, idCliente!).then((val) {
                                if (val == true) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      Rotas.ordens,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
