import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/main_button.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const InterestsScreen(),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: "Email"),
                validator: (value) {
                  return null;

                  // return "idontlike ur email";
                },
                onSaved: (newValue) {
                  formData["email"] = newValue ?? "";
                },
              ),
              Gaps.v16,
              TextFormField(
                decoration: const InputDecoration(hintText: "Password"),
                validator: (value) {
                  return null;

                  // return "wrong password";
                },
                onSaved: (newValue) {
                  formData["password"] = newValue ?? "";
                },
              ),
              Gaps.v28,
              MainButton(
                text: "Next2",
                onTap: (_) => _onSubmitTap(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
