import 'package:flutter/material.dart';

String imagePath = 'assets/images/';

TextTheme appTextTheme(BuildContext context){
  return Theme.of(context).textTheme;
}

List<String> locationList = ['Nairobi','Mombasa','Kisumu','Malaba','Kilgoris','Nyando','Kisii','Malaba','Awendo','Siaya'];

List<String> servicesList = ['Plumbing','Electrical','Cobler','Carpentry','Tailoring','Painting','Mechanic','Welding','Plastic Welding','Laundry Services'];
// List<String> servicesList = List.generate(100, (index) => 'Item $index');

// Widget getSizedBox({double? height, double? width}) {
//   return SizedBox(
//     height: height ?? 0,
//     width: width ?? 0,
//   );
// }