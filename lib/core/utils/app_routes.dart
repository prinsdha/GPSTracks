import 'package:get/get.dart';
import 'package:gpstracks/ui/screens/base_screen.dart';
import 'package:gpstracks/ui/screens/widget/permission_denied_screen.dart';

final List<GetPage<dynamic>> routes = [
  GetPage(name: BaseScreen.routeName, page: () => const BaseScreen()),
  GetPage(
      name: PermissionDeniedScreen.routeName,
      page: () => const PermissionDeniedScreen()),
];
