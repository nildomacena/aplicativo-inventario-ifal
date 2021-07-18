import 'package:get/get.dart';
import 'package:inventario_getx/data/model/bem.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';

class LocalidadeDetailRepository {
  FirestoreProvider firestoreProvider = Get.find();

  Stream<Localidade> streamLocalidadeById(Localidade localidade) {
    return firestoreProvider.streamLocalidade(localidade);
  }

  Stream<List<Bem>> streamBensPorLocalidade(Localidade localidade) {
    return firestoreProvider.streamBensPorLocalidade(localidade);
  }

  Future<List<Bem>> getBensPorLocalidade(Localidade localidade) {
    return firestoreProvider.getBensPorLocalidade(localidade);
  }
}
