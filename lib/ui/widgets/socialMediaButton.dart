
import 'package:flutter/cupertino.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/constants.dart';

class SocialMediaButton extends StatelessWidget {
  String fileName;
  String? text;
  Color? bgColor;
  final VoidCallback onPressed;

  SocialMediaButton({super.key, this.text, required this.fileName,this.bgColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsetsDirectional.all(15),
        // margin: EdgeInsetsDirectional.only(bottom: 10),
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            imageAsset(
              fileName: fileName,
              imgWidth: 25,
              imgHeight: 25,
              isNormalImage: false,
            ),
            Text(
              text ?? '',
              style: appTextTheme(context).labelSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
