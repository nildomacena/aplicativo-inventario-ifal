import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/localidade_detail_page/localidade_detail.controller.dart';
import 'package:inventario_getx/data/model/localidade.dart';

class CardDadosGerais extends StatelessWidget {
  final LocalidadeDetailController controller;
  CardDadosGerais({@required this.controller}) : assert(controller != null);
  TextStyle textStyleDados =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    return GetX<LocalidadeDetailController>(builder: (_) {
      if (_.localidade == null)
        return Center(child: CircularProgressIndicator());
      return Card(
        elevation: 5,
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Container(
          padding: EdgeInsets.all(10),
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 2),
                child: Text(
                  'Localidade: ${_.localidade.nome}',
                  style: textStyleDados,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 2),
                child: Text(
                  'Bens cadastrados: ${_.bens.length}',
                  style: textStyleDados,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 2),
                child: Text(
                  'Status: ${_.localidade.statusAsString}',
                  style: textStyleDados,
                ),
              ),
              Container(
                height: 80,
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlineButton(
                      splashColor: Colors.green,
                      color: Colors.green,
                      child: Text('PANORÂMICAS'),
                      onPressed: controller.goToPanoramicas,
                    ),
                    OutlineButton(
                      splashColor: Colors.green,
                      child: Text('RELATÓRIO'),
                      onPressed: controller.goToRelatorio,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
