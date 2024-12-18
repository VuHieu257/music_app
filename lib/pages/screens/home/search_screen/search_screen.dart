import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../../musicplayerscreen/music_player_screen.dart';
import '../../musicplayerscreen/provider.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isCheck=false;
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _songs = [];
  List<DocumentSnapshot> _filteredSongs = [];
  String nameSearch= "";
  List<String> _searchHistory = [];

  // Hàm lọc bài hát
  void _filterSongs(String query) {
    if (query.isNotEmpty) {
      // Lọc danh sách bài hát dựa trên từ khóa tìm kiếm
      _filteredSongs = _songs.where((song) {
        return song['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
            song['artist'].toString().toLowerCase().contains(query.toLowerCase());
      }).toList();

      // Thêm từ khóa vào lịch sử tìm kiếm nếu chưa có
      if (!_searchHistory.contains(query)) {
        _searchHistory.add(query);
        _saveSearchHistory();
      }
    } else {
      // Nếu không có từ khóa, hiển thị tất cả bài hát
      _filteredSongs = _songs;
    }
    setState(() {});
  }


  // Load search history
  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  // Save search history
  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', _searchHistory);
  }

  // Clear search history
  Future<void> _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    setState(() {
      _searchHistory.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:Styles.defaultPadding,vertical: Styles.defaultPadding*2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: context.width*0.7,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: 'Tìm kiếm bài hát',
                        filled: true,
                        fillColor: Styles.grey.withOpacity(0.2),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide.none
                        )
                    ),
                    onChanged: _filterSongs,
                  ),
                ),
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text("Cancel",style: context.theme.textTheme.headlineSmall,))
              ],
            ),
            SizedBox(height:context.height*0.01 ,),
            if (_searchHistory.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _searchHistory.map((query) {
                      return GestureDetector(
                        onTap: () {
                          _searchController.text = query;
                          _filterSongs(query);
                        },
                        child: Chip(label: Text(query)),
                      );
                    }).toList(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _clearSearchHistory,
                      child: const Text('Clear History'),
                    ),
                  ),
                ],
              ),
            Text('Lịch sử tìm kiếm',style: context.theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600
            ),),
            SizedBox(height:context.height*0.01 ,),
            Wrap(
              children: [
                eHistory(context,"Let Me Down Slowly"),
                eHistory(context,"Thiên lý ơi"),
                eHistory(context,"Podcast"),
                eHistory(context,"Âm thầm bên em"),
                eHistory(context,"Let Me Down Slowly"),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('db_songs').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  _songs = snapshot.data!.docs;
                  // Nếu không có từ khóa tìm kiếm, hiển thị tất cả bài hát
                  if (_searchController.text.isEmpty) {
                    _filteredSongs = _songs;
                  }
                  return ListView.builder(
                    itemCount: _filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = _filteredSongs[index];
                      return InkWell(
                        onTap: () {
                          // Truyền danh sách bài hát và chỉ số bài hát được chọn vào MusicPlayerProvider
                          Provider.of<MusicPlayerProvider>(context, listen: false)
                              .setPlaylist(_filteredSongs, index); // Truyền danh sách đã lọc và index

                          // Phát nhạc từ URL của bài hát
                          Provider.of<MusicPlayerProvider>(context, listen: false)
                              .playMusic(song['song_url']);

                          // Điều hướng đến màn hình phát nhạc (MusicPlayerScreen)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MusicPlayerScreen(
                                songs: _filteredSongs, // Truyền danh sách bài hát đã lọc
                                initialIndex: index, // Truyền chỉ số bài hát được chọn
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(song['image_url']),
                          ),
                          title: Text(song['title'], style: context.theme.textTheme.headlineSmall),
                          subtitle: Text(song['artist'], style: context.theme.textTheme.titleMedium),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              // Xử lý khi nhấn nút tùy chọn
                            },
                          ),
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
    );
  }

  Container eHistory(BuildContext context,String  title){
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10,right: 5),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Styles.greyLight
      ),
      child: Text(title,style: context.theme.textTheme.titleMedium,),
    );
  }
}