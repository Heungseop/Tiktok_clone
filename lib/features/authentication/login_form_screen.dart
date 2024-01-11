import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/view_models/login_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class LoginFormScreen extends ConsumerStatefulWidget {
  const LoginFormScreen({super.key});

  @override
  LoginFormScreenState createState() => LoginFormScreenState();
}

class LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        //login
        ref
            .read(loginProvider.notifier)
            .login(formData["email"]!, formData["password"]!, context);
        // context.goNamed(InterestsScreen.routeName);
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
                initialValue: "test@a.com",
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
                initialValue: "1q2w3e4r5t!",
                validator: (value) {
                  return null;

                  // return "wrong password";
                },
                onSaved: (newValue) {
                  formData["password"] = newValue ?? "";
                },
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSubmitTap,
                child: FormButton(
                  disabled: ref.watch(loginProvider).isLoading,
                ),
              ),
              // MainButton(
              //   text: "Next",
              //   onTap: (_) => _onSubmitTap(),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
