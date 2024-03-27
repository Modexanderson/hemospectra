import 'package:flutter/material.dart';
import 'package:hemospectra/widgets/articles.dart';

import '../../widgets/custom_search_bar.dart';
import '../drawer/drawer_menu.dart';

class FavoriteArticlesScreen extends StatelessWidget {
  FavoriteArticlesScreen({super.key});

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Resources',
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                controller: searchController,
                onChanged: (value) {
                  // Handle search functionality
                  // For example, filter patient records based on the search query
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Favourite Articles',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const Articles()
            ],
          ),
        ));
  }
}
