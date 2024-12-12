import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/pages/screens/home/home.dart';
import 'package:provider/provider.dart';

import '../../../core/colors/color.dart';
import '../../../themeprovider.dart';
import '../../screens/message/message.dart';
import '../../screens/musicplayerscreen/provider.dart';
import '../../screens/schedule/schedule_screen.dart';
import '../../screens/user_profile/user_profile_screen.dart';
import '../../widget_small/bottom/show_custom_bottom/show_custom_bottom_sheet.dart';
import '../../widget_small/bottom_music_player.dart';
class BottomNavigaBar extends StatefulWidget {
  const BottomNavigaBar({super.key});

  @override
  State<BottomNavigaBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigaBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const MessageScreen(),
    const ScheduleScreen(),
    const UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final user=FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final musicPlayerProvider = Provider.of<MusicPlayerProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],

          if (musicPlayerProvider.isVisibility)
            Positioned(
              bottom: 0,
              top: MediaQuery.of(context).padding.bottom+context.height*0.78,
              left: 0,
              right: 0,
              child: _buildMusicPlayerBar(musicPlayerProvider),
            ),
          // BottomNavigationBar đặt lên trên cùng
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(Styles.defaultPadding),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)), // Round all corners
                  child: BottomNavigationBar(
                      backgroundColor: isDarkMode ? Styles.dark.withOpacity(0.8) : Styles.light,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.messenger_outline),
                          label: 'Messages',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.calendar_today_outlined),
                          label: 'Schedule',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person_outline),
                          label: 'User',
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor: isDarkMode ? Colors.blueAccent : Colors.blue,
                      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
                      onTap: _onItemTapped,
                      type: BottomNavigationBarType.fixed,
                    ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMusicPlayerBar(MusicPlayerProvider musicPlayer) {
    return
      BottomMusicPlayer(
        songName: musicPlayer.currentSong?['title'] ?? '',
        artistName: musicPlayer.currentSong?['artist'] ?? '',
        albumArt: musicPlayer.currentSong?['image_url'] ?? '',
        isPlaying: musicPlayer.isPlaying,
        idUser:"$user",
        idSong:musicPlayer.currentSong?.id??"",
        musicPlayer:musicPlayer,
        onClose: () {
          if (musicPlayer.isPlaying) {
            musicPlayer.pauseMusic();
          } else {
            musicPlayer.resumeMusic();}
        },
      );
  }

}
