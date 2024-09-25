import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/widgets/bottomNavigation.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/StringsRes.dart';
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

    var url = Uri.parse('http://192.168.6.55:8080/active_User');

    var response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs.getString('userToken').toString()
        }// Encode the data as JSON
    );

    print(response.body);

    return "Hello";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.settings,
                      size: 30,
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
                    'Moses Kuria',
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
                    '+254708090304',
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

}




