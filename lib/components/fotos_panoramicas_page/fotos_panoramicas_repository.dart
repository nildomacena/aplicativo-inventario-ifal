import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';

class FotosPanoramicasRepository {
  final FirestoreProvider firestoreProvider;

  FotosPanoramicasRepository({@required this.firestoreProvider})
      : assert(firestoreProvider != null);

  Stream<Localidade> streamLocalidadeById(Localidade localidade) {
    return firestoreProvider.streamLocalidade(localidade);
  }

  Future<dynamic> salvarImagensPanoramicas(
      Localidade localidade, List<File> imagens) async {
    return firestoreProvider.salvarImagensPanoramicas(localidade, imagens);
  }

  Future<dynamic> salvarMultiplasImagensPanoramicas(
      Localidade localidade, List<File> imagens) async {
    return firestoreProvider.salvarMultiplasImagensPanoramicas(
        localidade, imagens);
  }

  Future<Localidade> deletarImagemPanoramica(
      Localidade localidade, String imagem) {
    return firestoreProvider.deletarImagemPanoramica(localidade, imagem);
  }
}
