import 'dart:async';

import 'package:aikyam/ui/color_screen.dart';
import 'package:aikyam/ui/nfc/card_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_manager/nfc_manager.dart';

class TapCard extends StatefulWidget {
  const TapCard({Key? key}) : super(key: key);

  @override
  State<TapCard> createState() => _TapCardState();
}

class _TapCardState extends State<TapCard> {
  Timer? _nfcReadTimer;
  //
  @override
  void initState() {
    super.initState();
    _startNfcReading();
  }

  void _startNfcReading() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      setState(() {
        // Process the detected NFC tag data
        String decodedPayload = decodeNfcPayload(tag);
        print(decodedPayload);
        if (FirebaseAuth.instance.currentUser != null) {
          print(FirebaseAuth.instance.currentUser?.uid);
        }

        // showAnimatedDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       insetPadding: const EdgeInsets.all(15),
        //       contentPadding: const EdgeInsets.all(0),
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(15)),
        //       backgroundColor: const Color(0xFF151718),
        //       scrollable: true,
        //       content: Column(
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.all(15.0),
        //             child: Column(
        //               children: [
        //                 Padding(
        //                   padding: const EdgeInsets.only(
        //                       left: 10, right: 10, bottom: 10),
        //                   child: Row(
        //                     mainAxisSize: MainAxisSize.max,
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       const Text('Data in Card',
        //                           style: TextStyle(
        //                             color: Color(0xFFEEEFF0),
        //                             fontSize: 15,
        //                             fontFamily: 'Poppins',
        //                             fontWeight: FontWeight.w500,
        //                           )),
        //                       IconButton(
        //                         splashColor: const Color(0xFF151718),
        //                         icon: const Icon(Icons.close,
        //                             color: Color(0xFFEEEFF0)),
        //                         highlightColor: const Color(0xFF151718),
        //                         onPressed: () {
        //                           Navigator.of(context).pop();
        //
        //                           // Close the dialog
        //                         },
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   width: double.infinity,
        //                   child: Container(
        //                     width: 500,
        //                     height: 100,
        //                     decoration: const BoxDecoration(
        //                       color: Color(0xFF212325),
        //                       borderRadius:
        //                           BorderRadius.all(Radius.circular(40)),
        //                     ),
        //                     child: Padding(
        //                       padding: const EdgeInsets.only(left: 20, top: 10),
        //                       child: Text(decodedPayload,
        //                           style: const TextStyle(
        //                             color: Color(0xFFEEEFF0),
        //                             fontSize: 15,
        //                             fontFamily: 'Poppins',
        //                             fontWeight: FontWeight.w500,
        //                           )),
        //                     ),
        //                   ),
        //                 ),
        //                 const SizedBox(height: 20),
        //               ],
        //             ),
        //           ),
        //           const Divider(
        //             height: 20,
        //             color: Color(0xFFD88E90),
        //             thickness: 1.0,
        //           ),
        //           const SizedBox(height: 40),
        //         ],
        //       ),
        //     );
        //     ;
        //   },
        //   animationType: DialogTransitionType.fade,
        //   curve: Curves.easeInOutQuad,
        //   duration: const Duration(milliseconds: 600),
        // );
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                CardDetails(uid: decodedPayload),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInQuart;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );

        // Stop the timer and navigate if needed
        _nfcReadTimer?.cancel();
        // _navigateToNextScreen(
        //     decodedPayload); // Replace with your navigation logic
      });
    });
  }

  void _handleNfcTimeout() {
    Navigator.pop(context);
  }

  String decodeNfcPayload(NfcTag tag) {
    if (tag != null && tag.data.containsKey('ndef')) {
      var ndefData = tag.data['ndef'];
      if (ndefData.containsKey('cachedMessage')) {
        var cachedMessage = ndefData['cachedMessage'];
        if (cachedMessage.containsKey('records')) {
          var records = cachedMessage['records'];
          List<String> decodedRecords = [];

          for (var record in records) {
            if (record.containsKey('payload')) {
              var payload = record['payload'];

              // Check if the payload starts with 'en'
              if (payload.length >= 2 && payload[0] == 2 && payload[1] == 101) {
                // Remove the 'en' prefix and convert the rest to text
                String textPayload = String.fromCharCodes(payload.sublist(3));
                decodedRecords.add(textPayload);
              }
            }
          }

          return decodedRecords.join('\n');
        }
      }
    }

    return 'Unable to decode payload';
  }

  @override
  void dispose() {
    _nfcReadTimer?.cancel();
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(1000),
                        bottomRight: Radius.circular(1000),
                      ),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: Transform.scale(
                            scale: 1.4, // Adjust the scale factor as needed
                            child: Lottie.asset(
                              'assets/images/nfc-scan.json',
                              height: 600,
                              width: 500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Tap your card',
                    style: TextStyle(fontFamily: 'poppins'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                      ),
                      child: Container(
                        height: 159,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
