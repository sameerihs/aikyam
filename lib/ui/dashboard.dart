import 'package:aikyam/ui/qr.dart';
import 'package:aikyam/ui/secure_fields.dart';
import 'package:aikyam/ui/settings/logout.dart';
import 'package:aikyam/ui/settings/notifications.dart';
import 'package:aikyam/ui/settings/settings.dart';
import 'package:aikyam/ui/tap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String _userName = ""; // Store user's name
  String _userId = ""; // Store user's ID
  String _address = "";
  int _age = 0;
  String _contact = "";
  String _emergencyContact = "";
  String _bloodGroup = ""; // Set an initial value
  // String _aadharNumber = ""; // Optional
  // String _panNumber = ""; // Optional
  String _gender = ""; // Gender field
  String _uid = ""; // User ID field
  String _userEmail = ""; // User Email field

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  String _splitName(String name) {
    List<String> words = name.split(' ');
    int midIndex = words.length ~/ 2;
    String firstHalf = words.sublist(0, midIndex).join(' ');
    String secondHalf = words.sublist(midIndex).join(' ');
    return '$firstHalf\n$secondHalf';
  }

  // Fetch user information from Firestore using user ID
  void _fetchUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot userInfo =
          await _db.collection('users').doc(user.uid).get();
      setState(() {
        _userName = userInfo['name'];
        _userId = userInfo['userId'];
        _address = userInfo['address'];
        _age = userInfo['age'];
        _contact = userInfo['contact'];
        _gender = userInfo['gender'];
        _emergencyContact = userInfo['emergencyContact'];
        _bloodGroup = userInfo['bloodGroup'];
        _userEmail = userInfo['email'];
        // _aadharNumber = userInfo['aadharNumber'];
        // _panNumber = userInfo['pan'];
      });
    }
  }

  double _imageSize = 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SlidingSheet(
        color: Colors.black,
        elevation: 0,
        cornerRadius: 50,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.125, 0.2, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        listener: (state) {
          setState(() {
            _imageSize = 600 - (state.extent * 250);
          });
        },
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const LogoutPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.decelerate;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                  position: offsetAnimation, child: child);
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        CupertinoIcons.arrow_turn_down_left,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecureFields(),
                          ),
                        );
                      },
                      icon: const Icon(
                        FluentIcons.card_ui_20_filled,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        CupertinoIcons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 5,
                    width: 190,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(1000),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(1000),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(
                    color: Colors.black,
                    width: 5,
                  ),
                ),
                height: _imageSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: Transform.scale(
                    scale: 1.9, // Adjust the scale factor as needed
                    child: Lottie.asset(
                      'assets/images/lottie_profile.json',
                      height: 600,
                      width: 500,
                      animate: true,
                      repeat: false,
                    ),
                  ),
                ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(1000),
                //   child: Image.asset(
                //     'assets/images/aikyam_profile2.png',
                //     fit: BoxFit.cover,
                //   ),
                // ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 1, // Adjust the scale factor as needed
                      child: Lottie.asset(
                        'assets/images/swipe-up.json',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 80,
                        animate: true,
                        repeat: true,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        builder: (context, state) {
          return Container(
            height: 400,
            child: Column(
              children: [
                const Center(
                  child: Divider(
                    color: Colors.white54,
                    thickness: 5,
                    indent: 150,
                    endIndent: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(1000),
                          //   child: Transform.scale(
                          //     scale: 0.1, // Adjust the scale factor as needed
                          //     child: Lottie.asset(
                          //       'assets/images/lottie_profile.json',
                          //       height: 600,
                          //       width: 500,
                          //       animate: true,
                          //     ),
                          //   ),
                          // ),
                          // CircleAvatar(
                          //   radius: 41,
                          //   backgroundColor: Colors.white70,
                          //   child: CircleAvatar(
                          //     backgroundColor: Color(0xFF7D0A0A),
                          //     radius: 37,
                          //     backgroundImage: AssetImage(
                          //         'assets/images/aikyam_profile2.png'),
                          //     child: Stack(
                          //       children: [
                          //         Align(
                          //           alignment: Alignment.bottomRight,
                          //           child: CircleAvatar(
                          //             backgroundColor: Colors.black,
                          //             radius: 14,
                          //             child: Icon(
                          //               CupertinoIcons.pen,
                          //               color: Colors.white,
                          //               size: 20,
                          //               weight: 19,
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display user's name and ID fetched from Firestore
                              Text(
                                _userName, // Display user's name
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '@$_userId', // Display user's ID
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showAnimatedDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return QrPopUp();
                                      },
                                      animationType: DialogTransitionType.fade,
                                      curve: Curves.easeInOutQuad,
                                      duration:
                                          const Duration(milliseconds: 600),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 24,
                                    child: Icon(
                                      CupertinoIcons.qrcode,
                                      color: Colors.black,
                                      size: 32,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const TapCard(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.decelerate;
                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));

                                          var offsetAnimation =
                                              animation.drive(tween);
                                          return SlideTransition(
                                              position: offsetAnimation,
                                              child: child);
                                        },
                                      ),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 24,
                                    child: Icon(
                                      Icons.nfc_rounded,
                                      color: Colors.black,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 35,
                          ),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Container(
                                  height: 55,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _bloodGroup,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Container(
                                    height: 55,
                                    width: 250,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            '+91 $_contact',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            'my contact',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Container(
                                    height: 55,
                                    width: 250,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            '+91 $_emergencyContact',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            'emergency contact',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Container(
                                  height: 55,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$_age yrs',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 120,
                              width: 330,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _address,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      'my address',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
