import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/data/model/bem.dart';
import 'package:inventario_getx/data/model/correcao.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';

class CorrecoesRepository {
  final FirestoreProvider firestoreProvider = Get.find();

  Stream<List<Correcao>> streamCorrecoes() {
    return firestoreProvider.streamCorrecoes();
  }

  Future<Localidade> getLocalidadeById(String id) {
    return firestoreProvider.getLocalidadeById(id);
  }

  Future<Bem> getBemById(
      {@required String bemId, @required String localidadeId}) {
    return firestoreProvider.getBemById(
        bemId: bemId, localidadeId: localidadeId);
  }
}
