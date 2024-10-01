import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int?> getUserRole(String uid) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();

      // Assuming 'faculty' is a boolean field in Firestore
      // You may need to adjust this based on your Firestore schema
      if (snapshot.exists) {
        bool isFaculty = snapshot['role'];
        return isFaculty ? 2 : 1; // 2 for faculty, 1 for student
      } else {
        print("User document does not exist");
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
