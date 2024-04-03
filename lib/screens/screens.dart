// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../services/authentification_service.dart';
import '../widgets/async_progress_dialog.dart';
import '../widgets/show_confirmation_dialog.dart';
import 'drawer/drawer_menu.dart';
import 'home/home_screen.dart';
import 'manage_patients/edit_patient_screen.dart';
import 'resources/resources_screen.dart';
import 'test/test_screen.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  int _selectedIndex = 0;
  final List<String> _titles = ['Home', 'Test', 'Resources'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.notifications_outlined),
        //     onPressed: () {
        //       // Handle notification button press
        //     },
        //   ),
        // ],
      ),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(),
            TestScreen(), // Replace TestTabPage with your actual test page widget
            const ResourcesScreen(), // Replace ResourcesTabPage with your actual resources page widget
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: kBottomNavigationBarHeight,
              color: Colors
                  .white, // Set background color of the BottomNavigationBar
            ),
          ),
          BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Container(
                  width: 100,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0
                        ? Colors.blue
                        : Colors.transparent, // Set the selected item color
                    borderRadius: BorderRadius.circular(
                        10), // Set border radius for the selected item
                  ),
                  child: Icon(
                    Icons.home_outlined, // Icon for Home
                    color: _selectedIndex == 0
                        ? Colors.white
                        : Colors.grey, // Set icon color based on selected index
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 100,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1
                        ? Colors.blue
                        : Colors.transparent, // Set the selected item color
                    borderRadius: BorderRadius.circular(
                        10), // Set border radius for the selected item
                  ),
                  child: Icon(
                    Icons.medical_information_outlined, // Icon for Test
                    color: _selectedIndex == 1
                        ? Colors.white
                        : Colors.grey, // Set icon color based on selected index
                  ),
                ),
                label: 'Test',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 100,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2
                        ? Colors.blue
                        : Colors.transparent, // Set the selected item color
                    borderRadius: BorderRadius.circular(
                        10), // Set border radius for the selected item
                  ),
                  child: Icon(
                    Icons.video_settings_sharp, // Icon for Resources
                    color: _selectedIndex == 2
                        ? Colors.white
                        : Colors.grey, // Set icon color based on selected index
                  ),
                ),
                label: 'Resources',
              ),
            ],
            selectedItemColor: Colors
                .transparent, // Set transparent to hide default selection color
            currentIndex: _selectedIndex, // Set the current selected index
            onTap: _onItemTapped, // Handle tap events
            showSelectedLabels: false, // Hide default selected label
            showUnselectedLabels: false, // Hide default unselected label
            type: BottomNavigationBarType
                .fixed, // Ensure all icons are displayed with fixed width
          ),
        ],
      ),
      floatingActionButton: _selectedIndex ==
              1 // Check if the selected index is for the TestScreen
          ? FloatingActionButton(
              onPressed: () async {
                bool allowed = AuthentificationService().currentUserVerified;
                if (!allowed) {
                  final reverify = await showConfirmationDialog(context,
                      "You haven't verified your email address. This action is only allowed for verified users.",
                      positiveResponse: "Resend verification email",
                      negativeResponse: "Go back");
                  if (reverify) {
                    final future = AuthentificationService()
                        .sendVerificationEmailToCurrentUser();
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AsyncProgressDialog(
                          future,
                          // message: const Text("Resending verification email"),
                        );
                      },
                    );
                  }
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditPatientScreen(
                        patientToEdit: null, navigateToScan: true),
                  ),
                );
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const ScanningScreen(),
                //     ));
                // Handle scan action here
              },
              child: const Icon(
                Icons.adf_scanner_outlined,
                size: 40,
              ), // Icon for scan action
            )
          : null,
    );
  }
}
