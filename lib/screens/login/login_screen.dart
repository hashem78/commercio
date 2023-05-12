import 'package:commercio/screens/login/widgets/login_screen_select_theme_mode_button.dart';
import 'package:commercio/screens/login/widgets/login_screen_toggle_language_button.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      resizeToAvoidBottomInset: true,
      headerBuilder: (context, constraints, shrinkOffset) {
        return const Row(
          children: [
            LoginScreenToggleLanguageButton(),
            LoginScreenSelectThemeButton(),
          ],
        );
      },
    );
  }
}
