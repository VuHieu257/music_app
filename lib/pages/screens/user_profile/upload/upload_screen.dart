import 'package:flutter/material.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../../../widget_small/widget_music.dart';
class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },child: const Icon(Icons.arrow_back_ios),
        ),
        title: Center(child: Text(
          "Your uploads",style: context.theme.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        ),),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.file_upload_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Styles.defaultPadding),
          child: Column(
            children: [
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
