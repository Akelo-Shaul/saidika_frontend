
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/appBar.dart';
import 'package:saidika_ui/ui/widgets/appButton.dart';
import 'package:saidika_ui/ui/widgets/appTextField.dart';
import 'package:saidika_ui/ui/widgets/linkText.dart';
import 'package:saidika_ui/utils/constants.dart';
import 'package:saidika_ui/utils/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<FocusNode> focusNodes = [
  FocusNode(),
  FocusNode(),
  FocusNode(),
];
class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {

  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController serviceDescriptionController = TextEditingController();
  final TextEditingController serviceLocationController = TextEditingController();

  String? selectedService;
  String? selectedLocation;



  void onFocusChanged() {
    setState(() {});
  }


  Future<void> addService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('https://saidika-backend.onrender.com/api/v1/services/add_new_service');

    Map<String, dynamic> data = {
      'name': selectedService,
      'description': serviceDescriptionController.text,
      // 'available_location': selectedLocation,
    };

    print(data);

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString('userToken').toString(),
      },
      body: json.encode(data),
    );

    print(response.body);

    var responseBody = jsonDecode(response.body);

    print(context);

    print(responseBody['message']);

    if (response.statusCode == 200 || response.statusCode == 201){
      prefs.setBool('first_time_login', false);
      Navigator.pushNamed(context, homePage);
    } else {

    }
    // Navigator.pop(context);
    // Navigator.pushNamed(context, homePage);
  }


  void _showCustomServiceDropdown(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String tempSearchValue = ""; // Temporary search value within the dialog's state
        List<String> filteredServices = servicesList; // Start with the full list of services

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
                          hintText: 'Search services',
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
                            filteredServices = servicesList
                                .where((item) => item.toLowerCase().contains(tempSearchValue.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),

                    // Filtered list of services
                    Expanded( // Use Expanded to take remaining space
                      child: ListView.builder(
                        itemCount: filteredServices.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              filteredServices[index],
                              style: appTextTheme(context).labelMedium,
                            ),
                            onTap: () {
                              Navigator.pop(context, filteredServices[index]); // Close the dropdown and pass the selected service back
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
    ).then((selectedServiceValue) {
      if (selectedServiceValue != null) {
        // Update the parent widget's state with the selected service
        setState(() {
          selectedService = selectedServiceValue;
        });
      }
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        "Add Service",
        titleStyle: appTextTheme(context).labelMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Pushes content to the top and bottom
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Trigger dropdown when tapped
                          _showCustomServiceDropdown(context);
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
                                  Icon(Icons.control_point, color: AppColors.textColorLight),
                                  const SizedBox(width: 8),
                                  Text(
                                    selectedService ?? "Select a service",
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
                      AppTextArea(
                        hintText: 'Description',
                        prefixIcon: Icons.description,
                        controller: serviceDescriptionController,
                        focusNode: focusNodes[0],
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
                      Row(
                        children: [
                          Text(
                            'Can\'t see your service?',
                            style: appTextTheme(context).labelSmall,
                          ),
                          linkText(' New service', context, () {
                            // Navigator.pushReplacementNamed(context, addManualService);
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        btnText: 'Add Service',
                        textSize: 15,
                        voidCallBack: () {
                          addService();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, homePage);
                  },
                  child: Text(
                    'Skip',
                    style: appTextTheme(context).labelMedium?.copyWith(color: AppColors.primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
