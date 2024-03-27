import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

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

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
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
                    onPressed: () {},
                    icon: Icon(Icons.arrow_back),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.flash_on_rounded),
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
              padding: EdgeInsets.all(10),
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
                      // Implement cancel functionality
                    },
                    child: const Text('Cancel'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
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
                    child: const Text('Done'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
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
