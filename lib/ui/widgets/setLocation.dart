import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/widgets/appBar.dart';
import 'package:saidika_ui/utils/constants.dart';

class SetLocation extends StatefulWidget {
  const SetLocation({super.key});

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {

  // List<String> locations = ['Nairobi', 'Kisumu', 'Kakamega', 'Malaba', 'Kilgoris', 'Nyando', 'Olare'];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Select Your Location'
        // centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView.builder(
          itemCount: locationList.length,
          itemBuilder: (context, index){
            final location = locationList[index];
            return Container(
              width: double.infinity, //Span full width
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.black,
                      )
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                // child: Text(
                //   location,
                //   style: TextStyle(
                //     fontSize: 25,
                //   ),
                // ),
                child: ListTile(
                  onTap: (){
                    Navigator.pop(context, location);
                  },
                  title: Text(
                    location,
                    style: appTextTheme(context)
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        ),

      );
  }

}
