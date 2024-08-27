import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';

class MessageDetail extends StatefulWidget {
  const MessageDetail({super.key});

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  bool isAddStatus=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios,color: Styles.blueIcon,),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
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
          ],
        ),
        actions: const [
          Icon(Icons.more_vert,color: Styles.blueIcon,)
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(Styles.defaultPadding),
        child: Column(
          children: [
            Center(
              child: Text("13:45 PM",style: context.theme.textTheme.headlineSmall?.copyWith(
                color: Styles.grey
              ),),
            ),
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(Asset.bgImageAvatar),
                ),
                SizedBox(width: context.width*0.02,),
                Container(
                  width: context.height*0.3,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Styles.greyLight,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Text("aaaaaaaaaaaaaaaaaaaa",style: context.theme.textTheme.headlineMedium)),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  width: context.height*0.35,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                      color: Styles.blueIcon,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Text("Jane💕aaaaaaaaaaaaaaaaaaaa",style: context.theme.textTheme.headlineMedium?.copyWith(
                    color: Styles.light
                  ))),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  width: context.height*0.3,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                      color: Styles.greyLight,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: context.height*0.07,
                            width: context.height*0.07,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: AssetImage(Asset.bgImageMusicDetail)
                              )
                            ),
                          ),
                          SizedBox(width: context.width*0.02,),
                          Column(
                            children: [
                              SizedBox(
                                width: context.width*0.3,
                                child: Text("Bụi",style: context.theme.textTheme.headlineMedium?.copyWith(
                                    overflow: TextOverflow.ellipsis
                                )),
                              ),
                              SizedBox(
                                width: context.width*0.3,
                                child: Text("Mây trắng",style: context.theme.textTheme.headlineSmall?.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                  color: Styles.grey
                                )),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Styles.light
                        ),
                        child: Text("Hủy",style: context.theme.textTheme.headlineSmall,),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
        height: context.height*0.1,
        width: context.width,
        color: Styles.light,
        child: Row(
          children: [
            InkWell(
                onTap: () {
                  setState(() {
                    isAddStatus=!isAddStatus;
                  });
                },
                child: const Icon(Icons.add_circle_outline,color: Styles.blueIcon,)),
            const Spacer(),
            const Icon(Icons.camera_alt,color: Styles.blueIcon,),
            const Spacer(),
            const Icon(Icons.file_present,color: Styles.blueIcon,),
            const Spacer(),
            SizedBox(
              width: context.width*0.6,
              height: context.height*0.06,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Type your message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40))
                  )
                ),
              ),
            ),
            const Spacer(),
            const Icon(Icons.send,color: Styles.blueIcon,),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: isAddStatus,
        child: Container(
          padding: const EdgeInsets.all(20),
          height: context.height*0.2,
          color: Styles.greyLight,
          child:Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Styles.light,
                    child: Icon(Icons.headphones,size: 40,),
                  ),
                  Text("Cùng nghe",style: context.theme.textTheme.headlineSmall,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
