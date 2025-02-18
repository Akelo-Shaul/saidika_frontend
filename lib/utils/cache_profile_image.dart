import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<File> downloadAndSaveImage(String url, String fileName) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();

  final profileUrl = Uri.parse(url);

  // Make the HTTP request to fetch the image
  final response = await http.get(
      profileUrl,
      headers: {
        "Authorization": prefs.getString('userToken').toString()
      }
  );

  if (response.statusCode == 200) {
    // Get the application's documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Construct the full file path (directory + fileName)
    final filePath = '${directory.path}/$fileName';
    print(filePath);

    // Create a File object at the desired location
    final file = File(filePath);

    // bool fileExists = await file.exists();
    // print(fileExists);
    if (await file.exists()) {
      await file.delete();
    }

    // Write the image data (response.bodyBytes) to the file
    return file.writeAsBytes(response.bodyBytes);
  } else {
    throw Exception('Failed to load image');
  }

}

Future<void> deleteAndUpdate(String fileName) async{
  final directory = await getApplicationDocumentsDirectory();

  // Construct the full file path (directory + fileName)
  final filePath = '${directory.path}/$fileName';
  print(filePath);

  // Create a File object at the desired location
  final file = File(filePath);

  if (await file.exists()) {
    await file.delete();
  }
}
