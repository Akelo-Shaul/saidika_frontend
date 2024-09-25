import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saidika_ui/ui/screens/SplashScreen.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/utils/route.dart';

import '../utils/constants.dart';


Future<void> initializeApp() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SaidikaApp());
}
class SaidikaApp extends StatefulWidget {
  const SaidikaApp({super.key});

  @override
  State<SaidikaApp> createState() => _SaidikaAppState();
}

class _SaidikaAppState extends State<SaidikaApp> {
  @override
  Widget build(BuildContext context) {
    TextTheme googleTextTheme = GoogleFonts.interTextTheme(appTextTheme(context));
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Hides the debug banner that appears in the left top
      title: 'Saidika',
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: "/",
      theme: ThemeData(
        useMaterial3: false,
        textTheme: googleTextTheme.copyWith(
          titleLarge: googleTextTheme.titleLarge!.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
              height: 1.3),
          titleMedium: googleTextTheme.titleMedium!.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
              height: 1.3),
          titleSmall: googleTextTheme.titleSmall!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
              height: 1.3),
          labelLarge: googleTextTheme.labelLarge!
              .copyWith(fontSize: 30, color: AppColors.textColor, height: 1.3),
          labelMedium: googleTextTheme.labelMedium!
              .copyWith(fontSize: 20, color: AppColors.textColor, height: 1.3),
          labelSmall: googleTextTheme.labelSmall!
              .copyWith(fontSize: 15, color: AppColors.textColor, height: 1.3),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primaryColor,
          selectionColor: AppColors.primaryColor,
          selectionHandleColor: AppColors.primaryColor
        ),
        primarySwatch: AppColors.primaryApp,
        scaffoldBackgroundColor: AppColors.scafoldColor,
      ),
      home: SplashScreen(),
    );
  }
}
