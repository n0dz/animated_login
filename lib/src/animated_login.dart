// ignore_for_file: avoid_print

import 'package:animated_login/src/utils/colors.dart';
import 'package:animated_login/src/widgets/base_text_field.dart';
import 'package:animated_login/src/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

class AnimatedLogin extends StatefulWidget {
  const AnimatedLogin({super.key});

  @override
  State<AnimatedLogin> createState() => _AnimatedLoginState();
}

class _AnimatedLoginState extends State<AnimatedLogin> {
  //* Text controlllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //* Rive Animation Path
  var animatePath = "assets/Rive/bear.riv";

  //* State Machine Input -> SMI Input bool to trigger actions
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  //* SMI Bool for eyes
  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;

  //* SMI for numbers of chars in textfield
  SMIInput<double>? lookAtNumber;

  //* Art Board
  Artboard? artboard;

  //* State Machine Controller
  late StateMachineController? controller;

  //* toggle obscure text
  bool isObscureText = true;

  //*
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  //* function to login
  login() async {
    //* unfocus the textfield
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();

    //* show loading screen
    showLoadingDialog(context);

    //* delay by 2s
    await Future.delayed(
      const Duration(milliseconds: 2000),
    );
    if (mounted) Navigator.pop(context);

    //* check
    if (emailController.text == 'admin' && passwordController.text == "admin") {
      trigSuccess?.change(true);
    } else {
      trigFail?.change(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //* body
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),

            Text(
              "LOGIN",
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 5,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.31,
              width: screenWidth * 0.9,
              child: RiveAnimation.network(
                "http://public.rive.app/community/runtime-files/4771-9633-login-teddy.riv",
                fit: BoxFit.cover,
                placeHolder: Center(child: CircularProgressIndicator()),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              height: screenHeight * 0.35,
              decoration: BoxDecoration(
                color: AppColors.kScaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    BaseTextField(
                      onChanged: (value) => lookAtNumber?.change(
                        value.length.toDouble(),
                      ),
                      focusNode: emailFocusNode,
                      controller: emailController,
                      labelText: "Email",
                      obscureText: false,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        iconSize: 20,
                        onPressed: () => emailController.clear(),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    BaseTextField(
                      focusNode: passwordFocusNode,
                      controller: passwordController,
                      labelText: "Password",
                      obscureText: isObscureText,
                      suffixIcon: IconButton(
                        icon: isObscureText
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isObscureText = !isObscureText;
                          });
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //* login button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        elevation: 0,
                        shadowColor: Colors.white12,
                        minimumSize: const Size(
                          60,60
                        ),
                      ),
                      onPressed: login,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
