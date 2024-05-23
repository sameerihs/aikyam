import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Back",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: Colors.black,
              thickness: 3,
            ),
            const Icon(
              FluentIcons.arrow_exit_20_regular,
              size: 200,
              color: Colors.black,
            ),
            const SizedBox(height: 20),
            const Text(
              'Oh no! You\'re leaving',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const Text(
              'Are you sure?',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 50),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(20.0),
                  fixedSize: const Size(300, 70),
                  backgroundColor: Colors.white,
                  side: const BorderSide(
                      color: Color.fromRGBO(250, 247, 237, 100)),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)))),
              child: const Text(
                'Nah, keep me in',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 25),
            OutlinedButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(20.0),
                  fixedSize: const Size(300, 70),
                  backgroundColor: Colors.black,
                  side: const BorderSide(
                      color: Color.fromRGBO(250, 247, 237, 100)),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)))),
              child: const Text(
                'Yea, log me out',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   backgroundColor: Colors.black,
    //   body: Column(
    //     // crossAxisAlignment: CrossAxisAlignment.center,
    //     // mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       const Icon(
    //         Icons.exit_to_app,
    //         // FluentIcons.arrow_exit_20_regular,
    //         size: 200,
    //         color: Colors.white,
    //       ),
    //       const SizedBox(height: 20),
    //       const Text(
    //         'Oh no! You\'re leaving',
    //         style: TextStyle(
    //             color: Colors.white,
    //             fontFamily: 'Poppins',
    //             fontSize: 20,
    //             fontWeight: FontWeight.w500),
    //       ),
    //       const Text(
    //         'Are you sure?',
    //         style: TextStyle(
    //             color: Colors.white,
    //             fontFamily: 'Poppins',
    //             fontSize: 28,
    //             fontWeight: FontWeight.w500),
    //       ),
    //       const SizedBox(height: 50),
    //       OutlinedButton(
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //         style: OutlinedButton.styleFrom(
    //             padding: const EdgeInsets.all(20.0),
    //             fixedSize: const Size(300, 70),
    //             backgroundColor: Colors.white,
    //             side:
    //                 const BorderSide(color: Color.fromRGBO(250, 247, 237, 100)),
    //             shape: const RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.all(Radius.circular(100)))),
    //         child: const Text(
    //           'Nah, keep me in',
    //           style: TextStyle(
    //               color: Colors.black,
    //               fontFamily: 'Poppins',
    //               fontSize: 18,
    //               fontWeight: FontWeight.w500),
    //         ),
    //       ),
    //       const SizedBox(height: 25),
    //       OutlinedButton(
    //         onPressed: () async {
    //           await _auth.signOut();
    //           Navigator.of(context).pushReplacementNamed('/login');
    //         },
    //         style: OutlinedButton.styleFrom(
    //             padding: const EdgeInsets.all(20.0),
    //             fixedSize: const Size(300, 70),
    //             backgroundColor: Colors.black,
    //             side:
    //                 const BorderSide(color: Color.fromRGBO(250, 247, 237, 100)),
    //             shape: const RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.all(Radius.circular(100)))),
    //         child: const Text(
    //           'Yea, log me out',
    //           style: TextStyle(
    //               color: Colors.white,
    //               fontFamily: 'Poppins',
    //               fontSize: 18,
    //               fontWeight: FontWeight.w500),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
