import 'package:get/get.dart';
import 'package:inventario_getx/components/login_page/login_controller.dart';
import 'package:inventario_getx/components/login_page/login_repository.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
        () => LoginController(repository: LoginRepository()));
  }
}
