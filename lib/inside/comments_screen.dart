import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'comments_provider.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  Future<Map<String, dynamic>?> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<bool> _fetchMaskEmailConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(minutes: 1),
      minimumFetchInterval: Duration(hours: 1),
    ));
    
    await remoteConfig.fetchAndActivate();

    bool maskEmail = remoteConfig.getBool('mask_email');
    print('Mask email fetched from Remote Config: $maskEmail'); // Debug print
    return maskEmail;
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts[0].length > 3) {
      return '${parts[0].substring(0, 3)}****@${parts[1]}';
    } else {
      return email; // or mask differently if the local part is shorter than 3 characters
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
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff0C54BE),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: Future.wait([_fetchUserDetails(), _fetchMaskEmailConfig()]).then((results) => {
          'userDetails': results[0],
          'maskEmail': results[1],
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user details'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user details found'));
          } else {
            final userDetails = snapshot.data!['userDetails'] as Map<String, dynamic>;
            final maskEmail = snapshot.data!['maskEmail'] as bool;
            final email = maskEmail ? _maskEmail(userDetails['email']) : userDetails['email'];
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${userDetails['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Email: $email', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
                Expanded(
                  child: commentsProvider.loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: commentsProvider.comments.length,
                          itemBuilder: (context, index) {
                            final comment = commentsProvider.comments[index];
                            final commentEmail = maskEmail ? _maskEmail(comment.email) : comment.email;
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
                                            child: Text(comment.name[0].toUpperCase()),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name: ${comment.name}',
                                                overflow: TextOverflow.clip,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Email: $commentEmail',
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(comment.body),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
