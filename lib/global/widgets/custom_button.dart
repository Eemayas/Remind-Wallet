import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:remind_wallet/theme/color.dart'; // Assuming you use custom styles

class CustomButton extends StatelessWidget {
  final ButtonState buttonState;
  final TextEditingController titleController;
  final TextEditingController amtController;
  final TextEditingController tranasctionTypeController;
  final VoidCallback onSuccess;
  final Function? onPressed;

  const CustomButton({
    super.key,
    required this.buttonState,
    required this.titleController,
    required this.amtController,
    required this.tranasctionTypeController,
    required this.onSuccess,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressButton.icon(
      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
      height: 40.0,
      maxWidth: 200.0,
      iconedButtons: {
        ButtonState.idle: IconedButton(
          text: "Add Transaction",
          icon: const Icon(Icons.add, color: Colors.white),
          color: AppColors.buttonColor,
        ),
        ButtonState.loading: IconedButton(
          text: "Loading",
          color: AppColors.buttonLoadingColor,
        ),
        ButtonState.fail: IconedButton(
          text: "Failed",
          icon: const Icon(Icons.cancel, color: Colors.white),
          color: AppColors.buttonFailedColor,
        ),
        ButtonState.success: IconedButton(
          text: "Success",
          icon: const Icon(Icons.check_circle, color: Colors.white),
          color: AppColors.buttonSuccessColor,
        ),
      },
      onPressed: onPressed,
      state: buttonState,
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final IconData? icon;
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = Text(
      label,
      style: Theme.of(context)
          .textTheme
          .labelLarge
          ?.copyWith(color: AppColors.buttonTextColor),
    );

    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: AppColors.buttonTextColor,
        ),
        label: buttonChild,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          foregroundColor: AppColors.buttonTextColor,
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          foregroundColor: AppColors.buttonTextColor,
        ),
        child: buttonChild,
      );
    }
  }
}

class VariableWidthButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final double width;
  const VariableWidthButton({
    super.key,
    this.onPressed,
    required this.label,
    this.width = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * width,
          height: 35,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
