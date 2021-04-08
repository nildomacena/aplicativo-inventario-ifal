import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/login_page/login_controller.dart';
import 'package:inventario_getx/data/model/campus.dart';

class SelectCampusModal extends StatelessWidget {
  final LoginController controller;
  SelectCampusModal(this.controller);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Selecione o seu campus'),
        ),
        body: GetBuilder<LoginController>(
          builder: (_) {
            return Container(
                child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      bottom: controller.campusSelecionado != null ? 40 : 0),
                  child: ListView.builder(
                      itemCount: controller.campi.length,
                      itemBuilder: (context, index) {
                        Campus campus = controller.campi[index];
                        bool campusSelecionado =
                            controller.campusSelecionado != null &&
                                campus == controller.campusSelecionado;
                        return ListTile(
                          title: Text(
                            campus.nome.toUpperCase(),
                            style: TextStyle(
                                fontWeight: campusSelecionado
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                          selected: controller.campusSelecionado != null &&
                              campus == controller.campusSelecionado,
                          onTap: () {
                            controller.onSelectCampus(campus);
                          },
                        );
                      }),
                ),
                if (controller.campusSelecionado != null)
                  Positioned(
                      bottom: 0,
                      child: Container(
                        width: Get.width,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          child: Text('SELECIONAR CAMPUS'),
                          onPressed: controller.onDefineCampus,
                        ),
                      ))
              ],
            ));
          },
        ));
  }
}
