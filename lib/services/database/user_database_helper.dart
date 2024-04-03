import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../authentification_service.dart';

class UserDatabaseHelper {
  UserDatabaseHelper._privateConstructor();
  static final UserDatabaseHelper _instance =
      UserDatabaseHelper._privateConstructor();
  factory UserDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore? _firebaseFirestore;
  FirebaseFirestore get firestore {
    _firebaseFirestore ??= FirebaseFirestore.instance;
    return _firebaseFirestore!;
  }

  Future<void> createNewUser({
    required String uid,
    required String email,
    String? phone,
    String? displayPicture,
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? country,
    String? state,
    String? city,
    String? role,
  }) async {
    await firestore.collection('users').doc(uid).set({
      'user_email': email,
      'phone': phone,
      'display_picture': displayPicture,
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'country': country,
      'state': state,
      'city': city,
      'role': role,
    });
  }

  Future<String> updateUserProfile(Map<Object, Object?> data) async {
    final String currentUserUid = AuthentificationService().currentUser.uid;
    final patientsCollectionReference = firestore.collection('users');
    final docRef = patientsCollectionReference.doc(currentUserUid);
    await docRef.update(data);

    return docRef.id;
  }

  Future<bool> userExists(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('users').doc(uid).get();

      return snapshot.exists;
    } catch (e) {
      if (kDebugMode) {
        print("Error checking user existence: $e");
      }
      return false;
    }
  }

  Stream<DocumentSnapshot> get currentUserDataStream {
    String uid = AuthentificationService().currentUser.uid;
    return firestore.collection('users').doc(uid).get().asStream();
  }

  String getPathForCurrentUserDisplayPicture() {
    final String currentUserUid = AuthentificationService().currentUser.uid;
    return "user/display_picture/$currentUserUid";
  }

  Future<bool> uploadDisplayPictureForCurrentUser(String url) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = firestore.collection('users').doc(uid);
    await userDocSnapshot.update(
      {'display_picture': url},
    );
    return true;
  }

  Future<bool> removeDisplayPictureForCurrentUser() async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = firestore.collection('users').doc(uid);
    await userDocSnapshot.update(
      {
        'display_picture': FieldValue.delete(),
      },
    );
    return true;
  }

  Future<String> get displayPictureForCurrentUser async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = await firestore.collection('users').doc(uid).get();
    return userDocSnapshot.data()?['display_picture'] ??
        'https://cdn.vectorstock.com/i/1000x1000/62/59/default-avatar-photo-placeholder-profile-icon-vector-21666259.webp';
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    try {
      return await firestore.collection('users').doc(uid).get();
    } catch (e) {
      // Handle exceptions (e.g., Firestore errors)
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteCurrentUserData() async {
    final uid = AuthentificationService().currentUser.uid;
    final docRef = firestore.collection('users').doc(uid);

    // final ordersDoc = await ordersCollectionRef.get();
    // for (final orderDoc in ordersDoc.docs) {
    //   await ordersCollectionRef.doc(orderDoc.id).delete();
    // }
    await docRef.delete();
  }
}
