import 'package:flutter/material.dart';
import 'package:music_app/core/assets.dart';
import 'package:music_app/core/themes/theme_extensions.dart';

import '../../../core/colors/color.dart';

class SplashView extends StatefulWidget {
  final AnimationController animationController;

  const SplashView({super.key, required this.animationController});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    final introductionanimation =
    Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.0, -1.0))
        .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: introductionanimation,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                Asset.bgWell,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                "Discover New Music",
                // style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                style:context.theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Styles.light,
                  fontSize: 25
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 64, right: 64),
              child: Text(
                "Join us to explore fresh and unique melodies. Don’t miss the chance to experience a diverse music library from all around the world, right here!",
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headlineMedium?.copyWith(
                  color: Styles.light
                ),
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 16),
              child: InkWell(
                onTap: () {
                  widget.animationController.animateTo(0.2);
                },
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.only(
                    left: 56.0,
                    right: 56.0,
                    top: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(38.0),
                    color: Styles.light,
                  ),
                  child: Text(
                    "Let's begin",
                    style: context.theme.textTheme.headlineMedium?.copyWith(
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
