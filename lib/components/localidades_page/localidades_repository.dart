import 'package:flutter/cupertino.dart';
import 'package:inventario_getx/data/provider/auth_provider.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';

class LocalidadesRepository {
  final FirestoreProvider firestoreProvider;
  final AuthProvider authProvider;
  LocalidadesRepository(
      {@required this.firestoreProvider, @required this.authProvider})
      : assert(firestoreProvider != null && authProvider != null);

  Future<void> signOut() {
    return authProvider.signOut();
  }
}
