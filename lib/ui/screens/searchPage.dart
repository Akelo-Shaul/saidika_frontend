import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/appTextField.dart';
import 'package:saidika_ui/ui/widgets/bottomNavigation.dart';
import 'package:saidika_ui/ui/widgets/imageAsset.dart';
import 'package:saidika_ui/utils/StringsRes.dart';
import 'package:saidika_ui/utils/route.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Search extends StatefulWidget {
  final String data;
  const Search({super.key, required this.data});

  @override
  State<Search> createState() => _SearchState();
}

List<FocusNode> focusNodes = [
  FocusNode(),
];

class _SearchState extends State<Search> {
  int _selectedIndex = 1; // Assuming Search is at index 1
  List providers = [];
  List filteredServiceProvider = [];
  List<String> categories = ['Plumbing', 'Electrical', 'Mechanic', 'Cobler', 'Artist'];
  String? searchLocation;
  String? selectedCategory;
  final TextEditingController searchInputController = TextEditingController();

  Future<SharedPreferences> prefs =SharedPreferences.getInstance();

  // Fetch service providers from API
  Future<void> getServiceProviders() async {
    var url = Uri.parse('http://192.168.6.16:8080/api/v1/services/filter_by_location/$searchLocation');

    final SharedPreferences sharedPreferences = await prefs;

    // Fetch the userToken from SharedPreferences
    String? userToken = sharedPreferences.getString('userToken');


    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": '$userToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      setState(() {
        providers = responseBody;
        // Filter providers based on the selected category after fetching data
        filterByCategory(selectedCategory ?? ''); // Ensure the filtering applies
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final serviceName = widget.data;
    if (serviceName.isNotEmpty && serviceName != 'null') {
      setState(() {
        selectedCategory = serviceName;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    searchLocation = StringsRes.locationDefault; // Default location
    getServiceProviders();
  }

  // Handle bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, homePage);
          break;
        case 1:
          break; // Current page
        case 2:
          Navigator.pushReplacementNamed(context, chats);
          break;
        case 3:
          Navigator.pushReplacementNamed(context, profile);
          break;
      }
    });
  }

  // Refresh all data
  Future<void> _refreshAllData() async {
    setState(() {
      filteredServiceProvider = providers;
      searchInputController.clear();
      selectedCategory = null;
    });
    await getServiceProviders(); // Fetch fresh data when refreshing
  }

  // Filter providers by category
  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category.isNotEmpty) {
        filteredServiceProvider = providers.where((provider) => provider['name'] == category).toList();
      } else {
        filteredServiceProvider = providers; // Show all if no category is selected
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search field
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: 'Search...',
                      prefixIcon: Icons.search,
                      focusNode: focusNodes[0],
                      controller: searchInputController,
                      // Filter list while typing
                      onChanged: (value) {
                        print("Text changed: $value");
                        // Implement your filtering logic here
                      }
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshAllData,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    // Services and location header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StringsRes.services,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.pushNamed(context, setLocation);
                            if (result != null) {
                              setState(() {
                                searchLocation = result.toString();
                                getServiceProviders(); // Fetch filtered data by location
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(searchLocation!, style: TextStyle(fontSize: 16)),
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
                    // Categories list
                    SizedBox(
                      height: 32,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return GestureDetector(
                            onTap: () => filterByCategory(category),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
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
                    // Providers list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredServiceProvider.length,
                      itemBuilder: (context, index) {
                        final provider = filteredServiceProvider[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
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
                                            Text(
                                              '${provider['provider']['first_name']} ${provider['provider']['last_name']}',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on_outlined, size: 13),
                                                Text(provider['availableLocation'], style: TextStyle(fontSize: 12)),
                                                SizedBox(width: 8),
                                                Icon(Icons.star, size: 13),
                                                Text(provider['average_rating'].toString(), style: TextStyle(fontSize: 12)),
                                              ],
                                            ),
                                            Text(provider['name'], style: TextStyle(fontSize: 13)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final SharedPreferences sharedPreferences = await prefs;
                                          String? senderId = sharedPreferences.getString('userId');
                                          Navigator.pushNamed(
                                            context,
                                            chat_page,
                                            arguments: {
                                              'receiverName': provider['provider']['first_name'].toString(),
                                              'receiverId': provider['provider']['id'].toString(),
                                              'senderId': '$senderId',
                                              'chatId': 'chatId'
                                            },
                                          );
                                        },
                                        child: Icon(Icons.message, color: Colors.grey, size: 30),
                                      ),
                                      SizedBox(width: 8),
                                      GestureDetector(
                                        child: Icon(Icons.add_ic_call_rounded, color: Colors.grey, size: 30),
                                        onTap: () async {
                                          String providerPhone = '${provider['provider']['phone_number']}';
                                          print(providerPhone);
                                          Uri phoneUrl = Uri(scheme: 'tel', path: '0115089122');
                                          if (await canLaunchUrl(phoneUrl)) {
                                            await launchUrl(phoneUrl);
                                          }
                                        },

                                      ),
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
