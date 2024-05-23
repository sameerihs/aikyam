import 'package:aikyam/ui/dashboard.dart';
import 'package:aikyam/ui/nfc/write_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileSetupPage extends StatefulWidget {
  @override
  _UserProfileSetupPageState createState() => _UserProfileSetupPageState();
}

class _UserProfileSetupPageState extends State<UserProfileSetupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = "";
  String _userId = "";
  String _address = "";
  int _age = 0;
  String _contact = "";
  String _emergencyContact = "";
  String _bloodGroup = ""; // Set an initial value
  String _gender = ""; // Gender field
  String _uid = ""; // User ID field
  String _userEmail = ""; // User Email field

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  void _getUserEmail() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
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
                      "Profile Set up",
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
                title: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _name = newValue!,
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Age",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _age = int.parse(newValue!),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              ListTile(
                title: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "User Id",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your user id';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _userId = newValue!,
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Your Contact",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _contact = newValue!,
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              ListTile(
                title: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Email Id",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email id';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _userEmail = newValue!,
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 3,
              ),
              const ListTile(
                title: Text(
                  "EMERGENCY DETAILS",
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
                title: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Emergency Contact",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your emergency contact number';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _emergencyContact = newValue!,
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              ListTile(
                title: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Blood Group",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your blood group';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _bloodGroup = newValue!,
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              ListTile(
                title: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Your Address",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _address = newValue!,
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Perform form submission logic
                      print('Name: $_name');
                      print('Address: $_address');
                      print('Age: $_age');
                      print('Contact: $_contact');
                      print('Emergency Contact: $_emergencyContact');
                      print('Blood Group: $_bloodGroup');
                      print('Gender: $_gender');
                      // print('Aadhar Number: $_aadharNumber');
                      // print('PAN Number: $_panNumber');

                      // Firebase authentication logic
                      FirebaseAuth auth = FirebaseAuth.instance;
                      User? user = auth.currentUser;
                      if (user != null) {
                        print('User UID: ${user.uid}');
                        _uid = user.uid; // Assigning user UID

                        // Firestore document creation logic
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        await firestore.collection('users').doc(user.uid).set({
                          'uid': _uid,
                          'email': _userEmail, // Saving user's email
                          'userId': _userId,
                          'name': _name,
                          'address': _address,
                          'age': _age,
                          'contact': _contact,
                          'emergencyContact': _emergencyContact,
                          'bloodGroup': _bloodGroup,
                          'gender': _gender,
                        });

                        print('Firestore document created successfully.');
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const WriteCard(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                      } else {
                        print('User not signed in.');
                      }
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
