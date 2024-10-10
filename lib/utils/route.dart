import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/screens/CameraScreen.dart';
import 'package:saidika_ui/ui/screens/SplashScreen.dart';
import 'package:saidika_ui/ui/screens/addService.dart';
import 'package:saidika_ui/ui/screens/chat.dart';
import 'package:saidika_ui/ui/screens/chatPage.dart';
import 'package:saidika_ui/ui/screens/editProfile.dart';
import 'package:saidika_ui/ui/screens/homePage.dart';
import 'package:saidika_ui/ui/screens/introSliderScreen.dart';
import 'package:saidika_ui/ui/screens/profilePage.dart';
import 'package:saidika_ui/ui/screens/searchPage.dart';
import 'package:saidika_ui/ui/screens/signInEmail.dart';
import 'package:saidika_ui/ui/screens/signInScreen.dart';
import 'package:saidika_ui/ui/screens/signUpManuallyScreen.dart';
import 'package:saidika_ui/ui/screens/signUpScreen.dart';
import 'package:saidika_ui/ui/widgets/setLocation.dart';

const String splashScreen = '/splashScreen';
const String introSliderScreen = '/introSliderScreen';
const String signInScreen = '/signInScreen';
const String signUpScreen = '/signUpScreen';
const String signInEmail = '/signInEmail';
const String signUpManuallyScreen = '/signUpManuallyScreen';
const String homePage = '/homePage';
const String setLocation = '/setLocation';
const String search = '/search';
const String chats = '/chats';
const String profile = '/profile';
const String chat_page = '/chat_page';
const String addService = '/addService';
const String editProfile = '/editProfile';
const String cameraPage = '/cameraPage';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case introSliderScreen:
        return MaterialPageRoute(builder: (_) => IntroSliderScreen());
      case signInScreen:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case signUpScreen:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case signUpManuallyScreen:
        return MaterialPageRoute(builder: (_) => SignUpManuallyScreen());
      case homePage: 
        return MaterialPageRoute(builder: (_) => HomePage());
      case signInEmail:
        return MaterialPageRoute(builder: (_) => SignInEmail());
      case setLocation:
        return MaterialPageRoute(builder: (_) => SetLocation());
      case search:
        final String data = settings.arguments.toString();
        return MaterialPageRoute(builder: (_) => Search(data: data));
      case chats:
        return MaterialPageRoute(builder: (_) => Chat());
      case chat_page:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(builder: (_) => ChatPage(
          receiverName: args['receiverName']!,
          receiverId: args['receiverId']!,
          senderId: args['senderId']!,
          chatId: args['chatId']!,
        ));
      case profile:
        return MaterialPageRoute(builder: (_) => Profile());
      case addService:
        return MaterialPageRoute(builder: (_) => AddService());
      case editProfile:
        return MaterialPageRoute(builder: (_) => EditProfile());
      case cameraPage:
        return MaterialPageRoute(builder: (_) => CameraScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}