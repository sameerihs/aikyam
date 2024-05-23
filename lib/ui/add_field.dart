import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddField extends StatefulWidget {
  const AddField({Key? key}) : super(key: key);

  @override
  State<AddField> createState() => _AddFieldState();
}

class _AddFieldState extends State<AddField> {
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _fieldValueController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  Future<void> _createField() async {
    // Get the UID of the authenticated user
    String fieldName = _fieldNameController.text;
    String fieldValue = _fieldValueController.text;

    // Add a new field to Firestore
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        fieldName: fieldValue,
      });
      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      // Handle error
      print('Error adding field: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(14),
      contentPadding: const EdgeInsets.all(25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: const Color(0xFF151718),
      scrollable: true,
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 50, top: 30, bottom: 10),
                child: Text(
                  'We encrypt your data\nfor your privacy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              IconButton(
                splashColor: const Color(0xFF151718),
                icon: const Icon(Icons.close, color: Color(0xFFEEEFF0)),
                highlightColor: const Color(0xFF151718),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          ListTile(
            title: Text(
              'Field Name',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: TextField(
              controller: _fieldNameController,
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'What\'s this field called?',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white), // Change border color here
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: Text(
              'Field Value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: TextField(
              controller: _fieldValueController,
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'What value does it hold?',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white), // Change border color here
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          OutlinedButton(
            onPressed: _createField,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(5.0),
              fixedSize: const Size(260, 50),
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color.fromRGBO(250, 247, 237, 100)),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
            ),
            child: const Text(
              'Create field',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
