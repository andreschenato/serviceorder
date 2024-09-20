import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/controller/usuario_controller.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/model/usuario.dart';
import 'package:serviceorder/routes/rotas.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await tentaLoginAutomatico();
  String? email = await storage.read(key: 'email');
  String? senha = await storage.read(key: 'senha');
  Usuario? user;
  if (email != null && senha != null) {
    user = Usuario(email: email, senha: senha);
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserLogado(),
      )
    ],
    child: ServiceOrder(isLoggedIn: isLoggedIn, user: user,),
  ));
}

class ServiceOrder extends StatelessWidget {
  final bool isLoggedIn;
  final Usuario? user;

  const ServiceOrder({super.key, required this.isLoggedIn, this.user});

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      notifyLogin(context, user!);
    }
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      title: 'Service Order',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Asap'
      ),
      initialRoute: isLoggedIn ? Rotas.clientes : Rotas.login,
      routes: rotas,
    );
  }
}
