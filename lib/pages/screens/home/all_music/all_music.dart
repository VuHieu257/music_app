
import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../../../widget_small/widget_music.dart';
import '../../musicplayerscreen/music_player_screen.dart';
class AllMusic extends StatelessWidget {
  const AllMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios,color: Styles.dark,),
          ),
          title: Center(child: Text("Top charts",style: context.theme.textTheme.headlineLarge,)),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right:20.0),
              child: Icon(Icons.search,size: 30,),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Styles.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("23/07/2024",style: context.theme.textTheme.headlineSmall,),
                        Text("60 bài hát",style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),)
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.download_for_offline_outlined,size: 30,),
                    SizedBox(width: context.width*0.01,),
                    const Icon(Icons.playlist_add,size: 30,),
                    SizedBox(width: context.width*0.01,),
                    const Icon(Icons.play_circle,color: Styles.blueIcon,size: 30,),
                  ],
                ),
                SizedBox(height: context.height*0.02,),
                SizedBox(
                  // height: context.height*0.75,
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MusicPlayerScreen(),));
                          } ,
                          child: CustomMusic(icon: Icons.circle,img:Asset.bgImageMusic,rank: "$index",nameMusic: "Let Me Down Slowly",singer: "Sơn Tùng",onMorePressed: () {

                          },));
                    },),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
