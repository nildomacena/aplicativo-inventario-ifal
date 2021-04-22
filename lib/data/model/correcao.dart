import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Correcao {
  final String id;
  final String bemDescricao;
  final String bemId;
  final String bemPatrimonio;
  final String localidadeId;
  final String localidadeNome;
  final String motivo;
  final String campusId;
  Correcao(
      {@required this.id,
      @required this.bemDescricao,
      @required this.bemId,
      @required this.bemPatrimonio,
      @required this.localidadeId,
      @required this.localidadeNome,
      @required this.motivo,
      @required this.campusId});

  @override
  String toString() {
    return 'bemDescricao: $bemDescricao';
  }

  String get pathFirestore {
    return 'campi/$campusId/2020/2020/correcoes/$id';
  }

  factory Correcao.fromFirestore(DocumentSnapshot snapshot) {
    dynamic data = snapshot.data();
    return Correcao(
        id: snapshot.id,
        bemDescricao: data['bemDescricao'],
        bemId: data['bemId'],
        bemPatrimonio: data['bemPatrimonio'],
        localidadeId: data['localidadeId'],
        localidadeNome: data['localidadeNome'],
        motivo: data['motivo'],
        campusId: data['campusId'] ?? 'xQvvY7xXGWLIB4Eoj3HI');
  }
}
