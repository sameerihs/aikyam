import 'package:aikyam/ui/onboarding/text_column.dart';
import 'package:flutter/material.dart';

class OwnCardText extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const OwnCardText();

  @override
  Widget build(BuildContext context) {
    return const TextColumn(
      title: 'Seamless Upload',
      text: 'Seamlessly onboard your data into the cloud',
    );
  }
}
