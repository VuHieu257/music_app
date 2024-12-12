import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';

import '../../../core/colors/color.dart';
import '../screens/musicplayerscreen/provider.dart';
import 'favorite_button.dart';
class BottomMusicPlayer extends StatelessWidget {
  final String idSong;
  final String idUser;
  final String songName;
  final String artistName;
  final String albumArt;
  final bool isPlaying;
  final MusicPlayerProvider musicPlayer;
  final VoidCallback onClose;

  const BottomMusicPlayer({
    super.key,
    required this.idSong,
    required this.idUser,
    required this.songName,
    required this.artistName,
    required this.albumArt,
    required this.isPlaying,
    required this.musicPlayer,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: context.width,
      decoration: BoxDecoration(
        // color: Styles.greyLight.withOpacity(0.8),
        color: Styles.greyLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:NetworkImage(
                  albumArt,
                ) ,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      songName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      artistName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black87),
                        onPressed: onClose
              ),
              FavoriteButton(songId: idSong,userId: idUser,),
              // IconButton(
              //     icon: const Icon(Icons.favorite_border, color: Colors.black87),
              //     onPressed: () {
              //
              //     },
              // ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                onPressed: () {
                  musicPlayer.stopMusic();
                },
              ),
            ],
          ),
          Slider(
            value: musicPlayer.currentPosition.inSeconds.toDouble(),
            max: musicPlayer.totalDuration.inSeconds.toDouble(),
            inactiveColor: Colors.grey,
            onChanged: (value) {
              musicPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
        ],
      ),
    );
  }
}
