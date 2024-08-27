import 'package:flutter/cupertino.dart';

class MusicPlayerProvider with ChangeNotifier {
  bool _isMusicPlayerVisible = false;
  String _currentSongName = '';
  String _currentArtistName = '';
  String _currentAlbumArt = '';

  bool get isMusicPlayerVisible => _isMusicPlayerVisible;
  String get currentSongName => _currentSongName;
  String get currentArtistName => _currentArtistName;
  String get currentAlbumArt => _currentAlbumArt;

  void showMusicPlayer(String songName, String artistName, String albumArt) {
    _isMusicPlayerVisible = true;
    _currentSongName = songName;
    _currentArtistName = artistName;
    _currentAlbumArt = albumArt;
    notifyListeners();
  }

  void hideMusicPlayer() {
    _isMusicPlayerVisible = false;
    notifyListeners();
  }
}