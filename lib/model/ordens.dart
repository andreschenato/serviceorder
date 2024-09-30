class Ordens {
  int? id;
  int? usuarioId;
  int? clienteId;
  String? nomeUsuario;
  String? nomeCliente;
  String? descricao;
  String? laudo;
  DateTime? diaCriado;
  String? diaFinalizado;
  String? status;
  double? valorTotal;

  Ordens({
    this.id,
    this.usuarioId,
    this.clienteId,
    this.nomeUsuario,
    this.nomeCliente,
    this.descricao,
    this.laudo,
    this.diaCriado,
    this.diaFinalizado,
    this.status,
    this.valorTotal,
  });

  factory Ordens.fromJson(Map<String, dynamic> json) {
    return Ordens(
      id: int.parse(json['idOrdens']),
      usuarioId: int.parse(json['idUsuarioFK']),
      clienteId: int.parse(json['idClienteFK']),
      descricao: json['descricaoOrdem'],
      laudo: json['laudoOrdem'],
      status: json['status'],
      diaCriado: DateTime.parse(json['dataAbertura']),
      diaFinalizado: json['dataConclusao'],
      valorTotal: double.parse(json['valorTotal']),
    );
  }

  factory Ordens.fromJsonView(Map<String, dynamic> json) {
    return Ordens(
      id: int.parse(json['idOrdens']),
      usuarioId: int.parse(json['idUsuario']),
      descricao: json['descricaoOrdem'],
      nomeUsuario: json['nomeUsuario'],
      nomeCliente: json['nomeCliente'],
      laudo: json['laudoOrdem'],
      status: json['status'],
      diaCriado: DateTime.parse(json['dataAbertura']),
      diaFinalizado: json['dataConclusao'],
    );
  }
}
