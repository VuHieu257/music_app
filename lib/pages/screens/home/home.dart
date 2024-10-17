import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/home/search_screen/search_screen.dart';
import 'package:music_app/pages/screens/home/voice_search/voice_search_scree.dart';

import '../../../core/assets.dart';
import '../../../core/colors/color.dart';
import '../../widget_small/widget_music.dart';
import '../musicplayerscreen/music_player_screen.dart';
import 'all_music/all_music.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
          Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(Styles.defaultPadding),
              child: const Column(
                  children: [
                    //Made for you
                    MadeForYouSection( ),
                    //leaderboard
                    LeaderboardSection( ),
                  ],
                ),
              ),
            ),
          )
    );
  }
}


class MadeForYouSection extends StatelessWidget {

  const MadeForYouSection({super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(Asset.bgLogo),
            ),
            SizedBox(width: context.width*0.01,),
            Text("Music",style: context.theme.textTheme.headlineLarge?.copyWith(color: Styles.blueIcon,fontWeight: FontWeight.bold,fontSize: 26),),
            const Spacer(),
            InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const VoiceSearchScreen(),));
            },child: const Icon(Icons.mic_none,size: 30,),),
            SizedBox(width: context.width*0.02,),
            InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen(),));
            },child: const Icon(Icons.search,size: 30))
          ],
        ),
        SizedBox(height: context.height*0.03,),
        Row(
          children: [
            Text("Made For You",style: context.theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),),
            const Spacer(),
            InkWell(onTap: () {
            },child:Text("see more",style: context.theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),),),
          ],
        ),
        SizedBox(
          height: context.height*0.23,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              return customMadeForYou(context, context.height,Asset.bgImageHeader);
            },),
        ),
      ],
    );
  }
  Column customMadeForYou(BuildContext context,double height,String img){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: height*0.17,
          height: height*0.17,
          margin: const EdgeInsets.only(right: 20,top: 5),
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              image: DecorationImage(
                  image: AssetImage(img),
                  fit: BoxFit.fitHeight
              )
          ),
          child: Image.asset(Asset.iconPlay),
        ),
        SizedBox( width: height*0.17,child: Text("Inside Out",style: context.theme.textTheme.titleMedium,overflow: TextOverflow.ellipsis,))
      ],
    );
  }

}


class LeaderboardSection extends StatelessWidget {

  const LeaderboardSection({super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Leaderboard",style: context.theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),),
            const Spacer(),
            InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AllMusic(),));
              },child:Row(
                children: [
                  Text("see more",style: context.theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),),
                  Container(
                    padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Styles.grey.withOpacity(0.2)
                      ),
                      child: const Icon(Icons.play_arrow,color: Styles.blueIcon,))
                ],
              ),),
          ],
        ),
        SizedBox(height: context.height*0.01,),
          ListView.builder(
            primary: true,
            shrinkWrap: true,
            physics:const NeverScrollableScrollPhysics(),
            itemCount: 8,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MusicPlayerScreen(),));} ,
                  child: CustomMusic(icon: Icons.circle,img:Asset.bgImageMusic,rank: "$index",nameMusic: "Let Me Down Slowly",singer: "Sơn Tùng",onMorePressed: () {
                  },));
            },),
      ],
    );
  }
}
