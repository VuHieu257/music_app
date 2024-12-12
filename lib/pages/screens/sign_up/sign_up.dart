import 'package:flutter/material.dart';
import 'package:music_app/auth_service.dart';
import 'package:music_app/core/colors/color.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/sign_In/sign_in.dart';

import '../../../core/assets.dart';
import '../../widget_small/custom_button.dart';
import '../../widget_small/text_form_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool obscurrentText=true;

  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AuthService().hideKeyBoard(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: context.height*0.1,),
            Padding(
              padding: EdgeInsets.only(top:Styles.defaultPadding*2),
              child: Text("Register",style: context.theme.textTheme.headlineLarge?.copyWith(
                  color: Styles.blueIcon,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),),
            ),
            Text("Create your new account",style: context.theme.textTheme.headlineSmall?.copyWith(fontSize: 18,color: Styles.grey)),
            SizedBox(height: context.height*0.05,),
            CustomTextField(
              controller: _userNameController,
              hintText: "Full Name",
              prefixIcon: const Icon(Icons.account_circle,color: Styles.blueIcon,),
              bg: Styles.blueLight.withOpacity(0.5),
              colorText: Styles.blueIcon,
            ),
            SizedBox(height: context.height*0.015,),
            CustomTextField(
              controller: _userEmailController,
              hintText: "Enter email",
              prefixIcon: const Icon(Icons.email_outlined,color: Styles.blueIcon,),
              bg: Styles.blueLight.withOpacity(0.5),
              colorText: Styles.blueIcon,
            ),
            SizedBox(height: context.height*0.015,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => value!.isEmpty?"Endter password":null,
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
                  const Spacer(),
                  TextButton(onPressed: () {
                  }, child: Text(
                    "Forgot your password?",
                    style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.blueIcon,fontSize: 14),
                  ))
                ],
              ),
            ),
            CusButton(text: "Sign Up", color: Styles.blueIcon,onTap: () async {
              final message =
                  await AuthService().registration(
                userName: _userNameController.text,
                email: _userEmailController.text,
                password: _passwordController.text,
              );
              // setState(() {
              //   validPassword = message!;
              //   validEmail = message;
              // });
              if (_formKey.currentState!.validate()) {
                if (message!.contains(
                    "The account already exists for that email.") ||
                    message.contains(
                        "The password provided is too weak.")) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                } else if (message.contains('Success')) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                          const SignIn()));
                }
              }
            },),
            SizedBox(height: context.height*0.06,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 2,width: context.width*0.25,color: Styles.grey,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Or continue with",style: context.theme.textTheme.headlineSmall?.copyWith(fontSize: 18,color: Styles.grey)),
                ),
                Container(height: 2,width: context.width*0.25,color: Styles.grey,),
              ],
            ),
            SizedBox(height: context.height*0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconCon(Asset.iconFb),
                iconCon(Asset.iconGg),
                iconCon(Asset.iconIp),
              ],
            ),
            SizedBox(height: context.height*0.01,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You already have an account",style: context.theme.textTheme.titleMedium,),
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignIn(),));
                  }, child:Text("Sign In",style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.blueIcon,fontWeight: FontWeight.bold),)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Container iconCon(String img){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
      margin: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
      height: context.height*0.055,
      // width: context.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(img),
              fit: BoxFit.fill
          )
      ),
    );
  }
}
