import 'package:aikyam/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../dashboard.dart';
import '../onboarding/onboarding.dart';
import '../widgets/alert_box.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final myUsernameController = TextEditingController();
    final myPasswordController = TextEditingController();
    Color inputColor = const Color.fromRGBO(104, 103, 112, 90);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(24, 23, 31, 100),
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 40.0, right: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Let\'s sign you up.',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.w500),
              ),
              const Text(
                'Your Digital Identity in One place.',
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
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        color: Color.fromRGBO(250, 247, 237, 100)),
                    onTap: () {},
                    controller: myUsernameController,
                    cursorColor: const Color.fromRGBO(250, 247, 237, 100),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'enter your email',
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
                      hintText: 'enter new password',
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(104, 103, 112, 90)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 250),
              Row(children: <Widget>[
                const Text(
                  'Already have an account?',
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
                                  const LoginPage(),
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
                      primary: Colors.grey,
                      backgroundColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Login',
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
                    final _newUser = await _auth.createUserWithEmailAndPassword(
                        email: myUsernameController.text,
                        password: myPasswordController.text);

                    if (_newUser != null) {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  Onboarding(screenHeight: 200),
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
                        .startsWith('[firebase_auth/email-already-in-use]')) {
                      showAlert(context, 'Account already exists');
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
                  fixedSize: const Size(40, 45),
                  primary: const Color.fromRGBO(250, 247, 237, 100),
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                child: const Text(
                  'Register',
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
