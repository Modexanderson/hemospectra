import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hemospectra/screens/drawer/drawer_menu.dart';
import 'package:hemospectra/screens/profile/edit_profile_screen.dart';

import '../../services/authentification_service.dart';
import '../../widgets/custom_listtile.dart';

class ProfileScreen extends StatelessWidget {
  // final String userUid;

  ProfileScreen({super.key});

  String userUid = AuthentificationService().currentUser.uid;

  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userUid)
              .get();
      if (snapshot.exists) {
        return snapshot.data() ?? {};
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw e;
    }
  }

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
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
      drawer: DrawerMenu(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final profileData = snapshot.data;
            return ListView(
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
                                    color: Colors.blue,
                                  ),
                                  child: IconButton(
                                    color: Colors.white,
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      // Navigate to edit profile screen
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            profileData?['full_name'] ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profileData?['role'] ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(
                                      profileData: profileData!,
                                      userUid: userUid),
                                ),
                              );
                              // Navigate to edit profile screen
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                              fixedSize: MaterialStateProperty.all(
                                  const Size.fromWidth(300)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Edit Profile'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.edit),
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
                  subtitle: profileData?['full_name'] ?? '',
                ),
                CustomListTile(
                  title: 'Gender',
                  subtitle: profileData?['gender'] ?? '',
                ),
                CustomListTile(
                  title: 'Email',
                  subtitle: profileData?['user_email'] ?? '',
                ),
                CustomListTile(
                  title: 'Phone Number',
                  subtitle: profileData?['phone'] ?? '',
                ),
                CustomListTile(
                  title: 'Date of Birth',
                  subtitle: profileData?['date_of_birth'] ?? '',
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
