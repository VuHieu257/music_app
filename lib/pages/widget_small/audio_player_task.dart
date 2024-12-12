import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int currentIndex = 0;
  List<MediaItem> queue = [];

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    queue = params!['queue'] as List<MediaItem>;
    currentIndex = params['index'] as int;

    // Play the first song
    await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(queue[currentIndex].id)));
    _audioPlayer.play();

    // Notification while playing music
    AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        _audioPlayer.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      playing: true,
      processingState: AudioProcessingState.ready,
      systemActions: [MediaAction.seek], // Change to list
    );

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        onSkipToNext();
      }
    });
  }

  @override
  Future<void> onPlay() async {
    _audioPlayer.play();
    AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      playing: true,
      processingState: AudioProcessingState.ready,
    );
  }

  @override
  Future<void> onPause() async {
    _audioPlayer.pause();
    AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      playing: false,
      processingState: AudioProcessingState.ready,
    );
  }

  @override
  Future<void> onStop() async {
    await _audioPlayer.stop();
    await super.onStop();
    AudioServiceBackground.setState(
      controls: [],
      playing: false,
      processingState: AudioProcessingState.idle, // Use 'idle' instead of 'stopped'
    );
  }

  @override
  Future<void> onSkipToNext() async {
    if (currentIndex < queue.length - 1) {
      currentIndex++;
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(queue[currentIndex].id)));
      _audioPlayer.play();
    }
  }

  @override
  Future<void> onSkipToPrevious() async {
    if (currentIndex > 0) {
      currentIndex--;
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(queue[currentIndex].id)));
      _audioPlayer.play();
    }
  }
}
void startAudioService(List<MediaItem> queue, int index) async {
  await AudioService.start(
    backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
    androidNotificationChannelName: 'Music Player',
    androidNotificationColor: 0xFF2196F3,
    androidNotificationIcon: 'mipmap/ic_launcher',
    androidEnableQueue: true,
    params: {
      'queue': queue,
      'index': index,
    },
  );
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}
