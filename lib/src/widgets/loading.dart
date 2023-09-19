import 'package:flutter/material.dart';
import '../utils/colors.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierColor: Colors.black.withOpacity(0.85),
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(
                  color: AppColors.kBlackColor,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
