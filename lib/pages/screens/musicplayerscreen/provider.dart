import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widget_small/audio_player_task.dart';
import '../../widget_small/get_music_url.dart';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MusicPlayerProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  RepeatMode _repeatMode = RepeatMode.none;
  RepeatMode get repeatMode => _repeatMode;

  bool _isPlaying = false;
  bool _isVisibility = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  int _currentSongIndex = 0;
  List<DocumentSnapshot> _songs = [];
  Timer? _timer; // Timer để hẹn giờ

  bool get isPlaying => _isPlaying;
  bool get isVisibility => _isVisibility;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  DocumentSnapshot? get currentSong => _songs.isNotEmpty ? _songs[_currentSongIndex] : null;

  // Thêm biến kiểm tra chế độ phát ngẫu nhiên
  bool _isShuffleMode = false;
  bool get isShuffleMode => _isShuffleMode;

  void toggleShuffleMode() {
    _isShuffleMode = !_isShuffleMode;
    notifyListeners();
  }
  // Thêm danh sách bài hát yêu thích
  List<DocumentSnapshot> _favoriteSongs = [];
  List<DocumentSnapshot> get favoriteSongs => _favoriteSongs;
  /// Phương thức để thêm bài hát vào danh sách yêu thích
  void toggleFavorite(DocumentSnapshot song) {
    if (_favoriteSongs.contains(song)) {
      _favoriteSongs.remove(song); // Xóa bài hát khỏi danh sách yêu thích
    } else {
      _favoriteSongs.add(song); // Thêm bài hát vào danh sách yêu thích
    }
    notifyListeners();
  }

  // Phương thức kiểm tra bài hát có phải yêu thích hay không
  bool isFavorite(DocumentSnapshot song) {
    return _favoriteSongs.contains(song);
  }

  /// Cập nhật danh sách bài hát và bài đầu tiên để phát
  void setPlaylist(List<DocumentSnapshot> songs, int initialIndex) {
    _songs = songs;
    _currentSongIndex = initialIndex;
    notifyListeners();
  }

  /// Phát nhạc từ URL
  Future<void> playMusic(String url) async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      if (_currentSongIndex >= 0 && _currentSongIndex < _songs.length) {
        DocumentSnapshot currentSong = _songs[_currentSongIndex];

        if (!_recentlyPlayedSongs.contains(currentSong)) {
          _recentlyPlayedSongs.add(currentSong);
          if (_recentlyPlayedSongs.length > 4) {
            _recentlyPlayedSongs.removeAt(0); // Giữ lại 4 bài hát gần đây
          }
        }
        // Lưu lịch sử nghe vào Firebase Firestore
        await _saveListeningHistory(currentSong);
      }
      await _audioPlayer.setUrl(url);
      _audioPlayer.play();
      _isPlaying = true;
      _isVisibility=true;

      // Lắng nghe luồng position và duration
      _audioPlayer.positionStream.listen((position) {
        _currentPosition = position;
        notifyListeners();
      });
      _audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          _totalDuration = duration;
          notifyListeners();
        }
      });
      _audioPlayer.processingStateStream.listen((state) {
        if (state == ProcessingState.completed) {
          _onSongCompleted();
        }
      });

      // Bắt đầu AudioService để phát trong nền
      await _startAudioService();

      notifyListeners();
    } catch (e) {
      print("Lỗi khi phát nhạc: $e");
    }
  }

  /// Xử lý khi bài hát hoàn thành
  void _onSongCompleted() {
    if (_repeatMode == RepeatMode.one) {
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.play();
    } else {
      nextSong();
    }
  }

  /// Chuyển đến bài hát tiếp theo
  void nextSong() {
      if (_isShuffleMode) {
        _currentSongIndex = Random().nextInt(_songs.length); // Chọn bài hát ngẫu nhiên
      } else {
        if (_currentSongIndex < _songs.length - 1) {
          _currentSongIndex++;
        } else {
          _currentSongIndex = 0;
        }
      }
      playMusic(currentSong?['song_url']);
      notifyListeners();
  }

  /// Chuyển về bài hát trước đó
  void previousSong() {
    if (_currentSongIndex > 0) {
      _currentSongIndex--;
    } else {
      _currentSongIndex = _songs.length - 1;
    }
    playMusic(currentSong?['song_url']);
    notifyListeners();
  }

  /// Tạm dừng phát nhạc
  void pauseMusic() {
    _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  /// Tiếp tục phát nhạc
  void resumeMusic() {
    _audioPlayer.play();
    _isPlaying = true;
    notifyListeners();
  }

  /// Dừng phát nhạc
  void stopMusic() {
    _audioPlayer.stop();
    _isPlaying = false;
    _isVisibility=false;
    _timer?.cancel();
    notifyListeners();
  }

  /// Thay đổi chế độ lặp
  void toggleRepeatMode() {
    if (_repeatMode == RepeatMode.none) {
      _repeatMode = RepeatMode.one;
    } else if (_repeatMode == RepeatMode.one) {
      _repeatMode = RepeatMode.all;
    } else {
      _repeatMode = RepeatMode.none;
    }
    notifyListeners();
  }

  /// Seek đến vị trí đã chọn
  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  /// Khởi tạo AudioService để phát nhạc trong nền
  Future<void> _startAudioService() async {
    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      androidNotificationChannelName: 'Music Player',
      androidNotificationColor: 0xFF2196F3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidEnableQueue: true,
    );
  }
  void scheduleStopMusic(Duration duration) {
    // Hủy timer nếu có
    _timer?.cancel();

    // Tạo timer mới
    _timer = Timer(duration, () {
      stopMusic(); // Dừng nhạc khi hết thời gian
    });
  }
  List<DocumentSnapshot> _recentlyPlayedSongs = [];
  List<DocumentSnapshot> get recentlyPlayedSongs => _recentlyPlayedSongs;
  // Hàm lưu lịch sử nghe vào Firestore
  Future<void> _saveListeningHistory(DocumentSnapshot song) async {
    try {
      // Lấy user hiện tại (nếu bạn đã cấu hình Firebase Auth)
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await FirebaseFirestore.instance.collection('db_listening_history').add({
          'user_id': currentUser.uid, // ID người dùng
          'song_id': song.id,         // ID bài hát
          'title': song['title'],      // Tiêu đề bài hát
          'artist': song['artist'],    // Nghệ sĩ
          'image_url': song['image_url'], // URL ảnh bài hát
          'timestamp': FieldValue.serverTimestamp(), // Thời gian phát bài hát
        });
      }
    } catch (e) {
      print('Lỗi khi lưu lịch sử nghe: $e');
    }
  }
}
/// Điểm vào cho nhiệm vụ nền
void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}
