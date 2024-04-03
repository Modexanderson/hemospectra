// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hemospectra/widgets/snack_bar.dart';
import 'package:path_provider/path_provider.dart';

import '../../widgets/async_progress_dialog.dart';
import 'test_result_screen.dart';

class ScanningScreen extends StatefulWidget {
  final String patientId;
  const ScanningScreen({required this.patientId, Key? key}) : super(key: key);

  @override
  _ScanningScreenState createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    // Obtain a list of the available cameras on the device.
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    // Get the first available camera
    final firstCamera = cameras.first;
    // Initialize the camera controller
    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    // Initialize the camera controller asynchronously
    _initializeControllerFuture = _cameraController.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose of the camera controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      XFile? imageFile = await _cameraController.takePicture();
      setState(() {
        _imageFile = imageFile;
      });
      // Handle the captured image (e.g., display, process, or save)
    } catch (e) {
      // Handle any errors that occur during image capture
      print(e);
    }
  }

  Future<void> _uploadImageToStorage(XFile imageFile) async {
    try {
      // Upload the image file to Firebase Storage
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref('scanned_images/${DateTime.now()}.png')
          .putFile(File(imageFile.path));

      // Get the download URL for the uploaded image
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Update the scanned_image field in your Firebase Firestore document
      await FirebaseFirestore.instance
          .collection('patients') // Replace with your collection name
          .doc(widget.patientId) // Replace with your document ID
          .update({'scanned_image': downloadURL});

      // Show a message or perform any other actions after successful upload
      ShowSnackBar().showSnackBar(context, 'Image uploaded successfully');
      print('Image uploaded successfully');
    } catch (e) {
      // Handle any errors that occur during upload
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    5.0), // Same border radius as the elevated button
                color:
                    Colors.blue, // Same background color as the elevated button
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        // Toggle flash mode (on or off)
                        await _cameraController.setFlashMode(
                          _cameraController.value.flashMode == FlashMode.off
                              ? FlashMode.torch
                              : FlashMode.off,
                        );
                        setState(() {});
                      } catch (e) {
                        print(e); // Handle errors
                      }
                    },
                    icon: Icon(
                      _cameraController.value.flashMode == FlashMode.off
                          ? Icons.flash_off_rounded
                          : Icons.flash_on_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Camera view or scanning widget goes here
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview
                  return CameraPreview(_cameraController);
                } else {
                  // Otherwise, display a loading indicator
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    5.0), // Same border radius as the elevated button
                color:
                    Colors.blue, // Same background color as the elevated button
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Implement cancel functionality
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  IconButton.outlined(
                    iconSize: 30,
                    color: Colors.white,
                    onPressed: () {
                      _takePicture();
                      // Implement done functionality
                    },
                    icon: const Icon(
                      Icons.camera,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_imageFile != null) {
                        final imageUploadFuture =
                            _uploadImageToStorage(_imageFile!);
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AsyncProgressDialog(
                                  imageUploadFuture,
                                  progress: const CircularProgressIndicator(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Hang Tight!',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                    'Our super-powered algorithms are analyzing your results at lightning speed.', textAlign: TextAlign.center,)
                              ],
                            ));
                          },
                        );
                        // Close the dialog
                        Navigator.pop(context);

                        // Navigate to a new screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const TestResultScreen(), // Replace YourNextScreen with the screen you want to navigate to
                          ),
                        );
                      } else {
                        ShowSnackBar().showSnackBar(context,
                            'Scan an image to upload to database for testing');
                      }
                      // Implement capture functionality
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
