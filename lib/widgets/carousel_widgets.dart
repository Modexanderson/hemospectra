import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWidgets extends StatefulWidget {
  final Future<List<String>> imageUrlsFuture;
  const CarouselWidgets({required this.imageUrlsFuture, super.key});

  @override
  State<CarouselWidgets> createState() => _CarouselWidgetsState();
}

class _CarouselWidgetsState extends State<CarouselWidgets> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: widget.imageUrlsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // or any other loading indicator
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else {
          List<String>? imageUrls = snapshot.data;
          if (imageUrls != null && imageUrls.isNotEmpty) {
            return Column(
              children: [
                CarouselSlider(
                  items: imageUrls.map((imageUrl) {
                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                  options: CarouselOptions(
                    aspectRatio: 2,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                CarouselIndicator(
                  height: 10,
                  cornerRadius: 20,
                  width: 10,
                  activeColor: Colors.blue,
                  color: Colors.black54,
                  count: imageUrls.length,
                  index: _currentIndex,
                ),
              ],
            );
          } else {
            return const Text('No images found');
          }
        }
      },
    );
  }
}
