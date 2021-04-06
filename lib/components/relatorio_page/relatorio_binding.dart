import 'package:get/get.dart';
import 'package:inventario_getx/components/relatorio_page/relatorio_controller.dart';
import 'package:inventario_getx/components/relatorio_page/relatorio_repository.dart';

class RelatorioBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RelatorioController>(() => RelatorioController(
        repository: RelatorioRepository(firestoreProvider: Get.find())));
  }
}
