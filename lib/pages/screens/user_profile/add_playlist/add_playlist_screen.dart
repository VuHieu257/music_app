import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/auth_service.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:provider/provider.dart';

import '../../../../core/colors/color.dart';
import '../../../widget_small/custom_button.dart';
import '../playlist_screen/playlist _screen/provider.dart';
class AddPlaylistScreen extends StatefulWidget {
  const AddPlaylistScreen({super.key});

  @override
  State<AddPlaylistScreen> createState() => _AddPlaylistScreenState();
}

class _AddPlaylistScreenState extends State<AddPlaylistScreen> {
  bool _isChecked = false;
  final user=FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _playlistNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => AuthService().hideKeyBoard(),
      child: Scaffold(
       appBar: AppBar(
         leading: const Icon(Icons.add,color: Colors.white,),
         title: Center(
           child: Text("Create new playlist",style: context.theme.textTheme.headlineMedium,),
         ),
         actions: [
           InkWell(
             onTap: () {
               Navigator.pop(context);
             },
             child: const Padding(
               padding: EdgeInsets.all(8.0),
               child: Icon(Icons.close),
             ),
           )
         ],
       ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                 TextField(
                  controller: _playlistNameController,
                  decoration: const InputDecoration(
                    hintText: "Enter playlist name",
                    filled: true,
                    fillColor: Styles.greyLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none
                    ),
                  ),
                ),
                SizedBox(height: context.height*0.015,),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isChecked = !_isChecked;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isChecked ? Styles.blueIcon : Colors.grey.shade200,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _isChecked
                              ? const Icon(
                            Icons.check,
                            size: 20.0,
                            color: Styles.light,
                          )
                              : Icon(
                            Icons.circle,
                            size: 20.0,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text("Privacy settings",style: context.theme.textTheme.titleMedium,),
                    ],
                  ),
                ),
                InkWell(onTap: () {
                  Provider.of<PlaylistAddProvider>(context, listen: false)
                      .createNewPlaylist(_playlistNameController.text.trim(),"$user");
                  _playlistNameController.clear();
                  Navigator.pop(context);
                },child: CusButton(text: "Create playlist", color: Styles.blueIcon,))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
