import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commentsapp/controller/providers/useremailProvider.dart';
import 'package:commentsapp/controller/route_manager.dart';
import 'package:commentsapp/view/comments_screen.dart';
import 'package:commentsapp/view/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopUpDialogues {
  RouteManager routeManager = RouteManager();

  void showErrorDialog(String message,BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sure to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showUserDetailsDialog(BuildContext context, Map<String, dynamic>? userDetails) {
    if (userDetails != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('User Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${userDetails['name']}', style: const TextStyle(
                fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Email: ${userDetails['email']}', style: const TextStyle(
                fontFamily: "Poppins", color: Colors.grey, fontSize: 14)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');

    final userEmailProvider = Provider.of<UserEmailProvider>(context, listen: false);
    await userEmailProvider.clearUserEmail();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
