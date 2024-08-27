import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isCheck=false;

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
                  width: context.width*0.76,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Tìm kiếm bài hát',
                        filled: true,
                        fillColor: Styles.grey.withOpacity(0.2),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide.none
                        )
                    ),
                  ),
                ),
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text("hủy",style: context.theme.textTheme.headlineSmall,))
              ],
            ),
            SizedBox(height:context.height*0.01 ,),
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
            Padding(
              padding: const EdgeInsets.only(right:18.0,top: 10),
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
                        Text('Nổi bật',style: context.theme.textTheme.headlineMedium?.copyWith(
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
                        Text('Trending',style: context.theme.textTheme.headlineMedium?.copyWith(
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3, // Thay đổi số lượng bài hát
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage(Asset.bgImageAvatar),
                  ),
                  title: Text('Let Me Down Slowly',style: context.theme.textTheme.headlineSmall),
                  subtitle: Text('Sơn Tùng',style: context.theme.textTheme.titleMedium),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // Xử lý khi nhấn nút tùy chọn
                        },
                      ),
                    ],
                  ),
                );
              },
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