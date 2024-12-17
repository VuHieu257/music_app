import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../../../widget_small/favorite_button.dart';
import '../../../widget_small/widget_music.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool isCheck = false;
  final userID = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.keyboard_arrow_down),
        ),
        title: Center(
          child: Text(
            "Favorites",
            style: context.theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
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
                        isCheck = !isCheck;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          'Songs',
                          style: context.theme.textTheme.headlineMedium
                              ?.copyWith(
                                  color: isCheck == false
                                      ? Styles.dark
                                      : Styles.grey),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          height: context.height * 0.003,
                          width: context.width * 0.15,
                          decoration: BoxDecoration(
                              color: isCheck == false
                                  ? Styles.blueIcon
                                  : Styles.light,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: context.width * 0.06,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isCheck = !isCheck;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          'Album',
                          style: context.theme.textTheme.headlineMedium
                              ?.copyWith(
                                  color: isCheck == true
                                      ? Styles.dark
                                      : Styles.grey),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          height: context.height * 0.003,
                          width: context.width * 0.15,
                          decoration: BoxDecoration(
                              color: isCheck == true
                                  ? Styles.blueIcon
                                  : Styles.light,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: context.height * 0.02,
              ),
              Row(
                children: [
                  const Spacer(),
                  const Icon(Icons.search),
                  SizedBox(
                    width: context.width * 0.02,
                  ),
                  const Icon(Icons.checklist),
                ],
              ),
              SizedBox(
                height: context.height * 0.02,
              ),
              SizedBox(
                height: context.height * 0.8, // Đảm bảo chiều cao xác định
                width: context.width,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('db_user')
                      .doc("hafqF9xuWgXLQ9keqCmembit2L43")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('Error loading favorites'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!['favorites'] == null ||
                        (snapshot.data!['favorites'] as List).isEmpty) {
                      return const Center(child: Text('No favorite songs'));
                    } else {
                      final favoriteSongIds =
                          List<String>.from(snapshot.data!['favorites']);

                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('db_songs')
                            .where(FieldPath.documentId,
                                whereIn: favoriteSongIds)
                            .get(),
                        builder: (context, songSnapshot) {
                          if (songSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (songSnapshot.hasError) {
                            return const Center(
                                child: Text('Error loading songs'));
                          } else if (!songSnapshot.hasData ||
                              songSnapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('No songs found'));
                          } else {
                            final favoriteSongs = songSnapshot.data!.docs;

                            return ListView.builder(
                              itemCount: favoriteSongs.length,
                              itemBuilder: (context, index) {
                                final songData = favoriteSongs[index].data()
                                    as Map<String, dynamic>;
                                final songId = favoriteSongs[index].id;

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4.0,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                    },
                                    title: Row(
                                      children: [
                                        Expanded(
                                          // Bọc Text trong Expanded để tránh tràn
                                          child: Text(
                                            songData['title'],
                                            style: context
                                                .theme.textTheme.bodyMedium,
                                            overflow: TextOverflow
                                                .ellipsis, // Đảm bảo nội dung không tràn
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      songData['artist'],
                                      style: context.theme.textTheme.bodySmall,
                                      overflow: TextOverflow
                                          .ellipsis, // Đảm bảo nội dung không tràn
                                    ),
                                    leading: Container(
                                      width: context.height * 0.1,
                                      height: context.height * 0.1,
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 10),
                                      alignment: Alignment.bottomRight,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              songData['image_url']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: FavoriteButton(
                                        userId: "$userID",
                                        songId: songId,
                                      ),
                                    ),
                                  ),
                                  // child: ListTile(
                                  //   onTap: () {
                                  //   },
                                  //   title: Row(
                                  //     children: [
                                  //       Text(songData['title']),
                                  //     ],
                                  //   ),
                                  //   subtitle: Text(songData['artist']),
                                  //   leading: Container(
                                  //     width: context.height * 0.1,
                                  //     height: context.height * 0.1,
                                  //     margin: const EdgeInsets.only(
                                  //         right: 10, top: 10),
                                  //     alignment: Alignment.bottomRight,
                                  //     decoration: BoxDecoration(
                                  //       color: Colors.grey.shade300,
                                  //       borderRadius: const BorderRadius.all(
                                  //           Radius.circular(8)),
                                  //       image: DecorationImage(
                                  //         image: NetworkImage(
                                  //             songData['image_url']),
                                  //         fit: BoxFit.cover,
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   trailing: SizedBox(
                                  //     height: 30,
                                  //     width: 30,
                                  //     child: FavoriteButton(
                                  //       userId: "$userID",
                                  //       songId: songId,
                                  //     ),
                                  //   ),
                                  // ),
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
