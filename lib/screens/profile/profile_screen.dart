// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hemospectra/screens/drawer/drawer_menu.dart';
import 'package:hemospectra/screens/profile/edit_profile_screen.dart';
import 'package:hemospectra/widgets/custom_button.dart';
import 'package:hemospectra/widgets/snack_bar.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../exceptions/image_picking_exceptions.dart';
import '../../exceptions/local_files_handling_exception.dart';
import '../../models/body_models.dart';
import '../../models/size_config.dart';
import '../../services/authentification_service.dart';
import '../../services/database/user_database_helper.dart';
import '../../services/firestore_files_access/firestore_files_access_service.dart';
import '../../services/local_files_access/local_files_access_service.dart';
import '../../widgets/async_progress_dialog.dart';
import '../../widgets/custom_listtile.dart';

class ProfileScreen extends StatelessWidget {
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
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
      drawer: const DrawerMenu(),
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
                  child: Consumer<ChosenImage>(
                      builder: (context, bodyState, child) {
                    return Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                buildDisplayPictureAvatar(context, bodyState),
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
                                        getImageFromUser(context, bodyState);
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
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
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
                    );
                  }),
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

  Widget buildDisplayPictureAvatar(
      BuildContext context, ChosenImage bodyState) {
    return StreamBuilder(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        ImageProvider? backImage;
        if (bodyState.chosenImage != null) {
          backImage = MemoryImage(bodyState.chosenImage!.readAsBytesSync());
        } else if (snapshot.hasData && snapshot.data != null) {
          // final dynamic data = snapshot.data;
          // final String? url = data[UserDatabaseHelper.DP_KEY];
          // if (url != null) backImage = NetworkImage(url);
          final DocumentSnapshot<Map<String, dynamic>>? data =
              snapshot.data as DocumentSnapshot<Map<String, dynamic>>?;
          final Map<String, dynamic>? userData = data?.data();
          if (userData != null && userData.containsKey('display_picture')) {
            final String? url = userData['display_picture'];
            if (url != null) {
              backImage = NetworkImage(url);
            }
          }
        }
        return CircleAvatar(
          radius: SizeConfig.screenWidth! * 0.3,
          // backgroundColor: kTextColor.withOpacity(0.5),
          backgroundImage: backImage,
        );
      },
    );
  }

  void getImageFromUser(BuildContext context, ChosenImage bodyState) async {
    String? path;
    String? snackbarMessage;
    try {
      path = await choseImageFromLocalFiles(context);
      if (path == null) {
        throw LocalImagePickingUnknownReasonFailureException();
      }
    } on LocalFileHandlingException catch (e) {
      Logger().i("LocalFileHandlingException: $e");
      snackbarMessage = e.toString();
    } catch (e) {
      Logger().i("LocalFileHandlingException: $e");
      snackbarMessage = e.toString();
    } finally {
      if (snackbarMessage != null) {
        Logger().i(snackbarMessage);
        ShowSnackBar().showSnackBar(context, snackbarMessage);
      }
    }
    if (path == null) {
      return;
    }
    bodyState.setChosenImage = File(path);
  }

  Widget buildChosePictureButton(BuildContext context, ChosenImage bodyState) {
    return CustomButton(
      text: "Choose Picture",
      onPressed: () {
        getImageFromUser(context, bodyState);
      },
    );
  }

  Widget buildUploadPictureButton(BuildContext context, ChosenImage bodyState) {
    return CustomButton(
      text: "Upload Picture",
      onPressed: () {
        final Future uploadFuture =
            uploadImageToFirestorage(context, bodyState);
        showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              uploadFuture,
            );
          },
        );
        ShowSnackBar().showSnackBar(context, 'Display Picture updated');
      },
    );
  }

  Future<void> uploadImageToFirestorage(
      BuildContext context, ChosenImage bodyState) async {
    bool uploadDisplayPictureStatus = false;
    String? snackbarMessage;
    try {
      final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
          bodyState.chosenImage!,
          UserDatabaseHelper().getPathForCurrentUserDisplayPicture());

      uploadDisplayPictureStatus = await UserDatabaseHelper()
          .uploadDisplayPictureForCurrentUser(downloadUrl);
      if (uploadDisplayPictureStatus == true) {
        snackbarMessage = "Display Picture updated successfully";
      } else {
        throw "Coulnd't update display picture due to unknown reason";
      }
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
      snackbarMessage = "Something went wrong";
    } catch (e) {
      Logger().w("Unknown Exception: $e");
      snackbarMessage = "Something went wrong";
    } finally {
      Logger().i(snackbarMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage!),
        ),
      );
    }
  }

  Widget buildRemovePictureButton(BuildContext context, ChosenImage bodyState) {
    return CustomButton(
      text: "Remove Picture",
      onPressed: () async {
        final Future uploadFuture =
            removeImageFromFirestore(context, bodyState);
        await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              uploadFuture,
            );
          },
        );
        ShowSnackBar().showSnackBar(context, "Display Picture removed");

        Navigator.pop(context);
      },
    );
  }

  Future<void> removeImageFromFirestore(
      BuildContext context, ChosenImage bodyState) async {
    bool status = false;
    String? snackbarMessage;
    try {
      bool fileDeletedFromFirestore = false;
      fileDeletedFromFirestore = await FirestoreFilesAccess()
          .deleteFileFromPath(
              UserDatabaseHelper().getPathForCurrentUserDisplayPicture());
      if (fileDeletedFromFirestore == false) {
        throw "Couldn't delete file from Storage, please retry";
      }
      status = await UserDatabaseHelper().removeDisplayPictureForCurrentUser();
      if (status == true) {
        snackbarMessage = "Picture removed successfully";
      } else {
        throw "Coulnd't removed due to unknown reason";
      }
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
      snackbarMessage = "Something went wrong";
    } catch (e) {
      Logger().w("Unknown Exception: $e");
      snackbarMessage = "Something went wrong";
    } finally {
      Logger().i(snackbarMessage);
      ShowSnackBar().showSnackBar(context, snackbarMessage!);
    }
  }
}
