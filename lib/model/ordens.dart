class Ordens {
  int usuarioId;
  int clienteId;
  String descricao;
  String? laudo;
  DateTime diaCriado;
  DateTime? diaFinalizado;
  String status;

  Ordens({
    required this.usuarioId,
    required this.clienteId,
    required this.descricao,
    this.laudo,
    required this.diaCriado,
    this.diaFinalizado,
    required this.status,
  });
}
