import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/widget_small/widget_music.dart';
import 'package:provider/provider.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../../musicplayerscreen/music_player_screen.dart';
import '../playlist_screen/playlist _screen/provider.dart';
import '../playlist_screen/provider.dart';
import 'edit_playlists/edit_playlists_screen.dart';
class PersonalPlaylistsScreen extends StatefulWidget {
  final String id;
  const PersonalPlaylistsScreen({super.key, required this.id});

  @override
  State<PersonalPlaylistsScreen> createState() => _PersonalPlaylistsScreenState();
}

class _PersonalPlaylistsScreenState extends State<PersonalPlaylistsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlaylistProvider>(context, listen: false).fetchPlaylist();
    });
  }
  final user=FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    final provider=context.read<PlaylistAddProvider>();
    return Scaffold(
      appBar: AppBar(
        leading:  InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditPlaylistsScreen(),));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.more_horiz),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: context.height*0.32,
                  width: context.height*0.32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    image: const DecorationImage(
                      image:AssetImage(Asset.bgImageMusicDetail),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.favorite_border),
                  const SizedBox(width: 10),
                  const Icon(Icons.share),
                  const SizedBox(width: 10),
                  const Icon(Icons.add_circle_outline),
                  const Spacer(),
                  const Icon(Icons.shuffle),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal:10),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('db_playlists').doc(widget.id).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!['songs'] == null || (snapshot.data!['songs'] as List).isEmpty) {
                    return const Center(child: Text('No songs'));
                  } else {
                    final favoriteSongIds = List<String>.from(snapshot.data!['songs']);
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('db_songs')
                          .where(FieldPath.documentId, whereIn: favoriteSongIds)
                          .get(),
                      builder: (context, songSnapshot) {
                        if (songSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (songSnapshot.hasError) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (!songSnapshot.hasData || songSnapshot.data!.docs.isEmpty) {
                          return const Text('No songs found');
                        } else {
                          final playlistSongs = songSnapshot.data!.docs;
                          return ListView.builder(
                            itemCount: playlistSongs.length,
                            itemBuilder: (context, index) {
                              final songData = playlistSongs[index].data() as Map<String, dynamic>;
                              final songId = playlistSongs[index].id;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MusicPlayerScreen(
                                        songs: playlistSongs,
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(width: 1),borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4.0,
                                        offset: Offset(2, 2),
                                      ),
                                    ],),
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                  child: CustomMusic(
                                    icon: Icons.circle,
                                    img: songData['image_url'],
                                    rank: "$index",
                                    nameMusic: songData['title'],
                                    singer: songData['artist'],
                                    onMorePressed: () async {
                                      await provider.removeSongFromPlaylist(widget.id, songId, "$user");
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  }
                },
              ),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                primary: true,
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return CustomMusic(icon: Icons.download_for_offline_outlined,img:Asset.bgImageMusic,rank:"$index",nameMusic: "Let Me Down Slowly",singer: "Sơn tùng",
                    onMorePressed: () {
                    _showBottomSheet(context);
                  },);
                },),
            ],
          ),
        ),
      ),
    );
  }
}
void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: context.height*0.007,
              width: context.width*0.15,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Styles.grey
              ),
            ),
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  Asset.bgImageMusic,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text('Hien',style: context.theme.textTheme.headlineMedium,),
              subtitle: Text('1 bài hát',style: context.theme.textTheme.headlineSmall,),
            ),
            const Divider(),
            ListTile(
              leading:const Icon(Icons.add_road),
              title: Text('Thêm bài hát',style: context.theme.textTheme.headlineMedium,),
              onTap: () {
                // Hành động thêm bài hát
              },
            ),
            ListTile(
              leading:const Icon(Icons.edit),
              title: Text('Chỉnh sửa playlist',style: context.theme.textTheme.headlineMedium),
              onTap: () {
                // Hành động chỉnh sửa playlist
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text('Xóa playlist',style: context.theme.textTheme.headlineMedium),
              onTap: () {
                // Hành động xóa playlist
              },
            ),
          ],
        ),
      );
    },
  );
}