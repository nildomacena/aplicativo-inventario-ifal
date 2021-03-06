import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/localidade_detail_page/custom_widgets/card_dados_gerais.dart';
import 'package:inventario_getx/components/localidade_detail_page/localidade_detail.controller.dart';
import 'package:inventario_getx/data/model/bem.dart';
import 'package:inventario_getx/data/model/localidade.dart';

class LocalidadeDetailPage extends StatelessWidget {
  final LocalidadeDetailController controller = Get.find();

  Widget botaoAdicionarBem() {
    return Obx(() => Padding(
        padding: EdgeInsets.all(5),
        child: FlatButton(
            color: Colors.green,
            textColor: Colors.white,
            child: Text(controller.localidade.status == Status.finalizado
                ? 'LOCALIDADE FINALIZADA'
                : 'ADICIONAR BEM'),
            onPressed: controller.localidade.status == Status.finalizado
                ? null
                : controller.goToAdicionarBem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(controller.localidade.nome),
        ),
        body: GetBuilder<LocalidadeDetailController>(
          builder: (_) {
            return RefreshIndicator(
              onRefresh: () async {
                _.updateBens();
              },
              child: Container(
                  child: ListView.builder(
                      itemCount: _.bens == null ? 2 : _.bens.length + 2,
                      itemBuilder: (context, index) {
                        if (index == 0)
                          return CardDadosGerais(controller: controller);
                        if (index == 1) return botaoAdicionarBem();
                        Bem bem = _.bens[index - 2];
                        return Container(
                          margin: EdgeInsets.only(top: 3, bottom: 3),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: .4)),
                          height: 60,
                          width: double.infinity,
                          child: Material(
                            elevation: 1,
                            child: ListTile(
                              title: TextButton(
                                child: Text('${bem.descricaoFormatada}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                onPressed: () {
                                  controller.goToBem(bem);
                                },
                              ),
                              /* 
                            Removido para testes
                            Text(
                              '${bem.descricao} - ${bem.bemParticular ? 'Bem particular' : bem.semEtiqueta ? 'Sem etiqueta' : bem.patrimonio}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ), */
                            ),
                          ),
                        );
                      })),
            );
          },
        ));

    /* 
    Modo usando streams
    GetX<LocalidadeDetailController>(builder: (_) {
          return Container(
              child: ListView.builder(
                  itemCount: _.bens.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return CardDadosGerais(controller: controller);
                    if (index == 1) return botaoAdicionarBem();
                    Bem bem = _.bens[index - 2];
                    return Container(
                      margin: EdgeInsets.only(top: 3, bottom: 3),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: .4)),
                      height: 60,
                      width: double.infinity,
                      child: Material(
                        elevation: 1,
                        child: ListTile(
                          title: TextButton(
                            child: Text('${bem.descricao}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            onPressed: () {
                              controller.goToBem(bem);
                            },
                          ),
                          /* 
                          Removido para testes
                          Text(
                            '${bem.descricao} - ${bem.bemParticular ? 'Bem particular' : bem.semEtiqueta ? 'Sem etiqueta' : bem.patrimonio}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ), */
                        ),
                      ),
                    );
                  }));
        })); */
  }
}
