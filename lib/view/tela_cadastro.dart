import 'package:flutter/material.dart';
import 'package:serviceorder/controller/usuario_controller.dart';
import 'package:serviceorder/model/usuario.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/themes/button_default.dart';
import 'package:serviceorder/themes/form_field_default.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final senhaConfirm = TextEditingController();
  final userName = TextEditingController();
  final Usuario user = Usuario();
  @override
  void dispose() {
    userName.dispose();
    email.dispose();
    senha.dispose();
    senhaConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool? keepLogin = false;
    return Scaffold(
      body: Center(
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.2),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Criar conta',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: userName,
                  decoration: FormFieldDefault.textFieldStyle(
                    labelTxt: "Nome de usuário",
                    hintTxt: "Insira o nome de usuário",
                  ),
                  onChanged: (value) {
                    user.nome = userName.text;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome de usuário';
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
                      labelTxt: "Email", hintTxt: 'Insira um email'),
                  onChanged: (value) {
                    user.email = email.text;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: senha,
                  decoration: FormFieldDefault.textFieldStyle(
                      labelTxt: "Senha", hintTxt: 'Insira uma senha'),
                  onChanged: (value) {
                    user.senha = senha.text;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: senhaConfirm,
                  decoration: FormFieldDefault.textFieldStyle(
                      labelTxt: "Confirmar senha", hintTxt: 'Confirme a senha'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a senha';
                    } else if (value != senha.text) {
                      return 'As senhas devem ser iguais';
                    }
                    return null;
                  },
                ),
                StatefulBuilder(
                  builder: (context, setState) {
                    return CheckboxListTile(
                        title: const Text("Manter login?"),
                        value: keepLogin,
                        activeColor: Colors.blueAccent,
                        onChanged: (newVal) {
                          setState(
                            () {
                              keepLogin = newVal;
                            },
                          );
                        });
                  },
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonDefault.buttonStyle(),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            criaUser(user, keepLogin!).then((val) {
                              if (val == true) {
                                notifyLogin(context, user);
                                Navigator.of(context).pushNamedAndRemoveUntil(Rotas.clientes, (Route<dynamic> route) => false);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Email possivelmente já existe'),
                                  ),
                                );
                              }
                            });
                          }
                        },
                        child: const Text('Criar conta!')),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Não tem conta?',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      TextButton(
                          style: const ButtonStyle(
                              overlayColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.black),
                              textStyle: WidgetStatePropertyAll(TextStyle(
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.underline))),
                          onPressed: () {
                            Navigator.pushNamed(context, Rotas.login);
                          },
                          child: const Text(
                            'Clique aqui!',
                            style: TextStyle(fontSize: 16),
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
