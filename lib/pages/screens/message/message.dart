import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/message/create_group/GroupCreationScreen.dart';

import '../../../core/assets.dart';
import '../../../core/colors/color.dart';
import 'message_detail/message_detail..dart';
class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Styles.defaultPadding),
        child: Scaffold(
          appBar: AppBar(
            leading: null,
            automaticallyImplyLeading: false,
            title: Center(child: Text("Messages",style: context.theme.textTheme.headlineLarge?.copyWith(color: Styles.blueIcon,fontWeight: FontWeight.bold,fontSize: 26),)),
            actions:[
              InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GroupCreationScreen(),)),
                  child: const Icon(Icons.edit_note_outlined,size: 30,))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: context.height*0.02,),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Search",
                    hintStyle: context.theme.textTheme.headlineSmall
                  ),
                ),
                SizedBox(height: context.height*0.02,),
                SizedBox(
                  height: context.height*0.8,
                  child:ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MessageDetail(),));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(Asset.bgImageAvatar),
                                ),
                                SizedBox(width: context.width*0.02,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Jane💕",style: context.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500),),
                                    Text("Hello are you home?",style: context.theme.textTheme.titleMedium?.copyWith(
                                        color: Styles.grey
                                    ))
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("5mins",style:context.theme.textTheme.titleMedium),
                                    CircleAvatar(
                                      radius: 13,
                                      backgroundColor: Styles.blueIcon,
                                      child: Text("2",style:context.theme.textTheme.titleMedium?.copyWith(color: Styles.light)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                           const Divider(),
                          ],
                        ),
                      ),
                    );
                  },),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
