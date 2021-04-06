import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/data/model/usuario.dart';
import 'package:inventario_getx/data/provider/auth_provider.dart';

class AuthRepository {
  AuthProvider authProvider = Get.find();
  Stream<User> get user$ => authProvider.user$;

  Future<Usuario> getUserByUID(String uid) async {
    return authProvider.getUserByUID(uid);
  }
}
