import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
class RecommentPlaylistScreen extends StatelessWidget {
  const RecommentPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  null,
        automaticallyImplyLeading: false,
        title:Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
            const Spacer(),
            Center(
              child: Text("Lịch cá nhân",style: context.theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w500
              ),),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:Styles.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: context.height*0.1,
                  width: context.height*.1,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Asset.iconImageIconClock),
                          fit: BoxFit.cover)
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: context.width*0.85
                      ,child: Text("Turn on applets that run on an daily,weekly.\nIt's automaticnally tailored to your time\nzone",
                    style: context.theme.textTheme.headlineSmall?.copyWith(
                      letterSpacing: 0.27
                    ),textAlign: TextAlign.center,))
              ),
              customT(context,"Nhạc vui tươi, sôi động"),
              customT(context,"Nhạc nhẹ nhàng, thư giãn"),
              customT(context,"Âm nhạc cho ngày mới"),
              customT(context,"Playlist cá nhân"),
            ],
          ),
        ),),
    );
  }
  Container customT(BuildContext context,String title){
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding,vertical:Styles.defaultPadding),
      margin: EdgeInsets.symmetric(vertical: Styles.defaultPadding/2),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Styles.greyLight
      ),
      child: Text(
          title,
          style: context.theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: Styles.dark.withOpacity(0.8)
          )
      ),
    );
  }
}
