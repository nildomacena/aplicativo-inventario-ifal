import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventario_getx/data/model/bem.dart';

enum Status { nao_iniciado, em_andamento, finalizado }

class Localidade {
  final String nome;
  final String id;
  final String campusId;
  Status status;
  String
      panoramica; //Alterar para array quando o mesmo estiver sendo salvo no banco de dados
  List<Bem> bens;
  String imagemRelatorio;
  String observacoes;
  Localidade(
      {this.nome,
      this.id,
      this.campusId,
      this.panoramica,
      this.bens,
      this.status,
      this.imagemRelatorio,
      this.observacoes}) {
    if (status == null && bens.length == 0) {
      status = Status.nao_iniciado;
    } else if (status == null) status = Status.em_andamento;
  }

  Future<void> addBensFromFirestore(QuerySnapshot snapshotBens) async {
    bens = snapshotBens.docs.map((e) => Bem.fromFirestore(e)).toList();
    return;
  }

  String get pathFirestore => 'campi/$campusId/2020/2020/localidades/$id';

  factory Localidade.fromFirestore(DocumentSnapshot snapshot, String campusId,
      {QuerySnapshot snapshotBens}) {
    dynamic data = snapshot.data();
    Status status;
    List<Bem> bens = [];
    if (snapshotBens != null && snapshotBens.docs.length > 0)
      bens = snapshotBens.docs.map((e) => Bem.fromFirestore(e)).toList();

    if (data['status'] == null) {
      status = bens.isNotEmpty ? Status.em_andamento : Status.nao_iniciado;
    }
    return Localidade(
        nome: data['nome'],
        panoramica: data['panoramica'],
        imagemRelatorio: data['imagemRelatorio'] ?? '',
        observacoes: data['observacoes'] ?? '',
        status: status != null
            ? status
            : data['status'] == 2
                ? Status.finalizado
                : data['status'] == 1
                    ? Status.em_andamento
                    : Status.nao_iniciado,
        id: snapshot.id,
        campusId: campusId,
        bens: bens);
  }

  bool get possuiImagemRelatorio {
    return imagemRelatorio != null && imagemRelatorio.length > 0;
  }

  factory Localidade.fromFirestoreComBensTeste(
      DocumentSnapshot snapshot, String campusId,
      {QuerySnapshot snapshotBens}) {
    dynamic data = snapshot.data();
    Status status;
    List<Bem> bens = [];
    if (snapshotBens != null && snapshotBens.docs.length > 0)
      bens = snapshotBens.docs.map((e) => Bem.fromFirestore(e)).toList();

    if (data['status'] == null) {
      status = bens.isNotEmpty ? Status.em_andamento : Status.nao_iniciado;
    }
    return Localidade(
        nome: data['nome'],
        panoramica: data['panoramica'],
        status: status != null
            ? status
            : data['status'] == 2
                ? Status.finalizado
                : data['status'] == 1
                    ? Status.em_andamento
                    : Status.nao_iniciado,
        id: snapshot.id,
        campusId: campusId,
        bens: bens);
  }

  String get statusAsString {
    if (status == Status.nao_iniciado) return 'Não iniciado';
    if (status == Status.em_andamento) return 'Em andamento';
    if (status == Status.finalizado)
      return 'Finalizado';
    else
      return 'Em andamento';
  }

  @override
  String toString() {
    return 'Id: $id - Nome: $nome - Bens: ${bens.length}';
  }
}
