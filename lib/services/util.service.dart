import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:inventario_getx/data/model/descricaoBem.dart';

class UtilService {
  List<DescricaoBem> listaDescricao = [];

  initJson() async {
    String data = await rootBundle.loadString('assets/csvjson.json');
    List<dynamic> jsonResult = json.decode(data);
    jsonResult.forEach((value) {
      listaDescricao.add(DescricaoBem.fromMap(value));
    });
    print('jsonResult: ${listaDescricao.length}');
  }

  String getDescricaoPorTombamento(String tombamento) {
    String descricao = '';
    print(
        'listaDescricao: ${listaDescricao[100].tombamento} - ${listaDescricao[100].tombamento.runtimeType}');
    List<DescricaoBem> pesquisa = listaDescricao
        .where(
            (element) => element.tombamento.toString() == tombamento.toString())
        .toList();
    print('descricao por tombamento: $tombamento - ${pesquisa.length}');
    if (pesquisa.isNotEmpty) {
      descricao = pesquisa[0].denominacao;
    }
    return descricao;
  }

  void snackBarErro({String titulo, String mensagem}) {
    Get.snackbar(
      titulo ?? 'Erro',
      mensagem ?? 'Erro durante a operação',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
      duration: Duration(seconds: 5),
    );
  }

  void snackBar(
      {@required String titulo,
      @required String mensagem,
      SnackPosition snackPosition,
      Function action}) {
    Get.snackbar(
      titulo,
      mensagem,
      snackPosition: snackPosition ?? SnackPosition.TOP,
      backgroundColor: Colors.white,
      //colorText: Colors.white,
      margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
      duration: Duration(seconds: 5),
    );
  }

  showAlert(String titulo, String mensagem,
      {Function action, String actionLabel}) {
    return Get.dialog(
      AlertDialog(
        title: Text(titulo),
        content: Container(
          child: Text(mensagem),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('CANCELAR')),
          if (action != null)
            TextButton(onPressed: action, child: Text(actionLabel)),
        ],
      ),
    );
  }

  void showAlertCarregando([String mensagem]) {
    Get.dialog(
        AlertDialog(
            content: Container(
                height: 80,
                child: Column(children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text(
                    mensagem ?? 'Fazendo consulta...',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.primaryColor),
                  )
                ]))),
        barrierDismissible: false);
  }

  MaterialStateProperty<Color> colorButton(MaterialColor color) {
    return MaterialStateProperty.all<Color>(color);
  }
}

UtilService utilService = UtilService();
