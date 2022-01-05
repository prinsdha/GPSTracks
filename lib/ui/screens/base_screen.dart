
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gpstracks/core/services/firebase_service.dart';
import 'package:gpstracks/ui/screens/controller/base_controller.dart';
import 'package:gpstracks/ui/screens/widget/permission_denied_screen.dart';

class BaseScreen extends StatefulWidget {
  static const String routeName = "/baseScreen";
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final BaseController baseController = Get.find<BaseController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        builder: (BaseController controller) {
          return controller.isMapScreen
              ? SafeArea(
                  bottom: false,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (GoogleMapController controller) =>
                        baseController.controller.complete(controller),
                    markers: {
                      if (baseController.destination != null)
                        baseController.destination as Marker
                    },
                    onLongPress: baseController.addMarker,
                    polylines: baseController.polyline,
                    initialCameraPosition: controller.cameraPosition,
                  ))
              : const PermissionDeniedScreen();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: GetBuilder(
        builder: (BaseController controller) => controller.isMapScreen
            ? FloatingActionButton(
                child: const Icon(Icons.restart_alt),
                onPressed: () async {
                  baseController.removePolyLine();
                  FirebaseService.deleteAllLatLng();
                },
              )
            : const SizedBox(),
      ),
    );
  }
}
