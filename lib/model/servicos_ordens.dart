class ServicosOrdens {
  int? idServicosOrdens;
  int? idOrdem;
  int? idServico;
  String? nomeServico;
  double? preco;

  ServicosOrdens({
    this.idServicosOrdens,
    this.idOrdem,
    this.idServico,
    this.nomeServico,
    this.preco,
  });

  factory ServicosOrdens.fromJson(Map<String, dynamic> json) {
    return ServicosOrdens(
      idServicosOrdens: int.parse(json['idSO']),
      idOrdem: int.parse(json['idOrdem']),
      nomeServico: json['nomeServico'],
      preco: double.parse(json['preco']),
    );
  }
}
