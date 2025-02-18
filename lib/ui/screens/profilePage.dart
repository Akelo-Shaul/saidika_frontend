import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/appButton.dart';
import 'package:saidika_ui/ui/widgets/appTextField.dart';
import 'package:saidika_ui/ui/widgets/bottomNavigation.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/DesignConfig.dart';
import 'package:saidika_ui/utils/StringsRes.dart';
import 'package:saidika_ui/utils/constants.dart';
import 'package:saidika_ui/utils/route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

List<FocusNode> focusNode = [FocusNode()];

class _ProfileState extends State<Profile> {
  int tabIndex = 0; // Tab for description as default
  int _selectedIndex = 3; // Profile is at index 3
  Map<String, dynamic>? user;
  TextEditingController commentController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  String role = 'FINDER';
  Uint8List? imageBytes;
  File? profileImage;
  List<dynamic> serviceList = [];
  List<dynamic> commentRating = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handling navigation to different pages
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, homePage);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, search);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, chats);
        break;
      case 3:
      // Current page.
        break;
    }
  }

  Future<void> getProfileImage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      profileImage = File('${directory.path}/profileImage');
      debugPrint('Profile image path: ${profileImage!.path}');
      setState(() {}); // Update the state once directory is initialized
    } catch (e) {
      debugPrint('Error getting profile image: $e');
    }
  }

  Future<void> getActiveProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');
      String? userRole = prefs.getString('userRole');

      if (token == null) {
        debugPrint('No user token found');
        return;
      }


      Uri url = Uri.parse('');

      if (userRole == 'PROVIDER'){
        url = Uri.parse('https://saidika-backend.onrender.com/api/v1/provider/activeUser');
        print(url);
      }else if (userRole == 'FINDER'){
        url  = Uri.parse('https://saidika-backend.onrender.com/api/v1/finder/activeUser');
        print(url);
      }

      var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        setState(() {
          user = responseBody as Map<String, dynamic>;
          role = user!['role'];
        });
        debugPrint('User fetched: $user');
      } else {
        debugPrint('Failed to fetch active profile. Status code: ${response.statusCode}');
      }

      // Fetch profile image
      var profileUrl = Uri.parse('https://saidika-backend.onrender.com/api/v1/provider/getpp');
      var profileImageResponse = await http.get(
        profileUrl,
        headers: {
          "Authorization": token,
        },
      );
      if (profileImageResponse.statusCode == 200) {
        setState(() {
          imageBytes = profileImageResponse.bodyBytes;
        });
        debugPrint('Profile image fetched successfully');
      } else {
        debugPrint('Failed to fetch profile image. Status code: ${profileImageResponse.statusCode}');
      }

      var servicesListUrl = Uri.parse('https://saidika-backend.onrender.com/api/v1/services/get_services_offered');
      var servicesListResponse = await http.get(
        servicesListUrl,
        headers: {
          "Authorization": token,
        },
      );
      if(servicesListResponse.statusCode == 200){
        setState((){
          serviceList = jsonDecode(servicesListResponse.body);
          commentRating = serviceList[0]['provider']['comments'];
        });
        print(serviceList[0]['provider']['comments']);
      }else{
        print('List fetch fail');
      }



    } catch (e) {
      debugPrint('Error in getActiveProfile: $e');
    }
  }

  Future<void> addCommentRating(serviceId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');

      var url = Uri.parse('https://saidika-backend.onrender.com/api/v1/comments/${serviceId}');

      Map<String, dynamic> body = {
        "comment": commentController.text.trim(),
        "rating": int.tryParse(ratingController.text) ?? 1
      };


      print(body);

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": token,
        },
        body: json.encode(body),  // Encode the data as JSON
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Comment posted successfully: ${response.body}");
        setState(() {
          commentController.clear();
          ratingController.clear();
        });
      } else {
        print("Failed to post comment: ${response.statusCode}, ${response.body}");
      }
    }  catch (e) {
      // TODO
    }
  }

  @override
  void initState() {
    super.initState();
    getActiveProfile();
    getProfileImage();
  }

  // Removed didChangeDependencies to avoid duplicate calls

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove everything from shared preferences
    await prefs.clear();
    Navigator.pushNamed(context, signInScreen);
  }

  int currentIndex = 0;
  PageController pageController = PageController();

  void moveNext() {
    print('Moving to next');
    if (currentIndex < serviceList.length - 1) {
      setState(() {
        currentIndex++;
        pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void movePrevious() {
    print('Moving to previous');
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: drawerData(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: user == null
              ? Center(
            child: SpinKitFadingCube(
              color: AppColors.primaryColor,
              size: 50.0,
            ),
          )
              : SingleChildScrollView(
            child: Column(
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Builder(
                        builder: (context) => GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: const Icon(
                            Icons.settings,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            Icon(
                              Icons.check_box_rounded,
                              color: Colors.grey[700],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                // Profile Information
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: profileImage != null
                          ? Image.file(
                              File(profileImage!.path),
                              height: 145,
                              width: 145,
                              fit: BoxFit.cover,
                            )
                          : imageAsset(
                              isNormalImage: true,
                              fileName: 'profile.jpg',
                              imgHeight: 145,
                              imgWidth: 145,
                            ),
                    ),
                    Text(
                      '${user!['first_name']} ${user!['last_name']}'.toUpperCase(),
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: serviceList.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (currentIndex > 0)
                                      GestureDetector(
                                        onTap: movePrevious,
                                        child: const Icon(Icons.arrow_back_ios),
                                      )
                                    else
                                      const SizedBox(width: 24),

                                    Text(
                                      serviceList[currentIndex]['name']!,
                                      style: appTextTheme(context).labelMedium,
                                    ),

                                    if (currentIndex < serviceList.length - 1)
                                      GestureDetector(
                                        onTap: moveNext,
                                        child: const Icon(Icons.arrow_forward_ios),
                                      )
                                    else
                                      const SizedBox(width: 24),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 16),
                                    Text(
                                      serviceList[index]['availableLocation']!,
                                      style: appTextTheme(context).titleSmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  user!['phone'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 15),

                                // Tab-Like Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(() => tabIndex = 0),
                                      child: Container(
                                        height: 36,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.grey, width: 2),
                                          color: tabIndex == 0 ? Colors.orange : Colors.white,
                                        ),
                                        child: Center(child: Text('Description')),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () => setState(() => tabIndex = 1),
                                      child: Container(
                                        height: 36,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.grey, width: 2),
                                          color: tabIndex == 1 ? Colors.orange : Colors.white,
                                        ),
                                        child: const Center(child: Text('Reviews')),
                                      ),
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                                  child: _buildSelectedWidget(serviceList[currentIndex]['description']!, serviceList[currentIndex]['uuid']!),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }

  Widget _buildSelectedWidget(String description, String serviceId) {
    switch (tabIndex) {
      case 0:
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            description,
            style: appTextTheme(context).labelMedium
          ),
        );
      case 1:
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    hintText: 'Write Comment',
                    prefixIcon: null,
                    focusNode: focusNode[0],
                    controller: commentController,
                  ),
                ),
                const SizedBox(width: 7),
                SizedBox(
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: AppButton(
                    btnText: 'Post',
                    voidCallBack: (){
                      addCommentRating(serviceId);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: serviceList[currentIndex]['provider']['comments'].length,
              itemBuilder: (context, index) {
                final comment = serviceList[currentIndex]['provider']['comments'][index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: imageAsset(
                            isNormalImage: true,
                            fileName: 'profile.jpg',
                            imgHeight: 30,
                            imgWidth: 30,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Comment Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // comment["username"],
                                "Shaul",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              // Rating Stars
                              Row(
                                children: List.generate(
                                  5, // Maximum 5 stars
                                      (starIndex) => Icon(
                                    Icons.star,
                                    size: 14,
                                    color: starIndex < comment["rating"] ? Colors.amber : Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                comment["comment"],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        );
      default:
        return const Text('Lorem ipsum dolor sit amet.');
    }
  }

  Widget drawerData() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: Text(
                user != null
                    ? '${user!['first_name']} ${user!['last_name']}'.toUpperCase()
                    : 'John Doe',
                style: appTextTheme(context).labelLarge,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: SvgPicture.asset(
                    "${imagePath}drhome.svg",
                    height: MediaQuery.of(context).size.width / 14,
                  ),
                  title: Text(
                    'Edit Profile',
                    style: appTextTheme(context).labelMedium,
                  ),
                  subtitle: Divider(
                    color: AppColors.primaryApp,
                    endIndent: 40,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, editProfile);
                  },
                ),
                role == 'PROVIDER'
                    ? ListTile(
                  leading: SvgPicture.asset(
                    "${imagePath}addservice.svg",
                    height: MediaQuery.of(context).size.width / 14,
                  ),
                  title: Text(
                    'Add Service',
                    style: appTextTheme(context).labelMedium,
                  ),
                  subtitle: Divider(
                    color: AppColors.primaryApp,
                    endIndent: 40,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, addService);
                  },
                )
                    : const SizedBox.shrink(),
                ListTile(
                  leading: SvgPicture.asset(
                    "assets/images/logout.svg",
                    height: MediaQuery.of(context).size.width / 14,
                  ),
                  title: Text('Logout', style: appTextTheme(context).labelMedium),
                  subtitle: Divider(
                    color: AppColors.primaryApp,
                    endIndent: 40,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: DesignConfig.roundedrectangleshape,
                          title: Text(
                            StringsRes.logout,
                            style: appTextTheme(context)
                                .labelMedium
                                ?.copyWith(color: AppColors.primaryColor),
                          ),
                          content: Text(
                            StringsRes.logoutconfirm,
                            style: appTextTheme(context).labelSmall,
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                StringsRes.cancel,
                                style: appTextTheme(context).labelMedium,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                StringsRes.logout,
                                style: appTextTheme(context)
                                    .labelMedium
                                    ?.copyWith(color: Colors.red),
                              ),
                              onPressed: () {
                                logout();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
