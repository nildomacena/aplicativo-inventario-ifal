import 'package:get/get.dart';
import 'package:inventario_getx/components/localidade_detail_page/localidade_detail_repository.dart';
import 'package:inventario_getx/data/model/bem.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/routes/app_routes.dart';
import 'package:inventario_getx/services/util.service.dart';

class LocalidadeDetailController extends GetxController {
  Rx<Localidade> _localidade = Rx<Localidade>(null);
  //Localidade localidade;
  final LocalidadeDetailRepository repository = LocalidadeDetailRepository();
  //RxList<Bem> _bens = <Bem>[].obs;
  List<Bem> bens;
  get localidade => this._localidade.value;
  set localidade(value) => this._localidade.value = value;

  /*  get bens => this._bens.toList();
  set bens(value) => this._bens.value = value; */

  LocalidadeDetailController() {
    localidade = Get.arguments['localidade'];
    _localidade.bindStream(repository.streamLocalidadeById(localidade));
    updateBens();
    //_bens.bindStream(repository.streamBensPorLocalidade(localidade));
  }

  updateBens() async {
    bens = await repository.getBensPorLocalidade(localidade);
    update();
  }

  goToPanoramicas() {
    Get.toNamed(Routes.FOTOS_PANORAMICAS,
        arguments: {'localidade': localidade});
  }

  goToRelatorio() {
    Get.toNamed(Routes.RELATORIO, arguments: {'localidade': localidade});
  }

  goToAdicionarBem() async {
    var descricaoBem = await Get.toNamed(Routes.ADICIONAR_BEM,
        arguments: {'localidade': localidade});
    print('result goToAdicionarBem: $descricaoBem');
    if (descricaoBem != null) {
      updateBens();
      utilService.snackBar(
          titulo: 'Cadastro salvo!', mensagem: 'O bem $descricaoBem foi salvo');
    }
  }

  goToBem(Bem bem) async {
    print('Bem: $bem');
    var result = await Get.toNamed(Routes.BEM_DETAIL,
        arguments: {'bem': bem, 'localidade': localidade});
    if (result != null) updateBens();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
