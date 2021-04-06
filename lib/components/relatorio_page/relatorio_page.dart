import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/relatorio_page/relatorio_controller.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/services/util.service.dart';

class RelatorioPage extends StatelessWidget {
  final RelatorioController controller = Get.find();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 19);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.localidade.nome),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: GetBuilder<RelatorioController>(builder: (_) {
          print('localidadadse relatório: ${_.localidade}');

          return Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      height: 80,
                      color: controller.imagem != null &&
                              !controller.localidade.possuiImagemRelatorio
                          ? Colors.grey
                          : Colors.white,
                      alignment: Alignment.center,
                      child: controller.imagem != null
                          ? Image.file(
                              controller.imagem,
                              fit: BoxFit.cover,
                            )
                          : controller.localidade.possuiImagemRelatorio
                              ? Image.network(
                                  controller.localidade.imagemRelatorio,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.photo))),
              RaisedButton(
                  child: Text(controller.localidade.possuiImagemRelatorio
                      ? 'ALTERAR FOTO DO RELATÓRIO'
                      : controller.imagem == null
                          ? 'ADICIONAR FOTO DO RELATÓRIO'
                          : 'ALTERAR FOTO'),
                  color: Colors.green[200],
                  onPressed: controller.getImage),
              Divider(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: TextField(
                    maxLines: 8,
                    textCapitalization: TextCapitalization.sentences,
                    controller: controller.textEditingController,
                    decoration: InputDecoration(hintText: 'Observações'),
                    style: style,
                  ),
                ),
              ),
              if (controller.localidade.status == Status.finalizado)
                Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Container(
                      /* height: 50,
                      width: 200, */
                      child: RaisedButton(
                        child: Text(
                          controller.salvando
                              ? 'SALVANDO...'
                              : 'REABRIR LOCALIDADE',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        color: Colors.green,
                        disabledColor: Colors.grey,
                        onPressed: controller.onSubmit,
                      ),
                    )),
              if (controller.localidade.status != Status.finalizado)
                Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Container(
                      child: ElevatedButton(
                        child: Text(
                          controller.salvando
                              ? 'SALVANDO...'
                              : 'FINALIZAR LOCALIDADE',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        style: ButtonStyle(
                            backgroundColor: controller.imagem != null
                                ? utilService.colorButton(Colors.green)
                                : utilService.colorButton(Colors.grey)),
                        onPressed:
                            controller.imagem == null || controller.salvando
                                ? null
                                : controller.onSubmit
                        /*  setState(() {
                                  controller.salvando = true;
                                });
                                try {
                                  List<Localidade> localidades =
                                      await fireService.finalizarLocalidade(
                                          widget.localidade,
                                          controller.imagem,
                                          textEditingController.text);
                                  //Get.offAll(HomePage(localidades));
                                  Get.offAll(HomePage());
                                } catch (e) {
                                  setState(() {
                                    controller.salvando = false;
                                  });
                                  utilService.showSnackBarErro();
                                } */
                        ,
                      ),
                    ))
            ],
          );
        }),
      ),
    );
  }

  /* @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(controller.localidade.nome),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(child: GetBuilder<RelatorioController>(builder: (_) {
                return Container(
                    height: 80,
                    color: controller.imagem != null &&
                            !controller.localidade.possuiImagemRelatorio
                        ? Colors.grey
                        : Colors.white,
                    alignment: Alignment.center,
                    child: controller.imagem != null
                        ? Image.file(
                            controller.imagem,
                            fit: BoxFit.cover,
                          )
                        : controller.localidade.possuiImagemRelatorio
                            ? Image.network(
                                controller.localidade.imagemRelatorio,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.photo));
              })),
              RaisedButton(
                  child: Text(controller.localidade.possuiImagemRelatorio
                      ? 'ALTERAR FOTO DO RELATÓRIO'
                      : controller.imagem == null
                          ? 'ADICIONAR FOTO DO RELATÓRIO'
                          : 'ALTERAR FOTO'),
                  color: Colors.green[200],
                  onPressed: controller.getImage),
              Divider(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: TextField(
                    maxLines: 8,
                    textCapitalization: TextCapitalization.sentences,
                    controller: controller.textEditingController,
                    decoration: InputDecoration(hintText: 'Observações'),
                    style: style,
                  ),
                ),
              ),
              if (controller.localidade.status == Status.finalizado)
                Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: Container(
                      /* height: 50,
                      width: 200, */
                      child: RaisedButton(
                        child: Text(
                          controller.salvando
                              ? 'SALVANDO...'
                              : 'REABRIR LOCALIDADE',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        color: Colors.green,
                        disabledColor: Colors.grey,
                        onPressed: () async {
                          /* setState(() {
                            controller.salvando = true;
                          });
                          try {
                            Localidade localidade = await fireService
                                .reabrirLocalidade(widget.localidade);
                            Get.back(result: localidade);
                          } catch (e) {
                            setState(() {
                              controller.salvando = false;
                            });
                            utilService.showSnackBarErro();
                          } */
                        },
                      ),
                    )),
              if (controller.localidade.status != Status.finalizado)
                GetBuilder(builder: (_) {
                  return Container(
                      height: 60,
                      alignment: Alignment.center,
                      child: Container(
                        child: ElevatedButton(
                          child: Text(
                            controller.salvando
                                ? 'SALVANDO...'
                                : 'FINALIZAR LOCALIDADE',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          style: ButtonStyle(
                              backgroundColor: controller.imagem != null
                                  ? utilService.colorButton(Colors.green)
                                  : utilService.colorButton(Colors.grey)),
                          onPressed:
                              controller.imagem == null || controller.salvando
                                  ? null
                                  : () async {
                                      /*  setState(() {
                                  controller.salvando = true;
                                });
                                try {
                                  List<Localidade> localidades =
                                      await fireService.finalizarLocalidade(
                                          widget.localidade,
                                          controller.imagem,
                                          textEditingController.text);
                                  //Get.offAll(HomePage(localidades));
                                  Get.offAll(HomePage());
                                } catch (e) {
                                  setState(() {
                                    controller.salvando = false;
                                  });
                                  utilService.showSnackBarErro();
                                } */
                                    },
                        ),
                      ));
                })
            ],
          ),
        ));
  } */
}
