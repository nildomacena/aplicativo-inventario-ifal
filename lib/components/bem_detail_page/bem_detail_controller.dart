import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventario_getx/components/bem_detail_page/bem_detail_repository.dart';
import 'package:inventario_getx/custom_widgets/visualizar_imagem_page.dart';
import 'package:inventario_getx/data/model/bem.dart';
import 'package:inventario_getx/data/model/correcao.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/services/util.service.dart';

class BemDetailController extends GetxController {
  Localidade localidade;
  Bem bem;
  Correcao correcao;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  String radioEstado;
  File imagem;
  bool exibirCorrecao = true;

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

  final BemDetailRepository repository;
  BemDetailController({@required this.repository})
      : assert(repository != null) {
    bem = Get.arguments['bem'];
    localidade = Get.arguments['localidade'];
    correcao = Get.arguments['correcao'];
    initForm();
  }

  bool get formValid =>
      imagem != null ||
      patrimonioController.text != bem.patrimonio ||
      descricaoController.text != bem.descricao ||
      numeroSerieController.text != bem.numeroSerie ||
      observacoesController.text != bem.observacoes ||
      bemParticular != bem.bemParticular ||
      semEtiqueta != bem.semEtiqueta ||
      indicaDesfazimento != bem.indicaDesfazimento ||
      radioEstado != bem.estadoBem;

  initForm() {
    patrimonioController.text = bem.patrimonio;
    descricaoController.text = bem.descricao;
    numeroSerieController.text = bem.numeroSerie;
    observacoesController.text = bem.observacoes;
    bemParticular = bem.bemParticular;
    semEtiqueta = bem.semEtiqueta;
    indicaDesfazimento = bem.indicaDesfazimento;
    radioEstado = bem.estadoBem;
    //update();
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
    update();
  }

  onPatrimonioComplete([String value]) async {
    descricaoController.text =
        utilService.getDescricaoPorTombamento(patrimonioController.text);
    print(descricaoController.text);
    /* Localidade localidade =
        await repository.verificaBemJaCadastrado(patrimonioController.text); */
    /* if (localidade != null) {
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
    } */
    update();
  }

  String validatorPatrimonio([String value]) {
    if (value.isEmpty && !semEtiqueta && !bemParticular) {
      return "Digite o patrimônio do bem";
    }
    update();
  }

  toggleExibirCorrecao() {
    exibirCorrecao = false;
    update();
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
    update();
  }

  deletarBem(Bem bem) async {
    var result = await Get.dialog(
      AlertDialog(
        title: Text('Excluir Bem'),
        content: Text(
            'Deseja realmente excluir o bem ${bem.descricao}?\nATENÇÃO: Essa operação não pode ser desfeita!'),
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
              child: Text('EXCLUIR BEM')),
        ],
      ),
    );
    if (result == null || !result) {
      return;
    }
    utilService.showAlertCarregando('Aguarde...');
    try {
      await repository.deletarBem(bem);
      if (Get.isDialogOpen) Get.back();
      Get.back();
      utilService.snackBar(
          titulo: 'Bem excluído',
          mensagem: 'O bem ${bem.descricao} foi excluído ');
    } catch (e) {
      if (Get.isDialogOpen) Get.back();
      utilService.snackBarErro();
    }
  }

  String validatorDescricao([String value]) {
    if (value.isEmpty) return "Digite a descrição do bem";
  }
  /**FIM DESCRICAO */

  /**NUMERO SERIE */
  onNumeroSerieSubmit([String value]) {
    numeroSerieFocus.unfocus();
    observacoesFocus.requestFocus();
    update();
  }

  String validatorNumeroSerie([String value]) {
    if (value.isEmpty) return "Digite a descrição do bem";
  }
  /**FIM NUMERO SERIE */

  /**OBSERVAÇÕES */
  onObservacoesSubmit([String value]) {
    numeroSerieFocus.unfocus();
    observacoesFocus.requestFocus();
    update();
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
    Get.to(() => VisualizarImagemPage(imagem != null ? imagem : bem.imagem));
  }

  getImage() async {
    try {
      /* final PickedFile pickedFile = await picker.getImage(
          source: ImageSource.camera,
          maxHeight: 1920,
          maxWidth: 1920,
          imageQuality: 70);
      if (pickedFile == null) return;
      imagem = File(pickedFile.path);
      print('pickedFile: $pickedFile'); */
      File onFile = await utilService.getImage();
      if (onFile != null)
        imagem = onFile;
      else
        return;
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
    if (!formValid) {
      Get.back();
      utilService.snackBar(
          titulo: 'Cadastro inalterado',
          mensagem: 'O cadastro não foi alterado');
      return;
    }
    try {
      utilService.showAlertCarregando('Salvando cadastro do bem...');
      await repository.alterarBem(
          bemAntigo: bem,
          bemParticular: bemParticular,
          descricao: descricaoController.text,
          estadoBem: radioEstado,
          imagem: imagem,
          indicaDesfazimento: indicaDesfazimento,
          numeroSerie: numeroSerieController.text,
          observacoes: observacoesController.text,
          patrimonio: patrimonioController.text,
          semEtiqueta: semEtiqueta,
          correcao: correcao);
      if (Get.isDialogOpen) Get.back();
      Get.back();
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
