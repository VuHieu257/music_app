import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';

import '../../../../core/colors/color.dart';
class VoiceSearchScreen extends StatelessWidget {
  const VoiceSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Styles.defaultPadding),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Thử nói...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Handle song search
              },
              child: const Text(
                '"Mở bài Sao Phải Khóc"',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            SizedBox(height: context.height*0.5),
             const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.graphic_eq,
                  size: 40,
                ),
                Icon(
                  Icons.graphic_eq,
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.stop, color: Colors.white),
                onPressed: () {
                  // Handle stop action
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
