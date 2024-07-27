import 'package:commentsapp/firebase_options.dart';
import 'package:commentsapp/inside/comments_screen.dart';
import 'package:commentsapp/login/login.dart';
import 'package:commentsapp/signup/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'inside/comments_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
  runApp(
    ChangeNotifierProvider(
      create: (context) => CommentsProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
       CommentsScreen(),
      // LoginScreen(),
      // SignUpScreen()
    );
  }
}