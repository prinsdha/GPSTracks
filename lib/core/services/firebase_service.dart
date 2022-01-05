import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpstracks/core/services/repo/user_repo.dart';
import 'package:gpstracks/ui/shared/get_location_controller.dart';

CollectionReference userReference =
    FirebaseFirestore.instance.collection("User");

class FirebaseService {
  static Future<QuerySnapshot> getAllLatLng() async {
    final refLogBooks = userReference
        .doc(FirebaseInstance.firebaseAuth!.currentUser!.uid)
        .collection("Track")
        .orderBy("timestamp")
        .get();
    return refLogBooks;
  }

  static Future deleteAllLatLng() async {
    try {
      await userReference
          .doc(FirebaseInstance.firebaseAuth!.currentUser!.uid)
          .delete()
          .then((value) async {
        await UserRepo.userFirstCurrentLocation(LatLng(
            Get.find<GetCurrentLocation>().currentLatitude,
            Get.find<GetCurrentLocation>().currentLongitude));
      });
    } on Exception catch (_) {
    }
  }
}
