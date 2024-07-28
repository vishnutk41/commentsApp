import 'package:commentsapp/controller/providers/firebase_auth_provider.dart';
import 'package:commentsapp/controller/providers/useremailProvider.dart';
import 'package:commentsapp/firebase_options.dart';
import 'package:commentsapp/view/comments_screen.dart';
import 'package:commentsapp/view/login/login.dart';
import 'package:commentsapp/view/signup/sign_up.dart';
import 'package:commentsapp/view/widgets/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/providers/comments_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CommentsProvider()),
        ChangeNotifierProvider(create: (context) => UserEmailProvider()),
        Provider(create: (context) => FirebaseAuthProvider()), 
      ],
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
      //  CommentsScreen(),
      // LoginScreen(),
      SplashScreen(),
      // SignUpScreen()
    );
  }
}