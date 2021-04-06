import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/data/model/usuario.dart';
import 'package:inventario_getx/global_controllers/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository repository;
  Rx<User> _firebaseUser = Rx<User>(null);
  Rx<Usuario> _usuario = Rx<Usuario>(null);

  AuthController({@required this.repository}) : assert(repository != null) {}

  @override
  void onInit() {
    _firebaseUser.bindStream(repository.user$);
    _firebaseUser.listen((user) async {
      Usuario usuario = await repository.getUserByUID(user.uid);
      _usuario.value = usuario;
    });
    super.onInit();
  }
}
