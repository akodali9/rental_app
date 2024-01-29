import 'package:flutter/material.dart';
import 'package:rental_app/Auth/services/auth_services.dart';
import 'package:rental_app/Auth/provider/auth_switch.dart';
import 'package:rental_app/functions/snackbar_showtext.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
    required this.authSwitchCubit,
  });

  final AuthSwitchCubit authSwitchCubit;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final textFieldFocusNode = FocusNode();

  bool _pobscured = true;
  void toggleObscured() {
    setState(() {
      _pobscured = !_pobscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 350,
            child: TextFormField(
              decoration: const InputDecoration(
                label: Text("Email"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email, size: 24),
              ),
              controller: emailController,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 350,
            child: TextFormField(
              obscureText: _pobscured,
              focusNode: textFieldFocusNode,
              decoration: InputDecoration(
                label: const Text("Password"),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_rounded, size: 24),
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: GestureDetector(
                    onTap: toggleObscured,
                    child: Icon(
                      _pobscured
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      size: 24,
                    ),
                  ),
                ),
              ),
              controller: passwordController,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
          child: SizedBox(
            width: 120,
            child: IconButton.filledTonal(
              onPressed: () async {
                if (emailController.text != "" ||
                    passwordController.text != "") {
                  await AuthService.userLogin(
                    emailController.text,
                    passwordController.text,
                    context,
                  );
                } else {
                  return showSnackbar(context, "Please enter your credentials!");
                }
              },
              style: const ButtonStyle(
                enableFeedback: true,
                elevation: MaterialStatePropertyAll(20.0),
              ),
              icon: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.account_circle_outlined,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Text("Don't have an Account?"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton.outlined(
            onPressed: () {
              widget.authSwitchCubit.changeBool();
            },
            style: const ButtonStyle(
              enableFeedback: true,
              elevation: MaterialStatePropertyAll(20.0),
            ),
            icon: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Register",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                ),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
