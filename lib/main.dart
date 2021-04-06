import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/bindings/initial_binding.dart';
import 'package:inventario_getx/data/provider/auth_provider.dart';
import 'package:inventario_getx/global_controllers/auth_controller.dart';
import 'package:inventario_getx/global_controllers/auth_repository.dart';
import 'package:inventario_getx/routes/app_pages.dart';
import 'package:inventario_getx/routes/app_routes.dart';
import 'package:inventario_getx/services/util.service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await utilService.initJson();
  await Firebase.initializeApp();
  Get.put(AuthProvider(), permanent: true);
  Get.put(AuthController(repository: AuthRepository()), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      initialRoute: Routes.INITIAL,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    );
  }
}
