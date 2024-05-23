import 'package:flutter/material.dart';

class QrPopUp extends StatefulWidget {
  const QrPopUp({super.key});

  @override
  State<QrPopUp> createState() => _QrPopUpState();
}

class _QrPopUpState extends State<QrPopUp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(15),
      contentPadding: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: const Color(0xFF151718),
      scrollable: true,
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(left: 30.0, right: 30, top: 30, bottom: 10),
                child: Text(
                  'Let others scan this QR to\nget your emergency details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
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
          Image(
            image: const AssetImage('assets/images/qr-sample.png'),
            height: 250,
            width: 250,
          ),
          SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }
}
