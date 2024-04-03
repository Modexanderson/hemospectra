import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hemospectra/models/patient.dart';
import 'package:provider/provider.dart';

import '../models/size_config.dart';

class PatientImage extends StatelessWidget {
  const PatientImage({
    Key? key,
    required this.patient,
  }) : super(key: key);

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        // color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: SizedBox(
        height: 100,
        width: 100,
        child: CachedNetworkImage(
            imageUrl: patient.image!,
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
      ),
    );
  }
}
