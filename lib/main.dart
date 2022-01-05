import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpstracks/core/services/repo/user_repo.dart';
import 'package:gpstracks/core/utils/app_routes.dart';
import 'package:gpstracks/ui/global.dart';
import 'package:gpstracks/ui/screens/base_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await globalVerbsInit();
  await UserRepo.userLogin();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GPSTracks',
      initialRoute: BaseScreen.routeName,
      getPages: routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
