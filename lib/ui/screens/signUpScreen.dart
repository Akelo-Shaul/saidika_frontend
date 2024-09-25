import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/appButton.dart';
import 'package:saidika_ui/ui/widgets/linkText.dart';
import 'package:saidika_ui/ui/widgets/socialMediaButton.dart';
import 'package:saidika_ui/utils/constants.dart';
import 'package:saidika_ui/utils/route.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              'Sign up!',
              style: appTextTheme(context).titleLarge,
            ),
            SizedBox(height: 30),
            SocialMediaButton(
                text: "Continue with Google", fileName: "google.svg",bgColor: AppColors.googleBgColor,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, signInEmail);
                }
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Divider(
                    height: 2,
                    thickness: 2,
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(start: 5, end: 5),
                  child: Text(
                    'or',
                    style: appTextTheme(context).labelSmall!.copyWith(
                      color: AppColors.textColorLight,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Expanded(
                  child: Divider(
                    height: 2,
                    thickness: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Container(
              margin: EdgeInsetsDirectional.only(start: 20,end: 20),
              child: AppButton(
                btnText: 'Create Account',
                textSize: 15,
                voidCallBack: () {
                  Navigator.pushNamed(context, signUpManuallyScreen);
                },
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: appTextTheme(context).labelSmall,
                ),
                linkText(' Sign in', context, () {
                  Navigator.pushReplacementNamed(context, signInScreen);
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
