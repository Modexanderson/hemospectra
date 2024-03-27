import 'package:flutter/material.dart';

import '../screens/resources/article_detail_screen.dart';

class Articles extends StatefulWidget {
  const Articles({super.key});

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles>  with SingleTickerProviderStateMixin {

  int _currentIndex = 0;
  
  // Sample articles data
  List<Map<String, dynamic>> articles = [
    {
      'title': 'Article 1',
      'writer': 'John Doe',
      'publicationDate': 'March 25, 2024',
      'readingTime': '10 min',
      'image': 'assets/images/hemospectra.jpeg', // Sample image path
    },
    {
      'title': 'Article 2',
      'writer': 'Jane Smith',
      'publicationDate': 'March 26, 2024',
      'readingTime': '8 min',
      'image': 'assets/images/hemospectra.jpeg', // Sample image path
    },
    // Add more articles
  ];

  // Sample sections data
  List<String> sections = [
    'All',
    'Popular',
    'Recent',
    'Malaria',
    'Tuberculosis',
    'Typhoid',
    // Add more sections
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: sections.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
          child: DefaultTabController(
            length: sections.length,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  controller: _tabController,
                  padding: EdgeInsets.zero,
                  tabAlignment: TabAlignment.center,
                  isScrollable: true,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  tabs: sections
                      .map((section) => Tab(
                            text: section,
                          ))
                      .toList(),
                  labelColor: Colors.white, // Text color of selected section
                  unselectedLabelColor:
                      Colors.black, // Text color of unselected section
                  indicator: BoxDecoration(
                    color: Colors.red, // Background color of selected section
                    borderRadius: BorderRadius.circular(4),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,

                    children: sections
                        .map((section) => ListView.builder(
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                final article = articles[index];
                                return InkWell(
                                  onTap: () {
                                      Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ArticleDetailScreen(),
                                  ),
                                );
                                  },
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            article['image'], // Image path
                                            fit: BoxFit.cover,
                                            width: 50,
                                            height: 100,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    article[
                                                        'title'], // Article title
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'By ${article['writer']}', // Writer
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Published on ${article['publicationDate']}', // Publication date
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Reading time: ${article['readingTime']}', // Reading time
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}