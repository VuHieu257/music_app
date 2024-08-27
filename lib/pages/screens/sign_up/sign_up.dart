import 'package:flutter/material.dart';
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

  bool obscurrentText=true;

  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            hintText: "Full Name",
            prefixIcon: const Icon(Icons.account_circle,color: Styles.blueIcon,),
            bg: Styles.blueLight.withOpacity(0.5),
            colorText: Styles.blueIcon,
          ),
          SizedBox(height: context.height*0.015,),
          CustomTextField(
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
          const CusButton(text: "Sign Up", color: Styles.blueIcon),
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
