import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToOnboarding();
  }
  @override
  Widget build(BuildContext context) {
    return const SplashScreenWidget();
  }

  _navigateToOnboarding() async{
    await Future.delayed(const Duration(seconds: 2), (){
      Navigator.pushReplacementNamed(context, introSliderScreen);
    });
  }
}

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: imageAsset(
          fileName: "app_logo.png",
          imgWidth: MediaQuery.of(context).size.width * 0.5,
          imgHeight: MediaQuery.of(context).size.width * 0.55,
          isNormalImage: true,
        ),
      ),
    );
  }
}

