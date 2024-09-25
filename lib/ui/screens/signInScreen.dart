
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/linkText.dart';
import 'package:saidika_ui/ui/widgets/socialMediaButton.dart';
import 'package:saidika_ui/utils/constants.dart';
import 'package:saidika_ui/utils/route.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              'Let\'s you in!',
              style: appTextTheme(context).titleLarge,
            ),
            SizedBox(height: 30),
            SocialMediaButton(
                text: "Continue with Email", fileName: "email.svg",
              onPressed: () {
                Navigator.pushReplacementNamed(context, signInEmail);
              }
            ),
            SocialMediaButton(
                text: "Continue with Google", fileName: "google.svg",bgColor: AppColors.googleBgColor,
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, homeScreen);
                }
            ),

            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: appTextTheme(context).labelSmall,
                ),
                linkText(' Sign up', context, () {
                  Navigator.pushReplacementNamed(context, signUpScreen);
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
