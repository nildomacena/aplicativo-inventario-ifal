import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/bindings/initial_binding.dart';
import 'package:inventario_getx/data/provider/auth_provider.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';
import 'package:inventario_getx/global_controllers/auth_controller.dart';
import 'package:inventario_getx/global_controllers/auth_repository.dart';
import 'package:inventario_getx/routes/app_pages.dart';
import 'package:inventario_getx/routes/app_routes.dart';
import 'package:inventario_getx/services/util.service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await utilService.initJson();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.put(AuthProvider(), permanent: true);
  Get.put(AuthController(repository: AuthRepository()), permanent: true);
  Get.put(FirestoreProvider(), permanent: true);
  await FirestoreProvider().getCampi();
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
