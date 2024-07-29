import 'package:commentsapp/controller/providers/useremailProvider.dart';
import 'package:commentsapp/view/login/login.dart';
import 'package:commentsapp/view/widgets/popup_dialogues.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/providers/comments_provider.dart';
import '../controller/providers/user_provider.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  PopUpDialogues popUpDialogues = PopUpDialogues();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    final commentsProvider = Provider.of<CommentsProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

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
            onPressed: () => popUpDialogues.showUserDetailsDialog(context, userProvider.userDetails),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => popUpDialogues.showLogoutDialog(context),
          ),
        ],
      ),
      body: userProvider.userDetails == null
          ? const Center(child: CircularProgressIndicator())
          : commentsProvider.loading
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
                ),
    );
  }
}
