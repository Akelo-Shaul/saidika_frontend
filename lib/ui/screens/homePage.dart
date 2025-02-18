import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/bottomNavigation.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/StringsRes.dart';
import 'package:saidika_ui/utils/cache_profile_image.dart';
import 'package:saidika_ui/utils/constants.dart';
import 'package:saidika_ui/utils/route.dart';
import 'package:saidika_ui/utils/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


class _HomePageState extends State<HomePage> {
  //The home Top picks and services display
  List<Service> services = [
    Service(name: 'Plumbing', description: "quality plumbing services", imageUrl: '${imagePath}service_images/plumbing.jpg', appearanceInDB: 3),
    Service(name: "Electrical", description: "Mechanic", imageUrl: '${imagePath}service_images/electrical.jpg', appearanceInDB: 9),
    Service(name: 'Mechanic', description: 'Car, Engine and other mechanical services available', imageUrl: '${imagePath}service_images/mechanic.jpg', appearanceInDB: 5),
    Service(name: 'Cobler', description: 'shoes repair', imageUrl: '${imagePath}service_images/cobler.jpg', appearanceInDB: 0),
    Service(name: 'Cobler', description: 'shoes repair', imageUrl: '${imagePath}service_images/cobler.jpg', appearanceInDB: 0),
    Service(name: 'Cobler', description: 'shoes repair', imageUrl: '${imagePath}service_images/cobler.jpg', appearanceInDB: 0),
    Service(name: 'Cobler', description: 'shoes repair', imageUrl: '${imagePath}service_images/cobler.jpg', appearanceInDB: 0),
    Service(name: 'Cobler', description: 'shoes repair', imageUrl: '${imagePath}service_images/cobler.jpg', appearanceInDB: 0),
    Service(name: 'Cobler', description: 'shoes repair', imageUrl: '${imagePath}service_images/cobler.jpg', appearanceInDB: 0),
    Service(name: 'Cobler', description: 'shoes repair', imageUrl: '${imagePath}service_images/cobler.jpg', appearanceInDB: 0),
    Service(name: 'Cobler', description: 'shoes repair', imageUrl: '${imagePath}service_images/cobler.jpg', appearanceInDB: 0),
  ];

  final List<Map<String, dynamic>> notifications = [
    {
      'icon': Icons.notifications,
      'title': 'New message received',
      'subtitle': 'You have a new message.',
    },
    {
      'icon': Icons.notifications,
      'title': 'ALoha',
      'subtitle': 'Another message.',
    },
    // Additional notification objects here...
  ];

  String currentSelectedPage = '';

  //TODO: Hande this with cookies
  bool isLoggedIn = false;
  //TODO: Get from user logged in profile
  //currentLocation declaration
  String? currentLocation;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  String capitalize(String? input) {
    if (input == null || input.isEmpty) {
      return ''; // Handle null or empty cases
    }
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  Uint8List? imageBytes;
  File? profileImage;

  Future<void> getProfileImage() async {
    var directory = await getApplicationDocumentsDirectory();
    profileImage = File('${directory.path}/profileImage');
    setState(() {});  // Update the state once directory is initialized
  }

  Future<void> getProfile() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();



    var profileUrl = Uri.parse('https://saidika-backend.onrender.com/api/v1/provider/getpp');

    var profileImageResponse = await http.get(
        profileUrl,
        headers: {
          "Authorization": prefs.getString('userToken').toString()
        }
    );

    imageBytes = profileImageResponse.bodyBytes;
  }
  Future<void> makeAuthorizedRequest() async {
    final SharedPreferences sharedPreferences = await prefs;

    String? userToken = sharedPreferences.getString('userToken');
    String? userName = sharedPreferences.getString('userName');
    String? userLocation = sharedPreferences.getString('userLocation');

    setState(() {
      print(userName);
      if (userToken != null) {
        isLoggedIn = true;
      }

      // Safely assign userName, ensuring it's not null
      if (userName != null && userName.isNotEmpty) {
        currentSelectedPage = isLoggedIn
            ? 'Hi, ${capitalize(userName)}!'
            : 'Hi, There!';
      }

      if (userLocation != null && userLocation.isNotEmpty) {
        currentLocation = userLocation.toString();
      }

      // print(currentSelectedPage);
    });

    // print(userToken);

  }

  Future<void> getLocation() async{
    final SharedPreferences sharedPreferences = await prefs;

    //TODO: Get Location from current session
  }

  Future<void> navigateToAddService() async {
    final SharedPreferences sharedPreferences = await prefs;

    // Ensure SharedPreferences is ready before checking the value
    bool? firstTimeLogin = sharedPreferences.getBool('first_time_login') ?? false;

    // Check the value of first_time_login and navigate if true
    if (firstTimeLogin) {
      print('Navigate to addService Page');
      // Clear the flag after first navigation (optional, if you don't want repeated navigation)
      sharedPreferences.setBool('first_time_login', false);

      // Navigate to the addService page
      Navigator.pushNamed(context, addService);
    } else {
      print('First time login is not set, or already navigated.');
    }
  }

  @override
  void initState(){
    super.initState();
    getProfile();
    sortByAppearance();
    navigateToAddService();
    makeAuthorizedRequest();
    downloadAndSaveImage('https://saidika-backend.onrender.com/api/v1/provider/getpp', 'profileImage').then((file) {
      // Use the file, e.g., display it
      print('Image saved at: ${file.path}');
      setState(() {
        imageCache.clear();
        imageCache.clearLiveImages();
      });
    }).catchError((e) {
      print('Failed to download and save image: $e');
    });
    getProfileImage();
  }

  void sortByAppearance(){
    services.sort((a,b) => b.appearanceInDB.compareTo(a.appearanceInDB));
  }


  //Navigaton through pages section
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      //Handling navigation to different pages
      if(index !=0){
        switch (index) {
          case 0:
            break;
          case 1:
            Navigator.pushReplacementNamed(context, search);
            break;
          case 2:
            Navigator.pushReplacementNamed(context, chats);
            break;
          case 3:
            Navigator.pushReplacementNamed(context, profile);
            break;
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    if (currentLocation == null || currentLocation!.isEmpty) {
      currentLocation = 'Nairobi';
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: ListTile(
                              leading: Icon(notification['icon']),
                              title: Text(notification['title']),
                              subtitle: Text(notification['subtitle']),
                            ),
                          ),
                          // Add a divider after each ListTile except the last one.
                          // if (index < notifications.length - 1) const Divider(),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),

        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: profileImage != null ?
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Image.file(File(profileImage!.path), fit: BoxFit.cover), // Use fit to avoid overflow
                                ) :
                                imageAsset(
                                    isNormalImage: true,
                                    fileName: 'profile.jpg',
                                    imgHeight: 45,
                                    imgWidth: 45,
                                  )
                              ),
                              const SizedBox(width: 10),
                              Text(
                                currentSelectedPage,
                                style: appTextTheme(context)
                                    .labelMedium
                                    ?.copyWith(fontWeight: FontWeight.bold
                                  // fontFamily: 'Signika',
                                ),
                              ),
                            ],
                          ),
                           IconButton(
                            icon: const Icon(Icons.notifications_active),
                            onPressed: () {
                              _scaffoldKey.currentState?.openEndDrawer();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringsRes.location,
                            style: appTextTheme(context)
                                .labelSmall
                                // ?.copyWith(fontWeight: FontWeight.bold
                            // ),
                          ),
                          SizedBox(
                            height: 25,
                            child: TextButton(
                              onPressed: () async{
                                // final result = await Navigator.pushNamed(context, '/setLocation')as Map<String, dynamic>?;
                                final result = await Navigator.pushNamed(context, setLocation);
                                if (result != null) {
                                  print(result);
                                  setState(() {
                                    currentLocation = result.toString();
                                  });
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    currentLocation!,
                                    style: appTextTheme(context)
                                        .labelMedium
                                        ?.copyWith(fontWeight: FontWeight.bold,color: AppColors.orange
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Top Picks",
                                style: appTextTheme(context)
                                    .labelSmall
                                    ?.copyWith(fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Text(
                              //   "See All",
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 105.0, // Set the height for the ListView
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: services.length > 5 ? 5 : services.length,
                              itemBuilder: (context, index) {
                                final service = services[index];
                                return GestureDetector(
                                  onTap: (){
                                    // print('Navigating with service name: ${service.name}');
                                    Navigator.pushNamed(context, search, arguments: service.name);
                                  },
                                  child: Container(
                                    width: 100,
                                    // Fixed width for each item
                                    margin: const EdgeInsets.only(right: 8.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(service.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2.0,
                                      ),
                                    ),
                                    // Space between items
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 0, 3),
                                        child: Text(
                                          service.name,
                                          style: const TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "All Services",
                                style: appTextTheme(context)
                                    .labelSmall
                                    ?.copyWith(fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Container(// Set the height for the ListView
                                // height: 900,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: services.length, // Set the item count to the length of the services list
                                  itemBuilder: (context, index) {
                                    final service = services[index];
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, search, arguments: service.name);
                                      },
                                      child: Container(
                                        width: 100, // Fixed width for each item
                                        margin: const EdgeInsets.only(right: 8.0),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(service.imageUrl), // Use the correct image path variable
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 2.0,
                                          ),
                                        ), // Space between items
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 3),
                                            child: Text(
                                              service.name,
                                              style: const TextStyle(
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )

                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        //The bottom navigation bar
        bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
        ),
      ),
    );
  }

}
