import 'package:flutter/material.dart';

import 'drawer/drawer_menu.dart';
import 'home/home_screen.dart';
import 'resources/resources_screen.dart';
import 'scanning/scanning_screen.dart';
import 'test/test_screen.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  int _selectedIndex = 0;
  List<String> _titles = ['Home', 'Test', 'Resources'];

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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
      drawer: DrawerMenu(),
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
                    Icons.home, // Icon for Home
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
                    Icons.assignment, // Icon for Test
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
                    Icons.book, // Icon for Resources
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScanningScreen(),
                    ));
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
