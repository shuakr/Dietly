import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUserProfile({
    required String fullName,
    required String birthDate,
    required double height,
    required double weight,
    required String gender,
    required bool isSelfProfile,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User not logged in');
    }
    await _firestore.collection('users').doc(uid).collection('profiles').add({
      'fullName': fullName,
      'birthDate': birthDate,
      'height': height,
      'weight': weight,
      'gender': gender,
      'isSelfProfile': isSelfProfile,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
