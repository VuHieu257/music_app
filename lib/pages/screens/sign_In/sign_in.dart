import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/colors/color.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/sign_up/sign_up.dart';

import '../../../auth_service.dart';
import '../../../core/assets.dart';
import '../../layout/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../../widget_small/custom_button.dart';
import '../../widget_small/text_form_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool obsCurrentText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String validPassword = "";

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AuthService().hideKeyBoard(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: context.height * 0.35,
                  // width: context.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Asset.bgSigin), fit: BoxFit.fill)),
                ),
                SizedBox(
                  height: context.height * 0.015,
                ),
                Text(
                  "Welcome Back",
                  style: context.theme.textTheme.headlineLarge?.copyWith(
                      color: Styles.blueIcon,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
                Text("Login to your account?",
                    style: context.theme.textTheme.headlineSmall
                        ?.copyWith(fontSize: 18, color: Styles.grey)),
                SizedBox(
                  height: context.height * 0.04,
                ),
                CustomTextField(
                  hintText: "Full Name",
                  prefixIcon: const Icon(
                    Icons.account_circle,
                    color: Styles.blueIcon,
                  ),
                  bg: Styles.blueLight.withOpacity(0.5),
                  colorText: Styles.blueIcon,
                  controller: _emailController,
                ),
                SizedBox(
                  height: context.height * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) => value!.isEmpty ? "Nhập mật khẩu" : null,
                    controller: _passwordController,
                    obscureText: obsCurrentText,
                    decoration: InputDecoration(
                      filled: true,
                      // Cho phép tô màu nền
                      fillColor: Styles.blueLight.withOpacity(0.5),
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        // Bo góc
                        borderSide: BorderSide.none, // Loại bỏ viền
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_rounded,
                        size: 30,
                        color: Styles.blueIcon,
                      ),
                      hintText: "Enter password",
                      hintStyle: const TextStyle(
                        color: Styles.blueIcon,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      // labelText: "Password",
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obsCurrentText = !obsCurrentText;
                          });
                        },
                        child: Icon(
                          obsCurrentText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Styles.blueIcon,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: context.height * 0.01,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isChecked = !_isChecked;
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isChecked
                                    ? Styles.blueIcon
                                    : Colors.grey.shade200,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: _isChecked
                                    ? const Icon(
                                        Icons.check,
                                        size: 20.0,
                                        color: Styles.light,
                                      )
                                    : Icon(
                                        Icons.circle,
                                        size: 20.0,
                                        color: Colors.grey.shade200,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              "Remember me",
                              style: context.theme.textTheme.titleMedium
                                  ?.copyWith(color: Styles.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot your password?",
                            style: context.theme.textTheme.titleMedium
                                ?.copyWith(color: Styles.blueIcon, fontSize: 14),
                          ))
                    ],
                  ),
                ),
                InkWell(
                    onTap: () async {
                      final message = await AuthService().login(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      if (message!.contains('Success')) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomNavigaBar(),
                            ));
                      }
                      setState(() {
                        validPassword = message;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );
                      _formKey.currentState!.validate();
                    },
                    child: CusButton(text: "Sign In", color: Styles.blueIcon)),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account?",
                        style: context.theme.textTheme.titleMedium,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                ));
                          },
                          child: Text(
                            "Sign up",
                            style: context.theme.textTheme.titleMedium?.copyWith(
                                color: Styles.blueIcon,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
