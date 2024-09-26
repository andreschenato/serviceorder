import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serviceorder/controller/cliente_controller.dart';
import 'package:serviceorder/model/cliente.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/themes/button_default.dart';
import 'package:serviceorder/themes/form_field_default.dart';
import 'package:serviceorder/widgets/app_drawer.dart';
import 'package:serviceorder/widgets/custom_app_bar.dart';

class TelaEditarCliente extends StatefulWidget {
  final int idCliente;
  const TelaEditarCliente({super.key, required this.idCliente});

  @override
  State<TelaEditarCliente> createState() => _TelaEditarClienteState();
}

class _TelaEditarClienteState extends State<TelaEditarCliente> {
  final _formKey = GlobalKey<FormState>();
  Future<Cliente>? cliente;
  final nome = TextEditingController();
  final email = TextEditingController();
  final telefonePrincipal = TextEditingController();
  final telefoneSecundario = TextEditingController();
  final endereco = TextEditingController();
  final numero = TextEditingController();
  final bairro = TextEditingController();
  final complemento = TextEditingController();

  @override
  void dispose() {
    nome.dispose();
    email.dispose();
    telefonePrincipal.dispose();
    telefoneSecundario.dispose();
    endereco.dispose();
    numero.dispose();
    bairro.dispose();
    complemento.dispose();
    super.dispose();
  }

  @override
  void initState() {
    cliente = getDadosCliente(widget.idCliente);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(txt: 'Clientes'),
      drawer: AppDrawer.appDrawer(context: context, tela: 'Clientes'),
      body: Center(
        child: FutureBuilder(
          future: cliente,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar clientes'));
            } else if (snapshot.data != null) {
              var cli = snapshot.data!;
              nome.text = cli.nome!;
              email.text = cli.email != null ? cli.email! : "";
              telefonePrincipal.text = cli.telefonePrincipal!;
              telefoneSecundario.text =
                  cli.telefoneSecundario != null ? cli.telefoneSecundario! : "";
              endereco.text = cli.endereco!;
              numero.text = cli.numEndereco!;
              bairro.text = cli.bairro!;
              complemento.text = cli.complemento != null ? cli.complemento! : "";
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
                          controller: nome,
                          decoration: FormFieldDefault.textFieldStyle(
                              labelTxt: "Nome", hintTxt: 'Insira um nome'),
                          onChanged: (value) {
                            cli.nome = nome.text;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um nome';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: email,
                          decoration: FormFieldDefault.textFieldStyle(
                              labelTxt: "Email do cliente",
                              hintTxt: 'Insira um email'),
                          onChanged: (value) {
                            cli.email = email.text;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              cli.email = '';
                              return null;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: telefonePrincipal,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                          decoration: FormFieldDefault.textFieldStyle(
                              labelTxt: "Telefone principal",
                              hintTxt: 'Insira um telefone principal'),
                          onChanged: (value) {
                            cli.telefonePrincipal = telefonePrincipal.text;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um telefone principal';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: telefoneSecundario,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                          decoration: FormFieldDefault.textFieldStyle(
                              labelTxt: "Telefone secundário",
                              hintTxt: 'Insira um telefone secundário'),
                          onChanged: (value) {
                            cli.telefoneSecundario = telefoneSecundario.text;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              cli.telefoneSecundario = '';
                              return null;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: endereco,
                          decoration: FormFieldDefault.textFieldStyle(
                              labelTxt: "Endereço",
                              hintTxt: 'Insira um endereço'),
                          onChanged: (value) {
                            cli.endereco = endereco.text;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira um endereço';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: numero,
                          decoration: FormFieldDefault.textFieldStyle(
                              labelTxt: "Número",
                              hintTxt: 'Insira um número do endereço'),
                          onChanged: (value) {
                            cli.numEndereco = numero.text;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o número do endereço';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: bairro,
                          decoration: FormFieldDefault.textFieldStyle(
                              labelTxt: "Bairro", hintTxt: 'Insira um bairro'),
                          onChanged: (value) {
                            cli.bairro = bairro.text;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o bairro';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: complemento,
                          decoration: FormFieldDefault.textFieldStyle(
                              labelTxt: "Complemento",
                              hintTxt: 'Insira o complemento'),
                          onChanged: (value) {
                            cli.complemento = complemento.text;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              cli.complemento = '';
                              return null;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                      atualizaCliente(cli).then((val) {
                                        if (val == true) {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  Rotas.clientes,
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
          },
        ),
      ),
    );
  }
}
