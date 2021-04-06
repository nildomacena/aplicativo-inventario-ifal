import 'package:get/get.dart';
import 'package:inventario_getx/components/localidade_detail_page/localidade_detail.controller.dart';

class LocalidadeDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalidadeDetailController>(() => LocalidadeDetailController());
  }
}
