import 'package:flutter/material.dart';
import 'package:music_app/core/assets.dart';
import 'package:music_app/core/colors/color.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

class WelcomeView extends StatelessWidget {
  final AnimationController animationController;
  const WelcomeView({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final _firstHalfAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final secondHalfAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0.8,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _welcomeFirstHalfAnimation =
        Tween<Offset>(begin: const Offset(2, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _welcomeImageAnimation =
        Tween<Offset>(begin: Offset(4, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: _firstHalfAnimation,
      child: SlideTransition(
        position: secondHalfAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _welcomeImageAnimation,
                child: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(maxWidth: 350, maxHeight: 350),
                  child: Image.asset(
                    Asset.bgLogo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SlideTransition(
                position: _welcomeFirstHalfAnimation,
                child: const Text(
                  "Welcome",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,color: Styles.light),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 64, right: 64, top: 16, bottom: 16),
                child: Text(
                  "Take some time to relax while using our app",
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    color: Styles.light
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
