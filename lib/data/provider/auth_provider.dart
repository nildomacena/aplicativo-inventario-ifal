import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/data/model/usuario.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';

class AuthProvider {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User> get user$ => _auth.authStateChanges();
  Rx<Usuario> _usuario = Rx<Usuario>(null);
  Usuario get usuario => _usuario.value;

  AuthProvider() {
    _auth.authStateChanges().listen((user) async {
      _usuario.value = await getUserByUID(user.uid);
    });
  }

  Future<Usuario> login(
      {@required String email, @required String password}) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return getUserByUID(userCredential.user.uid);
  }

  Future<void> signOut() {}

  Future<Usuario> createUser(
      {@required String email,
      @required String nome,
      @required String cpf,
      @required String siape,
      @required String password}) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('usuarios')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) throw 'usuario-ja-cadastrado';
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    _firestore.collection('usuarios').add({
      'campus': {'id': 'xQvvY7xXGWLIB4Eoj3HI', 'nome': 'Benedito Bentes'},
      'campusId': 'xQvvY7xXGWLIB4Eoj3HI',
      'campusNome': 'Benedito Bentes',
      'confirmado': true,
      'cpf': cpf,
      'dataPreCadastro': FieldValue.serverTimestamp(),
      'dataSignup': FieldValue.serverTimestamp(),
      'papel': 'padrao',
      'siape': siape,
      'uid': userCredential.user.uid
    });
    return getUserByUID(userCredential.user.uid);
  }

  Future<Usuario> getUserByUID(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('usuarios').doc(uid).get();
    if (!snapshot.exists) return null;
    return Usuario.fromFirestore(snapshot);
  }
}
