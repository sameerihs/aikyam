import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'add_field.dart'; // Assuming you have AddField widget in a separate file

class SecureFields extends StatefulWidget {
  const SecureFields({Key? key}) : super(key: key);

  @override
  State<SecureFields> createState() => _SecureFieldsState();
}

class _SecureFieldsState extends State<SecureFields> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String uid;

  @override
  void initState() {
    super.initState();
    getUserUID();
  }

  Future<void> getUserUID() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userData.data() ?? {};
  }

  Future<List<String>> getSecureFields() async {
    Map<String, dynamic> userData = await getUserData();
    List<String> secureFields = [];
    for (String key in userData.keys) {
      // Add fields to secureFields list if they are not considered secure
      if (![
        'address',
        'age',
        'bloodGroup',
        'contact',
        'email',
        'emergencyContact',
        'gender',
        'name',
        'uid',
        'userId',
      ].contains(key)) {
        secureFields.add(key);
      }
    }
    return secureFields;
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
        child: Center(
          child: FutureBuilder<List<String>>(
            future: getSecureFields(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<String> secureFields = snapshot.data ?? [];
                if (secureFields.isEmpty) {
                  // If no secure fields, display the current screen
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 3,
                      ),
                      const ListTile(
                        title: Text(
                          "Your Secure Fields",
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
                      const SizedBox(height: 20),
                      const Text(
                        'You currently don\'t have any secured fields',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const SizedBox(height: 50),
                      const SizedBox(height: 25),
                      OutlinedButton(
                        onPressed: () {
                          showAnimatedDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddField();
                            },
                            animationType: DialogTransitionType.fade,
                            curve: Curves.easeInOutQuad,
                            duration: const Duration(milliseconds: 600),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(
                              0), // Adjust padding as needed
                          side: const BorderSide(
                              color: Color.fromRGBO(250, 247, 237, 100)),
                        ).copyWith(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.zero, // No rounded corners
                            ),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.black, // Black background color
                            border: Border.all(
                                color: const Color.fromRGBO(
                                    250, 247, 237, 100)), // Border color
                          ),
                          child: Center(
                            child: Text(
                              'Add field',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Display the secure fields
                  return Column(
                    children: [
                      const Divider(
                        color: Colors.black,
                        thickness: 3,
                      ),
                      const ListTile(
                        title: Text(
                          "Your Secure Fields",
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
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: secureFields
                            .map(
                              (field) => Column(
                                children: [
                                  Divider(),
                                  ListTile(
                                    title: Text(
                                      field,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle:
                                        FutureBuilder<Map<String, dynamic>>(
                                      future: getUserData(),
                                      builder: (context, snapshot) {
                                        // if (snapshot.connectionState ==
                                        //     ConnectionState.waiting) {
                                        //   return const CircularProgressIndicator();
                                        // }
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          Map<String, dynamic> userData =
                                              snapshot.data ?? {};
                                          return Text(
                                            userData[field].toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 25),
                      OutlinedButton(
                        onPressed: () {
                          showAnimatedDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddField();
                            },
                            animationType: DialogTransitionType.fade,
                            curve: Curves.easeInOutQuad,
                            duration: const Duration(milliseconds: 600),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(
                              0), // Adjust padding as needed
                          side: const BorderSide(
                              color: Color.fromRGBO(250, 247, 237, 100)),
                        ).copyWith(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.zero, // No rounded corners
                            ),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.black, // Black background color
                            border: Border.all(
                                color: const Color.fromRGBO(
                                    250, 247, 237, 100)), // Border color
                          ),
                          child: Center(
                            child: Text(
                              'Add more fields',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
