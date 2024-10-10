
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
import 'package:shared_preferences/shared_preferences.dart';

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

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

  Map<String, dynamic>? user;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<String> getActiveProfile() async{

    final SharedPreferences sharedPreferences = await prefs;
    String? userToken = sharedPreferences.getString('userToken');

    var url = Uri.parse('http://192.168.137.1:8080/active_User');

    var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": '$userToken'
        }
    );

    // print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      setState(() {
        user = responseBody as Map<String, dynamic>;
        firstNameController.text = user?['first_name'] ?? '';
        lastNameController.text = user?['last_name'] ?? '';
        emailController.text = user?['email'] ?? '';
        phoneController.text = user?['phone'] ?? '';
        // If you have the DOB in the user data, set it as well
        // dobController.text = user?['dob'] ?? ''; // Uncomment if needed
      });
      print(user);
      print(user!['id']);
      print(user!['first_name']);
      print(user!['last_name']);
      print(user!['phone']);
    }

    return "Hello";
  }

  @override
  void initState() {
    super.initState();
    getActiveProfile();
  }

  Future<void> editProfile() async{

    var url = Uri.parse('http://192.168.137.1:8080/api/v1/provider/register');

    Map<String, dynamic> data = {
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "password": passwordController.text,
      "confirmPassword": confirmPasswordController.text
    };

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

      print(response.body);

      print('Account updated successfully');

      Navigator.pop(context);

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(context, "Edit your profile"),
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
                SizedBox(height: 20),
                AppButton(
                  btnText: 'Update Account',
                  textSize: 15,
                  voidCallBack: (){
                    editProfile();
                    // Navigator.pushReplacementNamed(context, homeScreen);
                  },
                )
              ],
            ),
          )),
    );
  }
}
