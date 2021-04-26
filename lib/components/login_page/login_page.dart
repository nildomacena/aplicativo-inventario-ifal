import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/login_page/login_controller.dart';

class LoginPage extends StatelessWidget {
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 17);
  final LoginController controller = Get.find();

  Widget selectCampus() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(32.0)),
      child: TextButton(
        child: Text(controller.campusEscolhido != null
            ? 'Campus: ' + controller.campusEscolhido.nome.toUpperCase()
            : 'SELECIONAR CAMPUS'),
        onPressed: controller.openModalCampi,
      ),
    );
  }

  Widget emailField() {
    return GetBuilder<LoginController>(builder: (_) {
      return TextFormField(
        obscureText: false,
        style: style,
        controller: controller.emailController,
        focusNode: controller.emailFocus,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email Institucional",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        onFieldSubmitted: controller.onEmailSubmit,
        validator: controller.validatorEmail,
      );
    });
  }

  Widget passwordField() {
    return GetBuilder<LoginController>(builder: (_) {
      return TextFormField(
        obscureText: true,
        style: style,
        controller: controller.passwordController,
        focusNode: controller.passwordFocus,
        textInputAction:
            controller.signUp ? TextInputAction.next : TextInputAction.send,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Senha",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        onFieldSubmitted: controller.onPasswordSubmit,
        validator: controller.validatorPassword,
      );
    });
  }

  Widget esqueciSenhaBotao() {
    return TextButton(
      child: Text('Esqueci a senha'),
      onPressed: () {
        controller.redefinirSenha();
      },
    );
  }

  Widget confirmPasswordField() {
    return GetBuilder<LoginController>(builder: (_) {
      return TextFormField(
        obscureText: true,
        style: style,
        controller: controller.confirmPasswordController,
        focusNode: controller.confirmPasswordFocus,
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Repita a Senha",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        onFieldSubmitted: controller.onConfirmPasswordSubmit,
        validator: controller.validatorPassword,
      );
    });
  }

  Widget submitButton() {
    return GetBuilder<LoginController>(builder: (_) {
      print('salvando? ${controller.salvando}');
      return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.green,
        child: MaterialButton(
          minWidth: Get.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          disabledColor: Colors.grey[300],
          onPressed: controller.salvando ||
                  (controller.signUp && controller.campusEscolhido == null)
              ? null
              : controller.onSubmit,
          child: Text(
              controller.salvando
                  ? 'Aguarde...'
                  : controller.signUp
                      ? "Cadastrar"
                      : "Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    });
  }

  Widget toggleSignUpButton() {
    return GetBuilder<LoginController>(builder: (_) {
      return TextButton(
        //color: Colors.white,
        child: Text(controller.signUp ? "Já tenho usuário" : "Cadastre-se",
            style: style.copyWith(
                fontSize: 17,
                color: Colors.green,
                fontWeight: FontWeight.bold)),
        onPressed: () {
          controller.toggleSignup();
        },
      );
    });
  }

  Widget nomeField() {
    return TextFormField(
        style: style,
        controller: controller.nomeController,
        focusNode: controller.nomeFocus,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nome",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        onFieldSubmitted: controller.onNomeSubmit,
        validator: controller.validatorNome);
  }

  Widget cpfField() {
    return TextFormField(
        style: style,
        controller: controller.cpfController,
        focusNode: controller.cpfFocus,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "CPF",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        onFieldSubmitted: controller.onCpfSubmit,
        validator: controller.validatorCpf);
  }

  Widget siapeField() {
    return TextFormField(
        style: style,
        controller: controller.siapeController,
        focusNode: controller.siapeFocus,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "SIAPE",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        onFieldSubmitted: controller.onSiapeSubmit,
        validator: controller.validatorSiape);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text('teste'),
      ), */
      body: Container(
          color: Colors.grey[300],
          /* height: Get.height,
        width: Get.width, */
          child: GetBuilder<LoginController>(
            builder: (_) {
              return Form(
                key: controller.formKey,
                child: SafeArea(
                  child: Center(
                    child: Card(
                      margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        //padding: EdgeInsets.all(30),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                            ),
                            Container(
                              child: Text(
                                'INVENTÁRIO IFAL',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 2.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 1.0,
                                        color: Color.fromARGB(125, 0, 0, 255),
                                      ),
                                    ],
                                    color: Get.theme.primaryColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (controller.ultimoEmail == null)
                              Container(
                                padding: EdgeInsets.only(top: 100, bottom: 100),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            if (controller.ultimoEmail != null)
                              Column(
                                children: [
                                  Divider(),
                                  emailField(),
                                  if (controller.signUp)
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: nomeField(),
                                    ),
                                  if (controller.signUp)
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: cpfField(),
                                    ),
                                  if (controller.signUp)
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: siapeField(),
                                    ),
                                  if (controller.signUp) selectCampus(),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: passwordField(),
                                  ),
                                  if (controller.signUp) confirmPasswordField(),
                                  if (!controller.signUp) esqueciSenhaBotao(),
                                  toggleSignUpButton(),
                                  submitButton(),
                                  Padding(padding: EdgeInsets.all(20))
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
