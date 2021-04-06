import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';

class RelatorioRepository {
  final FirestoreProvider firestoreProvider;

  RelatorioRepository({@required this.firestoreProvider})
      : assert(firestoreProvider != null);

  Future<dynamic> finalizarLocalidade(
      Localidade localidade, File imagemRelatorio, String observacoes) async {
    return firestoreProvider.finalizarLocalidade(
        localidade, imagemRelatorio, observacoes);
  }

  Future<dynamic> reabrirLocalidade(Localidade localidade) async {
    return firestoreProvider.reabrirLocalidade(localidade);
  }

  Future<Localidade> getLocalidadeAtualizada(Localidade localidade) async {
    return firestoreProvider.getLocalidadeAtualizada(localidade);
  }
}
