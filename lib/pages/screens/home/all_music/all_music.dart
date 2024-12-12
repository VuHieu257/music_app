
import 'package:cloud_firestore/cloud_firestore.dart';
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
                SizedBox(child:         ListView.builder(
                  primary: true,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('db_songs').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No songs available"));
                        }

                        final songs = snapshot.data!.docs;
                        if (index >= songs.length) return Container(); // Ngăn lỗi nếu index vượt quá dữ liệu.

                        final song = songs[index];
                        return InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const MusicPlayerScreen(),
                            //   ),
                            // );
                          },
                          child: CustomMusic(
                            icon: Icons.circle,
                            img: song['image_url'] ?? 'default_image.png', // Link ảnh từ Firestore
                            rank: "${index + 1}",
                            nameMusic: song['title'] ?? "Unknown Song", // Tên bài hát
                            singer: song['artist'] ?? "Unknown Artist", // Tên nghệ sĩ
                            onMorePressed: () {
                              debugPrint("More options for ${song['name']}");
                            },
                          ),
                        );
                      },
                    );
                  },
                )
                  ,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
