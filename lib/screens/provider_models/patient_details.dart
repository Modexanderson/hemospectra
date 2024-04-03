
import 'package:flutter/material.dart';
import 'package:flutter/material.dart'; // Assuming you're using Flutter

enum ImageType {
  local,
  network,
}

class CustomImage {
  final ImageType imgType;
  final String path;

  CustomImage({this.imgType = ImageType.local, required this.path});

  @override
  String toString() {
    return "Instance of Custom Image: {imgType: $imgType, path: $path}";
  }
}

class PatientDetails extends ChangeNotifier {
  CustomImage? _selectedImage; // Change to nullable since initially it's not set
  List<String> _searchTags = [];

  CustomImage? get selectedImage {
    return _selectedImage;
  }

  set initialSelectedImage(CustomImage image) { // Change to set a single image
    _selectedImage = image;
    notifyListeners();
  }

  // If you want to update the selected image later
  set selectedImage(CustomImage? image) {
    _selectedImage = image;
    notifyListeners();
  }

  // Add a function to add a new selected image
  void addNewSelectedImage(CustomImage image) {
    _selectedImage = image;
    notifyListeners();
  }
  // void setSelectedImageAtIndex(CustomImage image, int index) {
  //   if (index < _selectedImage.length) {
  //     _selectedImage[index] = image;
  //     notifyListeners();
  //   }
  // }

  // void addNewSelectedImage(CustomImage image) {
  //   _selectedImage!.add(image);
  //   notifyListeners();
  // }

// Method to clear selected image
  void clearSelectedImage() {
    _selectedImage = null;
    notifyListeners(); // Notify listeners about the change
  }



  List<String> get searchTags {
    return _searchTags;
  }

  set searchTags(List<String> tags) {
    _searchTags = tags;
    notifyListeners();
  }

  set initSearchTags(List<String> tags) {
    _searchTags = tags;
  }

  void addSearchTag(String tag) {
    _searchTags.add(tag);
    notifyListeners();
  }

  void removeSearchTag({int? index}) {
    if (index == null) {
      _searchTags.removeLast();
    } else {
      _searchTags.removeAt(index);
    }
    notifyListeners();
  }
}
