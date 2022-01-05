import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpstracks/core/services/firebase_service.dart';
import 'package:gpstracks/core/utils/app_function.dart';

class FirebaseInstance {
  static late final FirebaseAuth? firebaseAuth;
  static late final FirebaseFirestore? fireStore;
}

class UserRepo {
  static Future<void> listUpdateUserLatLng(LatLng latLng) async {
    try {
      User? user = FirebaseInstance.firebaseAuth!.currentUser;
      userReference
          .doc(user!.uid)
          .collection("Track")
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        "location": {
          "latitude": latLng.latitude,
          "longitude": latLng.longitude,
        },
        'timestamp': Timestamp.now()
      });
    } on FirebaseException catch (e) {
      flutterToast(e.message.toString());
    } catch (e) {
      flutterToast(e.toString());
    }
  }

  static Future<void> userFirstCurrentLocation(LatLng latLng) async {
    try {
      User? user = FirebaseInstance.firebaseAuth!.currentUser;
      userReference
          .doc(user!.uid)
          .set({'firstCurrentLocation': latLng.toJson()}).then((value) async {
        await userReference
            .doc(user.uid)
            .collection("Track")
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set({
          "location": {
            "latitude": latLng.latitude,
            "longitude": latLng.longitude,
          },
          'timestamp': Timestamp.now()
        });
      });
    } on FirebaseException catch (e) {
      flutterToast(e.message.toString());
    } catch (e) {
      flutterToast(e.toString());
    }
  }

  static Future<void> userLogin() async {
    if (FirebaseInstance.firebaseAuth!.currentUser == null) {
      FirebaseAuth.instance.signInAnonymously();
    }
  }
}
