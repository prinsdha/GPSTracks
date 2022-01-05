import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpstracks/core/services/firebase_service.dart';
import 'package:gpstracks/core/services/repo/user_repo.dart';
import 'package:gpstracks/core/utils/shared_prefrences.dart';
import 'package:gpstracks/ui/global.dart';
import 'package:gpstracks/ui/screens/model/directions_model.dart';
import 'package:gpstracks/ui/shared/alert_dialog.dart';
import 'package:gpstracks/ui/shared/get_location_controller.dart';
import 'package:location/location.dart';

class BaseController extends GetxController {
  final getMyLocationController = Get.put(GetCurrentLocation());

  Set<Polyline> polyline = {};

  Completer<GoogleMapController> controller = Completer();
  late GoogleMapController googleMapController;

  Marker? destination;
  late CameraPosition cameraPosition;

// make sure to initialize before map loading

  void addMarker(LatLng pos) {
    destination = null;

    destination = Marker(
      markerId: const MarkerId('destination'),
      infoWindow: const InfoWindow(title: 'destination'),
      icon: destinationMarker!,
      position: pos,
    );

    update();
  }

  saveUserCurrentLocation() async {
    if (LocalDB.dataIsNull()) {
      await UserRepo.userFirstCurrentLocation(LatLng(
          getMyLocationController.currentLatitude,
          getMyLocationController.currentLongitude));
      LocalDB.saveUserUID(FirebaseInstance.firebaseAuth!.currentUser!.uid);
    }
  }

  listUpdateUserLatLng(LatLng latLng) async {
    await UserRepo.listUpdateUserLatLng(LatLng(
        getMyLocationController.currentLatitude,
        getMyLocationController.currentLongitude));
  }

  LatLng? latLng;
  bool isLatLngEmpty = true;
  late double distanceInMeters = 6;
  static const double destinationMatchInMeters = 10;
  List<DirectionModel> directionModel = [];
  List<LatLng> listLatLng = [];

  getDirectionRoute(LatLng latLng) {
    listLatLng.add(latLng);
    if (listLatLng.length > 1) {
      addPolyLine(latLng);
      moveCameraPosition(latLng);
    }
    update();
  }

  moveCameraPosition(LatLng latLng) async {
    googleMapController
        .moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latLng.latitude, latLng.longitude),
      zoom: 18,
    )));
    update();
  }

  addPolyLine(LatLng latLng) {
    polyline.add(Polyline(
      polylineId: PolylineId("${latLng.latitude},${latLng.longitude}"),
      visible: true,
      width: 5,
      startCap:
          Cap.customCapFromBitmap(BitmapDescriptor.defaultMarker, refWidth: 20),
      //latlng is List<LatLng>
      points: listLatLng, geodesic: true,

      color: Colors.blue,
    ));
    update();
  }

  removePolyLine() {
    polyline.clear();
    directionModel.clear();
    listLatLng.clear();
    update();
  }

  late bool _isMapScreen;

  bool get isMapScreen => _isMapScreen;

  set isMapScreen(bool value) {
    _isMapScreen = value;
    update();
  }

  givePermission() async {
    await getMyLocationController.determinePosition().then((value) async {
      isMapScreen = true;

      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(value.latitude, value.longitude), zoom: 18)))
          .catchError((e) {
      });

      await saveUserCurrentLocation();
      final snap = await FirebaseService.getAllLatLng();
      directionModel.addAll(snap.docs.map((e) => DirectionModel.fromJson(e)));
      if (directionModel.isNotEmpty) {
        listLatLng.addAll(directionModel.map((e) => LatLng(
            e.directionLocation.latitude, e.directionLocation.longitude)));
      }

      if (listLatLng.isNotEmpty) {
        latLng = listLatLng.last;
      } else {
        latLng = LatLng(value.latitude, value.longitude);
      }

      Location.instance.onLocationChanged.listen((event) async {
        distanceInMeters = Geolocator.distanceBetween(
            //--start latlng
            latLng!.latitude,
            latLng!.longitude,
            //--end latlng
            event.latitude!.toDouble(),
            event.longitude!.toDouble());
        if (distanceInMeters > 5) {
          LocalDB.writeSaveLastLatLng(LatLongCoordinate(
              longitude: event.longitude, latitude: event.latitude));

          await listUpdateUserLatLng(LatLng(event.latitude!, event.longitude!));
          getDirectionRoute(LatLng(event.latitude!, event.longitude!));
        }
        if (destination != null) {
          double distance2 = Geolocator.distanceBetween(
              //--start latlng
              destination!.position.latitude,
              destination!.position.longitude,
              //--end latlng
              event.latitude!,
              event.longitude!);
          if (distance2 < destinationMatchInMeters) {
            showCustomDialog();
          }
        }
      });
    }).catchError((e) {
      isMapScreen = false;
    });
  }

  @override
  void onInit() async {
    if (LocalDB.readLastLng() == null) {
      cameraPosition = CameraPosition(
          target: LatLng(getMyLocationController.currentLatitude,
              getMyLocationController.currentLongitude),
          zoom: 18);
    } else {
      cameraPosition = CameraPosition(
          target: LatLng(LocalDB.readLastLng()!.latitude!.toDouble(),
              LocalDB.readLastLng()!.longitude!.toDouble()),
          zoom: 18);
    }
    googleMapController = await controller.future;

    givePermission();

    super.onInit();
  }
}
