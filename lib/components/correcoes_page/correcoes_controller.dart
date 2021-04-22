import 'package:get/get.dart';
import 'package:inventario_getx/components/correcoes_page/correcoes_repository.dart';
import 'package:inventario_getx/data/model/bem.dart';
import 'package:inventario_getx/data/model/correcao.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/routes/app_routes.dart';
import 'package:inventario_getx/services/util.service.dart';

class CorrecoesController extends GetxController {
  CorrecoesRepository repository = Get.put(CorrecoesRepository());
  RxList<Correcao> _correcoes = RxList();

  List<Correcao> get correcoes => _correcoes.toList();
  CorrecoesController() {
    _correcoes.bindStream(repository.streamCorrecoes());
  }

  goToBem(Correcao correcao) async {
    try {
      utilService.showAlertCarregando('Buscando dados...');
      Localidade localidade =
          await repository.getLocalidadeById(correcao.localidadeId);
      Bem bem = await repository.getBemById(
          bemId: correcao.bemId, localidadeId: localidade.id);
      utilService.fecharAlert();
      Get.toNamed(Routes.BEM_DETAIL, arguments: {
        'correcao': correcao,
        'bem': bem,
        'localidade': localidade
      });
    } catch (e) {
      print('Erro: $e');
      utilService.fecharAlert();
      utilService.snackBarErro(
          mensagem: 'Ocorreu um erro durante a pesquisa\nTente novamente');
    }
  }
}
