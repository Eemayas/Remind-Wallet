// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:expenses_tracker/Pages/starting_pages/splash_screen.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import '../../Componet/riv_animation.dart';

class AskStoragePermission extends StatefulWidget {
  const AskStoragePermission({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AskStoragePermissionState createState() => _AskStoragePermissionState();
}

class _AskStoragePermissionState extends State<AskStoragePermission> {
  Future<void> requestStoragePermission(BuildContext context) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.fade, duration: Duration(seconds: 1), child: Splash_Page()));
    } else if (status.isDenied || status.isPermanentlyDenied) {
      PermissionStatus newStatus = await Permission.storage.request();
      if (newStatus.isGranted) {
        Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.fade, duration: Duration(seconds: 1), child: Splash_Page()));
      } else if (newStatus.isPermanentlyDenied) {
        openAppSettings();
        Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.fade, duration: Duration(seconds: 1), child: Splash_Page()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StateMachineMuscot(),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
              child: Text(
                "We kindly seek your permission to access storage for Remind Wallet to improve your experience. Rest assured, your data's security remains our top priority",
                textAlign: TextAlign.center,
                style: kwhiteTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ProgressButton.icon(
              textStyle: kwhiteTextStyle,
              height: 40.00,
              maxWidth: 200.00,
              iconedButtons: {
                ButtonState.idle: IconedButton(
                  text: "Give Permission",
                  icon: Icon(Icons.storage_rounded, color: Colors.white),
                  color: Colors.deepPurple.shade500,
                ),
                ButtonState.loading: IconedButton(text: "Loading", color: Colors.deepPurple.shade700),
                ButtonState.fail: IconedButton(text: "Failed", icon: Icon(Icons.cancel, color: Colors.white), color: Colors.red.shade300),
                ButtonState.success: IconedButton(
                    text: "Success",
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    color: Colors.green.shade400)
              },
              state: ButtonState.idle,
              onPressed: () => {openAppSettings(), requestStoragePermission(context)},
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
