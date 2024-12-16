import 'package:flutter/material.dart';
import 'package:music_app/core/size/size.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../core/assets.dart';
import '../../../core/colors/color.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final List<dynamic> img;
  final bool isMe;
  final bool isPlaying;
  final String urlVoice;
  final String titleSong;
  final String songImg;
  final void Function()? onPressed;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.img,
    required this.isPlaying,
    this.onPressed,
    required this.urlVoice,
    required this.titleSong,
    required this.songImg,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: widget.message.isNotEmpty,
            child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: widget.isMe ? Styles.blueIcon : Styles.greyLight,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Text(widget.message,
                    style: context.theme.textTheme.headlineMedium
                        ?.copyWith(color: Styles.light))),
          ),
          Visibility(
            visible: widget.img.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Wrap(
                spacing: 2.0,
                runSpacing: 2.0,
                children: List.generate(
                  widget.img.length,
                  (imgIndex) => Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(widget.img[imgIndex]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.urlVoice.isNotEmpty,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                  width: context.height * 0.3,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                      color: Styles.greyLight,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: context.height * 0.07,
                            width: context.height * 0.07,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                image: DecorationImage(
                                    image: NetworkImage(widget.songImg))),
                          ),
                          SizedBox(
                            width: context.width * 0.02,
                          ),
                          SizedBox(
                            width: context.width * 0.4,
                            child: Text(widget.titleSong,
                                style: context.theme.textTheme.titleMedium
                                    ?.copyWith(
                                        overflow: TextOverflow.ellipsis)),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: widget.onPressed,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(top: 10),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Styles.light),
                          child: Text(
                            widget.isPlaying ? "Stop" : "Play",
                            style: context.theme.textTheme.headlineSmall,
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
