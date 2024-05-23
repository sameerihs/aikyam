import 'package:aikyam/ui/dashboard.dart';
import 'package:aikyam/ui/login/login.dart';
import 'package:aikyam/ui/login/signup.dart';
import 'package:aikyam/ui/onboarding/onboarding.dart';
import 'package:flutter/cupertino.dart';

import '../ui/test.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/start': (context) => const Dashboard(),
  '/onboarding': (context) => const Onboarding(screenHeight: 200),
  '/login': (context) => const LoginPage(),
  '/signup': (context) => const SignUpPage(),
};
