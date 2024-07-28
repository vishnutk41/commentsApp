import 'package:commentsapp/controller/providers/useremailProvider.dart';
import 'package:commentsapp/view/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/providers/comments_provider.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  Map<String, dynamic>? userDetails;

  Future<Map<String, dynamic>?> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userDetails = userDoc.data() as Map<String, dynamic>?;

      if (userDetails != null) {
        final email = userDetails['email'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);

        final userEmailProvider = Provider.of<UserEmailProvider>(context, listen: false);
        await userEmailProvider.saveUserEmail(email);
      }

      return userDetails;
    }
    return null;
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');

    final userEmailProvider = Provider.of<UserEmailProvider>(context, listen: false);
    await userEmailProvider.clearUserEmail();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _showLogoutDialog() {
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
              _logout();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showUserDetailsDialog() {
    if (userDetails != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('User Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${userDetails!['name']}', style: const TextStyle(
                fontFamily: "Poppins", fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Email: ${userDetails!['email']}', style: const TextStyle(
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

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comments',
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff0C54BE),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: _showUserDetailsDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user details'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user details found'));
          } else {
            userDetails = snapshot.data;

            return commentsProvider.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: commentsProvider.maskedComments.length,
                    itemBuilder: (context, index) {
                      final comment = commentsProvider.maskedComments[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: Text(comment.name[0].toUpperCase(),
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 21,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'Name: ',
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                color: Color(0xffCED3DC),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 21,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: comment.name,
                                                  style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 21,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: true,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Email: ',
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                color: Color(0xffCED3DC),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 21,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: comment.email,
                                                  style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 21,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(comment.body,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
    );
  }
}