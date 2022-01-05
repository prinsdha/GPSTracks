import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpstracks/core/constant/app_images.dart';
import 'package:gpstracks/ui/global.dart';
import 'dart:ui' as ui;

flutterToast(String msg) {
  Fluttertoast.cancel();
  return Fluttertoast.showToast(
      msg: msg,
      textColor: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.70),
      fontSize: 14);
}

void setCustomMapPin() async {
  if (currentLocationMarker == null) {
    final Uint8List markerIcon =
        await getBytesFromAsset(AppImages.currentLocationMarker, 100);
    currentLocationMarker = BitmapDescriptor.fromBytes(markerIcon);
  }
  if (destinationMarker == null) {
    final Uint8List markerIcon =
        await getBytesFromAsset(AppImages.destinationMarker, 100);
    destinationMarker = BitmapDescriptor.fromBytes(markerIcon);
  }
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}
