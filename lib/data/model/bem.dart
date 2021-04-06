import 'package:cloud_firestore/cloud_firestore.dart';

class Bem {
  final String descricao;
  final String id;
  final String patrimonio;
  final bool semEtiqueta;
  final String numeroSerie;
  final String estadoBem;
  final bool bemParticular;
  final bool indicaDesfazimento;
  final String observacoes;
  final String localidadeId;
  final String campusId;
  final String imagem;
  final String nomeUsuario;
  final String uidUsuario;
  final DateTime dataCadastro;
  final bool aCorrigir;
  Bem(
      {this.id,
      this.descricao,
      this.patrimonio,
      this.bemParticular,
      this.estadoBem,
      this.indicaDesfazimento,
      this.numeroSerie,
      this.observacoes,
      this.semEtiqueta,
      this.imagem,
      this.campusId,
      this.localidadeId,
      this.nomeUsuario,
      this.uidUsuario,
      this.dataCadastro,
      this.aCorrigir});

  String get titulo {
    if (patrimonio.length > 0)
      return descricao + ' - ' + patrimonio;
    else
      return descricao;
  }

  String get dataCadastroFormatada {
    return '${dataCadastro.day}/${dataCadastro.month}/${dataCadastro.year} - ${dataCadastro.hour}:${dataCadastro.minute}';
  }

  factory Bem.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data();
    return Bem(
        id: snapshot.id,
        descricao: data['descricao'],
        patrimonio: data['patrimonio'],
        bemParticular: data['bemParticular'] ?? false, //Testes
        estadoBem: data['estadoBem'] ?? 'uso',
        indicaDesfazimento: data['indicaDesfazimento'] ?? false, //Testes
        numeroSerie: data['numeroSerie'],
        observacoes: data['observacoes'],
        semEtiqueta: data['semEtiqueta'] ?? false, //testes,
        imagem: data['imagem'],
        campusId: data['campusId'],
        localidadeId: data['localidadeId'],
        dataCadastro: data['timestamp'] != null
            ? data['timestamp'].toDate()
            : new DateTime.now(), //Colocado para testes
        nomeUsuario: data['nomeUsuario'] ?? "Usuario teste",
        uidUsuario: data['uidUsuario'] ?? 'uidteste',
        aCorrigir: data['aCorrigir'] ?? false);
  }

  @override
  String toString() {
    return 'Bem: $descricao - Patrimônio: $patrimonio';
  }
}
