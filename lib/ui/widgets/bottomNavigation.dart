import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/utils/constants.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: AppColors.primaryColor,
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              // Text style for the selected label
              return appTextTheme(context).labelSmall?.copyWith(
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              );
            } else {
              // Text style for unselected labels
              return appTextTheme(context).labelSmall?.copyWith(
                color: AppColors.textColorLight,
                fontWeight: FontWeight.normal,
              );
            }
          },
        ),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
