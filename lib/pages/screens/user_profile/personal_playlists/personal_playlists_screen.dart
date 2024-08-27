import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/widget_small/widget_music.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import 'edit_playlists/edit_playlists_screen.dart';
class PersonalPlaylistsScreen extends StatelessWidget {
  const PersonalPlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditPlaylistsScreen(),));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.more_horiz),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      height: context.height*0.32,
                      width: context.height*0.32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        image: const DecorationImage(
                          image:AssetImage(Asset.bgImageMusicDetail),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Hien',
                        style: context.theme.textTheme.headlineLarge
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 12,
                          backgroundImage:AssetImage(Asset.bgImageAvatar)
                        ),
                        const SizedBox(width: 8),
                        Text('phanhien.123',style: context.theme.textTheme.titleMedium),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.favorite_border),
                  const SizedBox(width: 10),
                  const Icon(Icons.share),
                  const SizedBox(width: 10),
                  const Icon(Icons.add_circle_outline),
                  const Spacer(),
                  const Icon(Icons.shuffle),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal:10),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                primary: true,
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return CustomMusic(icon: Icons.download_for_offline_outlined,img:Asset.bgImageMusic,rank:"$index",nameMusic: "Let Me Down Slowly",singer: "Sơn tùng",
                    onMorePressed: () {
                    _showBottomSheet(context);
                  },);
                },),
            ],
          ),
        ),
      ),
    );
  }
}
void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: context.height*0.007,
              width: context.width*0.15,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Styles.grey
              ),
            ),
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  Asset.bgImageMusic,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text('Hien',style: context.theme.textTheme.headlineMedium,),
              subtitle: Text('1 bài hát',style: context.theme.textTheme.headlineSmall,),
            ),
            const Divider(),
            ListTile(
              leading:const Icon(Icons.add_road),
              title: Text('Thêm bài hát',style: context.theme.textTheme.headlineMedium,),
              onTap: () {
                // Hành động thêm bài hát
              },
            ),
            ListTile(
              leading:const Icon(Icons.edit),
              title: Text('Chỉnh sửa playlist',style: context.theme.textTheme.headlineMedium),
              onTap: () {
                // Hành động chỉnh sửa playlist
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text('Xóa playlist',style: context.theme.textTheme.headlineMedium),
              onTap: () {
                // Hành động xóa playlist
              },
            ),
          ],
        ),
      );
    },
  );
}