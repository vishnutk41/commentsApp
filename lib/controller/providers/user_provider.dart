import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userDetails;

  Map<String, dynamic>? get userDetails => _userDetails;

  Future<void> fetchUserDetails(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userDetails = userDoc.data() as Map<String, dynamic>?;

      if (userDetails != null) {
        final email = userDetails['email'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);

        _userDetails = userDetails;
        notifyListeners();
      }
    }
  }
}
