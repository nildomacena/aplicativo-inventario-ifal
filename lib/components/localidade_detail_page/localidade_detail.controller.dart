import 'package:get/get.dart';
import 'package:inventario_getx/components/localidade_detail_page/localidade_detail_repository.dart';
import 'package:inventario_getx/data/model/bem.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/routes/app_routes.dart';

class LocalidadeDetailController extends GetxController {
  Rx<Localidade> _localidade = Rx<Localidade>(null);
  //Localidade localidade;
  final LocalidadeDetailRepository repository = LocalidadeDetailRepository();
  RxList<Bem> _bens = <Bem>[].obs;

  get localidade => this._localidade.value;
  set localidade(value) => this._localidade.value = value;

  get bens => this._bens.toList();
  set bens(value) => this._bens.value = value;

  LocalidadeDetailController() {
    localidade = Get.arguments['localidade'];
    _localidade.bindStream(repository.streamLocalidadeById(localidade));
    _bens.bindStream(repository.streamBensPorLocalidade(localidade));
  }

  goToPanoramicas() {
    Get.toNamed(Routes.FOTOS_PANORAMICAS,
        arguments: {'localidade': localidade});
  }

  goToRelatorio() {
    Get.toNamed(Routes.RELATORIO, arguments: {'localidade': localidade});
  }

  goToAdicionarBem() {
    Get.toNamed(Routes.ADICIONAR_BEM, arguments: {'localidade': localidade});
  }

  goToBem(Bem bem) {
    print('Bem: $bem');
  }

  @override
  void onClose() {
    super.onClose();
  }
}
