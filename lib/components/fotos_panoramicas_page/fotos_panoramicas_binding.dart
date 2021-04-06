import 'package:get/get.dart';
import 'package:inventario_getx/components/fotos_panoramicas_page/fotos_panoramicas_controller.dart';
import 'package:inventario_getx/components/fotos_panoramicas_page/fotos_panoramicas_repository.dart';

class FotosPanoramicasBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FotosPanoramicasController>(() => FotosPanoramicasController(
        repository: FotosPanoramicasRepository(firestoreProvider: Get.find())));
  }
}
