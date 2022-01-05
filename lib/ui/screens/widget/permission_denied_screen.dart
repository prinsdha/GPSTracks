import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gpstracks/core/constant/app_images.dart';
import 'package:gpstracks/ui/screens/controller/base_controller.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionDeniedScreen extends StatefulWidget {
  static const String routeName = "/permissionDeniedScreen";
  const PermissionDeniedScreen({Key? key}) : super(key: key);

  @override
  State<PermissionDeniedScreen> createState() => _PermissionDeniedScreenState();
}

class _PermissionDeniedScreenState extends State<PermissionDeniedScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        checkPermissionGranted();
        break;

      default:
    }
  }

  checkPermissionGranted() async {
    PermissionStatus locationPermission = await Permission.location.status;
    if (locationPermission.isGranted) {
      Get.find<BaseController>().isMapScreen = true;
      Get.find<BaseController>().onInit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          SvgPicture.asset(
            AppImages.perDeniedImage,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Location enabled",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              // color: Color(0xff007535),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "We need your location for live track",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              await openAppSettings();
            },
            child: Container(
              height: 50,
              width: Get.width - 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: const Color(0xff007535)),
              child: const Center(
                child: Text(
                  "Allow",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
