import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:inventario_getx/components/fotos_panoramicas_page/fotos_panoramicas_repository.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/services/util.service.dart';

class FotosPanoramicasController extends GetxController {
  final FotosPanoramicasRepository repository;
  Rx<Localidade> _localidade = Rx<Localidade>(null);
  List<Map> images = [];
  List<File> imagesFile = [];
  final picker = ImagePicker();
  Localidade get localidade => this._localidade.value;
  set localidade(Localidade value) => this._localidade.value = value;

  FotosPanoramicasController({@required this.repository})
      : assert(repository != null) {
    localidade = Get.arguments['localidade'];
    _localidade.bindStream(repository.streamLocalidadeById(localidade));
    print('Localidade Panoramica: $localidade');
  }

  @override
  onReady() {
    initImages();
    super.onReady();
  }

  initImages() {
    if (localidade.panoramica != null)
      images.add({'type': String, 'file': localidade.panoramica});
    update();
  }

  getImage() async {
    try {
      List<Media> res = await ImagesPicker.openCamera(
        pickType: PickType.image,
      );
      print('res: ${res.first.path}');
      images.add({'type': File, 'file': File(res.first.path)});
      update();
    } catch (e) {
      print('Erro durante a camptura da imagem: $e');
      utilService.snackBarErro(mensagem: 'Erro durante a captura da imagem');
    }
  }

  getImageBkp() async {
    try {
      final PickedFile pickedFile = await picker.getImage(
          source: ImageSource.camera,
          maxHeight: 1920,
          maxWidth: 1920,
          imageQuality: 70);
      if (pickedFile == null) return;
      images.add({'type': File, 'file': File(pickedFile.path)});
      imagesFile.add(File(pickedFile.path));
      print('pickedFile: $pickedFile');
      update();
    } catch (e) {
      print('Erro: $e');
      utilService.snackBarErro(mensagem: 'Erro durante a captura da imagem');
    }
  }

  onSubmit() async {
    print('onSubmit()');
    try {
      utilService.showAlertCarregando('Salvando imagens');
      await repository.salvarImagensPanoramicas(localidade, imagesFile);
      if (Get.isDialogOpen) Get.back();
      Get.back();
      utilService.snackBar(
        titulo: 'Fotos Salvas',
        mensagem: 'As imagens panorâmicas foram salvas',
      );
    } catch (e) {
      print('Erro ao salvar imagens: $e');
      if (Get.isDialogOpen) Get.back();
      utilService.snackBarErro(mensagem: 'Erro ao salvar imagens');
    }
  }
}
