import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:inventario_getx/components/localidades_page/localidades_repository.dart';
import 'package:inventario_getx/data/model/localidade.dart';
import 'package:inventario_getx/routes/app_routes.dart';

class LocalidadesController extends GetxController {
  LocalidadesRepository repository = LocalidadesRepository(
      authProvider: Get.find(), firestoreProvider: Get.find());
  List<Localidade> localidades = [];
  List<Localidade> localidadesFiltradas = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  LocalidadesController() {
    localidadesFiltradas = localidades = Get.arguments['localidades'];
    print('Localidades: $localidades');
  }

  @override
  void onInit() {
    searchController.addListener(() {
      localidadesFiltradas = localidades
          .where((element) => element.nome
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
      print(searchController.text);
      update();
    });
    super.onInit();
  }

  clearSearchText() {
    searchController.text = '';
    searchFocus.unfocus();
    update();
  }

  void signOut() async {
    await repository.signOut();
    Get.offAllNamed(Routes.INITIAL);
  }

  goToLocalidade(Localidade localidade) {
    Get.toNamed(Routes.LOCALIDADE_DETAIL,
        arguments: {'localidade': localidade});
  }
}
