import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';
import 'package:provider/provider.dart';

import '../../../core/assets.dart';
import '../../../core/colors/color.dart';
import '../../../music_player.dart';
class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final musicPlayerProvider = Provider.of<MusicPlayerProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading:InkWell(
              onTap: () {
                Navigator.pop(context);
              }, child: Icon(Icons.arrow_back, color: context.theme.iconTheme.color)),
          title:  Center(child: Text('Sau Cơn Mưa',style: context.theme.textTheme.headlineLarge,)),
          actions: [
            Icon(Icons.more_vert, color: context.theme.iconTheme.color),
          ],
        ),
          body: Padding(
            padding: EdgeInsets.all(Styles.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.height*.45,
                  child: PageView(
                    onPageChanged: (value) {
                      setState(() {
                        _currentPage = value;
                      });
                    },
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom:20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            Asset.bgImageMusicDetail, // Replace with your image URL
                            width: double.infinity,
                            height: context.height*0.3,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0,bottom: 12),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Text.rich(
                              textAlign:TextAlign.center,
                             TextSpan(
                                 children: [
                                   TextSpan(
                                     text:"But they're showing the lights to the way back home\n\n",
                                     style: context.theme.textTheme.headlineSmall?.copyWith(
                                       color: Styles.blue,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),
                                 TextSpan(
                                   text:"When you don't know where to go\n\nBut they're showing the lights to the way back home\n\nWhen you don't know where to go\n\nBut they're showing the lights to the way back home\n\nWhen you don't know where to go",
                                   style: context.theme.textTheme.headlineSmall?.copyWith(
                                       fontWeight: FontWeight.bold
                                   ),),
                                   TextSpan(
                                     text:"When you don't know where to go\n\nBut they're showing the lights to the way back home\n\nWhen you don't know where to go\n\nBut they're showing the lights to the way back home\n\nWhen you don't know where to go",
                                     style: context.theme.textTheme.headlineSmall?.copyWith(
                                         fontWeight: FontWeight.bold
                                     ),)
                               ]
                             )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIndicator(0),
                    const SizedBox(width: 8),
                    _buildIndicator(1),
                  ],
                ),
                // Container(
                //   margin: const EdgeInsets.symmetric(vertical: 20),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(8.0),
                //     child: Image.asset(
                //       Asset.bgImageMusicDetail, // Replace with your image URL
                //       width: double.infinity,
                //       height: 300,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                // Song Title and Artist
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exit Sign',
                          style: context.theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                        SizedBox(height: context.height*0.01,),
                        Text(
                          'HIEUTHUHAI, marzuz...',
                          style: context.theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(Icons.favorite_border, color:context.theme.iconTheme.color),
                    SizedBox(width: context.width*0.05,),

                    InkWell(
                      onTap: () {
                        showShareOptions(context);
                      }, child: Icon(Icons.share, color:context.theme.iconTheme.color)),
                  ],
                ),
                // Progress Bar
                Slider(
                  value: 0.25,
                  onChanged: (value) {},
                  activeColor: Styles.blueIcon,
                  inactiveColor: Styles.grey.withOpacity(0.4),
                ),
                // Time Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0:25',
                      style: context.theme.textTheme.headlineSmall?.copyWith(color: Styles.grey),
                    ),
                    Text(
                      '3:15',
                      style: context.theme.textTheme.headlineSmall?.copyWith(color: Styles.grey),
                    ),
                  ],
                ),
                // Control Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.shuffle,size: 25, color:context.theme.iconTheme.color,
                    ),
                    const Spacer(),
                    Icon(Icons.skip_previous,size: 30,color: context.theme.iconTheme.color?.withOpacity(0.7)),
                    SizedBox(width: context.width*0.01,),
                    InkWell(
                      onTap: () {
                        musicPlayerProvider.showMusicPlayer(
                          "Sau cơm mưa",
                          "Hiếu thứ 2",
                          Asset.bgImageMusicDetail,
                        );
                      },
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.play_arrow, color: Styles.light, size: 30),
                      ),
                    ),
                    SizedBox(width: context.width*0.01,),
                    Icon(Icons.skip_next,size: 30, color:context.theme.iconTheme.color?.withOpacity(0.7)),
                    const Spacer(),
                    Icon(Icons.repeat,size: 25, color:context.theme.iconTheme.color),
                  ],
                ),
                // Bottom Options
              ],
            ),
          ),
        bottomNavigationBar:Padding(
          padding: EdgeInsets.symmetric(horizontal:Styles.defaultPadding,vertical: 10),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    // showMessger(context);
                    showCommentModal(context);
                  },
                  child: Icon(Icons.messenger_outline,size: 25, color:context.theme.iconTheme.color)),
              const Spacer(),
              InkWell(
                  onTap: () {
                    showQualityBottomSheet(context);
                  },
                  child: Icon(Icons.download_for_offline_outlined,size: 30, color:context.theme.iconTheme.color)),
            ],
          ),
        ),
        ),
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Styles.blueIcon : Styles.grey,
      ),
    );
  }
}
// void showMessger(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (BuildContext context) {
//       return Container(
//         padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
//         height: context.height,
//         child: Column(
//           // mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Align(
//               alignment: Alignment.center,
//               child: Container(
//                 height: 4,
//                 alignment: Alignment.center,
//                 margin: const EdgeInsets.only(bottom: 10,top: 15),
//                 width: context.width*0.2,
//                 decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     color: Styles.grey
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: Text(
//                 "34  bình luận",
//                 style: context.theme.textTheme.headlineLarge?.copyWith(
//                 ),
//               ),
//             ),
//             SizedBox(height: context.height*0.4,
//               child: ListView.builder(
//                 itemCount: 10,
//                 itemBuilder: (context, index) {
//                 return _messUser(context,Asset.bgImageAvatar,"Nấm","❤️❤️","2m ago");
//               },),
//               ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundImage: AssetImage(Asset.bgImageAvatar),
//                 ),
//               ],
//             )
//           ],
//         ),
//       );
//     },
//   );
// }

void showCommentModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.8, // Occupies 80% of the screen height
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 4,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "34 bình luận",
                  style: context.theme.textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return _messUser(context, Asset.bgImageAvatar, "Nấm", "❤️❤️", "2m ago");
                  },
                ),
              ),
              const Divider(),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(Asset.bgImageAvatar),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: const Icon(Icons.tag_faces),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.send,color: Styles.blueIcon,)
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _messUser(BuildContext context,String img, String name, String comment, String date){
  return ListTile(
    trailing: const Icon(Icons.favorite_border,),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name,style: context.theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),),
        SizedBox(height: context.height*0.01,),
        Text(comment,style: context.theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),),
      ],
    ),
    subtitle: Row(
      children: [
        SizedBox(height: context.height*0.01,),
        Text(date,style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.grey),),
        SizedBox(width: context.width*0.02,),
        Text("Trả lời",style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.grey),),
      ],
    ),
    onTap: () {
      // Xử lý khi chọn chất lượng 128 kbps
      Navigator.pop(context);
    },
    leading:CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage(img),
    ),
  );

}
void showQualityBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 4,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 10),
                width: context.width*0.2,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Styles.grey
                ),
              ),
            ),
            Text(
              "Chọn chất lượng tải",
              style: context.theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold
              ),
            ),
            const Divider(color: Styles.dark,),
            ListTile(
              trailing: const Icon(Icons.done,color: Styles.blueIcon,),
              title: Text("Chất lượng tiêu chuẩn",style: context.theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),),
              subtitle: Text("Tiết kiệm bộ nhớ cho thiết bị",style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.grey),),
              onTap: () {
                // Xử lý khi chọn chất lượng 128 kbps
                Navigator.pop(context);
              },
            ),
            ListTile(
              trailing: const Icon(Icons.done,color: Styles.blueIcon,),
              title: Text("Chất lượng cao",style: context.theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),),
              subtitle: Text("Chất lượng âm thanh cao",style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.grey),),
              onTap: () {
                // Xử lý khi chọn chất lượng 320 kbps
                Navigator.pop(context);
              },
            ),
            ListTile(
              trailing: const Icon(Icons.done,color: Styles.blueIcon,),
              title: Row(
                children: [
                  Text("Lossless",style: context.theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),),
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Styles.blueIcon.withOpacity(0.3),
                        borderRadius: const BorderRadius.all(Radius.circular(5))
                    ),
                    child:Text("PREMIUM",style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.blueIcon,fontSize: 12),),
                  ),
                ],
              ),
              subtitle: Text("Tiết kiệm bộ nhớ cho thiết bị",style: context.theme.textTheme.titleMedium?.copyWith(color: Styles.grey),),
              onTap: () {
                // Xử lý khi chọn chất lượng Lossless
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

void showShareOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 4,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 10),
                width: context.width*0.2,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Styles.grey
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareOption(context, Asset.iconImageShareUrl, "Copy url"),
                _buildShareOption(context, Asset.iconImageShareIntargram, "Instagram"),
                _buildShareOption(context, Asset.iconImageShareMess, "Messenger"),
                _buildShareOption(context, Asset.iconImageShareFb, "Facebook"),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareOption(context, Asset.iconImageShareIntargram, "Instagram"),
                _buildShareOption(context, Asset.iconImageShareMessSms, "Message"),
                _buildShareOption(context, Asset.iconImageShareMore, "More"),
                Container(), // Placeholder for empty space
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildShareOption(BuildContext context,  String imagePath, String label) {
  return Column(
    children: [
      CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(imagePath),
      ),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 14)),
    ],
  );
}