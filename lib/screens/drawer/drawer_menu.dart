// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hemospectra/screens/manage_patients/manage_patients_screen.dart';
import 'package:hemospectra/screens/screens.dart';

import '../../services/authentification_service.dart';
import '../../widgets/async_progress_dialog.dart';
import '../../widgets/drawer_listtile.dart';
import '../../widgets/show_confirmation_dialog.dart';
import '../manage_patients/edit_patient_screen.dart';
import '../profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;


class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});
static const _emailAddress =
    'mailto:audunuhu70@gmail.com?subject=Help Request&body=Hello,';

    void _openEmail() async {
  if (await urlLauncher.canLaunch(_emailAddress)) {
    urlLauncher.launch(_emailAddress);
  } else {
    throw 'Could not launch email';
  }
}
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                      // color: Colors.blue,
                      ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                DrawerListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: 'Home',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Screens(),
                      ),
                    );
                    // Handle Home navigation
                  },
                ),
                DrawerListTile(
                  leading: const Icon(Icons.person_outlined),
                  title: 'Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                    // Handle Home navigation
                  },
                ),
                buildUserExpansionTile(context),
                // DrawerListTile(
                //   leading: const Icon(Icons.build_outlined),
                //   title: 'Tools',
                //   onTap: () {
                //     // Handle Tools navigation
                //   },
                // ),
                // DrawerListTile(
                //   leading: const Icon(Icons.settings_outlined),
                //   title: 'Settings',
                //   onTap: () {
                //     // Handle Settings navigation
                //   },
                // ),
                DrawerListTile(
                  leading: const Icon(Icons.help_outline_rounded),
                  title: 'Help & Support',
                  onTap: _openEmail,
                ),
              ],
            ),
          ),
          DrawerListTile(
            leading: const Icon(Icons.logout),
            title: 'Logout',
            onTap: () async {
              final confirmation = await showConfirmationDialog(
                context,
                'Are you sure you want to sign out',
                negativeResponse: 'no',
                positiveResponse: 'yes',
              );
              if (confirmation) AuthentificationService().signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget buildUserExpansionTile(BuildContext context) {
    return ExpansionTile(
      iconColor:Theme.of(context).secondaryHeaderColor,
      textColor: Theme.of(context).secondaryHeaderColor,
      collapsedIconColor: Colors.white,
      collapsedTextColor: Colors.white,
      leading: const Icon(
        Icons.business,
      ),
      title: const Text(
        'Medical Personel',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      children: [
        DrawerListTile(
          leading: const Icon(Icons.add_a_photo_outlined),
          title: 'Add New Patient',
          onTap: () async {
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
                          patientToEdit: null,
                        )));
          },
        ),
        DrawerListTile(
          leading: const Icon(Icons.manage_accounts_outlined),
          title: 'Manage My Patients',
          onTap: () async {
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
                      // message: Text("Resending verification email"),
                    );
                  },
                );
              }
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManagePatientsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
