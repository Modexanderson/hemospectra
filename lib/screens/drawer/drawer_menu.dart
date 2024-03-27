import 'package:flutter/material.dart';
import 'package:hemospectra/screens/screens.dart';

import '../../widgets/drawer_listtile.dart';
import '../profile/profile_screen.dart';
import '../resources/favorite_articles_screen.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                // color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          DrawerListTile(
            leading: const Icon(Icons.home),
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
            leading: const Icon(Icons.person),
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
          DrawerListTile(
            leading: const Icon(Icons.history),
            title: 'History',
            onTap: () {
              // Handle History navigation
            },
          ),
          DrawerListTile(
            leading: const Icon(Icons.favorite),
            title: 'Favorite Articles',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteArticlesScreen(),
                ),
              );
              // Handle Favorite Articles navigation
            },
          ),
          DrawerListTile(
            leading: const Icon(Icons.build),
            title: 'Tools',
            onTap: () {
              // Handle Tools navigation
            },
          ),
          DrawerListTile(
            leading: const Icon(Icons.settings),
            title: 'Settings',
            onTap: () {
              // Handle Settings navigation
            },
          ),
          DrawerListTile(
            leading: const Icon(Icons.help),
            title: 'Help & Support',
            onTap: () {
              // Handle Help & Support navigation
            },
          ),
          DrawerListTile(
            leading: const Icon(Icons.logout),
            title: 'Logout',
            onTap: () {
              // Handle Logout functionality
            },
          ),
        ],
      ),
    );
  }
}
