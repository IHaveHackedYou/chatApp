import 'package:flutter/material.dart';
import 'package:newwfirst/data/model/contact.dart';
import 'package:newwfirst/presentation/screens/forgot_password_screen.dart';
import 'package:newwfirst/presentation/screens/chat_screen.dart';
import 'package:newwfirst/presentation/screens/error_screen.dart';
import 'package:newwfirst/presentation/screens/home_screen.dart';
import 'package:newwfirst/presentation/screens/initial_screen.dart';
import 'package:newwfirst/presentation/screens/settings_screen.dart';
import 'package:newwfirst/presentation/screens/sign_in_screen.dart';
import 'package:newwfirst/presentation/screens/sign_up_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => InitialScreen());
      case "/signIn":
        return MaterialPageRoute(builder: (context) => SignInScreen());
      case "/signIn/forgotPassword":
        return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
      case "/signUp":
        return MaterialPageRoute(builder: (context) => SignUpScreen());
      case "/home":
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case "/home/chat":
        return MaterialPageRoute(builder: (context) => ChatScreen(args as Contact));
      case "/home/settings":
        return MaterialPageRoute(builder: (context) => SettingsScreen());
      default:
        return MaterialPageRoute(builder: (context) => ErrorScreen());
    }
  }
}
