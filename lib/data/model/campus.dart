import 'package:cloud_firestore/cloud_firestore.dart';

class Campus {
  final String id;
  final String nome;

  Campus({this.id, this.nome});

  String get firestorePath => 'campi/$id/2020/2020';
  @override
  String toString() {
    return 'Nome: $nome';
  }

  Map get asMap {
    return {'nome': nome, 'id': id};
  }

  factory Campus.fromFirestore(DocumentSnapshot snapshot) {
    dynamic data = snapshot.data();
    return Campus(
      id: snapshot.id,
      nome: data['nome'],
    );
  }
}
