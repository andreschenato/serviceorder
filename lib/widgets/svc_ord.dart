import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:serviceorder/controller/servico_controller.dart';
import 'package:serviceorder/controller/servicos_ordens_controller.dart';
import 'package:serviceorder/model/servico.dart';
import 'package:serviceorder/model/servicos_ordens.dart';
import 'package:serviceorder/model/user_logado.dart';
import 'package:serviceorder/themes/button_default.dart';

class SvcOrd extends StatefulWidget {
  final int idOrdem;
  const SvcOrd({super.key, required this.idOrdem});

  @override
  State<SvcOrd> createState() => _SvcOrdState();
}

class _SvcOrdState extends State<SvcOrd> {
  Future<List<ServicosOrdens>>? serviceorder;
  final ServicosOrdens newServicoOrdem = ServicosOrdens();

  @override
  void initState() {
    serviceorder = carregarServicosOrdens(widget.idOrdem);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 1.2,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Consumer<UserLogado>(
                  builder: (_, user, __) => FutureBuilder(
                    future: carregarServicos(user.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Erro ao carregar serviços'));
                      }
                      List<Servico> servicos = snapshot.data!;
                      return DropdownSearch<Servico>(
                        items: (s, p) => servicos,
                        itemAsString: (Servico servico) =>
                            '${servico.idServico} ${servico.nomeServico} - ${servico.preco}',
                        onChanged: (Servico? servico) {
                          newServicoOrdem.idServico = servico?.idServico;
                        },
                        popupProps: const PopupProps.menu(
                            showSearchBox: true,
                            fit: FlexFit.loose,
                            showSelectedItems: true,
                            constraints: BoxConstraints(maxHeight: 150)),
                        compareFn: (Servico s1, Servico s2) => s1 == s2,
                        dropdownBuilder: (context, servico) {
                          return Text(servico != null
                              ? "${servico.nomeServico} - ${servico.preco}"
                              : 'Selecione um serviço');
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              ElevatedButton(
                style: ButtonDefault.buttonStyle(),
                onPressed: () {
                  newServicoOrdem.idServico != null
                      ? adicionarServicoOrdem(
                              newServicoOrdem.idServico!, widget.idOrdem)
                          .then((_) {
                          setState(() {
                            serviceorder =
                                carregarServicosOrdens(widget.idOrdem);
                          });
                        })
                      : null;
                },
                child: const Icon(Icons.add_rounded),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            color: const Color.fromARGB(255, 230, 230, 230),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 1.2,
            ),
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: FutureBuilder(
              future: serviceorder,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Erro ao carregar os serviços desta ordem"),
                  );
                }
                var serviceOrderList = snapshot.data!;
                if (serviceOrderList.isEmpty) {
                  return const Center(
                    child: Text("Não há serviços atrelados a esta ordem"),
                  );
                }
                return ListView.builder(
                  itemCount: serviceOrderList.length,
                  itemBuilder: (context, index) {
                    final svcOrd = serviceOrderList[index];
                    return Card.filled(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor:
                                      const Color.fromARGB(255, 243, 2, 45),
                                  foregroundColor: Colors.white,
                                  onPressed: (context) {
                                    deleteServicoOrdem(svcOrd.idServicosOrdens!)
                                        .then((_) {
                                      setState(() {
                                        serviceorder = carregarServicosOrdens(
                                            widget.idOrdem);
                                      });
                                    });
                                  },
                                  icon: Icons.delete_rounded,
                                ),
                              ],
                            ),
                            child: ListTile(
                              tileColor:
                                  const Color.fromARGB(255, 219, 226, 240),
                              title: Text(
                                svcOrd.nomeServico!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800),
                              ),
                              subtitle: Text('R\$ ${svcOrd.preco!.toString()}'),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
