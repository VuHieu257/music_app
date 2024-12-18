import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../../../widget_small/widget_music.dart';
import '../../musicplayerscreen/music_player_screen.dart';
import '../search_screen/search_screen.dart';

class AllMusic extends StatelessWidget {
  const AllMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Styles.dark,
          ),
        ),
        title: Center(
            child: Text(
          "Top charts",
          style: context.theme.textTheme.headlineLarge,
        )),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.search,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Styles.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('db_songs').snapshots(),
                builder: (context, snapshot) {
                  int songCount = 0;

                  if (snapshot.hasData && snapshot.data != null) {
                    songCount = snapshot.data!.docs.length;
                  }
                  final String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
                  return Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            currentDate,
                            style: context.theme.textTheme.headlineSmall,
                          ),
                          Text(
                            "$songCount bài hát", // Hiển thị số lượng bài hát theo dữ liệu thực tế
                            style: context.theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.download_for_offline_outlined,
                        size: 30,
                      ),
                      SizedBox(
                        width: context.width * 0.01,
                      ),
                      const Icon(
                        Icons.playlist_add,
                        size: 30,
                      ),
                      SizedBox(
                        width: context.width * 0.01,
                      ),
                      const Icon(
                        Icons.play_circle,
                        color: Styles.blueIcon,
                        size: 30,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: context.height * 0.02,
              ),
              SizedBox(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('db_songs').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No songs available"));
                    }

                    final songs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: songs.length,
                      physics: const NeverScrollableScrollPhysics(),
                      primary: true,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  MusicPlayerScreen(initialIndex: index,songs: songs,),
                              ),
                            );
                          },
                          child: CustomMusic(
                            icon: Icons.circle,
                            img: song['image_url'] ?? 'default_image.png',
                            rank: "${index + 1}",
                            nameMusic: song['title'] ?? "Unknown Song",
                            singer: song['artist'] ?? "Unknown Artist",
                            onMorePressed: () {
                              debugPrint("More options for ${song['title']}");
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              // SizedBox(
              //   child: ListView.builder(
              //     primary: true,
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemCount: 8,
              //     itemBuilder: (context, index) {
              //       return StreamBuilder<QuerySnapshot>(
              //         stream: FirebaseFirestore.instance
              //             .collection('db_songs')
              //             .snapshots(),
              //         builder: (context, snapshot) {
              //           if (snapshot.connectionState ==
              //               ConnectionState.waiting) {
              //             return const Center(
              //                 child: CircularProgressIndicator());
              //           }
              //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              //             return const Center(
              //                 child: Text("No songs available"));
              //           }
              //
              //           final songs = snapshot.data!.docs;
              //           if (index >= songs.length) {
              //             return Container(); // Ngăn lỗi nếu index vượt quá dữ liệu.
              //           }
              //
              //           final song = songs[index];
              //           return InkWell(
              //             onTap: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => const MusicPlayerScreen(),
              //               //   ),
              //               // );
              //             },
              //             child: CustomMusic(
              //               icon: Icons.circle,
              //               img: song['image_url'] ?? 'default_image.png',
              //               // Link ảnh từ Firestore
              //               rank: "${index + 1}",
              //               nameMusic: song['title'] ?? "Unknown Song",
              //               // Tên bài hát
              //               singer: song['artist'] ?? "Unknown Artist",
              //               // Tên nghệ sĩ
              //               onMorePressed: () {
              //                 debugPrint("More options for ${song['name']}");
              //               },
              //             ),
              //           );
              //         },
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
