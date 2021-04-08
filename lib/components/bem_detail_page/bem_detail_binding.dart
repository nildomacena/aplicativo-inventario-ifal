import 'package:get/get.dart';
import 'package:inventario_getx/components/bem_detail_page/bem_detail_controller.dart';
import 'package:inventario_getx/components/bem_detail_page/bem_detail_repository.dart';

class BemDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BemDetailController>(() => BemDetailController(
        repository: BemDetailRepository(firestoreProvider: Get.find())));
  }
}
