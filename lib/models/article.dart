
import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String title;
  final String subTitle;
  final String writer;
  final DateTime publicationDate;
  final int readingTime;
  final String image;
  final String articleBody;
  final String category;

  Article({
    required this.title,
    required this.subTitle,
    required this.writer,
    required this.publicationDate,
    required this.readingTime,
    required this.image,
    required this.articleBody,
    required this.category,
  });

  factory Article.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Article(
      title: data['title'],
      subTitle: data['subTitle'],
      writer: data['writer'],
      publicationDate: (data['publicationDate'] as Timestamp).toDate(),
      readingTime: data['readingTime'],
      image: data['imageUrl'],
      articleBody: data['body'],
      category: data['category'],
    );
  }
}
