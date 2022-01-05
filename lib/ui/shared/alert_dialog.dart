import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpstracks/ui/screens/controller/base_controller.dart';

Future<void> showCustomDialog() async {
  return showDialog<void>(
    context: Get.context as BuildContext,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)), //this right here
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: FittedBox(
            child: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Great, You reached your end point.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: MaterialButton(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      onPressed: () {
                        Get.find<BaseController>().destination = null;
                        Get.back();
                      },
                      child: const Text(
                        "Ok",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
