import 'package:cloud_firestore/cloud_firestore.dart';

class Campus {
  final String id;
  final String nome;

  Campus({this.id, this.nome});
  
  @override
  String toString() {
    return 'Nome: $nome';
  }

  factory Campus.fromFirestore(DocumentSnapshot snapshot) {
    dynamic data = snapshot.data();
    return Campus(
      id: snapshot.id,
      nome: data['nome'],
    );
  }
}
