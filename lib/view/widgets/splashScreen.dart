import 'package:commentsapp/controller/providers/useremailProvider.dart';
import 'package:commentsapp/view/comments_screen.dart';
import 'package:commentsapp/view/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final userEmailProvider = Provider.of<UserEmailProvider>(context, listen: false);
    await userEmailProvider.loadUserEmail();

    if (userEmailProvider.userEmail == null) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );    } else {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => CommentsScreen()),
      (Route<dynamic> route) => false,
    );    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Color(0xff303F60),strokeWidth: 4,),
      ),
    );
  }
}
