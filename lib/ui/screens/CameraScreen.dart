import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool isRearCamera = true;
  XFile? imageFile;


  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async{
    cameras = await availableCameras();
    if(cameras != null && cameras!.isNotEmpty){
      _cameraController = CameraController(cameras![0], ResolutionPreset.high);
      await _cameraController!.initialize();
      setState(() {

      });
    }
  }

  void switchCamera() async {
    if (_cameraController != null) {
      await _cameraController!.dispose(); // Dispose of the old controller
    }

    setState(() {
      isRearCamera = !isRearCamera; // Toggle the camera
      _cameraController = CameraController(
        cameras![isRearCamera ? 0 : 1],
        ResolutionPreset.high,
      );
      _cameraController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    });
  }


  Future<void> capturePhoto() async{
    if(_cameraController != null && _cameraController!.value.isInitialized){
      imageFile = await _cameraController!.takePicture();
      print(imageFile);
      setState(() {});
    }
  }

  Future<void> pickGalleryImage() async{
    final ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: _cameraController != null &&
                  _cameraController!.value.isInitialized
                  ? CameraPreview(_cameraController!)
                  : Center(child: CircularProgressIndicator()),
            ),
            // Bottom section with gallery and camera controls
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black,
                child: Column(
                  children: [
                    // Gallery preview at the bottom
                    Container(
                      height: 100,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5, // Replace with actual gallery items
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: pickGalleryImage, // To pick an image
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: 80,
                              color: Colors.grey, // Temporary placeholder
                              child: Icon(Icons.photo, size: 40),
                            ),
                          );
                        },
                      ),
                    ),
                    // Camera control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.image, color: Colors.white),
                          onPressed: pickGalleryImage, // Open gallery picker
                        ),
                        GestureDetector(
                          onTap: capturePhoto, // Capture photo
                          child: Icon(Icons.circle, size: 70, color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(Icons.switch_camera, color: Colors.white),
                          onPressed: switchCamera, // Switch camera
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

