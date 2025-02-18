
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/appBar.dart';
import 'package:saidika_ui/ui/widgets/appButton.dart';
import 'package:saidika_ui/ui/widgets/appTextField.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/cache_profile_image.dart';
import 'package:saidika_ui/utils/constants.dart';

import 'package:http/http.dart' as http;
import 'package:saidika_ui/utils/route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

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
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final TextEditingController locatonController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? role;
  XFile? _selectedImage;
  File? profileImage;

  Future<void> getProfileImage() async {
    var directory = await getApplicationDocumentsDirectory();
    profileImage = File('${directory.path}/profileImage');
    print(profileImage);
    print(profileImage.runtimeType);
    setState(() {});  // Update the state once directory is initialized
  }

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

    var url = Uri.parse('https://saidika-backend.onrender.com/active_User');

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
        locatonController.text = user?['location'] ?? '';
        phoneController.text = user?['phone'] ?? '';
        role = user?['role'];
      });
      print(user);
      print(user!['id']);
      print(user!['first_name']);
      print(user!['last_name']);
      print(user!['phone']);
    }

    return "Hello";
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

  Future<void> editProfile() async{

    final SharedPreferences sharedPreferences = await prefs;

    String? userToken = sharedPreferences.getString('userToken');

    Uri url;
    if(role == 'PROVIDER') {
      url = Uri.parse('https://saidika-backend.onrender.com/api/v1/provider/update_profile');
    }else{
      url = Uri.parse('https://saidika-backend.onrender.com/api/v1/finder/update_profile');
    }

    print(url);

    Map<String, dynamic> data = {
      "location": locatonController.text,
      "phone_number": phoneController.text,
      "password": passwordController.text,
    };

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": '$userToken',
      },
      body: json.encode(data),  // Encode the data as JSON
    );

    // print(response.statusCode);
    // print(json.encode(data));
    print(response.body);

    if (response.statusCode == 201 || response.statusCode == 200 ) {

      print(response.body);

      print('Account updated successfully');

      Navigator.pop(context);

    }
  }

  // Future<void> updateProfilePicture() async {
  //   final SharedPreferences sharedPreferences = await prefs;
  //   String? userToken = sharedPreferences.getString('userToken');
  //
  //   // Determine the URL based on the role
  //   Uri url;
  //   if (role == 'PROVIDER') {
  //     url = Uri.parse('http://192.168.100.45:8080/api/v1/provider/update_profile');
  //   } else {
  //     url = Uri.parse('http://192.168.100.45:8080/api/v1/finder/update_profile');
  //   }
  //
  //   var request = http.MultipartRequest('POST', url);
  //
  //   // Add headers for authorization
  //   request.headers['Authorization'] = userToken.toString ?? '';
  //
  //   // Check if an image is selected
  //   if (_selectedImage != null) {
  //     String fileExtension = _selectedImage!.path.split('.').last.toLowerCase();
  //     String? mimeType;
  //
  //     if (fileExtension == 'jpeg' || fileExtension == 'jpg') {
  //       mimeType = 'jpeg';
  //     } else if (fileExtension == 'png') {
  //       mimeType = 'png';
  //     } else {
  //       print("Unsupported file type.");
  //       return; // Exit if the file type is unsupported
  //     }
  //
  //     // Add the image file to the request
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'image', // Field name as expected by the server
  //         _selectedImage!.path,
  //         contentType: MediaType('image', mimeType),
  //       ),
  //     );
  //   } else {
  //     print("No profile photo selected.");
  //     return; // Exit if no image is selected
  //   }
  //
  //   try {
  //     // Send the request and wait for a response
  //     http.StreamedResponse response = await request.send();
  //
  //     // Check the status code
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print('Profile Photo updated successfully');
  //
  //       // Read the response body
  //       String responseBody = await response.stream.bytesToString();
  //       print('Response body: $responseBody');
  //
  //       // Navigate or update UI on success
  //       Navigator.pop(context);
  //     } else {
  //       print('Failed to update');
  //       String errorResponse = await response.stream.bytesToString();
  //       print('Error: $errorResponse');
  //     }
  //   } catch (e) {
  //     print('Failed to update profile photo: $e');
  //   }
  // }


  Future<void> updateProfilePicture() async {
    final SharedPreferences sharedPreferences = await prefs;
    String? userToken = sharedPreferences.getString('userToken');

    Uri url;
    if (role == 'PROVIDER') {
      url = Uri.parse('https://saidika-backend.onrender.com/api/v1/provider/updateProfilePhoto');
    } else {
      url = Uri.parse('https://saidika-backend.onrender.com/api/v1/finder/updateProfilePhoto');
    }

    try {
      if (_selectedImage != null){
        var request = http.MultipartRequest('POST', url)
          ..headers['Authorization'] = userToken.toString()
          ..files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));

        var response = await request.send();

        if (response.statusCode == 200) {
          print("Profile photo updated successfully");
          await downloadAndSaveImage('https://saidika-backend.onrender.com/api/v1/provider/getpp', 'profileImage');
          setState(() {
            imageCache.clear();
            imageCache.clearLiveImages();
          });
        } else {
          print("Failed to update profile photo: ${response.statusCode}");
        }
      }



    } catch (e) {
      print("Error: $e");
    }
  }



  @override
  void initState() {
    super.initState();
    getActiveProfile();
  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(context, "Edit your profile"),
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
                            ) : profileImage != null ? Image.file(
                              File(profileImage!.path),) :
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
                  hintText: 'Phone number',
                  prefixIcon: Icons.phone_android,
                  controller: phoneController,
                  focusNode: focusNodes[1],
                  keyboardType: TextInputType.phone,
                ),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'New Password',
                  prefixIcon: Icons.lock,
                  controller: passwordController,
                  focusNode: focusNodes[2],
                  isPasswordField: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Confirm New Password',
                  prefixIcon: Icons.lock_outline,
                  controller: confirmPasswordController,
                  isPasswordField: true,
                  focusNode: focusNodes[3],
                  keyboardType: TextInputType.visiblePassword,
                ),
                AppTextField(
                  textFieldCallBack: onFocusChanged,
                  hintText: 'Location',
                  prefixIcon: Icons.location_on,
                  controller: locatonController,
                  isPasswordField: true,
                  focusNode: focusNodes[4],
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 20),
                AppButton(
                  btnText: 'Update Account',
                  textSize: 15,
                  voidCallBack: (){
                    updateProfilePicture();
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
