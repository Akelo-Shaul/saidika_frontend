
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saidika_ui/configs/FirebaseNotifs.dart';
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

var selectedValue = "FINDER";

class SignUpManuallyScreen extends StatefulWidget {
  const SignUpManuallyScreen({super.key});

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
  final TextEditingController otpController = TextEditingController();

  bool isTrue = false;

  // String? cookie;

  String message = '';
  int? messageCode;
  String emailMessage = '';
  int? emailStatusCode;

  XFile? _selectedImage;

  String selectedLocation = 'Select Location';

  late FirebaseMessaging messaging;


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

  Future<void> sendOtp() async {
    String email = emailController.text;
    var url = Uri.parse('https://saidika-backend.onrender.com/send_otp?email=$email');
    print(url);
    if(email.isNotEmpty){
      // print(emailController.text);
      // print('Sending the OTP to gmail');
      var response = await http.post(
        url,
      );
      // print(response.body);
      var data = jsonDecode(response.body);
      print(data);
      print(data['message']);

      setState(() {
        emailMessage = data['message'];
        emailStatusCode = data['statusCode'];
      });
    }
  }

  Future<void> _openCamera() async {
    final result = await Navigator.pushNamed(context, cameraPage);
    if (result is XFile) {
      print('Image Result: ${result.path}');

      setState(() {
        _selectedImage = result;
        print('Selected Image Path: ${_selectedImage!.path}');
      });
    } else {
      print('No image captured');
    }
  }

  Future<void> createAccount() async{

    Uri url = Uri.parse('');
    if (selectedValue == 'PROVIDER') {
      url = Uri.parse('https://saidika-backend.onrender.com/api/v1/provider/register');
      print(url);
    } else if (selectedValue == 'FINDER') {
      url = Uri.parse('https://saidika-backend.onrender.com/api/v1/finder/register');
      print(url);
    }


    // Create a multipart request
    var request = http.MultipartRequest('POST', url);


    // Add JSON data as a field for `reg_model`
    request.fields.addAll({
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "role": selectedValue,
      "location": selectedLocation,
      'confirmPassword': confirmPasswordController.text,
      "password": passwordController.text
    });

    // Add the profile picture file
    if (_selectedImage != null) {

      // Add the profile picture file
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_pic', // Field name as expected by the server
          _selectedImage!.path,
        ),
      );
    } else {
      print("No profile photo selected.");
    }



    try {
      // Send the request and get a response
      http.StreamedResponse response = await request.send();

      print(response);
      // Handle the response
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Account created successfully');
        // You can read the response if needed
        String responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');

        // Navigate or update UI on success
        Navigator.pushNamed(context, signInEmail);
      } else {
        print('Failed to create account');
        String errorResponse = await response.stream.bytesToString();
        print('Error: $errorResponse');
      }
    } catch (e) {
      print('Failed to create account: $e');
    }

    print(request.fields);
    print(request.files);
    print(request.headers);

  }


  Future<void> checkOtp() async{
    String otpCode = otpController.text;
    var url = Uri.parse('https://saidika-backend.onrender.com/verify_otp?code=$otpCode');
    print(url);
    if(otpCode.isNotEmpty){
      var response = await http.post(
        url,
      );
      // print(response.body);
      var data = jsonDecode(response.body);
      print(data);
      print(data['message']);
      setState(() {
        message = data['message'];
        messageCode = data['statusCode'];
      });
    }

  }


  void _showCustomLocationDropdown(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String tempSearchValue = ""; // Temporary search value within the dialog's state
        List<String> filteredLocation = locationList; // Start with the full list of services

        return StatefulBuilder( // Use StatefulBuilder to manage the state within the dialog
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // No rounded corners for full screen
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // Full width
                height: MediaQuery.of(context).size.height, // Full height
                child: Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Select Location',
                          hintStyle: appTextTheme(context).labelMedium,
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          // Update the filtered services based on search input
                          setState(() {
                            tempSearchValue = value;
                            filteredLocation = locationList
                                .where((item) => item.toLowerCase().contains(tempSearchValue.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),

                    // Filtered list of services
                    Expanded( // Use Expanded to take remaining space
                      child: ListView.builder(
                        itemCount: filteredLocation.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              filteredLocation[index],
                              style: appTextTheme(context).labelMedium,
                            ),
                            onTap: () {
                              Navigator.pop(context, filteredLocation[index]);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((selectedLocationValue){
      if (selectedLocationValue != null){
        setState(() {
          selectedLocation = selectedLocationValue;
        });
      }
    });
  }

  @override
  void initState() async{
    super.initState();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setupFirebaseNotifications();
    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) async {
      if (value != null) {
        await prefs.setString("notifToken", value);
      }
    });
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
                GestureDetector(
                  onTap: _openCamera,
                  child: Stack(
                    children: [
                      Positioned(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _selectedImage != null ?
                           SizedBox(
                            height: 130,
                            width: 130,
                            child: Image.file(File(_selectedImage!.path), fit: BoxFit.cover), // Use fit to avoid overflow
                          ) :
                          imageAsset(
                            isNormalImage: true,
                            fileName: 'profile.jpg',
                            imgHeight: 130,
                            imgWidth: 130,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit_square,
                            color: AppColors.primaryColor,
                            size: 40,
                          ),
                          onPressed: _openCamera, // Remove image action
                        ),
                      ),
                    ]
                  ),
                ),
                const SizedBox(height: 20),
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
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2008, 12, 5),
                      firstDate: DateTime(1850),
                        lastDate: DateTime(DateTime.now().year - 16, 12, 31),
                        builder:(BuildContext context, Widget? child){
                        return Theme(
                          data: Theme.of(context).copyWith(
                            dialogTheme: DialogTheme(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                              ),
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                textStyle: TextStyle(
                                  fontSize: 16, // Set the font size for the buttons
                                  fontWeight: FontWeight.bold, // Customize font weight if needed
                                  color: AppColors.primaryColor, // Change text color if required
                                ),
                              )
                            ),
                            inputDecorationTheme: const InputDecorationTheme(
                              contentPadding: EdgeInsets.only(bottom: 100),
                            ),
                          ),
                          child: child!);
                      }
                    );

                    if (pickedDate != null) {
                      // Format the selected date and update the controller
                      dobController.text = "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                    }

                  },
                  child: AbsorbPointer(
                    child: AppTextField(
                      textFieldCallBack: onFocusChanged,
                      hintText: 'Date of birth',
                      prefixIcon: Icons.calendar_month,
                      controller: dobController,
                      focusNode: focusNodes[2],
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Email',
                  prefixIcon: Icons.mail_rounded,
                  controller: emailController,
                  focusNode: focusNodes[3],
                  keyboardType: TextInputType.emailAddress,
                ),
                emailMessage.isNotEmpty && emailMessage != '' ? Container(
                    margin: const EdgeInsetsDirectional.only(bottom: 20,top: 0),
                    child: emailStatusCode == 200
                        ? Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.green,),
                            const SizedBox(width: 6,),
                            Text(
                              emailMessage,
                              style: appTextTheme(context).labelSmall!.copyWith(
                                  color: AppColors.green
                              ),
                            )
                          ],
                        )
                        : Row(
                          children: [
                            Icon(Icons.cancel, color: AppColors.red,),
                            const SizedBox(width: 6,),
                            Text(
                              emailMessage,
                              style: appTextTheme(context).labelSmall!.copyWith(
                                  color: AppColors.red
                              ),
                            )
                          ],
                        )
                ) : Container(),
                Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextFieldNoMargin(
                              textFieldCallBack: onFocusChanged,
                              hintText: 'OTP',
                              prefixIcon: Icons.shield,
                              controller: otpController,
                              onChanged: (value){
                                  if (value.length == 6) {
                                    checkOtp();
                                  }
                              },
                              focusNode: focusNodes[4],
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(width: 10),  // Add spacing between the text field and button
                          AppButton(
                            btnText: 'Send',
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.17,
                            textSize: 15,
                            voidCallBack: (){
                              sendOtp();
                              // Navigator.pushReplacementNamed(context, homeScreen);
                            },
                          ),
                        ]
                    ),
                  ],
                ),
                message.isNotEmpty && message != '' ? Container(
                  margin: const EdgeInsetsDirectional.only(bottom: 20,top: 0),
                  child: messageCode == 200
                  ? Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.green,),
                      const SizedBox(width: 6,),
                      Text(
                        message,
                        style: appTextTheme(context).labelSmall!.copyWith(
                            color: AppColors.green
                        ),
                      )
                    ],
                  )
                  : Row(
                    children: [
                      Icon(Icons.cancel, color: AppColors.red,),
                      const SizedBox(width: 6,),
                      Text(
                        message,
                        style: appTextTheme(context).labelSmall!.copyWith(
                            color: AppColors.red
                        ),
                      )
                    ],
                  )
                ) : Container(),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Phone number',
                  prefixIcon: Icons.phone_android,
                  controller: phoneController,
                  focusNode: focusNodes[5],
                  keyboardType: TextInputType.phone,
                ),

                GestureDetector(
                  onTap: () {
                    // Trigger dropdown when tapped
                    _showCustomLocationDropdown(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: AppColors.textColorLight),
                            const SizedBox(width: 8),
                            Text(
                              selectedLocation ?? "Select a Location",
                              style: appTextTheme(context).labelMedium?.copyWith(color: AppColors.textColorLight),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_drop_down, color: AppColors.textColorLight),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Password',
                  prefixIcon: Icons.lock,
                  controller: passwordController,
                  focusNode: focusNodes[6],
                  isPasswordField: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  controller: confirmPasswordController,
                  isPasswordField: true,
                  focusNode: focusNodes[7],
                  keyboardType: TextInputType.visiblePassword,
                ),
                DropdownButtonFormField(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                const SizedBox(height: 20),
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
