import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/pages/screens/user_profile/playlist_screen/playlist%20_screen/provider.dart';
import 'package:provider/provider.dart';

import '../../../../../core/size/size.dart';
import '../playlist_detail_screen.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final TextEditingController _playlistNameController = TextEditingController();
  final user=FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    // Fetch playlists when the screen is initialized
    final provider = Provider.of<PlaylistAddProvider>(context, listen: false);
    provider.fetchPlaylists("$user");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyBoard(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Playlist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
          // leading: CircleAvatar(radius: 10, backgroundImage: AssetImage(Asset.bgLogo)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _playlistNameController,
                      decoration: const InputDecoration(
                        labelText: 'Create New Playlist',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () {
                      Provider.of<PlaylistAddProvider>(context, listen: false)
                          .createNewPlaylist(_playlistNameController.text.trim(),"$user");
                      _playlistNameController.clear();
                    },
                    label: const Text("Add Playlist", style: TextStyle(color: Colors.blue)),
                    icon: const Icon(Icons.add_box_outlined, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Consumer<PlaylistAddProvider>(
                  builder: (context, provider, child) {
                    return ListView.builder(
                      itemCount: provider.playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = provider.playlists[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4.0,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(playlist['name']),
                            subtitle: Text("${playlist['songs'].length} songs"),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistDetailScreen(id: playlist.id,songsPlay:provider.playlists)));
                            },
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

