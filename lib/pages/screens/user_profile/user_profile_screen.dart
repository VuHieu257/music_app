import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:music_app/pages/screens/user_profile/downloads/download_screen.dart';
import 'package:music_app/pages/screens/user_profile/favorites/favorites.dart';
import 'package:music_app/pages/screens/user_profile/personal_playlists/personal_playlists_screen.dart';
import 'package:music_app/pages/screens/user_profile/premium/premium_screen.dart';
import 'package:music_app/pages/screens/user_profile/recent_played/recent_played_screen.dart';
import 'package:music_app/pages/screens/user_profile/setting/setting_screen.dart';
import 'package:music_app/pages/screens/user_profile/upload/upload_screen.dart';

import '../../../core/assets.dart';
import '../../../core/colors/color.dart';
import '../schedule/personalInfo_screen/personalInfo_screen.dart';
import 'add_playlist/add_playlist_screen.dart';
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isCheck=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_for_offline_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>const SettingScreen(),));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        Asset.bgImageAvatar
                    ), // Example image
                  ),
                  SizedBox(width: context.height*0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width:context.width*0.5,child: Text('phanhien.123',style: context.theme.textTheme.headlineMedium?.copyWith(
                          overflow: TextOverflow.ellipsis
                      ),)),
                      SizedBox(
                        width: context.width*0.55,
                        child: Row(
                          children: [
                            SizedBox(width: context.width*0.27,child: Text('0',style: context.theme.textTheme.titleMedium?.copyWith(
                                color: Styles.grey
                            ),textAlign: TextAlign.center)),
                            SizedBox(width: context.width*0.27,child: Text('0',style: context.theme.textTheme.titleMedium?.copyWith(
                                color: Styles.grey
                            ),textAlign: TextAlign.center)),
                          ],
                        ),),
                      SizedBox(
                        width: context.width*0.55,
                        child: Row(
                          children: [
                            SizedBox(width: context.width*0.27,child: Text('Đang theo dõi',style: context.theme.textTheme.titleMedium?.copyWith(
                                color: Styles.grey
                            ),textAlign: TextAlign.start)),
                            const Spacer(),
                            SizedBox(width: context.width*0.27,child: Text('Người theo dõi',style: context.theme.textTheme.titleMedium?.copyWith(
                                color: Styles.grey
                            ),textAlign: TextAlign.start)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoScreen(),));
                    },
                    child: Row(
                      children: [
                        Text("hồ sơ",style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.grey),),
                        const Icon(Icons.arrow_forward_ios,size: 15,color: Styles.grey,)
                      ],
                    ),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.edit),
                  //   onPressed: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoScreen(),));
                  //   },
                  // ),
                ],
              ),
            ),
            // Option Buttons
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PremiumScreen(),));
                            },
                            child: _buildOptionButton(context,context.width,context.height,Asset.iconImageIconKing,Icons.star, 'Premium',"Gói", Colors.amber,false)),
                        // const Spacer(),
                        InkWell(onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadScreen(),));
                          },child: _buildOptionButton(context,context.width,context.height,"",Icons.upload, 'Your uploads',"1 bài hát", Colors.blue,false)),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const DownloadScreen(),));
                          },child: _buildOptionButton(context,context.width,context.height,"",Icons.download, 'Downloads',"1 bài hát",Colors.green,false)),
                        // const Spacer(),
                        InkWell(onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const RecentPlayedScreen(),));
                         },child: _buildOptionButton(context,context.width,context.height,"",Icons.history, 'Recent', "1 bài hát",Colors.orange,false)),
                      ],
                    ),
                    InkWell(onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen(),));
                    },child: _buildOptionButton(context,context.width,context.height,"",Icons.favorite, 'Favorites', "1 bài hát",Colors.pink,true)),
                  ],
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:18.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isCheck=!isCheck;
                      });
                    },
                    child: Column(
                      children: [
                        Text('Bài hát',style: context.theme.textTheme.headlineMedium?.copyWith(
                            color: isCheck==false?Styles.dark:Styles.grey
                        ),),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          height: context.height*0.003,
                          width: context.width*0.15,
                          decoration: BoxDecoration(
                              color:isCheck==false?Styles.blueIcon:Styles.light,
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: context.width*0.06,),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isCheck=!isCheck;
                      });
                    },
                    child: Column(
                      children: [
                        Text('Album',style: context.theme.textTheme.headlineMedium?.copyWith(
                            color: isCheck==true?Styles.dark:Styles.grey
                        ),),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          height: context.height*0.003,
                          width: context.width*0.15,
                          decoration: BoxDecoration(
                              color:isCheck==true?Styles.blueIcon:Styles.light,
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Container(
                  height: context.height*0.1,
                  width: context.height*0.1,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Styles.greyLight
                  ),
                  child: const Icon(Icons.add),
                ),
                title: const Text("Tạo playlist"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPlaylistScreen(),));
                },
              ),
            ),
            InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalPlaylistsScreen(),));
            },child: _buildPlaylistItem('Chill', Asset.bgImageMusic)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context,double width,double height,String img,IconData icon, String label,String labelSup, Color color, bool isCheck) {
    return Container(
      width:isCheck?width:width*0.43,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          img==""?Icon(icon, color: color):Container(
            width: width*0.06,
            height: height*0.05,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(img),
                    fit: BoxFit.fitWidth
                )
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,style: context.theme.textTheme.titleMedium,),
              Text(labelSup,style: context.theme.textTheme.titleSmall?.copyWith(
                  color: Styles.grey
              ),),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistItem(String title, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading:
        Container(
          height: context.height*0.1,
          width: context.height*0.1,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Styles.greyLight,
            image: DecorationImage(image: AssetImage(imagePath),fit: BoxFit.fitWidth)
          ),
        ),
        title: Text(title),
      ),
    );
  }
}