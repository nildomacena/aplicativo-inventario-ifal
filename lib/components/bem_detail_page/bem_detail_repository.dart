import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:inventario_getx/data/model/bem.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';

class BemDetailRepository {
  final FirestoreProvider firestoreProvider;

  BemDetailRepository({@required this.firestoreProvider})
      : assert(firestoreProvider != null);

  Future alterarBem(
      {@required Bem bemAntigo,
      @required File imagem,
      @required String descricao,
      @required String patrimonio,
      @required bool semEtiqueta,
      @required String numeroSerie,
      @required String estadoBem,
      @required bool bemParticular,
      @required bool indicaDesfazimento,
      @required String observacoes}) {
    return firestoreProvider.alterarBem(
        bemAntigo: bemAntigo,
        imagem: imagem,
        descricao: descricao,
        patrimonio: patrimonio,
        semEtiqueta: semEtiqueta ?? false,
        numeroSerie: numeroSerie ?? '',
        estadoBem: estadoBem,
        bemParticular: bemParticular,
        indicaDesfazimento: indicaDesfazimento,
        observacoes: observacoes ?? '');
  }
}
