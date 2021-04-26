import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/data/model/campus.dart';
import 'package:inventario_getx/data/model/usuario.dart';
import 'package:inventario_getx/data/provider/firestore_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<String> getUltimoEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }

  Future<Usuario> login(
      {@required String email, @required String password}) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    return getUserByUID(userCredential.user.uid);
  }

  Future<void> signOut() {}

  Future<Usuario> createUser(
      {@required String email,
      @required String nome,
      @required String cpf,
      @required String siape,
      @required Campus campus,
      @required String password}) async {
    QuerySnapshot querySnapshot;
    /* querySnapshot = await _firestore
        .collection('usuarios')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) throw {code: 'usuario-ja-cadastrado'}; */

    querySnapshot = await _firestore
        .collection('${campus.firestorePath}/preCadastros')
        .where('cpf', isEqualTo: cpf.replaceAll(new RegExp(r'[^\w\s]+'), ''))
        .where('siape', isEqualTo: siape)
        .get();
    print(cpf.replaceAll(new RegExp(r'[^\w\s]+'), ''));
    print(querySnapshot.docs.isEmpty);
    if (querySnapshot.docs.isEmpty) throw 'pre-cadastro-inexistente';
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firestore.doc('usuarios/${userCredential.user.uid}').set({
      'idPreCadastro': querySnapshot.docs.first.id,
      'nome': nome,
      'email': email,
      'campus': campus.asMap,
      'campusId': campus.id,
      'campusNome': campus.nome,
      'confirmado': true,
      'cpf': cpf,
      'dataPreCadastro': FieldValue.serverTimestamp(),
      'dataSignup': FieldValue.serverTimestamp(),
      'papel': 'padrao',
      'siape': siape,
      'uid': userCredential.user.uid
    });
    await _firestore
        .doc(
            '${campus.firestorePath}/preCadastros/${querySnapshot.docs.first.id}')
        .update({
      'dataSignup': FieldValue.serverTimestamp(),
    });
    return getUserByUID(userCredential.user.uid);
  }

  Future<Usuario> getUserByUID(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('usuarios').doc(uid).get();
    if (!snapshot.exists) return null;
    return Usuario.fromFirestore(snapshot);
  }

  Future<void> redefinirSenha(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
