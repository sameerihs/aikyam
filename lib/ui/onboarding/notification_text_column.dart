// ignore_for_file: use_key_in_widget_constructors

import 'package:aikyam/ui/onboarding/text_column.dart';
import 'package:flutter/material.dart';

class NotificationText extends StatelessWidget {
  const NotificationText();

  @override
  Widget build(BuildContext context) {
    return const TextColumn(
      title: 'Quick Share',
      text: 'Instantly share your details',
    );
  }
}
