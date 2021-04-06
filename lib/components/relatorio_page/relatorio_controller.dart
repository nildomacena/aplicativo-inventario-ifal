import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/services/util.service.dart';
import './relatorio_repository.dart';

class RelatorioController extends GetxController {
  final RelatorioRepository repository;
  final picker = ImagePicker();
  TextEditingController textEditingController = TextEditingController();
  Localidade localidade;
  File imagem;
  bool salvando = false;

  RelatorioController({@required this.repository})
      : assert(repository != null) {}

  @override
  onInit() async {
    localidade = Get.arguments['localidade'];
    localidade = await repository.getLocalidadeAtualizada(localidade);
    textEditingController.text = localidade.observacoes ?? '';
    super.onInit();
  }

  getImage() async {
    try {
      final PickedFile pickedFile = await picker.getImage(
          source: ImageSource.camera,
          maxHeight: 1920,
          maxWidth: 1920,
          imageQuality: 70);
      if (pickedFile == null) return;
      imagem = File(pickedFile.path);
      print('pickedFile: $pickedFile');
      update();
    } catch (e) {
      print('Erro: $e');
      utilService.snackBarErro(mensagem: 'Erro durante a captura da imagem');
    }
  }

  onSubmit() async {
    print('onSubmit()');
    if (localidade.status == Status.finalizado) {
      dynamic result = await Get.dialog(AlertDialog(
        title: Text('Confirmação'),
        content: Text(
            'Deseja realmente reabrir a localidade?\nAo fazer isso, a imagem do relatório será excluída.'),
        actions: [
          TextButton(
            child: Text('CANCELAR'),
            onPressed: () {
              Get.back(result: false);
            },
          ),
          TextButton(
            child: Text('CONFIRMAR'),
            onPressed: () {
              Get.back(result: true);
            },
          )
        ],
      ));
      if (result == null || !result) {
        return;
      } else {
        reabrirLocalidade();
        return;
      }
    }
    if (imagem == null) {
      utilService.snackBarErro(mensagem: 'Não foi selecionada nenhuma imagem');
      return;
    }
    dynamic result = await Get.dialog(AlertDialog(
      title: Text('Confirmação'),
      content: Text(
          'Ao enviar a foto do relatório, você estará finalizando a localidade.\nTem certeza que deseja isso?'),
      actions: [
        TextButton(
          child: Text('CANCELAR'),
          onPressed: () {
            Get.back(result: false);
          },
        ),
        TextButton(
          child: Text('CONFIRMAR'),
          onPressed: () {
            Get.back(result: true);
          },
        )
      ],
    ));
    if (result == null || !result) {
      Get.back();
      return;
    }
    try {
      utilService.showAlertCarregando('Salvando imagens');
      await repository.finalizarLocalidade(
          localidade, imagem, textEditingController.text ?? '');
      if (Get.isDialogOpen) Get.back();
      Get.back();
      utilService.snackBar(
        titulo: 'Fotos Salvas',
        mensagem: 'O relatório foi salvo e a localidade finalizada',
      );
    } catch (e) {
      print('Erro ao salvar imagens: $e');
      if (Get.isDialogOpen) Get.back();
      utilService.snackBarErro(mensagem: 'Erro ao salvar imagens');
    }
  }

  reabrirLocalidade() async {
    print('reabrir localidade');
    try {
      utilService.showAlertCarregando('Reabrindo localidade...');
      await repository.reabrirLocalidade(localidade);
      if (Get.isDialogOpen) Get.back();
      Get.back();
      utilService.snackBar(
        titulo: 'Localidade reaberta',
        mensagem: 'A localidade ${localidade.nome} foi reaberta.',
      );
    } catch (e) {
      print('Erro durante o processo: $e');
      if (Get.isDialogOpen) Get.back();
      utilService.snackBarErro(mensagem: 'Erro durante o processo');
    }
  }
}
