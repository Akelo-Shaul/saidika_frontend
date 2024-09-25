import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/bottomNavigation.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/StringsRes.dart';
import 'package:saidika_ui/utils/constants.dart';
import 'package:saidika_ui/utils/route.dart';
import 'package:saidika_ui/utils/service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

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

  String currentSelectedPage = 'Hi, There!';

  //TODO: Hande this with cookies
  bool isLoggedIn = false;
  //TODO: Get from user logged in profile
  String user = 'Shaul';

  Future<void> makeAuthorizedRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');

    if (token != null){
      isLoggedIn = true;
    }

    print(token);
  }

  @override
  void initState() {
    super.initState();
    sortByAppearance();

    makeAuthorizedRequest();

    currentSelectedPage = isLoggedIn
        ? 'Hi, There!'
        : 'Hi, ${user}!';
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

  //currentLocation declaration
  String? currentLocation;

  @override
  Widget build(BuildContext context) {

    if (currentLocation == null || currentLocation!.isEmpty) {
      currentLocation = 'Nairobi';
    }

    return SafeArea(
      child: Scaffold(
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
                                child: imageAsset(
                                  isNormalImage: true,
                                  fileName: 'profile.jpg',
                                  imgHeight: 45,
                                  imgWidth: 45,
                                ),
                              ),
                              SizedBox(width: 10),
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
                          Icon(Icons.notifications_active),
                        ],
                      ),
                      SizedBox(height: 15),
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
                          Container(
                            height: 25,
                            child: TextButton(
                              onPressed: () async{
                                // final result = await Navigator.pushNamed(context, '/setLocation')as Map<String, dynamic>?;
                                final result = await Navigator.pushNamed(context, setLocation);
                                if (result != null) {
                                  print(result);
                                  // setState(() {
                                  //   currentLocation = result['location'] ?? 'Unknown';
                                  // });
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
                                  SizedBox(width: 8.0),
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
                      SizedBox(height: 10),
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
                          SizedBox(height: 6),
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
                                    // Space between items
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 0, 0, 3),
                                        child: Text(
                                          service.name,
                                          style: TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ),
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
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 15),
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
                              SizedBox(height: 4,),
                              Container(// Set the height for the ListView
                                // height: 900,
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                        margin: const EdgeInsets.only(right: 8.0), // Space between items
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 3),
                                            child: Text(
                                              service.name,
                                              style: TextStyle(
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ),
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
