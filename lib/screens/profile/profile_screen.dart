import 'package:flutter/material.dart';

import '../../widgets/custom_listtile.dart';
import '../drawer/drawer_menu.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage('assets/user_image.jpg'),
                        ),
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue, // Background color
                            ),
                            child: IconButton(
                              color: Colors.white,
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const EditProfileScreen(),
                                //   ),
                                // );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Medical Laboratory Scientist',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                        // Implement edit profile functionality
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          fixedSize: MaterialStateProperty.all(
                              const Size.fromWidth(300)),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.0), // Adjust the value as needed
                            ),
                          )),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Edit Profile'),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.edit)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          CustomListTile(
            title: 'Name',
            subtitle: 'John Doe',
          ),
          CustomListTile(
            title: 'Gender',
            subtitle: 'Male',
          ),
          CustomListTile(
            title: 'Email',
            subtitle: 'johndoe@example.com',
          ),
          CustomListTile(
            title: 'Phone Number',
            subtitle: '+1234567890',
          ),
          CustomListTile(
            title: 'Date of Birth',
            subtitle: 'January 1, 1990',
          ),
        ],
      ),
    );
  }
}
