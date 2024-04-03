import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({Key? key}) : super(key: key);

  @override
  _ScanningScreenState createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late XFile _imageFile;

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

  // Future<void> _takePicture() async {
  //   try {
  //     await _initializeControllerFuture;
  //     final path = (await getTemporaryDirectory()).path;
  //     final imagePath = '$path/image.jpg'; // Adjust path and filename as needed
  //     await _cameraController.takePicture(imagePath);
  //     setState(() {
  //       _imageFile = XFile(imagePath);
  //     });
  //     // Handle the captured image (e.g., display, process, or save)
  //   } catch (e) {
  //     // Handle any errors that occur during image capture
  //     print(e);
  //   }
  // }

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
                      // Implement done functionality
                    },
                    icon: const Icon(
                      Icons.camera,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
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
