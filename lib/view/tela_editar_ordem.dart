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
import 'package:intl/intl.dart';
import 'package:serviceorder/widgets/svc_ord.dart';

class TelaEditarOrdem extends StatefulWidget {
  final int idOrdem;
  const TelaEditarOrdem({super.key, required this.idOrdem});

  @override
  State<TelaEditarOrdem> createState() => _TelaEditarOrdemState();
}

class _TelaEditarOrdemState extends State<TelaEditarOrdem> {
  final _formKey = GlobalKey<FormState>();
  Future<Ordens>? ordem;
  final descricao = TextEditingController();
  final laudo = TextEditingController();
  final diaConclusao = TextEditingController();

  @override
  void dispose() {
    descricao.dispose();
    laudo.dispose();
    diaConclusao.dispose();
    super.dispose();
  }

  @override
  void initState() {
    ordem = getDadosOrdem(widget.idOrdem);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = DateFormat("dd/MM/yyyy - HH:mm");
    var sqlT = DateFormat("yyyy-MM-dd HH:mm:ss");

    return Scaffold(
      appBar: CustomAppBar.appBar(txt: 'Ordens de Serviço'),
      drawer: AppDrawer.appDrawer(context: context, tela: 'Ordens'),
      body: Center(
        child: FutureBuilder(
          future: ordem,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar ordem'));
            } else {
              Ordens ord = snapshot.data!;
              descricao.text = ord.descricao!;
              laudo.text = ord.laudo!;
              diaConclusao.text = t.format(DateTime.parse(ord.diaFinalizado!));
              return Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 1.2,
                ),
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<UserLogado>(
                            builder: (_, user, __) =>
                                FutureBuilder(
                              future: carregarClientes(user.id!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Erro ao carregar clientes'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text('Nenhum cliente disponível'),
                                  );
                                }
                                List<Cliente> clientes = snapshot.data!;
                                var cli = snapshot.data!
                                    .where((val) => val.id == ord.clienteId);
                                return DropdownSearch<Cliente>(
                                  selectedItem:
                                      cli.isNotEmpty ? cli.single : null,
                                  items: (c, lp) => clientes,
                                  itemAsString: (Cliente cliente) =>
                                      '${cliente.id} - ${cliente.nome}',
                                  onChanged: (Cliente? cliente) {
                                    ord.clienteId = cliente?.id;
                                  },
                                  popupProps: PopupProps.menu(
                                    showSearchBox: true,
                                    fit: FlexFit.loose,
                                    disabledItemFn: (item) =>
                                        item.id == ord.clienteId,
                                    showSelectedItems: true,
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
                          DropdownSearch<String>(
                            items: (s, p) => [
                              'Em aberto',
                              'Em andamento',
                              'Concluída',
                              'Cancelada'
                            ],
                            selectedItem: ord.status,
                            onChanged: (String? status) {
                              if (status != null) {
                                setState(() {
                                  ord.status = status;
                                });
                              }
                            },
                            popupProps: PopupProps.menu(
                              fit: FlexFit.loose,
                              disabledItemFn: (String item) => item == ord.status,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: diaConclusao,
                            decoration: FormFieldDefault.textFieldStyle(
                                labelTxt: "Data de conclusão",
                                hintTxt: 'Insira uma data de conclusão'),
                            readOnly: true,
                            onTap: () async {
                              DateTime? _pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (_pickedDate != null) {
                                TimeOfDay? _pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                      
                                if (_pickedTime != null) {
                                  final DateTime finalDateTime = DateTime(
                                    _pickedDate.year,
                                    _pickedDate.month,
                                    _pickedDate.day,
                                    _pickedTime.hour,
                                    _pickedTime.minute,
                                  );
                                  diaConclusao.text =
                                      t.format(finalDateTime).toString();
                                  setState(() {
                                    ord.diaFinalizado = sqlT.format(finalDateTime);
                                    print(ord.diaFinalizado);
                                  });
                                }
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: descricao,
                            maxLines: 10,
                            maxLength: 1000,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: FormFieldDefault.textFieldStyle(
                                labelTxt: "Descrição da ordem de serviço",
                                hintTxt: 'Insira uma descrição da ordem'),
                            onChanged: (value) {
                              ord.descricao = descricao.text;
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
                            height: 15,
                          ),
                          TextFormField(
                            controller: laudo,
                            maxLines: 10,
                            maxLength: 1000,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: FormFieldDefault.textFieldStyle(
                                labelTxt: "Laudo da ordem de serviço",
                                hintTxt: 'Insira o laudo da ordem'),
                            onChanged: (value) {
                              ord.laudo = laudo.text;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          SvcOrd(idOrdem: widget.idOrdem),

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
                                        atualizaOrdem(ord).then((val) {
                                          if (val == true) {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    Rotas.ordens,
                                                    (Route<dynamic> route) =>
                                                        false);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('Erro ao criar serviço'),
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
          },
        ),
      ),
    );
  }
}
