import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:inventario_getx/components/fotos_panoramicas_page/fotos_panoramicas_repository.dart';
import 'package:inventario_getx/custom_widgets/visualizar_imagem_page.dart';
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
    images = [];
    if (localidade.panoramicas != null && localidade.panoramicas.isNotEmpty)
      localidade.panoramicas.forEach((p) {
        images.add({'type': String, 'file': p});
      });
    //images.add({'type': String, 'file': localidade.panoramica});
    update();
  }

  getImage() async {
    try {
      List<Media> res = await ImagesPicker.openCamera(
        pickType: PickType.image,
      );
      print('res: ${res.first.path}');
      images.add({'type': File, 'file': File(res.first.path)});
      imagesFile.add(File(res.first.path));

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

  goToImagem(imagem) {
    if (imagem == null) return;
    Get.to(() => VisualizarImagemPage(imagem));
  }

  deleteImage(dynamic imagem) async {
    int index = 0;
    int indexAchou;

    if (imagem['type'] == File) {
      //print(imagesFile.indexOf(imagem));
      images.forEach((i) {
        if (i['type'] == File && i['file'].path.contains(imagem['file'].path)) {
          indexAchou = index;
        }
        index++;
      });
      images.removeAt(indexAchou);
      index = 0;
      imagesFile.forEach((i) {
        if (i.path.contains(imagem['file'].path)) {
          indexAchou = index;
        }
        index++;
      });
      imagesFile.removeAt(indexAchou);
    } else {
      print('imagem[type].runtimeType == String');
      var result = await Get.dialog(AlertDialog(
        title: Text('Confirmação'),
        content:
            Text('Essa imagem está salva na nuvem. Deseja realmente excluir?'),
        actions: [
          TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: Text('CANCELAR')),
          TextButton(
              onPressed: () {
                Get.back(result: true);
              },
              child: Text('CONFIRMAR'))
        ],
      ));
      if (result == null || !result) return;
      try {
        print('result: ${imagem.toString()}');
        utilService.showAlertCarregando('Deletando imagem...');
        localidade = await repository.deletarImagemPanoramica(
            localidade, imagem['file']);
        print('localidade panoramicas: ${localidade.panoramicas}');

        initImages();
        if (Get.isDialogOpen) Get.back();
      } catch (e) {
        print('Erro: $e');
        if (Get.isDialogOpen) Get.back();
        utilService.snackBarErro(mensagem: 'Erro durante a operação');
      }
    }
  }

  onSubmit() async {
    print('onSubmit()');
    try {
      utilService.showAlertCarregando('Salvando imagens');
      //await repository.salvarImagensPanoramicas(localidade, imagesFile);
      await repository.salvarMultiplasImagensPanoramicas(
          localidade, imagesFile);
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
