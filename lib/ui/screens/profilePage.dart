import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/bottomNavigation.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/DesignConfig.dart';
import 'package:saidika_ui/utils/StringsRes.dart';
import 'package:saidika_ui/utils/constants.dart';
import 'package:saidika_ui/utils/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int tabIndex = 0; //Tab for description as default

  int _selectedIndex = 3; // Profile is at index 1

  Map<String, dynamic>? user;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      //Handling navigation to different pages
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

          break;
      }
    });
  }

  Future<String> getActiveProfile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('http://192.168.6.16:8080/active_User');

    var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs.getString('userToken').toString()
        }// Encode the data as JSON
    );

    // print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Extract cookie from response headers
      // String? rawCookie = response.headers['set-cookie'];
      var responseBody = jsonDecode(response.body);
      setState(() {
        user = responseBody as Map<String, dynamic>;
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

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken'); // Clear the session token
    await prefs.remove('userId'); // Clear the session token

    Navigator.pushNamed(context, signInScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:Drawer(
        child: drawerData(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: user == null
           ? SpinKitFadingCube(
              color: AppColors.primaryColor,
              size: 50.0,
            )
          : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer(); // Opens the drawer correctly
                        },
                        child: Icon(
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
                        )
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
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: imageAsset(
                      isNormalImage: true,
                      fileName: 'profile.jpg',
                      imgHeight: 145,
                      imgWidth: 145,
                    ),
                  ),
                  Text(
                    '${user!['first_name']} ${user!['last_name']}',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    'Plumber',
                    style: TextStyle(
                        fontSize: 22
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                      ),
                      Text(
                        StringsRes.locationDefault,
                        style: TextStyle(
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                  Text(
                    user!['phone'],
                    style: TextStyle(
                        fontSize: 18
                    ),
                  )
                ],
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        tabIndex = 0;
                      });
                    },
                    child: Container(
                      height: 36,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: Colors.grey,
                            width: 2
                        ),
                        color: tabIndex == 0 ? Colors.orange : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'Description',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        tabIndex = 1;
                      });
                    },
                    child: Container(
                      height: 36,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: Colors.grey,
                            width: 2
                        ),
                        color: tabIndex == 1 ? Colors.orange : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                            'Reviews'
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        tabIndex = 2;
                      });
                    },
                    child: Container(
                      height: 36,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: Colors.grey,
                            width: 2
                        ),
                        color: tabIndex == 2 ? Colors.orange : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                            'Ratings'
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                child: _buildSelectedWidget(),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }

  Widget _buildSelectedWidget() {
    switch (tabIndex) {
      case 0:
        return Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');
      case 1:
        return Text('The reviews');
      case 2:
        return Text('The ratings');
      default:
        return Text('Lorem ipsum dolor sit amet.');
    }
  }


  Widget drawerData() {
    var width = MediaQuery.of(context).size.width / 8;
    return Column(
      children: [
        Container(
          // decoration: BoxDecoration(
          //   gradient: DesignConfig.gradient,
          // ),
          padding: const EdgeInsets.only(top: 50, bottom: 15,left: 15),
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              if (Platform.isIOS) BackButton(color: Colors.white),
              Container(
                width: 85,
                height: 85,
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(45.0)),
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: imageAsset(
                    isNormalImage: true,
                    fileName: 'profile.jpg',
                    imgHeight: 130,
                    imgWidth: 130,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Name',
                      style: appTextTheme(context).labelMedium
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
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
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileActivity(data: data,)));
                },
              ),
              ListTile(
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
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileActivity(data: data,)));
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/images/logout.svg",
                  height: MediaQuery.of(context).size.width / 14,
                ),
                title: Text('Logout',
                  style: appTextTheme(context).labelMedium),
                subtitle: Divider(
                  color: AppColors.primaryApp,
                  endIndent: 40,
                ),
                onTap: () {
                  Navigator.pop(context);
                  //Constant.session.logoutUser(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: DesignConfig.roundedrectangleshape,
                        title: Text(
                          StringsRes.logout,
                          style: appTextTheme(context).labelMedium?.copyWith(color: AppColors.primaryColor),
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
                              style: appTextTheme(context).labelMedium?.copyWith(color: Colors.red),
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
    );
  }

}




