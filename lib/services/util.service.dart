import 'dart:convert';
import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:camerawesome/camerapreview.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:inventario_getx/data/model/descricaoBem.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<File> getImage() async {
    PictureController _pictureController = new PictureController();
    ValueNotifier<double> _zoomNotifier = ValueNotifier(0);
    final Directory extDir = await getTemporaryDirectory();
    ValueNotifier<CameraFlashes> _switchFlash =
        ValueNotifier(CameraFlashes.AUTO);
    ValueNotifier<Size> _photoSize = ValueNotifier(null);
    ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);

    ValueNotifier<CaptureModes> _captureMode =
        ValueNotifier(CaptureModes.PHOTO);

    final String filePath =
        '${extDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    /* await _pictureController.takePicture(filePath);
    File imagem = File(filePath);
    print(imagem);
    return imagem; */
    File imageAux = await Get.to(Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CameraAwesome(
              testMode: false,
              onPermissionsResult: (bool result) {},
              /* selectDefaultSize: (List<Size> availableSizes) =>
                  Size(Get.height, Get.width), */
              onCameraStarted: () {},
              onOrientationChanged: (CameraOrientations newOrientation) {},
              zoom: _zoomNotifier,
              sensor: _sensor,
              photoSize: _photoSize,
              switchFlashMode: _switchFlash,
              captureMode: _captureMode,
              //orientation: DeviceOrientation.portraitUp,
              fitted: true,
            ),
            Positioned(
                bottom: 20,
                child: Container(
                  alignment: Alignment.center,
                  width: Get.width,
                  child: IconButton(
                    color: Colors.green,
                    hoverColor: Colors.green,
                    onPressed: () async {
                      await _pictureController.takePicture(filePath);
                      File imagem = File(filePath);
                      Get.back(result: imagem);
                    },
                    icon: Icon(
                      Icons.camera,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
    if (imageAux == null) return imageAux;
    File image = await FlutterImageCompress.compressAndGetFile(
      imageAux.absolute.path,
      '${extDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      minWidth: 1920,
      minHeight: 1920,
      quality: 70,
    );
    await imageAux.delete();
    return image;
  }

  Future<File> getImageBkp() {
    return Get.to(Scaffold(
      body: SafeArea(
        child: CameraCamera(
            enableZoom: true,
            resolutionPreset: ResolutionPreset.ultraHigh,
            onFile: (file) {
              Get.back(result: file);
            }),
      ),
    ));
  }
}

UtilService utilService = UtilService();
