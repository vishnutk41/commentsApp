import 'package:commentsapp/controller/providers/firebase_auth_provider.dart';
import 'package:commentsapp/controller/utilities/constants.dart';
import 'package:commentsapp/view/login/login.dart';
import 'package:commentsapp/controller/route_manager.dart';
import 'package:commentsapp/view/widgets/popup_dialogues.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  RouteManager routeManager = RouteManager();
  PopUpDialogues popUpDialogues = PopUpDialogues();

  final FirebaseAuthProvider _authProvider = FirebaseAuthProvider();

  Future<void> _signUp() async {
    if (_validateInputs()) {
      User? user = await _authProvider.signUp(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
Navigator.of(context).pushAndRemoveUntil(
  routeManager.createRoute(LoginScreen()),
  (Route<dynamic> route) => false,
);       }
    }
  }

  bool _validateInputs() {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;

    if (name.isEmpty) {
      popUpDialogues.showErrorDialog('Name cannot be empty',context);
      return false;
    }

    if (!_isValidEmail(email)) {
     popUpDialogues.showErrorDialog('Invalid email address',context);
      return false;
    }

    if (password.length < 6) {
    popUpDialogues.showErrorDialog('Password must be at least 6 characters',context);
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$",
    );
    return emailRegExp.hasMatch(email);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCED3DC),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                _buildTextField('Name', _nameController, false),
                const SizedBox(height: 20),
                _buildTextField('Email', _emailController, false),
                const SizedBox(height: 20),
                _buildTextField('Password', _passwordController, true),
              ],
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                GestureDetector(
                  onTap: _signUp,
                  child: Container(
                    height: 50,
                    width: 230,
                    decoration: buttonDecorationStyle,
                    child:  Center(
                      child: Text(
                        'Signup',
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(routeManager.createRoute(LoginScreen()));
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
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