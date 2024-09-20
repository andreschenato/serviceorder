import 'package:flutter/material.dart';
import 'package:serviceorder/controller/cliente_controller.dart';
import 'package:serviceorder/model/cliente.dart';
import 'package:serviceorder/widgets/app_drawer.dart';

class TelaClientes extends StatefulWidget {
  const TelaClientes({super.key});

  @override
  State<TelaClientes> createState() => _TelaClientesState();
}

class _TelaClientesState extends State<TelaClientes> {
  Future<List<Cliente>>? clientes;

  @override
  void initState() {
    clientes = carregarClientes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Clientes',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 59, 40, 204),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer.appDrawer(),
      body: FutureBuilder(
        future: clientes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar clientes'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: buildClientes(snapshot.data!),
            );
          } else {
            return const Center(child: Text('Não há clientes'));
          }
        },
      ),
    );
  }
}
