
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/appBar.dart';
import 'package:saidika_ui/ui/widgets/appButton.dart';
import 'package:saidika_ui/ui/widgets/appTextField.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/constants.dart';

import 'package:http/http.dart' as http;
import 'package:saidika_ui/utils/route.dart';

List<FocusNode> focusNodes = [
  FocusNode(),
  FocusNode(),
  FocusNode(),
  FocusNode(),
  FocusNode(),
  FocusNode(),
  FocusNode(),
  FocusNode(),
  FocusNode(),
];

var selectedValue = "FINDER";

class SignUpManuallyScreen extends StatefulWidget {
  const SignUpManuallyScreen({Key? key}) : super(key: key);

  @override
  State<SignUpManuallyScreen> createState() => _SignUpManuallyScreenState();
}

class _SignUpManuallyScreenState extends State<SignUpManuallyScreen> {

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  // String? cookie;


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

    var url;
    if (selectedValue == 'PROVIDER'){
      url = Uri.parse('http://192.168.137.1:8080/api/v1/provider/register');
      print(url);
    }else if (selectedValue == 'FINDER'){
      url = Uri.parse('http://192.168.137.1:8080/api/v1/finder/register');
      print(url);
    }

    Map<String, dynamic> data = {
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "role": selectedValue,
      "password": passwordController.text,
      "confirmPassword": confirmPasswordController.text

    };

    // if (passwordController.text == confirmPasswordController.text){
    //   print(json.encode(data));
    //   Navigator.pushReplacementNamed(context, homePage);
    // }

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(data),  // Encode the data as JSON
    );

    // print(response.statusCode);
    // print(json.encode(data));
    print(response.body);

    if (await response.statusCode == 201 || await response.statusCode == 200 ) {
      // Success: Handle the response here
      print(response.body);
      // var responseBody = jsonDecode(response.body);
      // print(cookie);
      // print('Message: ${responseBody}');
      print('Account created successfully');

      if (selectedValue == 'PROVIDER'){
        Navigator.pushReplacementNamed(context, addService);
      }else if (selectedValue == 'FINDER'){
        Navigator.pushReplacementNamed(context, signInEmail);
      }

    }

    try {
      if (true) {

      } else {
        // Error: Handle the error response here
        print('Error creating account: ${response.statusCode}');
      }
    } catch(e) {
      print('Failed to create account: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(context, "Fill your profile"),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsetsDirectional.all(20),
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
                SizedBox(height: 20),
                AppTextField(
                    textFieldCallBack: onFocusChanged,
                    hintText: 'First name',
                    prefixIcon: Icons.person,
                    focusNode: focusNodes[0],
                    controller: firstNameController),
                AppTextField(
                    textFieldCallBack: onFocusChanged,
                    hintText: 'Last Name',
                    prefixIcon: Icons.person,
                    controller: lastNameController,
                    focusNode: focusNodes[1]),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Date of birth',
                  prefixIcon: Icons.calendar_month,
                  controller: dobController,
                  focusNode: focusNodes[2],
                  keyboardType: TextInputType.datetime,
                ),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Email',
                  prefixIcon: Icons.mail_rounded,
                  controller: emailController,
                  focusNode: focusNodes[3],
                  keyboardType: TextInputType.emailAddress,
                ),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Phone number',
                  prefixIcon: Icons.phone_android,
                  controller: phoneController,
                  focusNode: focusNodes[4],
                  keyboardType: TextInputType.phone,
                ),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Password',
                  prefixIcon: Icons.lock,
                  controller: passwordController,
                  focusNode: focusNodes[5],
                  isPasswordField: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  controller: confirmPasswordController,
                  isPasswordField: true,
                  focusNode: focusNodes[6],
                  keyboardType: TextInputType.visiblePassword,
                ),
                DropdownButtonFormField(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  decoration: InputDecoration(
                    prefixIcon: selectedValue == "FINDER"
                        ? Icon(Icons.home_repair_service, color: AppColors.textColorLight)
                        : Icon(Icons.search, color: AppColors.textColorLight),
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
                SizedBox(height: 20),
                AppButton(
                  btnText: 'Create Account',
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
