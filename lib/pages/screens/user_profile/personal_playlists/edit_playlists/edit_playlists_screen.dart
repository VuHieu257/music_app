import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../../core/assets.dart';
import '../../../../../core/colors/color.dart';
class EditPlaylistsScreen extends StatefulWidget {
  const EditPlaylistsScreen({super.key});

  @override
  State<EditPlaylistsScreen> createState() => _EditPlaylistsScreenState();
}

class _EditPlaylistsScreenState extends State<EditPlaylistsScreen> {
  bool isSelectedAll = false;
  List<bool> isSelected = [false, false, false]; // Giả sử có 3 bài hát

  void toggleSelectAll() {
    setState(() {
      isSelectedAll = !isSelectedAll;
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = isSelectedAll;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.add_circle_outline,color: Colors.white,),
        title: Text('Chọn bài hát',style: context.theme.textTheme.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: isSelectedAll,
              onChanged: (value) {
                toggleSelectAll();
              },
            ),
            title: Text('Chọn tất cả (${isSelected.where((e) => e).length} được chọn)',style: context.theme.textTheme.headlineSmall,),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: isSelected.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: isSelected[index],
                    onChanged: (value) {
                      setState(() {
                        isSelected[index] = value ?? false;
                      });
                    },
                  ),
                  title: const Text('Let Me Down Slowly'),
                  subtitle: const Text('Sơn Tùng'),
                  trailing: Image.asset(
                    Asset.bgImageMusic, // Thay thế bằng đường dẫn ảnh của bạn
                    width: context.height*0.1,
                    height: context.height*0.1,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Styles.greyLight.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () {
                // Xử lý khi nhấn nút Xóa
              },
              icon: const Icon(Icons.delete,color: Styles.dark,),
              label: Text('Xóa',style: context.theme.textTheme.headlineSmall,),
            ),
            TextButton.icon(
              onPressed: () {
                // Xử lý khi nhấn nút Thêm vào playlist
              },
              icon: const Icon(Icons.playlist_add,color: Styles.dark,),
              label: Text('Thêm vào playlist',style: context.theme.textTheme.headlineSmall),
            ),
          ],
        ),
      ),
    );
  }
}
