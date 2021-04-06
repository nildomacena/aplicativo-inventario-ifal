import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';

class AdicionarBemRepository {
  final FirestoreProvider firestoreProvider;

  AdicionarBemRepository({@required this.firestoreProvider})
      : assert(firestoreProvider != null);

  Future<Localidade> verificaBemJaCadastrado(String patrimonio) {
    return firestoreProvider.verificaBemJaCadastrado(patrimonio);
  }

  Future<Localidade> salvarBem(Localidade localidade,
      {@required File imagem,
      @required String descricao,
      @required String patrimonio,
      @required bool semEtiqueta,
      @required String numeroSerie,
      @required String estadoBem,
      @required bool bemParticular,
      @required bool indicaDesfazimento,
      @required String observacoes}) {
    return firestoreProvider.salvarBem(localidade,
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
