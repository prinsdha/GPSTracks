import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpstracks/core/services/repo/user_repo.dart';
import 'package:gpstracks/core/utils/app_function.dart';
import 'package:gpstracks/ui/screens/controller/base_controller.dart';

import 'package:gpstracks/ui/shared/get_location_controller.dart';

late bool isLoginComplete;
late String initialRoute;
BitmapDescriptor? currentLocationMarker;
BitmapDescriptor? destinationMarker;

globalVerbsInit() async {
  FirebaseInstance.firebaseAuth = FirebaseAuth.instance;
  FirebaseInstance.fireStore = FirebaseFirestore.instance;
  BaseController baseController = Get.put(BaseController());

  setCustomMapPin();
  await Get.put(GetCurrentLocation()).determinePosition().then((value) {
    baseController.isMapScreen = true;
  }).catchError((e) {
    baseController.isMapScreen = false;
  });
}

