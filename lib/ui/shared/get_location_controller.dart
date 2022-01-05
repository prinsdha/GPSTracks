import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:get/get.dart';

class GetCurrentLocation extends GetxController {
  double currentLatitude = 0;

  double currentLongitude = 0;

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await loc.Location.instance.requestService();

      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition().then((value) {
      currentLatitude = value.latitude;
      currentLongitude = value.longitude;

      return value;
    });
  }

}

class LatLongCoordinate {
  double? latitude;
  double? longitude;

  LatLongCoordinate({this.latitude, this.longitude});
}
