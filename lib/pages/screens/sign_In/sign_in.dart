import 'package:flutter/material.dart';
import 'package:music_app/core/colors/color.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/sign_up/sign_up.dart';

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
  final TextEditingController _passwordController=TextEditingController();

  bool obscurrentText=true;

  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: context.height*0.35,
              // width: context.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Asset.bgSigin),
                  fit: BoxFit.fill
                )
              ),
            ),
            SizedBox(height: context.height*0.015,),
            Text("Welcome Back",style: context.theme.textTheme.headlineLarge?.copyWith(color: Styles.blueIcon,fontWeight: FontWeight.bold,fontSize: 26),),
            Text("Login to your account?",style: context.theme.textTheme.headlineSmall?.copyWith(fontSize: 18,color: Styles.grey)),
            SizedBox(height: context.height*0.04,),
            CustomTextField(
              hintText: "Full Name",
              prefixIcon: const Icon(Icons.account_circle,color: Styles.blueIcon,),
              bg: Styles.blueLight.withOpacity(0.5),
              colorText: Styles.blueIcon,
            ),
            SizedBox(height: context.height*0.015,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => value!.isEmpty?"Nhập mật khẩu":null,
                controller: _passwordController,
                obscureText: obscurrentText,
                decoration: InputDecoration(
                  filled: true, // Cho phép tô màu nền
                  fillColor: Styles.blueLight.withOpacity(0.5),
                  alignLabelWithHint: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)), // Bo góc
                    borderSide: BorderSide.none, // Loại bỏ viền
                  ),
                  prefixIcon: const Icon(Icons.lock_rounded,size: 30,color: Styles.blueIcon,),
                  hintText: "Enter password",
                  hintStyle: const TextStyle(
                    color: Styles.blueIcon,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  // labelText: "Password",
                  suffixIcon: GestureDetector(
                    onTap: (){
                      setState(() {
                        obscurrentText=!obscurrentText;
                      });
                    },
                    child: Icon(obscurrentText?Icons.visibility_off_outlined:Icons.visibility_outlined,color: Styles.blueIcon,),
                  ),
                ),
              ),
            ),
            SizedBox(height: context.height*0.01,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
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
                            color: _isChecked ? Styles.blueIcon : Colors.grey.shade200,
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
                        Text("Remember me",style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.grey,fontSize: 14),),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(onPressed: () {
                    }, child: Text(
                      "Forgot your password?",
                      style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.blueIcon,fontSize: 14),
                    ))
                ],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.all(Styles.defaultPadding),
            //   padding: const EdgeInsets.symmetric(vertical: 15),
            //   width: context.width,
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     borderRadius: Styles.defaultBorderRadius,
            //     color: Styles.blueIcon
            //   ),
            //   child: Text(
            //     "Sign In",style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.light,),
            //   ),
            // ),
            InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavigaBar(),));
                },
                child: const CusButton(text: "Sign In", color: Styles.blueIcon)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don’t have an account?",style: context.theme.textTheme.titleMedium,),
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp(),));
                   }, child:Text("Sign up",style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.blueIcon,fontWeight: FontWeight.bold),)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
