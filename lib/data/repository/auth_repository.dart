
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?>  registerWithEmail(String name, String email, String password, String role) async{
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = cred.user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "id": user.uid,
          "name": name,
          "email": email,
          "role": role,
        });
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String, dynamic>?> loginWithEmail(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = cred.user;

      if (user != null) {
        DocumentSnapshot snap =
        await _firestore.collection("users").doc(user.uid).get();
        return snap.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}

