import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/fotos_panoramicas_page/fotos_panoramicas_controller.dart';
import 'package:inventario_getx/services/util.service.dart';

class FotosPanoramicasPage extends StatelessWidget {
  FotosPanoramicasController controller = Get.find();

  Widget containerImagem(Map imagem) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (imagem['type'] == File)
            GestureDetector(
              onTap: () {
                controller.goToImagem(imagem['file']);
              },
              child: ExtendedImage.file(
                imagem['file'],
                fit: BoxFit.cover,
              ),
            ),
          if (imagem['type'] == String)
            GestureDetector(
              onTap: () {
                controller.goToImagem(imagem['file']);
              },
              child: ExtendedImage.network(
                imagem['file'],
                fit: BoxFit.cover,
              ),
            ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  controller.deleteImage(imagem);
                }),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotos Panorâmicas'),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt), onPressed: controller.getImage),
      body: Container(
        child: GetBuilder<FotosPanoramicasController>(builder: (_) {
          return Stack(
            fit: StackFit.expand,
            children: [
              StaggeredGridView.countBuilder(
                itemCount: controller.images.length,
                crossAxisCount: 2,
                staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: EdgeInsets.all(3),
                      child: containerImagem(controller.images[index]));
                  /* Image.file()
                            _images[index],
                            fit: BoxFit.cover,
                          )); */
                },
              ),
              Positioned(
                bottom: 0,
                right: (Get.width / 50) + 100,
                child: Container(
                  width: 200,
                  child: TextButton(
                    onPressed: controller.imagesFile.isEmpty
                        ? null
                        : controller.onSubmit,
                    child: Text(
                      'SALVAR IMAGENS',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: controller.imagesFile.isEmpty
                            ? utilService.colorButton(Colors.grey)
                            : utilService.colorButton(Colors.green)),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
