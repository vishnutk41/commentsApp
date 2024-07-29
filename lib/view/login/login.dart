import 'package:commentsapp/controller/providers/firebase_auth_provider.dart';
import 'package:commentsapp/controller/utilities/constants.dart';
import 'package:commentsapp/view/comments_screen.dart';
import 'package:commentsapp/controller/route_manager.dart';
import 'package:commentsapp/view/signup/sign_up.dart';
import 'package:commentsapp/view/widgets/popup_dialogues.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  RouteManager routeManager = RouteManager();
  PopUpDialogues popUpDialogues = PopUpDialogues();
  final FirebaseAuthProvider _authProvider = FirebaseAuthProvider();
    Future<void> _login() async {
    try {
      User? user = await _authProvider.signIn(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
Navigator.of(context).pushAndRemoveUntil(
  routeManager.createRoute(CommentsScreen()),
  (Route<dynamic> route) => false,
);      } else {
        popUpDialogues.showErrorDialog("Wrong credentials",context);
      }
    } catch (e) {
      popUpDialogues.showErrorDialog("An error occurred: ${e.toString()}",context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCED3DC),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             Text(
              'Comments',
style: commentsTextStyle,
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                _buildTextField('Email', _emailController, false),
                const SizedBox(height: 20),
                _buildTextField('Password', _passwordController, true),
              ],
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                GestureDetector(
                  onTap: _login,
                  child: Container(
                    height: 50,
                    width: 230,
                    decoration: buttonDecorationStyle,
                    child:  Center(
                      child: Text(
                        'Login',
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(routeManager.createRoute(SignUpScreen()));
                  },
                  child: Center(
                    child: RichText(
                      text: const TextSpan(
                        text: 'New here? ',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Signup',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Color(0xff2652b8),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool obscureText) {
    return SizedBox(
      width: 356,
      height: 35,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            fontFamily: "Poppins",
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}