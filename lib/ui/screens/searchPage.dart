import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/widgets/appTextField.dart';
import 'package:saidika_ui/ui/widgets/bottomNavigation.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/StringsRes.dart';
import 'package:saidika_ui/utils/route.dart';
import 'package:saidika_ui/utils/service_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

List<FocusNode> focusNodes = [
  FocusNode(),
];

class Search extends StatefulWidget {
  final String data;
  const Search({super.key, required this.data});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {


  // String? serviceName;

  //Handling navigation between pages
  int _selectedIndex = 1; // Assuming Search is at index 1, adjust if needed

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      //Handling navigation to different pages
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, homePage);
          break;
        case 1:
        // Current page
          break;
        case 2:
          Navigator.pushReplacementNamed(context, chats);
          break;
        case 3:
          Navigator.pushReplacementNamed(context, profile);
          break;
      }
    });
  }

  //List of service providers
  // List<ServiceProvider> serviceProviders = [
  //   ServiceProvider(name: 'Shaul Akelo', location: 'Malaba', ratings: 9.7, service: 'Plumbing', imageUrl: 'assets/avatar.jpg'),
  //   ServiceProvider(name: 'Andy Woody', location: 'Kilgoris', ratings: 7.3, service: 'Electrical', imageUrl: 'assets/avatar.jpg'),
  //   ServiceProvider(name: 'Jon Doe', location: 'Nairobi', ratings: 8.7, service: 'Cobler', imageUrl: 'assets/avatar.jpg'),
  //   ServiceProvider(name: 'Burmer C', location: 'Kakamega', ratings: 5.4, service: 'Mechanic', imageUrl: 'assets/avatar.jpg')
  // ];

  List providers = [];

  //List of categories
  List<String> categories =['Plumbing', 'Electrical', 'Mechanic', 'Cobler','Artist'];

  List filteredServiceProvider = [];

  String? searchLocation;

  String? selectedCategory;

  final TextEditingController searchInputController = TextEditingController();

  // Future<Map<String, dynamic>> getServiceProviders() async{
  Future<String> getServiceProviders() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('http://192.168.6.55:8080/api/v1/services/filter_by_location/$searchLocation');

    print(url);

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString('userToken').toString()
      }// Encode the data as JSON
    );

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      providers = responseBody;
      // print(responseBody['name']);
      for (var provider in providers) {
        print("THe name ${provider['name']}");
        print("THe description ${provider['description']}");
        print("THe location ${provider['availableLocation']}");
        print("THe firstName ${provider['provider']['first_name']}");
        print("THe lastName ${provider['provider']['last_name']}");
      }
      // print(responseBody['name'].toString());
      // print(responseBody['description'].toString());
      // print(responseBody['availableLocation'].toString());
      // print(responseBody['provider'].first_name.toString());
    }

    return "Hello";
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final serviceName = widget.data;
    if (serviceName.isNotEmpty && serviceName != 'null') {
      // Use the arguments
      selectedCategory = serviceName;
      print('Received argument: $serviceName');
      filteredServiceProvider = providers.where((provider) => provider['name'] == serviceName).toList();
    } else {
      // Handle case where no argument is passed
      print('No arguments received');
      filteredServiceProvider = providers; // Default to all providers
    }
  }

  void onFocusChanged(){
    setState(() {

    });
  }

  Future<void> _refreshAllData() async {
    setState(() {
      filteredServiceProvider = providers;
      searchInputController.clear();
      selectedCategory = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getServiceProviders();
    filteredServiceProvider = providers;
  }

  @override
  Widget build(BuildContext context) {
    if (searchLocation == null || searchLocation!.isEmpty) {
      searchLocation = StringsRes.locationDefault;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar-like widget
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      textFieldCallBack: onFocusChanged,
                      hintText: 'Search...',
                      prefixIcon: Icons.search,
                      controller: searchInputController,
                      focusNode: focusNodes[0],
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded( // Use Expanded to take up the remaining space
              child: RefreshIndicator(
                onRefresh: _refreshAllData,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StringsRes.services,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            final result = Navigator.pushNamed(context, setLocation);
                            if (result != null) {
                              setState(() {
                                print(result);
                                // Handle location selection and filtering
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                searchLocation!,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.tune, size: 20),
                              SizedBox(width: 5),
                              Icon(Icons.location_on_outlined, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7),
                    SizedBox(
                      height: 32,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return GestureDetector(
                            onTap: () {
                              selectedCategory = category;
                              setState(() {
                                filteredServiceProvider = providers.where((provider) => provider['name'] == category).toList();
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(index == 0 ? 0 : 2, 0, 2, 0),
                              child: Container(
                                height: 32,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: selectedCategory == category ? Colors.orange : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey, width: 2),
                                ),
                                child: Center(child: Text(category)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: providers.length,
                      itemBuilder: (context, index) {
                        final provider = providers[index];
                        return Padding(
                          padding: EdgeInsets.fromLTRB(0, index == 0 ? 0 : 5, 0, 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: imageAsset(
                                          isNormalImage: true,
                                          fileName: 'profile.jpg',
                                          imgHeight: 50,
                                          imgWidth: 50,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                                              child: Text(
                                                '${provider['provider']['first_name']} ${provider['provider']['last_name']}',
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: .5),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on_outlined, size: 13),
                                                Text(provider['availableLocation'], style: TextStyle(fontSize: 12)),
                                                SizedBox(width: 8),
                                                Icon(Icons.star, size: 13),
                                                Text(provider['availableLocation'], style: TextStyle(fontSize: 12)),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                                              child: Text(provider['name'], style: TextStyle(fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(context, '/chat_page');
                                        },
                                        child: Icon(Icons.message, color: Colors.grey, size: 30),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.add_ic_call_rounded, color: Colors.grey, size: 30),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }

}
