import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/login_page/login_repository.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/data/model/usuario.dart';
import 'package:inventario_getx/routes/app_routes.dart';
import 'package:inventario_getx/services/util.service.dart';

class LoginController extends GetxController {
  final LoginRepository repository;
  final formKey = GlobalKey<FormState>();

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
  void onInit() {
    passwordController.text = 'q1w2e3';
    emailController.text = 'ednildo.filho@ifal.edu.br';
    super.onInit();
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
      return 'Digite um email válido';
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
      return 'Digite seu número SIAPE completo';
    }
  }

  toggleSignup() {
    signUp = !signUp;
    update();
  }

  toggleSalvando(bool value) {
    salvando = value;
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
        else
          usuario = await repository.createUser(
              email: emailController.text,
              nome: nomeController.text,
              cpf: cpfController.text,
              siape: siapeController.text,
              password: passwordController.text);
        List<Localidade> localidades =
            await repository.getLocalidadesByUsuario(usuario);

        print('result: $localidades');
        if (Get.isDialogOpen) Get.back();
        Get.offAllNamed(Routes.LOCALIDADES,
            arguments: {'localidades': localidades});
        if (localidades.isEmpty) {
          utilService.snackBarErro(
              mensagem:
                  'Não foram encontradas localidades para esse usuário.\nEntre em contato com os administradores');
        }
      } on PlatformException catch (e) {
        if (Get.isDialogOpen) Get.back();
        if (e.code.contains('user-not-found')) {
          utilService.snackBarErro(mensagem: 'Usuário não encontrado');
        }
        if (e.code.contains('wrong-password')) {
          utilService.snackBarErro(mensagem: 'Senha incorreta');
        }
        if (e.code.contains('email-already-in-use')) {
          utilService.snackBarErro(
              mensagem: 'Esse email já está sendo utilizado');
        }
      } catch (e) {
        if (Get.isDialogOpen) Get.back();
        if (e != null && e.code != null) {
          if (e.code.contains('user-not-found')) {
            utilService.snackBarErro(mensagem: 'Usuário não encontrado');
          }
          if (e.code.contains('email-already-in-use')) {
            utilService.snackBarErro(
                mensagem: 'Esse email já está sendo utilizado');
          }
          if (e.code.contains('wrong-password')) {
            utilService.snackBarErro(mensagem: 'Senha incorreta');
          }
        }
        print('erro ao fazer login $e');
      }
    }
  }
}
