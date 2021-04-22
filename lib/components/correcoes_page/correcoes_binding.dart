import 'package:get/get.dart';
import 'package:inventario_getx/components/correcoes_page/correcoes_controller.dart';

class CorrecoesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CorrecoesController>(() => CorrecoesController());
  }
}
