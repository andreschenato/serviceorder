class Historico {
  int? idHistorico;
  DateTime? dataModificacao;
  String? statusAnterior;
  String? statusNovo;
  int? idOrdens;

  Historico({
    this.idHistorico,
    this.dataModificacao,
    this.statusAnterior,
    this.statusNovo,
    this.idOrdens,
  });

  factory Historico.fromJson(Map<String, dynamic> json) {
    return Historico(
      idHistorico: int.parse(json['idHistorico']),
      dataModificacao: DateTime.parse(json['dataModificacao']),
      statusAnterior: json['statusAnterior'],
      statusNovo: json['statusNovo'],
      idOrdens: int.parse(json['idOrdens']),
    );
  }
}