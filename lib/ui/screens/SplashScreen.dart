import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:saidika_ui/configs/FirebaseNotifs.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void _initializeNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await setupFirebaseNotifications(); // This is a Future, so we await it inside this function.
    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) async {
      if (value != null) {
        await prefs.setString("notifToken", value);
        // setState(){
        //   token = value;
        // }
        print('FCM $value');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeNotifications();
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

