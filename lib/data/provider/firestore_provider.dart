import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/data/model/bem.dart';
import 'package:inventario_getx/data/model/campus.dart';
import 'package:inventario_getx/data/model/correcao.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/data/model/usuario.dart';
import 'package:inventario_getx/data/provider/auth_provider.dart';
import 'package:inventario_getx/services/util.service.dart';

class FirestoreProvider {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  AuthProvider authProvider = Get.find();
  List<Campus> campi = [];

  FirestoreProvider() {}

  Future<List<Campus>> getCampi() async {
    if (campi.isNotEmpty) return campi;
    campi = (await _firestore.collection('campi').orderBy('nome').get())
        .docs
        .map((c) => Campus.fromFirestore(c))
        .toList();
    return campi;
  }

  Stream<List<Correcao>> streamCorrecoes() {
    return _firestore
        .collection(
            'campi/${authProvider.usuario.campusId}/2020/2020/correcoes')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((s) => Correcao.fromFirestore(s)).toList());
  }

  Future<List<Localidade>> getLocalidadesPorUsuario([Usuario usuario]) async {
    if (usuario == null) {
      usuario = authProvider.usuario;
    }
    QuerySnapshot querySnapshot = await _firestore
        .collection('campi/${usuario.campusId}/2020/2020/localidades')
        .get();
    List<Localidade> localidades = querySnapshot.docs
        .map((s) => Localidade.fromFirestore(
              s,
              usuario.campusId,
            ))
        .toList();
    localidades.sort((a, b) {
      //Função que ordena as localidades mostrando as que estão em andamento primeiro
      int numero;
      if (a.status == Status.em_andamento)
        numero = -1;
      else
        numero = a.status.index;
      return numero.compareTo(b.status.index);
    });
    return localidades;
  }

  Stream<Localidade> streamLocalidade(Localidade localidade) {
    return _firestore.doc(localidade.pathFirestore).snapshots().map(
        (snapshot) => Localidade.fromFirestore(snapshot, localidade.campusId));
  }

  Stream<List<Bem>> streamBensPorLocalidade(Localidade localidade) {
    return _firestore
        .doc(localidade.pathFirestore)
        .collection('bens')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((s) => Bem.fromFirestore(s)).toList());
  }

  Future<dynamic> salvarImagensPanoramicas(
      Localidade localidade, List<File> imagens) async {
    List<Future> salvandoImagens = [];
    TaskSnapshot taskSnapshot = await storage
        .ref()
        .child(
            'inventario2020/${localidade.campusId}/${localidade.id}/foto-panoramica')
        .putFile(imagens[0])
        .whenComplete(() => null);
    return _firestore
        .doc(
            'campi/${authProvider.usuario.campusId}/2020/2020/localidades/${localidade.id}')
        .update({'panoramica': await taskSnapshot.ref.getDownloadURL()});
  }

  Future<dynamic> salvarMultiplasImagensPanoramicas(
      Localidade localidade, List<File> imagens) async {
    List<Future> salvandoImagens = [];
    List<String> urlImagens = [];
    salvandoImagens = imagens
        .map((imagem) => storage
            .ref()
            .child(
                'inventario2020/${localidade.campusId}/${localidade.id}/fotos-panoramicas/${utilService.getFileName(imagem)}')
            .putFile(imagem)
            .then((value) async =>
                urlImagens.add(await value.ref.getDownloadURL())))
        .toList();
    await Future.wait(salvandoImagens);
    /* TaskSnapshot taskSnapshot = await storage
        .ref()
        .child(
            'inventario2020/${localidade.campusId}/${localidade.id}/fotos-panoramicas')
        .putFile(imagens[0])
        .whenComplete(() => null); */
    localidade.panoramicas.forEach((p) {
      urlImagens.add(p);
    });
    return _firestore
        .doc(
            'campi/${authProvider.usuario.campusId}/2020/2020/localidades/${localidade.id}')
        .update({'panoramicas': urlImagens});
  }

  Future<Localidade> deletarImagemPanoramica(
      Localidade localidade, String imagem) async {
    List<String> aux = [...localidade.panoramicas];
    aux.removeWhere((i) => i.contains(imagem));
    await _firestore.doc(localidade.pathFirestore).update({'panoramicas': aux});
    return getLocalidadeAtualizada(localidade);
  }

  Future<Localidade> getLocalidadeAtualizada(Localidade localidade) async {
    return Localidade.fromFirestore(
        await _firestore.doc(localidade.pathFirestore).get(),
        localidade.campusId);
  }

  Future<dynamic> finalizarLocalidade(
      Localidade localidade, File imagemRelatorio, String observacoes) async {
    TaskSnapshot taskSnapshot = await storage
        .ref()
        .child(
            'inventario2020/${localidade.campusId}/${localidade.id}/relatorio')
        .putFile(imagemRelatorio)
        .whenComplete(() => null);

    await _firestore.doc(localidade.pathFirestore).update({
      'imagemRelatorioPath': taskSnapshot.ref.fullPath,
      'imagemRelatorio': await taskSnapshot.ref.getDownloadURL(),
      'observacoes': observacoes,
      'uidUsuario': authProvider.usuario.uid,
      'nomeUsuario': authProvider.usuario.nome,
      'status': Status.finalizado.index,
      'finalizadoEm': FieldValue.serverTimestamp()
    });
    await firebaseMessaging.subscribeToTopic(localidade.id);
    return;
  }

  Future<dynamic> reabrirLocalidade(Localidade localidade) async {
    return _firestore.doc(localidade.pathFirestore).update({
      'status': Status.em_andamento.index,
      'imagemRelatorio': '',
      'reabertoEm': FieldValue.serverTimestamp(),
      'reabertoPor': authProvider.usuario.uid
    });
    //return getLocalidadeById(localidade.id);
  }

  Future<Localidade> getLocalidadeById(String id) async {
    return Localidade.fromFirestore(
        await _firestore
            .doc(
                'campi/${authProvider.usuario.campusId}/2020/2020/localidades/$id')
            .get(),
        authProvider.usuario.campusId);
  }

  Future<Localidade> verificaBemJaCadastrado(String patrimonio) async {
    QuerySnapshot snapshot = await _firestore
        .collection('campi/${authProvider.usuario.campusId}/2020/2020/bens')
        .where('patrimonio', isEqualTo: patrimonio)
        .where('semEtiqueta', isEqualTo: false)
        .where('bemParticular', isEqualTo: false)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return getLocalidadeById(snapshot.docs.first.data()['localidadeId']);
  }

  /**BENS */
  Future<Localidade> salvarBem(Localidade localidade,
      {@required File imagem,
      @required String descricao,
      @required String patrimonio,
      @required bool semEtiqueta,
      @required String numeroSerie,
      @required String estadoBem,
      @required bool bemParticular,
      @required bool indicaDesfazimento,
      @required String observacoes}) async {
    Usuario usuario = authProvider.usuario;
    Localidade verificacao = await verificaBemJaCadastrado(patrimonio);
    if (verificacao != null) {
      throw {
        'code': 'bem-cadastrado',
        'descricao':
            'O bem ${descricao ?? ''} já foi inventariado na localidade ${localidade.nome}'
      };
    }
    print('localidade salvarBem: $localidade');
    DocumentReference documentReference =
        await _firestore.collection('${localidade.pathFirestore}/bens').add({
      'descricao': descricao,
      'patrimonio': patrimonio,
      'semEtiqueta': semEtiqueta,
      'numeroSerie': numeroSerie,
      'estadoBem': estadoBem,
      'bemParticular': bemParticular,
      'indicaDesfazimento': indicaDesfazimento,
      'observacoes': observacoes,
      'campusId': usuario.campusId,
      'localidadeId': localidade.id,
      'deletado': false,
      'nomeUsuario': usuario.nome,
      'uidUsuario': usuario.uid,
      'aCorrigir': false,
      'timestamp': FieldValue.serverTimestamp()
    });

    TaskSnapshot taskSnapshot = await storage
        .ref()
        .child(
            'inventario2020/${localidade.campusId}/${localidade.id}/bens/${documentReference.id}.png')
        .putFile(imagem)
        .whenComplete(() => null);
    await documentReference
        .update({'imagem': await taskSnapshot.ref.getDownloadURL()});
    DocumentSnapshot localidadeSnapshot = await _firestore
        .doc('campi/${usuario.campusId}/2020/2020/localidades/${localidade.id}')
        .get();
    QuerySnapshot bensSnapshot =
        await _firestore.collection('${localidade.pathFirestore}/bens').get();
    await firebaseMessaging.subscribeToTopic(documentReference.id);
    await imagem.delete();
    return Localidade.fromFirestore(localidadeSnapshot, localidade.campusId,
        snapshotBens: bensSnapshot);
  }

  Future<dynamic> alterarBem(
      {@required Bem bemAntigo,
      @required String descricao,
      @required String patrimonio,
      @required bool semEtiqueta,
      @required String numeroSerie,
      @required String estadoBem,
      @required bool bemParticular,
      @required bool indicaDesfazimento,
      @required String observacoes,
      @required File imagem,
      Correcao correcao}) async {
    if (imagem != null) {
      TaskSnapshot taskSnapshot = await storage
          .ref()
          .child(bemAntigo.storagePath)
          .putFile(imagem)
          .whenComplete(() => null);
      await _firestore.doc(bemAntigo.firestorePath).update({
        'descricao': descricao,
        'patrimonio': patrimonio,
        'semEtiqueta': semEtiqueta,
        'numeroSerie': numeroSerie,
        'estadoBem': estadoBem,
        'bemParticular': bemParticular,
        'indicaDesfazimento': indicaDesfazimento,
        'observacoes': observacoes,
        'imagem': await taskSnapshot.ref.getDownloadURL()
      });
    } else {
      await _firestore.doc(bemAntigo.firestorePath).update({
        'descricao': descricao,
        'patrimonio': patrimonio,
        'semEtiqueta': semEtiqueta,
        'numeroSerie': numeroSerie,
        'estadoBem': estadoBem,
        'bemParticular': bemParticular,
        'indicaDesfazimento': indicaDesfazimento,
        'observacoes': observacoes,
      });
    }
    print('Correcao: ${correcao.pathFirestore}');

    if (correcao != null) {
      await _firestore.doc(correcao.pathFirestore).update(
          {'corrigido': true, 'corrigidoEm': FieldValue.serverTimestamp()});
    }

    return;
  }

  Future<void> deletarBem(Bem bem) async {
    return _firestore.doc(bem.firestorePath).delete();
  }

  Future<Bem> getBemById(
      {@required String bemId, @required String localidadeId}) async {
    print(
        'campi/${authProvider.usuario.campusId}/2020/2020/localidades/$localidadeId/bens/$bemId');
    return Bem.fromFirestore(await _firestore
        .doc(
            'campi/${authProvider.usuario.campusId}/2020/2020/localidades/$localidadeId/bens/$bemId')
        .get());
  }
}
