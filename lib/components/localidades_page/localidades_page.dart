import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/localidades_page/localidades_controller.dart';
import 'package:inventario_getx/data/model/localidade.dart';

class LocalidadesPage extends StatelessWidget {
  LocalidadesController controller = Get.put(LocalidadesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
        if (controller.correcoes.isEmpty) return Container();
        return FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: controller.goToCorrecoes,
            child: Icon(Icons.warning));
      }),
      appBar: AppBar(
        title: Text('Localidades'),
        actions: [
          IconButton(
              onPressed: controller.signOut, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: GetBuilder<LocalidadesController>(
        init: LocalidadesController(),
        builder: (_) {
          return RefreshIndicator(
            key: controller.refreshIndicatorKey,
            onRefresh: controller.updateLocalidades,
            child: Container(
              child: ListView.builder(
                  itemCount: controller.localidadesFiltradas.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (controller.localidades.isEmpty)
                      return Container(
                          margin: EdgeInsets.only(top: 25),
                          child: Column(
                            children: [
                              Text(
                                  'Não há localidades cadastradas.\nEntre em contato com o Administrador',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20)),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      controller.updateRefreshIndicator();
                                    },
                                    child: Text('ATUALIZAR')),
                              )
                            ],
                          ));
                    if (index == 0)
                      return Container(
                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, left: 5, right: 5),
                        height: 45,
                        width: MediaQuery.of(context).size.width * 8,
                        child: TextField(
                          style: TextStyle(fontSize: 18),
                          autofocus: false,
                          focusNode: controller.searchFocus,
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: controller.clearSearchText,
                            ),
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                          ),
                        ),
                      );
                    Localidade localidade =
                        controller.localidadesFiltradas[index - 1];
                    return Container(
                      margin: EdgeInsets.only(
                          top: 15, bottom: 15, left: 5, right: 5),
                      height: 80,
                      width: MediaQuery.of(context).size.width * 8,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(22))),
                      child: RaisedButton(
                        elevation: 2,
                        color: Colors.grey[400],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localidade.nome ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              localidade.statusAsString,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                        onPressed: () {
                          controller.goToLocalidade(localidade);
                        }
                        /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LocalidadePage(
                                          localidadesFiltradas[index - 1]))); */
                        ,
                      ),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
