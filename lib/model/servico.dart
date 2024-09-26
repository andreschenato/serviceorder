class Servico {
  int? idServico;
  String? nomeServico;
  String? descricao;
  double? preco;

  Servico({
    this.idServico,
    this.nomeServico,
    this.descricao,
    this.preco,
  });

  factory Servico.fromJson(Map<String, dynamic> json) {
    return Servico(
      idServico: int.parse(json['idServico']),
      nomeServico: json['nomeServico'],
      descricao: json['descricaoServico'],
      preco: double.parse(json['preco']),
    );
  }
}