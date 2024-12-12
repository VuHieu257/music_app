import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../../core/colors/color.dart';
import '../../../widget_small/custom_button.dart';
class AddPlaylistScreen extends StatefulWidget {
  const AddPlaylistScreen({super.key});

  @override
  State<AddPlaylistScreen> createState() => _AddPlaylistScreenState();
}

class _AddPlaylistScreenState extends State<AddPlaylistScreen> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       leading: const Icon(Icons.add,color: Colors.white,),
       title: Center(
         child: Text("Tạo playlist mới",style: context.theme.textTheme.headlineMedium,),
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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: "Nhập tên playlist",
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
                    Text("Cài đặt riêng tư",style: context.theme.textTheme.titleMedium,),
                  ],
                ),
              ),
              CusButton(text: "Tạo playlist", color: Styles.blueIcon,)
            ],
          ),
        ),
      ),
    );
  }
}
