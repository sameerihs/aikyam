import 'package:flutter/material.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  bool priceNotificationEnabled = true;
  bool newArrivalsNotificationEnabled = true;
  bool paymentRemindersNotificationEnabled = true;
  bool trendingDesignsNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
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
                  'Change your notification\npreferences',
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
          Padding(
              padding: const EdgeInsets.only(
                  top: 15, right: 30, left: 30, bottom: 30),
              child: Column(
                children: [
                  // Email Notifications
                  Row(
                    children: [
                      const Text(
                        'Emergency Alerts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Transform.scale(
                        scale: 1.1,
                        child: Switch(
                          value: priceNotificationEnabled,
                          onChanged: (value) {
                            setState(() {
                              priceNotificationEnabled = value;
                            });
                          },
                          activeColor: Colors.white,
                          inactiveTrackColor: Colors.grey[850],
                        ),
                      ),
                    ],
                  ),

                  // New Arrivals Notifications
                  Row(
                    children: [
                      const Text(
                        'New Features',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Transform.scale(
                        scale: 1.1,
                        child: Switch(
                          value: newArrivalsNotificationEnabled,
                          onChanged: (value) {
                            setState(() {
                              newArrivalsNotificationEnabled = value;
                            });
                          },
                          activeColor: Colors.white,
                          inactiveTrackColor: Colors.grey[850],
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const Text(
                        'Update Reminders',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Transform.scale(
                        scale: 1.1,
                        child: Switch(
                          value: paymentRemindersNotificationEnabled,
                          onChanged: (value) {
                            setState(() {
                              paymentRemindersNotificationEnabled = value;
                            });
                          },
                          activeColor: Colors.white,
                          inactiveTrackColor: Colors.grey[850],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Cloud Storage Alerts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Transform.scale(
                        scale: 1.1,
                        child: Switch(
                          value: trendingDesignsNotificationEnabled,
                          onChanged: (value) {
                            setState(() {
                              trendingDesignsNotificationEnabled = value;
                            });
                          },
                          activeColor: Colors.white,
                          inactiveTrackColor: Colors.grey[850],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
