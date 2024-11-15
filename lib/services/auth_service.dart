import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user role based on Firestore integer field 'role'
  Future<int?> getUserRole(String uid) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();

      if (snapshot.exists) {
        // Get the role from the Firestore document
        int role = snapshot['role'];
        print("user role is: ");
        print(role);
        // Return the role directly since it's already stored as an int
        return role; // Example: 1 for student, 2 for faculty, 3 for admin
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
