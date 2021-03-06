import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/login_page/custom_widgets/select_campus_modal.dart';
import 'package:inventario_getx/components/login_page/login_repository.dart';
import 'package:inventario_getx/data/model/campus.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/data/model/usuario.dart';
import 'package:inventario_getx/routes/app_routes.dart';
import 'package:inventario_getx/services/util.service.dart';
import 'package:vibration/vibration.dart';

class LoginController extends GetxController {
  final LoginRepository repository;
  final formKey = GlobalKey<FormState>();
  List<Campus> campi = [];
  Campus campusSelecionado;
  Campus campusEscolhido;
  String ultimoEmail;

  TextEditingController emailController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController siapeController = TextEditingController();
  TextEditingController cpfController =
      MaskedTextController(mask: '000.000.000-00');
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode siapeFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode nomeFocus = FocusNode();
  FocusNode cpfFocus = FocusNode();

  bool salvando = false;
  bool signUp = false;
  LoginController({@required this.repository}) : assert(repository != null);

  final _obj = ''.obs;
  set obj(value) => this._obj.value = value;
  get obj => this._obj.value;

  @override
  void onInit() async {
    /*  passwordController.text = 'q1w2e3';
    emailController.text = 'ednildo.filho@ifal.edu.br'; */
    campi = await repository.getCampi();
    getUltimoEmail();
    super.onInit();
  }

  //APENAS PARA TESTES
  testarVibracao() async {
    try {
      String qrCodePatrimonio = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", false, ScanMode.DEFAULT);
    } catch (e) {}
    if (await Vibration.hasVibrator()) {
      await FlutterBeep.beep();
      await Vibration.vibrate();
    }
  }

  getUltimoEmail() async {
    ultimoEmail = await repository.getUltimoEmail();
    emailController.text = ultimoEmail;
    update();
  }

  void onEmailSubmit([String email]) {
    if (signUp) {
      nomeFocus.requestFocus();
    } else {
      passwordFocus.requestFocus();
    }
  }

  onPasswordSubmit([String nome]) {
    if (signUp) {
      confirmPasswordFocus.requestFocus();
    } else {
      onSubmit();
    }
  }

  onCpfSubmit([String nome]) {
    siapeFocus.requestFocus();
  }

  onSiapeSubmit([String nome]) {
    passwordFocus.requestFocus();
  }

  onNomeSubmit([String nome]) {
    cpfFocus.requestFocus();
  }

  onConfirmPasswordSubmit([String value]) {
    onSubmit();
  }

  String validatorEmail(String value) {
    if (value.isEmpty) {
      return 'Digite o seu email';
    }
    if (!value.contains(RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$"))) {
      return 'Digite um email v??lido';
    }
    if (!value.contains('@ifal.edu.br')) {
      return 'Digite o seu email institucional';
    }
  }

  String validatorNome(String value) {
    if (value.isEmpty) {
      return 'Digite seu nome completo';
    }
  }

  String validatorPassword(String value) {
    if (value.length < 6) {
      return 'Senha muito curta';
    }
  }

  String validatorCpf([String value]) {
    if (value.isEmpty) {
      return 'Digite seu CPF completo';
    }
  }

  String validatorSiape([String value]) {
    if (value.isEmpty) {
      return 'Digite seu n??mero SIAPE completo';
    }
  }

  toggleSignup() {
    signUp = !signUp;
    update();
  }

  toggleSalvando(bool value) {
    salvando = value;
  }

  openModalCampi() {
    print('Campi: $campi');
    Get.to(() => SelectCampusModal(Get.find()), fullscreenDialog: true);
  }

  onSelectCampus(Campus campus) {
    if (campusSelecionado != null && campus.id.contains(campusSelecionado.id))
      campusSelecionado = null;
    else
      campusSelecionado = campus;
    print('campusSelecionado: $campusSelecionado');
    update();
  }

  onDefineCampus() {
    if (campusSelecionado == null) {
      utilService.snackBarErro(mensagem: 'Escolha primeiro um  campus');
      return;
    }
    campusEscolhido = campusSelecionado;
    update();
    Get.back();
  }

  redefinirSenha() async {
    if (emailController.text.isEmpty ||
        !emailController.text.isEmail ||
        !emailController.text.toLowerCase().contains('@ifal.edu.br')) {
      utilService.snackBarErro(
          mensagem: 'Digite um email institucional v??lido');
      return;
    }
    bool confirma = await Get.dialog(AlertDialog(
      title: Text('Confirma????o'),
      content:
          Text('Deseja realmente enviar um email de recupera????o de senha ?'),
      actions: [
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: Text('Confirma'),
          onPressed: () {
            Get.back(result: true);
          },
        )
      ],
    ));
    if (confirma == null || !confirma) {
      return;
    }
    try {
      await repository.redefinirSenha(emailController.text);
      utilService.snackBar(
          titulo: 'Email enviado',
          mensagem: 'Acesse sua caixa de email para redefinir a senha');
    } catch (e) {
      utilService.snackBarErro(
          titulo: 'Ocorreu um erro durante o processo',
          mensagem:
              'Tente novamente, caso o erro persista, entre em contato com o administrador do sistema');
    }
  }

  onSubmit() async {
    print('onSubmit: ${formKey.currentState.validate()}');
    if (formKey.currentState.validate()) {
      try {
        Usuario usuario;
        print('onSubmit: $signUp');
        utilService.showAlertCarregando('Fazendo login...');
        if (!signUp)
          usuario = await repository.login(
              emailController.text, passwordController.text);
        else {
          if (campusEscolhido == null) {
            utilService.snackBarErro(
                mensagem: 'Seleciona um campus para realizar o cadastro');
            return;
          }
          usuario = await repository.createUser(
              campus: campusEscolhido,
              email: emailController.text,
              nome: nomeController.text,
              cpf: cpfController.text,
              siape: siapeController.text,
              password: passwordController.text);
        }
        if (usuario == null) return;
        List<Localidade> localidades =
            await repository.getLocalidadesByUsuario(usuario);

        print('result: $localidades');
        if (Get.isDialogOpen) Get.back();
        Get.offAllNamed(Routes.LOCALIDADES,
            arguments: {'localidades': localidades});
        if (localidades.isEmpty) {
          utilService.snackBarErro(
              mensagem:
                  'N??o foram encontradas localidades para esse usu??rio.\nEntre em contato com os administradores');
        }
      } on FirebaseAuthException catch (e) {
        if (Get.isDialogOpen) Get.back();
        if (e.code.contains('user-not-found')) {
          utilService.snackBarErro(mensagem: 'Usu??rio n??o encontrado');
        }
        if (e.code.contains('wrong-password')) {
          utilService.snackBarErro(mensagem: 'Senha incorreta');
        }
        if (e.code.contains('email-already-in-use')) {
          utilService.snackBarErro(
              mensagem: 'Esse email j?? est?? sendo utilizado');
        }
        if (e.code.contains('usuario-ja-cadastrado')) {
          utilService.snackBarErro(
              mensagem: 'Esse email j?? est?? sendo utilizado');
        }
      } catch (e) {
        if (Get.isDialogOpen) Get.back();
        if (e.runtimeType == String && e.contains('pre-cadastro-inexistente'))
          utilService.snackBarErro(
              mensagem:
                  'Seu pr??-cadastro n??o foi realizado.\nEntre em contato com a comiss??o do seu campus.');
        else
          utilService.snackBarErro(mensagem: 'Erro durante o login');
        print('erro ao fazer login $e');
      }
    }
  }
}
