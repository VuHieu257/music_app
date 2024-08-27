import 'package:flutter/material.dart';
import 'package:music_app/core/colors/color.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

class MoodDiaryVew extends StatelessWidget {
  final AnimationController animationController;

  const MoodDiaryVew({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final _firstHalfAnimation =
        Tween<Offset>(begin:const Offset(1, 0), end:const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve:const Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _secondHalfAnimation =
        Tween<Offset>(begin:const Offset(0, 0), end: const Offset(-1, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve:const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _moodFirstHalfAnimation =
        Tween<Offset>(begin:const Offset(2, 0), end:const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve:const Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _moodSecondHalfAnimation =
        Tween<Offset>(begin:const Offset(0, 0), end:const Offset(-2, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve:const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _imageFirstHalfAnimation =
        Tween<Offset>(begin:const Offset(4, 0), end:const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve:const Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _imageSecondHalfAnimation =
        Tween<Offset>(begin:const Offset(0, 0), end:const Offset(-4, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve:const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    return SlideTransition(
      position: _firstHalfAnimation,
      child: SlideTransition(
        position: _secondHalfAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create Personal Playlists",
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold,color: Styles.light
                ),
              ),
              SlideTransition(
                position: _moodFirstHalfAnimation,
                child: SlideTransition(
                  position: _moodSecondHalfAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 64, right: 64, top: 16, bottom: 16),
                    child: Text(
                      "Turn music into your personal identity! Join our app to create your favorite playlists and share them with friends. Your music, your style!",
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.headlineSmall?.copyWith(
                        color: Styles.light
                      ),
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: _imageFirstHalfAnimation,
                child: SlideTransition(
                  position: _imageSecondHalfAnimation,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 350, maxHeight: 250),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(image: AssetImage(
                        'assets/introduction_animation/mood_dairy_image.png',
                      ),
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
