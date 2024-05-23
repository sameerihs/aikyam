import 'package:aikyam/ui/dashboard.dart';
import 'package:aikyam/ui/login/signup.dart';
import 'package:aikyam/ui/onboarding/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/alert_box.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final myUsernameController = TextEditingController();
    final myPasswordController = TextEditingController();
    Color inputColor = const Color.fromRGBO(104, 103, 112, 90);
    // Color inputColor = const Color.fromRGBO(250, 247, 237, 100);
    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      myUsernameController.dispose();
      myPasswordController.dispose();
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 23, 31, 100),
      //NOTE: ADD A SingleChildScrollView WIDGET ON TOP OF SCAFFOLD TO
      // PREVENT KEYBOARD MESSING UP THE WIDGETS
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 40.0, right: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 40),
              const Text(
                'Let\'s sign you in.',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.w500),
              ),
              const Text(
                'Welcome back.',
                style: TextStyle(
                    color: Color.fromRGBO(253, 253, 254, 90),
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(250, 247, 237, 100)),
                    borderRadius: BorderRadius.circular(15)),
                width: 310,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 20, bottom: 5, right: 20),
                  child: TextField(
                    style: const TextStyle(
                        color: Color.fromRGBO(250, 247, 237, 100)),
                    keyboardType: TextInputType.emailAddress,
                    onTap: () {},
                    controller: myUsernameController,
                    cursorColor: const Color.fromRGBO(250, 247, 237, 100),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'email',
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(104, 103, 112, 90)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(250, 247, 237, 100)),
                    borderRadius: BorderRadius.circular(15)),
                width: 310,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 20, bottom: 5, right: 20),
                  child: TextField(
                    style: const TextStyle(
                        color: Color.fromRGBO(250, 247, 237, 100)),
                    controller: myPasswordController,
                    obscureText: true,
                    cursorColor: const Color.fromRGBO(250, 247, 237, 100),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'password',
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(104, 103, 112, 90)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 250),
              Row(children: <Widget>[
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                      color: Color.fromRGBO(253, 253, 254, 90),
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SignUpPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInQuart;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                                position: offsetAnimation, child: child);
                          },
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      backgroundColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ))
              ]),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  try {
                    final _LoginUser = await _auth.signInWithEmailAndPassword(
                        email: myUsernameController.text,
                        password: myPasswordController.text);

                    if (_LoginUser != null) {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  Dashboard(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInQuart;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                                position: offsetAnimation, child: child);
                          },
                        ),
                      );
                    }
                  } catch (e) {
                    if (e
                        .toString()
                        .startsWith('[firebase_auth/wrong-password]')) {
                      showAlert(context, 'Wrong password!');
                    } else if (e
                        .toString()
                        .startsWith('[firebase_auth/unknown]')) {
                      showAlert(context, 'Enter email and password');
                    } else if (e
                        .toString()
                        .startsWith('[firebase_auth/invalid-email]')) {
                      showAlert(context, 'Invalid email');
                    } else {
                      showAlert(context, 'An error occured, try again later');
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(250, 247, 237, 100),
                  fixedSize: const Size(40, 45),
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
