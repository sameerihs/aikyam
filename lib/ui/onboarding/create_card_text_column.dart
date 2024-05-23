// ignore_for_file: use_key_in_widget_constructors

import 'package:aikyam/ui/onboarding/text_column.dart';
import 'package:flutter/material.dart';

class CreateCardText extends StatelessWidget {
  const CreateCardText();

  @override
  Widget build(BuildContext context) {
    return const TextColumn(
      title: 'Create A Card',
      text: 'Create your own card based on your preference',
    );
  }
}
