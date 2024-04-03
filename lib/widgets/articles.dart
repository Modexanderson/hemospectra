import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/article.dart';
import '../screens/resources/article_detail_screen.dart';

class Articles extends StatefulWidget {
  const Articles({Key? key}) : super(key: key);

  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  List<String> sections = [
    'All',
    'Popular',
    'Recent',
    'Malaria',
    'Tuberculosis',
    'Typhoid',
  ];

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
              isScrollable: true,
              tabs: sections.map((section) => Tab(text: section)).toList(),
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('articles')
                    .orderBy('publicationDate', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child:  SizedBox());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  List<Article> articles = snapshot.data!.docs
                      .map((doc) => Article.fromSnapshot(doc))
                      .where((article) =>
                          _currentIndex == 0 ||
                          article.category == sections[_currentIndex])
                      .toList();

                  return TabBarView(
                    controller: _tabController,
                    children: sections.map((section) {
                      final sectionArticles = articles
                          .where((article) =>
                              section == 'All' || article.category == section)
                          .toList();
                      return ListView.builder(
                        itemCount: sectionArticles.length,
                        itemBuilder: (context, index) {
                          return ArticleCard(article: sectionArticles[index]);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              CachedNetworkImage(
                width: 100,
                height: 100,
                imageUrl: article.image,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('By ${article.writer}',
                        style: const TextStyle(fontSize: 12)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.published_with_changes_sharp,
                                size: 15),
                            const SizedBox(width: 5),
                            Text(
                              DateFormat.yMMMd()
                                  .format(article.publicationDate),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 15),
                            const SizedBox(width: 5),
                            Text(
                              '${article.readingTime} min. read',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
