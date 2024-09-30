import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/utils/constants.dart';

class AppTextField extends StatelessWidget {
  String hintText;
  IconData prefixIcon;
  VoidCallback? textFieldCallBack;
  bool? isPasswordField, isEnabled, autoFocus;
  Function(String)? onChanged;
  FocusNode focusNode;
  TextInputType? keyboardType;
  TextEditingController controller;

  AppTextField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.focusNode,
    required this.controller,
    this.isPasswordField,
    this.onChanged,
    this.textFieldCallBack,
    this.keyboardType,
    this.isEnabled,
    this.autoFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 20),
      child: TextField(
          enabled: isEnabled ?? true,
          autofocus: autoFocus ?? false,
          controller: controller,
          style: appTextTheme(context).labelSmall,
          onTap: textFieldCallBack,
          onChanged: onChanged,
          obscureText: isPasswordField ?? false,
          focusNode: focusNode,
          keyboardType: keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            focusedBorder: focusedOutlineInputBorder(),
            enabledBorder: enabledOutlineInputBorder(),
            disabledBorder: enabledOutlineInputBorder(),
            prefixIcon: Icon(prefixIcon,
                color: focusNode.hasFocus
                    ? AppColors.primaryColor
                    : AppColors.textColorLight,
                size: 25),
            filled: true,
            fillColor: focusNode.hasFocus
                ? AppColors.primaryLightColor
                : AppColors.grey,
          )),
    );
  }
}

class AppTextFieldWithSuffixIcon extends StatelessWidget {
  String hintText;
  IconData prefixIcon;
  IconData postfixIcon;
  VoidCallback? textFieldCallBack, postfixIconCallBack;
  bool? isPasswordField, isEnabled, autoFocus;
  FocusNode focusNode;
  TextInputType? keyboardType;
  TextEditingController controller;

  AppTextFieldWithSuffixIcon({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.focusNode,
    required this.postfixIcon,
    required this.controller,
    this.isPasswordField,
    this.postfixIconCallBack,
    this.textFieldCallBack,
    this.keyboardType,
    this.isEnabled,
    this.autoFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 20),
      child: TextField(
          enabled: isEnabled ?? true,
          autofocus: autoFocus ?? false,
          controller: controller,
          style: appTextTheme(context).labelSmall,
          onTap: textFieldCallBack,
          obscureText: isPasswordField ?? false,
          focusNode: focusNode,
          keyboardType: keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            focusedBorder: focusedOutlineInputBorder(),
            enabledBorder: enabledOutlineInputBorder(),
            disabledBorder: enabledOutlineInputBorder(),
            prefixIcon: Icon(prefixIcon,
                color: focusNode.hasFocus
                    ? AppColors.primaryColor
                    : AppColors.textColorLight,
                size: 25),
            suffixIcon: IconButton(
                splashRadius: 1,
                onPressed: postfixIconCallBack,
                icon: Icon(postfixIcon,
                    color: focusNode.hasFocus
                        ? AppColors.primaryColor
                        : AppColors.textColorLight)),
            filled: true,
            fillColor: focusNode.hasFocus
                ? AppColors.primaryLightColor
                : AppColors.grey,
          )),
    );
  }
}

class AppTextArea extends StatelessWidget {
  String hintText;
  IconData prefixIcon;
  TextEditingController controller;
  FocusNode focusNode;
  bool? isEnabled, autoFocus;
  Function(String)? onChanged;
  VoidCallback? onTap;

  AppTextArea({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    required this.prefixIcon,
    this.isEnabled,
    this.autoFocus,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 20),
      child: TextField(
        enabled: isEnabled ?? true,
        autofocus: autoFocus ?? false,
        controller: controller,
        focusNode: focusNode,
        onTap: onTap,
        onChanged: onChanged,
        maxLines: null,  // This allows the TextField to behave like a textarea
        keyboardType: TextInputType.multiline,
        style: appTextTheme(context).labelMedium,
        decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.textColorLight),
            borderRadius: BorderRadius.circular(15),
          ),
          prefixIcon: Icon(prefixIcon,
              color: focusNode.hasFocus
                  ? AppColors.primaryColor
                  : AppColors.textColorLight,
              size: 25),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Colors.white,  // Set background color to white (or any other neutral color)
        ),
      ),
    );
  }
}


focusedOutlineInputBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.primaryColor),
    borderRadius: BorderRadius.circular(15),
  );
}

enabledOutlineInputBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(15),
  );
}
