import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String documentID;
  final String uid;
  final String nome;
  final String email;
  final String papel;
  final String campusId;
  final String campusNome;
  Usuario(
      {this.nome,
      this.documentID,
      this.uid,
      this.email,
      this.papel,
      this.campusId,
      this.campusNome});

  factory Usuario.fromFirestore(DocumentSnapshot snapshot) {
    dynamic data = snapshot.data();
    return Usuario(
        documentID: snapshot.id,
        nome: data['nome'],
        email: data['email'],
        papel: data['papel'],
        uid: data['uid'],
        campusId: data['campusId'] ?? 'xQvvY7xXGWLIB4Eoj3HI',
        campusNome: data['campus']['campusNome'] ?? 'Benedito Bentes'
        /* 
        TODO retirar esse comentario ID do campus colocado apenas para testes
        campusId: data['campus']['id'] ?? '',
        campusNome: data['campus']['nome'] ?? '' */
        );
  }

  @override
  String toString() {
    return 'Nome: $nome - Campus: $campusNome';
  }
}
