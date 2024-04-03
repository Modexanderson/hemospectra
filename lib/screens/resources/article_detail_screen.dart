import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  const ArticleDetailScreen({required this.article, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: Navigator.of(context).pop,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.share),
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   ),
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.favorite_border),
        //   ),
        // ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          CachedNetworkImage(
            imageUrl: article.image,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageBuilder: (context, imageProvider) => Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(10), // Adjust the value as needed
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // category
          Text(
            article.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            article.subTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              height: 1,
            ),
          ),

          Text(
            article.writer,
            style: const TextStyle(),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            article.articleBody,
            textAlign: TextAlign.justify,
            style: const TextStyle(),
          ),

          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
