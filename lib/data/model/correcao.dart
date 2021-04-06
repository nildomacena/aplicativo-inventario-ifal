import 'package:cloud_firestore/cloud_firestore.dart';

class Correcao {
  final String id;
  final String bemDescricao;
  final String bemId;
  final String bemPatrimonio;
  final String localidadeId;
  final String localidadeNome;
  final String motivo;
  Correcao(
      {this.id,
      this.bemDescricao,
      this.bemId,
      this.bemPatrimonio,
      this.localidadeId,
      this.localidadeNome,
      this.motivo});

  @override
  String toString() {
    return 'bemDescricao: $bemDescricao';
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
    );
  }
}
