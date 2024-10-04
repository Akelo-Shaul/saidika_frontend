import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class CameraGalleryPage extends StatefulWidget {
  @override
  _CameraGalleryPageState createState() => _CameraGalleryPageState();
}

class _CameraGalleryPageState extends State<CameraGalleryPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  List<XFile>? _galleryImages;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadGalleryImages();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras[0], // Use the first available camera
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> _loadGalleryImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _galleryImages = pickedFiles;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera with Gallery'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                // Camera preview
                Expanded(
                  child: CameraPreview(_controller),
                ),
                // Gallery images
                Container(
                  height: 100,
                  child: _galleryImages != null
                      ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _galleryImages!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.file(
                          File(_galleryImages![index].path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )
                      : Center(child: Text('No images selected.')),
                ),
                // Button to pick images
                ElevatedButton(
                  onPressed: _loadGalleryImages,
                  child: Text('Pick Images from Gallery'),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
