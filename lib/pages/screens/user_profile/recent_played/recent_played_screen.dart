import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../../../widget_small/widget_music.dart';
class RecentPlayedScreen extends StatefulWidget {
  const RecentPlayedScreen({super.key});

  @override
  State<RecentPlayedScreen> createState() => _RecentPlayedScreenState();
}

class _RecentPlayedScreenState extends State<RecentPlayedScreen> {
  bool isCheck=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },child: const Icon(Icons.keyboard_arrow_down),
        ),
        title: Center(child: Text(
          "Recent played",style: context.theme.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        ),),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.more_horiz),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Styles.defaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isCheck=!isCheck;
                      });
                    },
                    child: Column(
                      children: [
                        Text('Bài hát',style: context.theme.textTheme.headlineMedium?.copyWith(
                            color: isCheck==false?Styles.dark:Styles.grey
                        ),),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          height: context.height*0.003,
                          width: context.width*0.15,
                          decoration: BoxDecoration(
                              color:isCheck==false?Styles.blueIcon:Styles.light,
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: context.width*0.06,),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isCheck=!isCheck;
                      });
                    },
                    child: Column(
                      children: [
                        Text('Album',style: context.theme.textTheme.headlineMedium?.copyWith(
                            color: isCheck==true?Styles.dark:Styles.grey
                        ),),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          height: context.height*0.003,
                          width: context.width*0.15,
                          decoration: BoxDecoration(
                              color:isCheck==true?Styles.blueIcon:Styles.light,
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.height*0.02,),
              Row(
                children: [
                  Text("Tất cả (3)",style: context.theme.textTheme.titleMedium,),
                  const Spacer(),
                  const Icon(Icons.search),
                  SizedBox(width: context.width*0.02,),
                  const Icon(Icons.checklist),
                ],
              ),
              SizedBox(height: context.height*0.02,),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                primary: true,
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return CustomMusic(icon: Icons.download_for_offline_outlined,img:Asset.bgImageMusic,rank:"$index",nameMusic: "Let Me Down Slowly",singer: "Sơn tùng",onMorePressed: () {

                  },);
                },)
            ],
          ),
        ),
      ),
    );
  }
}