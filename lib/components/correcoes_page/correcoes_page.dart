import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/correcoes_page/correcoes_controller.dart';
import 'package:inventario_getx/data/model/correcao.dart';

class CorrecoesPage extends StatelessWidget {
  CorrecoesController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Correções solicitadas'),
      ),
      body: Container(
        child: GetX<CorrecoesController>(builder: (_) {
          if (_.correcoes.isEmpty)
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não há registros de correções solicitadas',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('VOLTAR'))
                ],
              ),
            );
          return ListView.builder(
            itemCount: _.correcoes.length,
            itemBuilder: (context, index) {
              Correcao correcao = _.correcoes[index];
              return ListTile(
                title: Text(
                    'Bem: ${correcao.bemDescricao} - Pat.: ${correcao.bemPatrimonio ?? 'Sem patrimônio'}'),
                subtitle: Text('Motivo da correção: ${correcao.motivo}'),
                onTap: () {
                  _.goToBem(correcao);
                },
              );
            },
          );
        }),
      ),
    );
  }
}
