import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistAddProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DocumentSnapshot> _playlists = [];
  List<DocumentSnapshot> get playlists => _playlists;

  Future<void> fetchPlaylists(String userId) async {
    final snapshot = await _firestore.collection('db_playlists').where('userId', isEqualTo: userId).get();
    _playlists = snapshot.docs;
    notifyListeners();
  }

  Future<void> createNewPlaylist(String playlistName,String userId) async {
    if (playlistName.isNotEmpty) {
      await _firestore.collection('db_playlists').add({
        'name': playlistName,
        'songs': [],
        'userId': userId,
      });
      await fetchPlaylists(userId);
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId,String userId) async {
    await _firestore.collection('db_playlists').doc(playlistId).update({
      'songs': FieldValue.arrayRemove([songId]),
    });
    await fetchPlaylists(userId); // Cập nhật danh sách playlist
  }
}
