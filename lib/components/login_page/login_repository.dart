import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/data/model/campus.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/data/model/usuario.dart';
import 'package:inventario_getx/data/provider/auth_provider.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';

class LoginRepository {
  AuthProvider authProvider = Get.find();
  FirestoreProvider firestoreProvider = Get.find();

  Future<Usuario> login(String email, String password) {
    print('login');
    if (!email.toLowerCase().contains('ifal.edu.br'))
      return Future.error(PlatformException(code: 'email-nao-institucional'));
    return authProvider.login(email: email, password: password);
  }

  Future<Usuario> createUser(
      {@required String email,
      @required String nome,
      @required String cpf,
      @required String siape,
      @required Campus campus,
      @required String password}) {
    print('login');
    if (!email.toLowerCase().contains('ifal.edu.br'))
      return Future.error(PlatformException(code: 'email-nao-institucional'));
    return authProvider.createUser(
        email: email,
        campus: campus,
        password: password,
        siape: siape,
        cpf: cpf,
        nome: nome);
  }

  Future<String> getUltimoEmail() {
    return authProvider.getUltimoEmail();
  }

  Future<List<Localidade>> getLocalidadesByUsuario(Usuario usuario) {
    return firestoreProvider.getLocalidadesPorUsuario(usuario);
  }

  Future<List<Campus>> getCampi() {
    return firestoreProvider.getCampi();
  }
}
