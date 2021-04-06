import 'package:get/get.dart';
import 'package:inventario_getx/components/adicionar_bem_page/adicionar_bem_controller.dart';
import 'package:inventario_getx/components/adicionar_bem_page/adicionar_bem_repository.dart';

class AdicionarBemBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdicionarBemController>(() => AdicionarBemController(
        repository: AdicionarBemRepository(firestoreProvider: Get.find())));
  }
}
