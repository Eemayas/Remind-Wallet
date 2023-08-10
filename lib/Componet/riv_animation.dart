//https://www.youtube.com/watch?v=mEl4ad1WXps
import 'package:expenses_tracker/Componet/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';

class StateMachineMuscot extends StatefulWidget {
  const StateMachineMuscot({super.key});

  @override
  State<StateMachineMuscot> createState() => _StateMachineMuscotState();
}

class _StateMachineMuscotState extends State<StateMachineMuscot> {
  Artboard? riveArtboard;
  SMIBool? isDance;
  SMITrigger? isLookUp;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/riv/dash_flutter_muscot.riv').then(
      (data) async {
        try {
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;
          var controller = StateMachineController.fromArtboard(artboard, 'birb');
          if (controller != null) {
            artboard.addController(controller);
            isDance = controller.findSMI('dance');
            isDance?.value = true;
            isLookUp = controller.findSMI('look up');
            isLookUp?.value = true;
          }
          setState(() => riveArtboard = artboard);
        } catch (e) {
          customSnackbar(context: context, text: "Error:\n ${e.toString()}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return riveArtboard == null
        ? const SizedBox()
        : Expanded(
            child: Rive(
              artboard: riveArtboard!,
            ),
          );
  }
}
