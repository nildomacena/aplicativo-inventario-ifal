import 'package:get/get.dart';
import 'package:inventario_getx/components/adicionar_bem_page/adicionar_bem_binding.dart';
import 'package:inventario_getx/components/adicionar_bem_page/adicionar_bem_page.dart';
import 'package:inventario_getx/components/bem_detail_page/bem_detail_binding.dart';
import 'package:inventario_getx/components/bem_detail_page/bem_detail_page.dart';
import 'package:inventario_getx/components/correcoes_page/correcoes_binding.dart';
import 'package:inventario_getx/components/correcoes_page/correcoes_page.dart';
import 'package:inventario_getx/components/fotos_panoramicas_page/fotos_panoramicas_binding.dart';
import 'package:inventario_getx/components/fotos_panoramicas_page/fotos_panoramicas_page.dart';
import 'package:inventario_getx/components/localidade_detail_page/localidade_detail_binding.dart';
import 'package:inventario_getx/components/localidade_detail_page/localidade_detail_page.dart';
import 'package:inventario_getx/components/localidades_page/localidades_binding.dart';
import 'package:inventario_getx/components/localidades_page/localidades_page.dart';
import 'package:inventario_getx/components/login_page/login_binding.dart';
import 'package:inventario_getx/components/login_page/login_page.dart';
import 'package:inventario_getx/components/relatorio_page/relatorio_binding.dart';
import 'package:inventario_getx/components/relatorio_page/relatorio_page.dart';
import 'package:inventario_getx/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
        name: Routes.INITIAL, page: () => LoginPage(), binding: LoginBinding()),
    GetPage(
        name: Routes.LOCALIDADES,
        page: () => LocalidadesPage(),
        binding: LocalidadesBinding()),
    GetPage(
        name: Routes.LOCALIDADE_DETAIL,
        page: () => LocalidadeDetailPage(),
        binding: LocalidadeDetailBinding()),
    GetPage(
        name: Routes.FOTOS_PANORAMICAS,
        page: () => FotosPanoramicasPage(),
        binding: FotosPanoramicasBinding()),
    GetPage(
        name: Routes.RELATORIO,
        page: () => RelatorioPage(),
        binding: RelatorioBinding()),
    GetPage(
        name: Routes.ADICIONAR_BEM,
        page: () => AdicionarBemPage(),
        binding: AdicionarBemBinding()),
    GetPage(
        name: Routes.BEM_DETAIL,
        page: () => BemDetailPage(),
        binding: BemDetailBinding()),
    GetPage(
        name: Routes.CORRECOES,
        page: () => CorrecoesPage(),
        binding: CorrecoesBinding()),
  ];
}
