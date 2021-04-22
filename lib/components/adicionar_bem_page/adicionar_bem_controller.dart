import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventario_getx/components/adicionar_bem_page/adicionar_bem_repository.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/services/util.service.dart';
import 'package:inventario_getx/custom_widgets/visualizar_imagem_page.dart';

class AdicionarBemController extends GetxController {
  Localidade localidade;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  TextEditingController patrimonioController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController numeroSerieController = TextEditingController();
  TextEditingController observacoesController = TextEditingController();

  FocusNode patrimonioFocus = FocusNode();
  FocusNode descricaoFocus = FocusNode();
  FocusNode numeroSerieFocus = FocusNode();
  FocusNode observacoesFocus = FocusNode();

  bool bemParticular = false;
  bool semEtiqueta = false;
  bool indicaDesfazimento = false;
  bool salvando = false;
  bool alterar = false;

  String radioEstado;

  File imagem;

  final AdicionarBemRepository repository;
  AdicionarBemController({@required this.repository})
      : assert(repository != null) {
    localidade = Get.arguments['localidade'];
  }

  unFocusAll() {
    patrimonioFocus.unfocus();
    descricaoFocus.unfocus();
    numeroSerieFocus.unfocus();
    observacoesFocus.unfocus();
  }

  /**PATRIMONIO */
  onPatrimonioSubmit([String value]) {
    patrimonioFocus.unfocus();
    descricaoFocus.requestFocus();
  }

  checkPatrimonio([String patrimonio]) async {
    Localidade localidade = await repository
        .verificaBemJaCadastrado(patrimonio ?? patrimonioController.text);
    if (localidade != null) {
      Get.dialog(AlertDialog(
        title: Text('Bem Já inventariado'),
        content: Text(
            'O bem ${descricaoController.text ?? ''} já foi inventariado na localidade ${localidade.nome}'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Get.back();
            },
          )
        ],
      ));
    }
  }

  onPatrimonioComplete([String value]) async {
    descricaoController.text =
        utilService.getDescricaoPorTombamento(patrimonioController.text);
    print(descricaoController.text);
    checkPatrimonio();
  }

  String validatorPatrimonio([String value]) {
    if (value.isEmpty && !semEtiqueta && !bemParticular) {
      return "Digite o patrimônio do bem";
    }
  }

  scanQrCode() async {
    try {
      String qrCodePatrimonio = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", false, ScanMode.DEFAULT);
      if (qrCodePatrimonio != null &&
          qrCodePatrimonio != '' &&
          qrCodePatrimonio != '-1') {
        descricaoController.text =
            utilService.getDescricaoPorTombamento(qrCodePatrimonio);
        patrimonioController.text = qrCodePatrimonio;
        checkPatrimonio(qrCodePatrimonio);
        update();
      }
    } catch (e) {
      print('Erro QR Code');
    }
  }

  toggleEtiqueta(bool value) {
    print('toggle etiqueta: $value');
    semEtiqueta = value;
    if (semEtiqueta) patrimonioController.text = '';
    update();
  }

/*   toggleParticular(bool value) {
    bemParticular = value;
    if (semEtiqueta) patrimonioController.text = '';
    update();
  } */

  /**FIM PATRIMONIO */

  /**DESCRICAO */
  onDescricaoSubmit([String value]) {
    descricaoFocus.unfocus();
    numeroSerieFocus.requestFocus();
  }

  String validatorDescricao([String value]) {
    if (value.isEmpty) return "Digite a descrição do bem";
  }
  /**FIM DESCRICAO */

  /**NUMERO SERIE */
  onNumeroSerieSubmit([String value]) {
    numeroSerieFocus.unfocus();
    observacoesFocus.requestFocus();
  }

  String validatorNumeroSerie([String value]) {
    if (value.isEmpty) return "Digite a descrição do bem";
  }
  /**FIM NUMERO SERIE */

  /**OBSERVAÇÕES */
  onObservacoesSubmit([String value]) {
    numeroSerieFocus.unfocus();
    observacoesFocus.requestFocus();
  }

  /**FIM OBSERVAÇÕES */

  onChangeRadioButton(String value) {
    print('onChangeRadioButton $value');
    radioEstado = value;
    update();
  }

  onChangeBemParticular(bool value) {
    bemParticular = value;
    if (bemParticular) {
      patrimonioController.text = '';
      semEtiqueta = true;
    }
    update();
  }

  onChangeDesfazimento(bool value) {
    indicaDesfazimento = value;
    update();
  }

  goToImagem() {
    if (imagem == null) return;
    Get.to(() => VisualizarImagemPage(imagem));
  }

  getImageTeste() async {
    File result = await utilService.getImage();
    if (result != null) imagem = result;
    update();
  }

  getImage() async {
    try {
      File onFile = await utilService.getImage();
      if (onFile != null)
        imagem = onFile;
      else
        return;
      /*  final PickedFile pickedFile = await picker.getImage(
          source: ImageSource.camera,
          maxHeight: 1920,
          maxWidth: 1920,
          imageQuality: 70);
      if (pickedFile == null) return;
      imagem = File(pickedFile.path);
      print('pickedFile: $pickedFile'); */
      update();
    } catch (e) {
      print('Erro: $e');
      utilService.snackBarErro(mensagem: 'Erro durante a captura da imagem');
    }
  }

  deletarImagem() async {
    unFocusAll();
    bool result = await Get.dialog(AlertDialog(
      title: Text('Confirmação'),
      content: Text('Deseja realmente excluir essa imagem?'),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('CANCELAR')),
        TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: Text('CONFIRMAR'))
      ],
    ));
    if (result == null) return;
    imagem = null;
    update();
  }

  onSubmit() async {
    unFocusAll();
    if (!formKey.currentState.validate()) {
      return;
    }
    try {
      utilService.showAlertCarregando('Salvando cadastro do bem...');
      Localidade teste = await repository.salvarBem(localidade,
          bemParticular: bemParticular,
          descricao: descricaoController.text,
          estadoBem: radioEstado,
          imagem: imagem,
          indicaDesfazimento: indicaDesfazimento,
          numeroSerie: numeroSerieController.text,
          observacoes: observacoesController.text,
          patrimonio: patrimonioController.text,
          semEtiqueta: semEtiqueta);
      if (Get.isDialogOpen) Get.back();
      Get.back();
      print('teste: $teste');
      utilService.snackBar(
          titulo: 'Cadastro salvo!',
          mensagem: 'O bem ${descricaoController.text} foi salvo');
    } catch (e) {
      if (Get.isDialogOpen) Get.back();
      print('Erro durante o cadastro: $e');
      /* if (e['code'] != null && e['code'] == 'bem-cadastrado') {
        utilService.snackBarErro(mensagem: e['descricao']);
      } else */
      utilService.snackBarErro(
          mensagem:
              'Ocorreu um erro durante o cadastro. Verifique as informações e tente novamente');
    }
  }
}
