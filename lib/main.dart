import 'package:saidika_ui/app/saidikaApp.dart';
import 'package:saidika_ui/utils/cache_profile_image.dart';

void main() {
  initializeApp();
  downloadAndSaveImage('https://saidika-backend.onrender.com/api/v1/provider/getpp', 'profileImage').then((file) {
    // Use the file, e.g., display it
    print('Image saved at: ${file.path}');
  }).catchError((e) {
    print('Failed to download and save image: $e');
  });
}

