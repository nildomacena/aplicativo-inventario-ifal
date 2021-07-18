import 'package:auto_size_text/auto_size_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/bem_detail_page/bem_detail_controller.dart';
import 'package:inventario_getx/services/util.service.dart';

class BemDetailPage extends StatelessWidget {
  final BemDetailController controller = Get.find();
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 19);

  Widget patrimonioField() {
    return Container(
      height: 60,
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: TextFormField(
                enabled: !controller.semEtiqueta,
                obscureText: false,
                style: style,
                readOnly: controller.bemParticular,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.number,
                controller: controller.patrimonioController,
                focusNode: controller.patrimonioFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: controller.onPatrimonioSubmit,
                onEditingComplete: controller.onPatrimonioComplete,
                validator: controller.validatorPatrimonio,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: controller.bemParticular
                        ? 'Bem Particular'
                        : "Patrimônio do bem",
                    hintStyle: TextStyle(
                        color: Colors.grey[400], fontWeight: FontWeight.w400),
                    border: UnderlineInputBorder())),
          ),
          IconButton(
              icon: Icon(FontAwesome.qrcode),
              onPressed: controller.semEtiqueta ? null : controller.scanQrCode),
          Expanded(
            flex: 5,
            child: Row(
              children: <Widget>[
                Checkbox(
                    value: controller.semEtiqueta,
                    onChanged: controller.bemParticular
                        ? null
                        : (value) {
                            controller.toggleEtiqueta(value);
                          }),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: controller.bemParticular
                        ? null
                        : () {
                            controller.toggleEtiqueta(!controller.semEtiqueta);
                          },
                    child: AutoSizeText(
                      'Sem Etiqueta?',
                      maxLines: 1,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget descricaoField() {
    return TextFormField(
        obscureText: false,
        style: style,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        controller: controller.descricaoController,
        focusNode: controller.descricaoFocus,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: controller.onDescricaoSubmit,
        validator: controller.validatorDescricao,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Descrição",
            hintStyle:
                TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w400),
            border: UnderlineInputBorder()));
  }

  Widget numeroSerieField() {
    return TextFormField(
        obscureText: false,
        style: style,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        controller: controller.numeroSerieController,
        focusNode: controller.numeroSerieFocus,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: controller.onNumeroSerieSubmit,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Número de série",
            hintStyle:
                TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w400),
            border: UnderlineInputBorder()));
  }

  Widget observacoesField() {
    return TextFormField(
        obscureText: false,
        style: style,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: TextInputType.text,
        controller: controller.observacoesController,
        focusNode: controller.observacoesFocus,
        maxLines: 2,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: controller.onObservacoesSubmit,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Observações",
            hintStyle:
                TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w400),
            border: UnderlineInputBorder()));
  }

  Widget containerEstado() {
    return Container(
      height: 80,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(5, 15, 5, 0),
            padding: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Radio(
                    value: 'uso',
                    groupValue: controller.radioEstado,
                    onChanged: (value) {
                      controller.onChangeRadioButton(value);
                    }),
                GestureDetector(
                  child: Text(
                    'Em uso',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    controller.onChangeRadioButton('uso');
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                Radio(
                  value: 'ocioso',
                  groupValue: controller.radioEstado,
                  onChanged: (value) {
                    controller.onChangeRadioButton(value);
                  },
                ),
                GestureDetector(
                  child: Text(
                    'Ocioso',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    controller.onChangeRadioButton('ocioso');
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                Radio(
                  value: 'danificado',
                  groupValue: controller.radioEstado,
                  onChanged: (value) {
                    controller.onChangeRadioButton(value);
                  },
                ),
                GestureDetector(
                  child: AutoSizeText(
                    'Danificado',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    controller.onChangeRadioButton('danificado');
                  },
                ),
              ],
            ),
          ),
          Positioned(
              top: 5,
              left: 20,
              child: Center(
                  child: Container(
                      color: Colors.white,
                      child: Text(
                        'Estado do bem',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      ))))
        ],
      ),
    );
  }

  Widget checkBemParticular() {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: .1)),
      height: 60,
      width: Get.width,
      child: Row(
        children: <Widget>[
          Checkbox(
              value: controller.bemParticular,
              onChanged: (value) {
                controller.onChangeBemParticular(value);
              }),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                controller.onChangeBemParticular(!controller.bemParticular);
              },
              child: Text(
                'Bem Particular?',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget checkDesfazimento() {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: .1)),
      height: 60,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
              value: controller.indicaDesfazimento,
              onChanged: (value) {
                controller.onChangeDesfazimento(value);
              }),
          GestureDetector(
            onTap: () {
              controller.onChangeDesfazimento(!controller.indicaDesfazimento);
            },
            child: Text(
              'Indica bem para Desfazimento?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget salvarButton() {
    print('controller.formValid - ${controller.formValid}');
    return Container(
        //alignment: Alignment.center,
        margin: EdgeInsets.only(top: 20),
        width: Get.width,
        height: 50,
        child: RaisedButton(
            color: Colors.green,
            splashColor: Colors.white,
            child: Text(
              'Salvar',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            onPressed:
                /* !controller.formValid
                ? null
                :  */
                () {
              controller.onSubmit();
            }));
  }

  Widget cardCorrecao() {
    return Container(
      width: Get.width,
      height: 60,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red[200],
                ),
                width: Get.width,
                height: 100,
                child: Container(
                  margin: EdgeInsets.only(top: 10, left: 10, right: 15),
                  child: AutoSizeText(
                    'Correção solicitada: ${controller.correcao.motivo}',
                    maxLines: 2,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )),
          Positioned(
            top: -5,
            right: 0,
            child: IconButton(
              splashColor: Colors.grey,
              icon: Icon(Icons.close),
              color: Colors.black,
              onPressed: () {
                print('close');
                controller.toggleExibirCorrecao();
              },
              iconSize: 15,
            ),
          )
        ],
      ),
    );
  }

  Widget rowFoto() {
    print(controller.bem.imagem);
    return Container(
      height: 250,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
                child: controller.imagem != null
                    ? Image.file(
                        controller.imagem,
                        fit: BoxFit.cover,
                      )
                    : ExtendedImage.network(
                        controller.bem.imagem,
                        fit: BoxFit.cover,
                      ),
                onTap: () {
                  controller.goToImagem();
                }),
          ),
          /* Expanded(
              child: controller.imagem != null && controller.bem.imagem != null
                  ? GestureDetector(
                      child: Hero(
                        tag: controller.imagem.path,
                        child: controller.imagem != null
                            ? Image.file(
                                controller.imagem,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                controller.bem.imagem,
                                fit: BoxFit.cover,
                              ),
                      ),
                      onTap: () {
                        controller.goToImagem();
                      })
                  : Container(
                      child: Center(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              controller.getImage();
                            },
                            icon: Icon(Icons.photo),
                            label: Text('Adicionar Imagem')),
                      ),
                    )), */
          Divider(),
          if (controller.imagem != null)
            ElevatedButton.icon(
              onPressed: () {
                controller.deletarImagem();
              },
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              label: Text(
                'Apagar Imagem',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor: utilService.colorButton(Colors.red)),
            ),
          if (controller.imagem == null)
            ElevatedButton.icon(
              onPressed: () {
                controller.getImage();
              },
              icon: Icon(
                Icons.photo,
                color: Colors.white,
              ),
              label: Text(
                'Alterar Imagem',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor: utilService.colorButton(Colors.green)),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Bem'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                controller.deletarBem(controller.bem);
              })
        ],
      ),
      body: Container(
        child: GetBuilder<BemDetailController>(
          builder: (_) {
            print('Bem: ${controller.bem.imagem}');
            return Container(
              //padding: EdgeInsets.only(top: 10),
              child: Form(
                key: controller.formKey,
                child: ListView(
                  children: <Widget>[
                    rowFoto(),
                    if (controller.correcao != null &&
                        controller.exibirCorrecao)
                      cardCorrecao(),
                    patrimonioField(),
                    descricaoField(),
                    numeroSerieField(),
                    containerEstado(),
                    Divider(),
                    checkBemParticular(),
                    checkDesfazimento(),
                    observacoesField(),
                    salvarButton()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
