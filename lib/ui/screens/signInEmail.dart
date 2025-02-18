
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/theme/colors.dart';

import 'package:saidika_ui/ui/widgets/appBar.dart';
import 'package:saidika_ui/ui/widgets/appButton.dart';
import 'package:saidika_ui/ui/widgets/appTextField.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';

import 'package:http/http.dart' as http;
import 'package:saidika_ui/utils/constants.dart';
import 'package:saidika_ui/utils/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<FocusNode> focusNodes = [
  FocusNode(),
  FocusNode(),
  FocusNode(),
];

var selectedValue = "FINDER";

class SignInEmail extends StatefulWidget {
  const SignInEmail({super.key});

  @override
  State<SignInEmail> createState() => _SignInEmailState();
}

class _SignInEmailState extends State<SignInEmail> {


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          value: "FINDER",
          child: Text(
            "Service Finder",
            style: appTextTheme(context).labelSmall,
          )),
      DropdownMenuItem(
          value: "PROVIDER",
          child: Text(
            "Service Provider",
            style: appTextTheme(context).labelSmall,
          )),
    ];
    return menuItems;
  }

  void onFocusChanged() {
    setState(() {});
  }

  Future<void> createAccount() async{

    Uri url = Uri.parse('');

    if (selectedValue == 'PROVIDER'){
      url = Uri.parse('https://saidika-backend.onrender.com/api/v1/provider/login');
      print(url);
    }else if (selectedValue == 'FINDER'){
      url  = Uri.parse('https://saidika-backend.onrender.com/api/v1/finder/login');
      print(url);
    }

    Map<String, dynamic> data = {
      "email": emailController.text,
      "password": passwordController.text
    };


    print(data);
    // Navigator.pushReplacementNamed(context, homePage);

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(data),  // Encode the data as JSON
    );


    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {

      // Extract cookie from response headers
      // String? rawCookie = response.headers['set-cookie'];
      var responseBody = jsonDecode(response.body);

      // Extract the authorization token
      String authorizationToken = responseBody['authorization'];
      String userId = responseBody['profile_id'];
      String userName = responseBody['profile_name'];
      bool firstTimeLogin = responseBody['first_time_login'];
      String role = selectedValue.toString();

      //TODO: Get location from cookie
      // String userLocation = responseBody['location'];

      // print(authorizationToken);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('userToken', authorizationToken);
      await prefs.setString('userId', userId);
      await prefs.setString('userName', userName);
      await prefs.setBool('first_time_login', firstTimeLogin);
      await prefs.setString('userRole', role);
      // await prefs.setString('userLocation', userLocation);

      print('Log In Success');
      // print(userName);


      if (selectedValue == 'PROVIDER' && responseBody['first_time_login']){
        Navigator.pushReplacementNamed(context, addService);
      }else{
        Navigator.pushReplacementNamed(context, homePage);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Fill your profile"),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(20),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: imageAsset(
                    isNormalImage: true,
                    fileName: 'profile.jpg',
                    imgHeight: 130,
                    imgWidth: 130,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  decoration: InputDecoration(
                    prefixIcon: selectedValue == "FINDER"
                        ? Icon(Icons.search, color: AppColors.textColorLight)
                        : Icon(Icons.home_repair_service,color: AppColors.textColorLight),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: AppColors.grey,
                  ),
                  dropdownColor: AppColors.grey,
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: dropdownItems,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Email',
                  prefixIcon: Icons.mail_rounded,
                  controller: emailController,
                  focusNode: focusNodes[0],
                  keyboardType: TextInputType.emailAddress,
                ),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Password',
                  prefixIcon: Icons.lock,
                  controller: passwordController,
                  focusNode: focusNodes[1],
                  isPasswordField: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 20),
                AppButton(
                  btnText: 'Log In',
                  textSize: 15,
                  voidCallBack: (){
                    createAccount();
                    // Navigator.pushReplacementNamed(context, homeScreen);
                  },
                )
              ],
            ),
          )),
    );
  }
}
