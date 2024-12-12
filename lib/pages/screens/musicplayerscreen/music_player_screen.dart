import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/musicplayerscreen/provider.dart';
import 'package:provider/provider.dart';

import '../../../core/assets.dart';
import '../../../core/colors/color.dart';
import '../../widget_small/favorite_button.dart';
import '../../widget_small/get_music_url.dart';

class MusicPlayerScreen extends StatefulWidget {
  final List<DocumentSnapshot> songs; // Danh sách các bài hát
  final int initialIndex; // Chỉ số bài hát ban đầu

  const MusicPlayerScreen({
    super.key,
    required this.songs,
    required this.initialIndex,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late MusicPlayerProvider musicPlayerProvider;
  final user = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();

    // Lấy MusicPlayerProvider từ Provider
    musicPlayerProvider =
        Provider.of<MusicPlayerProvider>(context, listen: false);

    // Đặt playlist và bài hát đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      musicPlayerProvider.setPlaylist(widget.songs, widget.initialIndex);
      musicPlayerProvider
          .playMusic(musicPlayerProvider.currentSong?['song_url']);
    });
  }

  Duration _stopDuration = const Duration(minutes: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_arrow_down,
                color: context.theme.iconTheme.color)),
        centerTitle: true,
        title: Consumer<MusicPlayerProvider>(
          builder: (context, musicPlayer, child) {
            if (musicPlayer.currentSong == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Text(musicPlayer.currentSong?['title'],
                style: Theme.of(context).textTheme.headlineLarge);
          },
        ),
        actions: [
          Icon(Icons.more_horiz, color: context.theme.iconTheme.color),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<MusicPlayerProvider>(
              builder: (context, musicPlayer, child) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.height * .5,
                        child: PageView(
                          onPageChanged: (value) {
                            setState(() {
                              _currentPage = value;
                            });
                          },
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  musicPlayer.currentSong?['image_url'],
                                  width: double.infinity,
                                  height: context.height * 0.35,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text("No image");
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 12),
                              child: SingleChildScrollView(
                                child: Center(
                                  child: Text.rich(
                                      textAlign: TextAlign.center,
                                      TextSpan(children: [
                                        TextSpan(
                                          text:
                                              "But they're showing the lights to the way back home\n\n",
                                          style: context
                                              .theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                  color: Styles.blue,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              "When you don't know where to go\n\nBut they're showing the lights to the way back home\n\nWhen you don't know where to go\n\nBut they're showing the lights to the way back home\n\nWhen you don't know where to go",
                                          style: context
                                              .theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              "When you don't know where to go\n\nBut they're showing the lights to the way back home\n\nWhen you don't know where to go\n\nBut they're showing the lights to the way back home\n\nWhen you don't know where to go",
                                          style: context
                                              .theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        )
                                      ])),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildIndicator(0),
                          const SizedBox(width: 8),
                          _buildIndicator(1),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(musicPlayer.currentSong?['title'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              const SizedBox(height: 8),
                              Text(musicPlayer.currentSong?['artist'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                            ],
                          ),
                          const Spacer(),
                          FavoriteButton(
                            userId: user ?? "",
                            songId: musicPlayer.currentSong?.id ?? "",
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          // DropdownButton<Duration>(
                          //   value: _stopDuration,
                          //   items: [
                          //     const Duration(minutes: 0),
                          //     const Duration(minutes: 1),
                          //     const Duration(minutes: 5),
                          //     const Duration(minutes: 10),
                          //     const Duration(minutes: 15),
                          //   ].map((Duration duration) {
                          //     return DropdownMenuItem<Duration>(
                          //       value: duration,
                          //       child: Text("${duration.inMinutes} phút"),
                          //     );
                          //   }).toList(),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _stopDuration = value!;
                          //       musicPlayer.scheduleStopMusic(_stopDuration);
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                      Slider(
                        value: musicPlayer.currentPosition.inSeconds.toDouble(),
                        max: musicPlayer.totalDuration.inSeconds.toDouble(),
                        onChanged: (value) {
                          musicPlayer.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(musicPlayer.currentPosition)),
                          Text(_formatDuration(musicPlayer.totalDuration)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.shuffle,
                              color: musicPlayer.isShuffleMode
                                  ? Colors.blue
                                  : Colors.grey,
                              size: 25,
                            ),
                            onPressed: musicPlayer.toggleShuffleMode,
                          ),
                          // Icon(Icons.shuffle, size: 25, color: Theme.of(context).iconTheme.color),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            iconSize: 40,
                            onPressed:
                                musicPlayer.previousSong, // Chuyển về bài trước
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 30,
                            child: IconButton(
                              icon: Icon(musicPlayer.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow),
                              iconSize: 30,
                              color: Colors.white,
                              onPressed: () {
                                if (musicPlayer.isPlaying) {
                                  musicPlayer.pauseMusic();
                                } else {
                                  musicPlayer.resumeMusic();
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            iconSize: 40,
                            onPressed:
                                musicPlayer.nextSong, // Chuyển bài tiếp theo
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              musicPlayer.repeatMode == RepeatMode.one
                                  ? Icons.repeat_one
                                  : musicPlayer.repeatMode == RepeatMode.all
                                      ? Icons.repeat
                                      : Icons.repeat,
                              color: musicPlayer.repeatMode != RepeatMode.none
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: musicPlayer.toggleRepeatMode,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                // showMessger(context);
                                showCommentModal(context,musicPlayer.currentSong!.id);
                              },
                              child: Icon(Icons.messenger_outline,
                                  size: 25,
                                  color: context.theme.iconTheme.color)),
                          const Spacer(),
                          InkWell(
                              onTap: () {
                                showQualityBottomSheet(context);
                              },
                              child: Icon(Icons.download_for_offline_outlined,
                                  size: 30,
                                  color: context.theme.iconTheme.color)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar:Padding(
      //   padding: EdgeInsets.symmetric(horizontal:Styles.defaultPadding,vertical: 10),
      //   child: Row(
      //     children: [
      //       InkWell(
      //           onTap: () {
      //             // showMessger(context);
      //             // showCommentModal(context);
      //           },
      //           child: Icon(Icons.messenger_outline,size: 25, color:context.theme.iconTheme.color)),
      //       const Spacer(),
      //       InkWell(
      //           onTap: () {
      //             // showQualityBottomSheet(context);
      //           },
      //           child: Icon(Icons.download_for_offline_outlined,size: 30, color:context.theme.iconTheme.color)),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Styles.blueIcon : Styles.grey,
      ),
    );
  }

  // Hàm định dạng thời gian
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  // void showCommentModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (BuildContext context) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.8, // Occupies 80% of the screen height
  //         child: Container(
  //           padding:
  //               const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Align(
  //                 alignment: Alignment.center,
  //                 child: Container(
  //                   height: 4,
  //                   width: MediaQuery.of(context).size.width * 0.2,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Align(
  //                 alignment: Alignment.center,
  //                 child: Text(
  //                   "34 bình luận",
  //                   style: context.theme.textTheme.headlineMedium,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: 10,
  //                   itemBuilder: (context, index) {
  //                     return _messUser(context, Asset.bgImageAvatar, "Nấm",
  //                         "❤️❤️", "2m ago");
  //                   },
  //                 ),
  //               ),
  //               const Divider(),
  //               Row(
  //                 children: [
  //                   const CircleAvatar(
  //                     radius: 20,
  //                     backgroundImage: AssetImage(Asset.bgImageAvatar),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Expanded(
  //                     child: TextField(
  //                       decoration: InputDecoration(
  //                         hintText: 'Add a comment...',
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         suffixIcon: const Icon(Icons.tag_faces),
  //                         contentPadding:
  //                             const EdgeInsets.symmetric(horizontal: 15),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   const Icon(
  //                     Icons.send,
  //                     color: Styles.blueIcon,
  //                   )
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  void showCommentModal(BuildContext context, String songId) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8, // Occupies 80% of the screen height
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 4,
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Title with comment count
                StreamBuilder<int>(
                  stream: fetchCommentCount(songId), // Fetch the comment count
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        "$count bình luận",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),

                // Comment list
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: fetchComments(songId), // Fetch comment data
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Chưa có bình luận nào.'));
                      }

                      final comments = snapshot.data!;
                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                              NetworkImage(comment['avatar'] ?? ''),
                            ),
                            title: Text(comment['username'] ?? 'Unknown'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment['content'] ?? ''),
                                const SizedBox(height: 5),
                                Text(
                                  comment['timestamp'] ?? '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const Divider(),

                // Add new comment
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(Asset.bgImageAvatar),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Thêm bình luận...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: const Icon(Icons.tag_faces),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.send, color: Styles.blueIcon),
                      onPressed: () async {
                        if (commentController.text.trim().isNotEmpty) {
                          await addComment(songId, {
                            'userId': 'currentUserId', // Lấy từ Auth
                            'username': 'currentUsername', // Lấy từ Auth
                            'avatar': 'currentAvatarUrl', // Lấy từ Auth
                            'content': commentController.text.trim(),
                            'timestamp': DateTime.now().toIso8601String(),
                          });
                          commentController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Stream<int> fetchCommentCount(String songId) {
    return FirebaseFirestore.instance
        .collection('db_songs')
        .doc(songId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      return (data != null && data['comments'] != null)
          ? (data['comments'] as List).length
          : 0;
    });
  }
  Stream<List<Map<String, dynamic>>> fetchComments(String songId) {
    return FirebaseFirestore.instance
        .collection('db_songs')
        .doc(songId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data != null && data['comments'] != null) {
        return List<Map<String, dynamic>>.from(data['comments']);
      }
      return [];
    });
  }
  Future<void> addComment(String songId, Map<String, dynamic> newComment) async {
    final songRef = FirebaseFirestore.instance.collection('db_songs').doc(songId);
    await songRef.update({
      'comments': FieldValue.arrayUnion([newComment])
    });
  }

  Widget _messUser(BuildContext context, String img, String name,
      String comment, String date) {
    return ListTile(
      trailing: const Icon(
        Icons.favorite_border,
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: context.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: context.height * 0.01,
          ),
          Text(
            comment,
            style: context.theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          SizedBox(
            height: context.height * 0.01,
          ),
          Text(
            date,
            style: context.theme.textTheme.titleMedium
                ?.copyWith(color: Styles.grey),
          ),
          SizedBox(
            width: context.width * 0.02,
          ),
          Text(
            "Trả lời",
            style: context.theme.textTheme.titleMedium
                ?.copyWith(color: Styles.grey),
          ),
        ],
      ),
      onTap: () {
        // Xử lý khi chọn chất lượng 128 kbps
        Navigator.pop(context);
      },
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage(img),
      ),
    );
  }

  void showQualityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 4,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10),
                  width: context.width * 0.2,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Styles.grey),
                ),
              ),
              Text(
                "Chọn chất lượng tải",
                style: context.theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Divider(
                color: Styles.dark,
              ),
              ListTile(
                trailing: const Icon(
                  Icons.done,
                  color: Styles.blueIcon,
                ),
                title: Text(
                  "Chất lượng tiêu chuẩn",
                  style: context.theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "Tiết kiệm bộ nhớ cho thiết bị",
                  style: context.theme.textTheme.titleMedium
                      ?.copyWith(color: Styles.grey),
                ),
                onTap: () {
                  // Xử lý khi chọn chất lượng 128 kbps
                  Navigator.pop(context);
                },
              ),
              ListTile(
                trailing: const Icon(
                  Icons.done,
                  color: Styles.blueIcon,
                ),
                title: Text(
                  "Chất lượng cao",
                  style: context.theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "Chất lượng âm thanh cao",
                  style: context.theme.textTheme.titleMedium
                      ?.copyWith(color: Styles.grey),
                ),
                onTap: () {
                  // Xử lý khi chọn chất lượng 320 kbps
                  Navigator.pop(context);
                },
              ),
              ListTile(
                trailing: const Icon(
                  Icons.done,
                  color: Styles.blueIcon,
                ),
                title: Row(
                  children: [
                    Text(
                      "Lossless",
                      style: context.theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Styles.blueIcon.withOpacity(0.3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Text(
                        "PREMIUM",
                        style: context.theme.textTheme.titleMedium
                            ?.copyWith(color: Styles.blueIcon, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  "Tiết kiệm bộ nhớ cho thiết bị",
                  style: context.theme.textTheme.titleMedium
                      ?.copyWith(color: Styles.grey),
                ),
                onTap: () {
                  // Xử lý khi chọn chất lượng Lossless
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
