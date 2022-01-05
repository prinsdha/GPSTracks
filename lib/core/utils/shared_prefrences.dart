import 'package:get_storage/get_storage.dart';
import 'package:gpstracks/ui/shared/get_location_controller.dart';

class LocalDB {
  static final sharedPreference = GetStorage();
  static saveUserUID(String uid) {
    sharedPreference.write("userUID", uid);
  }

  static bool dataIsNull() {
    final uid = sharedPreference.read("userUID");
    if (uid != null) {
      return false;
    } else {
      return true;
    }
  }

  static writeSaveLastLatLng(LatLongCoordinate latLongCoordinate) {
    sharedPreference.write("LastLatLng", {
      "latitude": latLongCoordinate.latitude,
      "longitude": latLongCoordinate.longitude
    });
  }

  static LatLongCoordinate? readLastLng() {
    final read = sharedPreference.read("LastLatLng");
    if (read != null) {
      return LatLongCoordinate(
          latitude: read["latitude"], longitude: read["longitude"]);
    } else {
      return null;
    }
  }
}
