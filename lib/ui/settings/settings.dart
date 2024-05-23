import 'package:aikyam/ui/nfc/card_details.dart';
import 'package:aikyam/ui/settings/logout.dart';
import 'package:aikyam/ui/widgets/like_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'notifications.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String uid = "";
  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 10, bottom: 10),
              child: Column(
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 3,
            ),
            const ListTile(
              title: Text(
                "GENERAL",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 24,
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 3,
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.person_circle),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CardDetails(uid: uid)));
              },
              title: const Text(
                "Account",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.bell_circle),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                showAnimatedDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const NotificationsSettings();
                  },
                  animationType: DialogTransitionType.fade,
                  curve: Curves.easeInOutQuad,
                  duration: const Duration(milliseconds: 600),
                );
              },
              title: const Text(
                "Notifications",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LogoutPage()));
              },
              leading: const Icon(Icons.logout),
              trailing: const Icon(Icons.arrow_forward),
              title: const Text(
                "Log out",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const ListTile(
              leading: Icon(CupertinoIcons.delete_simple),
              trailing: Icon(Icons.arrow_forward),
              title: Text(
                "Delete Account",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 3,
            ),
            const ListTile(
              title: Text(
                "FEEDBACK",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 24,
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 3,
            ),
            const ListTile(
              leading: Icon(Icons.bug_report_outlined),
              trailing: Icon(Icons.arrow_forward),
              title: Text(
                "Report a bug",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const ListTile(
              leading: Icon(Icons.feedback_outlined),
              trailing: Icon(Icons.arrow_forward),
              title: Text(
                "Send feedback",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(
              height: 1,
            ),
            const ListTile(
              title: Text(
                'Brewed by team aikyam',
                style: TextStyle(fontFamily: 'poppins'),
              ),
              trailing: Icon(
                Icons.favorite_border,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
