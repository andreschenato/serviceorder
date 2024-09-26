import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/controller/cliente_controller.dart';
import 'package:serviceorder/model/cliente.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/themes/button_default.dart';
import 'package:serviceorder/themes/form_field_default.dart';
import 'package:serviceorder/widgets/app_drawer.dart';
import 'package:serviceorder/widgets/custom_app_bar.dart';

class TelaCriaCliente extends StatefulWidget {
  const TelaCriaCliente({super.key});

  @override
  State<TelaCriaCliente> createState() => _TelaCriaClienteState();
}

class _TelaCriaClienteState extends State<TelaCriaCliente> {
  final _formKey = GlobalKey<FormState>();
  final Cliente cliente = Cliente();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(txt: 'Clientes'),
      drawer: AppDrawer.appDrawer(context: context, tela: 'Clientes'),
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
                  controller: nome,
                  decoration: FormFieldDefault.textFieldStyle(
                      labelTxt: "Nome", hintTxt: 'Insira um nome'),
                  onChanged: (value) {
                    cliente.nome = nome.text;
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
                      labelTxt: "Email do cliente", hintTxt: 'Insira um email'),
                  onChanged: (value) {
                    cliente.email = email.text;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      cliente.email = '';
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
                    cliente.telefonePrincipal = telefonePrincipal.text;
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
                    cliente.telefoneSecundario = telefoneSecundario.text;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      cliente.telefoneSecundario = '';
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
                      labelTxt: "Endereço", hintTxt: 'Insira um endereço'),
                  onChanged: (value) {
                    cliente.endereco = endereco.text;
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
                    cliente.numEndereco = numero.text;
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
                    cliente.bairro = bairro.text;
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
                      labelTxt: "Complemento", hintTxt: 'Insira o complemento'),
                  onChanged: (value) {
                    cliente.complemento = complemento.text;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      cliente.complemento = '';
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
                    Consumer<UserLogado>(
                        builder: (context, user, _) => Expanded(
                              child: ElevatedButton(
                                  style: ButtonDefault.buttonStyle(),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      criaCliente(cliente, user.id!)
                                          .then((val) {
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
                            )),
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
