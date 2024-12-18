import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/sign_In/sign_in.dart';

import '../../../../core/colors/color.dart';
import '../../../widget_small/bottom/show_custom_bottom/show_custom_bottom_sheet.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool autoPlay = false;
  bool showLyrics = true;
  int _selectedIndex = -1;
  int _selectedDisplayIndex = -1;
  int _selectedLanguageIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt',style: context.theme.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w500
        ),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(
              title: Text('Adjust sound quality',style: context.theme.textTheme.headlineSmall,),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showSoundQualityOptions();
              },
            ),
            ListTile(
              title: Text('Display',style: context.theme.textTheme.headlineSmall,),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showDisplayOptions();
              },
            ),
            ListTile(
              title: Text('Language',style: context.theme.textTheme.headlineSmall,),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showLanguageOptions();
              },
            ),
            ListTile(
              title: Text('Equalizer',style: context.theme.textTheme.headlineSmall,),
              subtitle: Text('Adjust audio settings',style: context.theme.textTheme.headlineSmall?.copyWith(
                color: Styles.grey
              ),),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Equalizer settings screen
              },
            ),
            SwitchListTile(
              activeTrackColor: Styles.blueIcon,
              // inactiveThumbColor: Styles.light,
              // inactiveTrackColor: Styles.grey,
              title: Text('Auto-Play',style: context.theme.textTheme.headlineSmall,),
              value: autoPlay,
              onChanged: (bool value) {
                setState(() {
                  autoPlay = value;
                });
              },
            ),
            SwitchListTile(
              activeTrackColor: Styles.blueIcon,
              title: Text('Show Lyrics on Player',style: context.theme.textTheme.headlineSmall,),
              value: showLyrics,
              onChanged: (bool value) {
                setState(() {
                  showLyrics = value;
                });
              },
            ),
            ListTile(
              title: Text('Connect to a Device',style: context.theme.textTheme.headlineSmall,),
              subtitle: Text('Listen to and control music on your devices',style: context.theme.textTheme.headlineSmall?.copyWith(
                  color: Styles.grey
              ),),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Connect to a Device screen
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Others",style: context.theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600
              ),),
            ),
            ListTile(
              title: Text('Help & Support',style: context.theme.textTheme.headlineSmall,),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Help & Support screen
              },
            ),
            ListTile(
              title: Text('Logout',style: context.theme.textTheme.headlineSmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold
              ),),
              trailing: const Icon(Icons.logout),
              onTap:() => _logout(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Đăng xuất người dùng
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignIn(),),(route) => false,);
    } catch (e) {
      debugPrint("Error logging out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }
  void _showSoundQualityOptions() {
    showCustomSoundQualitySheet(
      title: "Chất lượng âm thanh",
      context: context,
      options: ['Stereo', 'Bass boost', 'Preset EQ'],
      selectedIndex: _selectedIndex,
      onOptionSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
  void _showDisplayOptions() {
    showCustomSoundQualitySheet(
      title: "Giao diện",
      context: context,
      options: ['Auto', 'Sáng', 'Tối'],
      selectedIndex: _selectedDisplayIndex,
      onOptionSelected: (int index) {
        setState(() {
          _selectedDisplayIndex = index;
        });
      },
    );
  }
  void _showLanguageOptions() {
    showCustomSoundQualitySheet(
      title: "Ngôn Ngữ",
      context: context,
      options: ['Bahasa Indonesia (Tiếng Indonesia)', 'English (Tiếng Anh)', 'Tiếng Việt',"한글 (Tiếng Hàn)"],
      selectedIndex: _selectedLanguageIndex,
      onOptionSelected: (int index) {
        setState(() {
          _selectedLanguageIndex = index;
        });
      },
    );
  }
}
