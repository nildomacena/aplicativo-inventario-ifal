import 'package:get/get.dart';
import 'package:inventario_getx/data/provider/auth_provider.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';
import 'package:inventario_getx/global_controllers/auth_controller.dart';
import 'package:inventario_getx/global_controllers/auth_repository.dart';

class InitialBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    Get.put(AuthProvider(), permanent: true);
    Get.put(AuthController(repository: AuthRepository()), permanent: true);
    Get.put(FirestoreProvider(), permanent: true);
  }
}
