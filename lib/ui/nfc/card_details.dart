import 'package:aikyam/ui/settings/logout.dart';
import 'package:aikyam/ui/widgets/like_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardDetails extends StatefulWidget {
  final String uid;
  const CardDetails({Key? key, required this.uid}) : super(key: key);

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late String _name = "";
  late String _emergencyContact = "";
  late String _bloodGroup = "";
  late String _address = "";
  late String _mailId = "";
  late String _contact = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    String uid = widget.uid;
    // Fetch data from Firestore using the UID
    // Example code to fetch data based on UID
    try {
      // Assuming you have a 'users' collection in Firestore
      DocumentSnapshot userInfo = await _db.collection('users').doc(uid).get();
      if (userInfo.exists) {
        // Access the data and update state variables
        setState(() {
          _name = userInfo['name'];
          _emergencyContact = userInfo['emergencyContact'];
          _bloodGroup = userInfo['bloodGroup'];
          _address = userInfo['address'];
          _mailId = userInfo['email'];
          _contact = userInfo['contact'];
        });
        print(
            "$_name $_emergencyContact $_bloodGroup $_address $_mailId $_contact");
      } else {
        // Handle the case when the document doesn't exist
        setState(() {
          _name = 'N/A';
          _emergencyContact = 'N/A';
          _bloodGroup = 'N/A';
          _address = 'N/A';
          _mailId = 'N/A';
          _contact = 'N/A';
        });
        print(
            "$_name $_emergencyContact $_bloodGroup $_address $_mailId $_contact");
      }
    } catch (error) {
      print('Error fetching data: $error');
      // Handle error
    }
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
                    "Card Details",
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
                "Emergency",
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
              trailing: Text(
                _name,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
              title: const Text(
                "Name",
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
              trailing: Text(
                _emergencyContact,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
              title: const Text(
                "Emergency Contact",
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
              trailing: Text(
                _bloodGroup,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
              title: const Text(
                "Blood Group",
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
              trailing: Text(
                _address,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
              title: const Text(
                "Address",
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
                "Other Details",
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
              horizontalTitleGap: 0,
              trailing: Text(
                _mailId,
                softWrap: false,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
              title: const Text(
                "Mail Id",
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
              trailing: Text(
                _contact,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
              title: const Text(
                "Contact",
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
            const ListTile(),
          ],
        ),
      ),
    );
  }
}
