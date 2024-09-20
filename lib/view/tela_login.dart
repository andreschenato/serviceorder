import 'package:flutter/material.dart';
import 'package:serviceorder/controller/usuario_controller.dart';
import 'package:serviceorder/model/usuario.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:serviceorder/themes/button_default.dart';
import 'package:serviceorder/themes/form_field_default.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final Usuario user = Usuario();
  @override
  void dispose() {
    email.dispose();
    senha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool? keepLogin = false;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 1.2,
              maxHeight: MediaQuery.of(context).size.height / 1.2),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
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
                            fazLogin(user, keepLogin!).then((val) {
                              if (val == true) {
                                notifyLogin(context, user);
                                Navigator.of(context).pushNamedAndRemoveUntil(Rotas.clientes, (Route<dynamic> route) => false);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Email ou senha inválidos'),
                                  ),
                                );
                              }
                            });
                          }
                        },
                        child: const Text('Login')),
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
                            Navigator.pushNamed(context, Rotas.cadastro);
                          },
                          child: const Text(
                            'Clique aqui!',
                            style: TextStyle(fontSize: 16),
                          )),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
