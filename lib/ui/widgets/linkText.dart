import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/utils/constants.dart';

Widget linkText(String text, BuildContext context, VoidCallback voidCallback) {
  return GestureDetector(
    onTap: voidCallback,
    child: Center(
      child: Text(
        text,
        style: appTextTheme(context).labelSmall?.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    ),
  );
}
