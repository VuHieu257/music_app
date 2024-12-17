import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/user_profile/playlist_screen/playlist%20_screen/provider.dart';
import 'package:music_app/pages/screens/user_profile/playlist_screen/provider.dart';
import 'package:provider/provider.dart';

import '../../../widget_small/widget_music.dart';
import '../../musicplayerscreen/music_player_screen.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final String id;
  final List<DocumentSnapshot> songsPlay;
  const PlaylistDetailScreen({super.key, required this.id ,required this.songsPlay});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
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
        centerTitle: true,
        title: const Text('Playlist',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),),
        leading:InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          const Divider(),
      Expanded(
            child:
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
                                    _showDeleteDialog(
                                      context,
                                      "${songData['title']}",
                                          () async {
                                        await provider.removeSongFromPlaylist(widget.id, songId, "$user");
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Song removed successfully.')),
                                        );
                                      },
                                    );
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
      ),
        ],
      ),
    );
  }
  Future<void> _showDeleteDialog(
      BuildContext context, String songTitle, VoidCallback onConfirm) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Song'),
          content: Text('Are you sure you want to remove "$songTitle" from your playlist?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                onConfirm(); // Chỉ gọi hàm xóa sau khi bấm nút Delete
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
