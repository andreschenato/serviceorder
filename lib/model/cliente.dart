class Cliente {
  int? id;
  String? nome;
  String? telefonePrincipal;
  String? telefoneSecundario;
  String? email;
  String? endereco;
  String? numEndereco;
  String? bairro;
  String? enderecoCompleto;
  String? status;
  String? complemento;

  Cliente({
    this.id,
    this.nome,
    this.telefonePrincipal,
    this.telefoneSecundario,
    this.email,
    this.endereco,
    this.numEndereco,
    this.bairro,
    this.enderecoCompleto,
    this.status,
    this.complemento,
  });

   factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: int.parse(json['idCliente']),
      nome: json['nomeCliente'],
      telefonePrincipal: json['telefonePrincipal'],
      telefoneSecundario: json['telefoneSecundario'],
      email: json['email'],
      endereco: json['endereco'],
      numEndereco: json['numEndereco'],
      bairro: json['bairro'],
      enderecoCompleto: json['enderecoCompleto'],
      status: json['status'],
      complemento: json['complemento'],
    );
  }
}
