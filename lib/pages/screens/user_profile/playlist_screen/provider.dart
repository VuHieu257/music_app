import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistProvider with ChangeNotifier {
  List<dynamic> _songs = [];

  List<dynamic> get songs => _songs;

  User? _user;

  User? get user => _user;

  Future<void> fetchPlaylist() async {
    _user = FirebaseAuth.instance.currentUser;

    final snapshot = await FirebaseFirestore.instance
        .collection('db_playlists')
        .doc(_user?.uid)
        .get();

    if (snapshot.exists) {
      _songs = snapshot.data()!['songs'] ?? [];
    } else {
      await createPlaylistIfNotExists("${_user?.uid}");
    }

    notifyListeners();
  }

  Future<void> createPlaylistIfNotExists(String playlistId) async {
    await FirebaseFirestore.instance.collection('db_playlists')
        .doc(playlistId)
        .set({
        });
  }

  // Future<void> removeFromPlaylist(String playlistId, String artistName) async {
  //   // Tìm tất cả bài hát của nhạc sĩ theo artistName
  //   final songSnapshots = await FirebaseFirestore.instance
  //       .collection('db_songs')
  //       .where("artist", isEqualTo: artistName) // Tìm bài hát theo tên nhạc sĩ
  //       .get(); // Lấy dữ liệu
  //
  //   // Kiểm tra xem có bài hát nào không
  //   if (songSnapshots.docs.isNotEmpty) {
  //     for (var songSnapshot in songSnapshots.docs) {
  //       final songData = songSnapshot.data(); // Lấy dữ liệu bài hát
  //
  //       // Cập nhật playlist để xóa bài hát
  //       await FirebaseFirestore.instance.collection('db_playlists').doc(playlistId).update({
  //         'songs': FieldValue.arrayRemove([{
  //           'songId':songSnapshots.docs.,
  //           // 'title': songData['title'],
  //           // 'artist': songData['artist'],
  //           // 'song_url': songData['song_url'],
  //           // 'image_url': songData['image_url'],
  //         }])
  //       });
  //       print('Bài hát "${songData['title']}" đã được xóa khỏi playlist');
  //     }
  //   } else {
  //     print('Không tìm thấy bài hát nào của nhạc sĩ $artistName.');
  //   }
  // }
}
