import 'package:flutter/material.dart';
import 'package:music_app/core/colors/color.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import 'add_schedule/add_schedule_screen.dart';
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Text("Lịch cá nhân",style: context.theme.textTheme.headlineLarge?.copyWith(color: Styles.blueIcon,fontWeight: FontWeight.bold,fontSize: 26),),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>const AddScheduleScreen(),));
              },
              child: const Icon(Icons.add_circle_outline),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding:EdgeInsets.all(Styles.defaultPadding),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              primary: true,
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (context, index) {
              return customSchedule(context,"If every day at $index:30AM, then follow a playlist","by phanhien.123");
            },),
        ),
      ),
    );
  }
  Container customSchedule(BuildContext context,String title,String content){
    return Container(
      padding:EdgeInsets.all(Styles.defaultPadding/2),
      margin: EdgeInsets.only(bottom:Styles.defaultPadding),
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Styles.greyLight,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.query_builder,),
          SizedBox(height: context.height*.01,),
          SizedBox(width: context.width*.85,child: Text(title,style: context.theme.textTheme.headlineSmall,)),
          SizedBox(height: context.height*.005,),
          SizedBox(width: context.width*.85,child: Text(content,style: context.theme.textTheme.titleMedium?.copyWith(
              color: Styles.dark.withOpacity(0.8)
          ),))
        ],
      ),
    );
  }
}
