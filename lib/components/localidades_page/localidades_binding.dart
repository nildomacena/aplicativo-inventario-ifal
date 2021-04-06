import 'package:get/get.dart';
import 'package:inventario_getx/components/localidades_page/localidades_controller.dart';

class LocalidadesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalidadesController>(() => LocalidadesController());
  }
}
